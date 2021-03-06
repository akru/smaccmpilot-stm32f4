{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeOperators #-}

module SMACCMPilot.INS.Tower (sensorFusion) where

import Data.Traversable
import Ivory.Language
import Ivory.Stdlib
import Ivory.Tower
import Numeric.Estimator.Model.Coordinate
import Prelude hiding (mapM)
import SMACCMPilot.Comm.Ivory.Types
import qualified SMACCMPilot.Comm.Ivory.Types.MagnetometerSample  as M
import qualified SMACCMPilot.Comm.Ivory.Types.AccelerometerSample as A
import qualified SMACCMPilot.Comm.Ivory.Types.GyroscopeSample     as G
import qualified SMACCMPilot.Comm.Ivory.Types.Xyz as XYZ
import SMACCMPilot.INS.Ivory
import SMACCMPilot.Time

changeUnits :: (Functor f, Functor g) => (x -> y) -> f (g x) -> f (g y)
changeUnits f = fmap (fmap f)

accel :: (SafeCast IFloat to)
      => ConstRef s ('Struct "accelerometer_sample")
      -> Ivory eff (XYZ to)
accel sample = fmap (fmap safeCast)
             $ mapM deref
             $ fmap ((sample ~> A.sample) ~>)
             $ xyz XYZ.x XYZ.y XYZ.z

gyro :: (Floating to, SafeCast IFloat to)
      => ConstRef s ('Struct "gyroscope_sample")
      -> Ivory eff (XYZ to)
gyro sample = changeUnits (* (pi / 180))
            $ fmap (fmap safeCast)
            $ mapM deref
            $ fmap ((sample ~> G.sample) ~>)
            $ xyz XYZ.x XYZ.y XYZ.z

kalman_predict :: Def ('[ Ref s1 ('Struct "kalman_state")
                        , Ref s2 ('Struct "kalman_covariance")
                        , Ref s3 ('Stored ITime)
                        , ITime
                        , ConstRef s4 ('Struct "gyroscope_sample")] ':-> ())
kalman_predict = proc "kalman_predict" $
  \ state_vector covariance last_predict now last_gyro -> body $ do
      gyro_not_ready <- deref $ last_gyro ~> G.samplefail
      when gyro_not_ready retVoid

      last_time <- deref last_predict
      let dt = safeCast (castDefault (toIMicroseconds (now - last_time)) :: Sint32) * 1.0e-6
      kalmanPredict state_vector covariance dt =<< gyro last_gyro
      store last_predict now

accel_measure :: Def ('[ Ref s1 ('Struct "kalman_state")
                       , Ref s2 ('Struct "kalman_covariance")
                       , ConstRef s3 ('Struct "accelerometer_sample")
                       ] ':-> ())
accel_measure = proc "accel_measure" $ \ state_vector covariance last_accel -> body $ do
  accelMeasure state_vector covariance =<< accel last_accel

mag :: (Num to, SafeCast IFloat to)
    => ConstRef s ('Struct "magnetometer_sample")
    -> Ivory eff (XYZ to)
mag sample = changeUnits (* 1000)
           $ fmap (fmap safeCast)
           $ mapM deref
           $ fmap ((sample ~> M.sample) ~>)
           $ xyz XYZ.x XYZ.y XYZ.z

mag_measure :: Def ('[ Ref s1 ('Struct "kalman_state")
                     , Ref s2 ('Struct "kalman_covariance")
                     , ConstRef s3 ('Struct "magnetometer_sample")] ':-> ())
mag_measure = proc "mag_measure" $ \ state_vector covariance last_mag -> body $ do
  magMeasure state_vector covariance =<< mag last_mag

init_filter :: Def ('[ Ref s1 ('Struct "kalman_state")
                     , Ref s2 ('Struct "kalman_covariance")
                     , ConstRef s3 ('Struct "accelerometer_sample")
                     , ConstRef s4 ('Struct "magnetometer_sample")
                     ] ':-> IBool)
init_filter = proc "init_filter" $
  \ state_vector covariance last_accel last_mag -> body $ do
      magFail <- deref $ last_mag ~> M.samplefail
      when (iNot magFail) $ do
        acc <- accel last_accel
        mag' <- mag last_mag
        kalmanInit state_vector covariance acc mag'
        ret true
      ret false

sensorFusion :: ChanOutput ('Struct "accelerometer_sample")
             -> ChanOutput ('Struct "gyroscope_sample")
             -> ChanOutput ('Struct "magnetometer_sample")
             -> ChanOutput ('Stored IBool)
             -> Tower e (ChanOutput ('Struct "kalman_state"))
sensorFusion accelSource gyroSource magSource motion = do
  (stateSink, stateSource) <- channel

  let deps = insTypesModule : typeModules
  mapM_ towerDepends deps
  mapM_ towerModule deps

  monitor "fuse" $ do
    monitorModuleDef $ do
      incl kalman_predict
      incl accel_measure
      incl mag_measure
      incl init_filter

    initialized <- state "initialized"
    last_predict <- state "last_predict"
    state_vector <- state "state_vector"
    covariance <- state "covariance"

    last_gyro <- stateInit "last_gyro" $ istruct [ G.samplefail .= ival true ]
    last_acc  <- stateInit "last_acc" $ istruct [ A.samplefail .= ival true ]
    last_mag <- stateInit "last_mag" $ istruct [ M.samplefail .= ival true ]

    in_motion <- state "in_motion"

    handler accelSource "accel" $ do
      callback $ \ sample -> do
        accelFail <- deref $ sample ~> A.samplefail
        unless accelFail $ do
          refCopy last_acc sample
          ready <- deref initialized
          when ready $ call_ accel_measure state_vector covariance (constRef last_acc)

    handler gyroSource "gyro" $ do
      stateEmit <- emitter stateSink 1
      callback $ \ sample -> do
        gyroFail <- deref $ sample ~> G.samplefail
        gyroCal <- deref $ sample ~> G.calibrated
        unless (gyroFail .|| iNot gyroCal) $ do
          refCopy last_gyro sample

          ready <- deref initialized
          ifte_ ready
            (do
              now <- fmap iTimeFromTimeMicros $ deref $ last_gyro ~> G.time
              call_ kalman_predict state_vector covariance last_predict now (constRef last_gyro)
            ) (do
              magCal <- deref $ last_mag ~> M.calibrated
              wasMoving <- deref in_motion

              when (magCal .&& iNot wasMoving) $ do
                done <- call init_filter state_vector
                                         covariance
                                         (constRef last_acc)
                                         (constRef last_mag)
                when done $ do
                  store initialized true
                  t <- deref $ last_acc ~> A.time
                  store last_predict (iTimeFromTimeMicros t)
            )

        emit stateEmit $ constRef state_vector

    handler magSource "mag" $ callback $ \ sample -> do
      failed <- deref $ sample ~> M.samplefail
      cal <- deref $ sample ~> M.calibrated
      unless (failed .|| iNot cal) $ do
        refCopy last_mag sample
        ready <- deref initialized
        when ready $ call_ mag_measure state_vector covariance $ constRef last_mag

    handler motion "calibration_status" $ callback $ refCopy in_motion

  return stateSource
