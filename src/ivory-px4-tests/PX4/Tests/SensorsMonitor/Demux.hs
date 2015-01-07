{-# LANGUAGE DataKinds #-}

module PX4.Tests.SensorsMonitor.Demux (demux) where

import Ivory.HXStream
import Ivory.Language
import Ivory.Serialize
import Ivory.Tower
import SMACCMPilot.Hardware.GPS.Types
import SMACCMPilot.Hardware.HMC5883L.Types
import SMACCMPilot.Hardware.MPU6000.Types
import SMACCMPilot.Hardware.MS5611.Types

mkHandler :: (ANat len, IvoryArea a, IvoryZero a, IvorySizeOf a, SerializableRef a)
          => Ref s1 (Array len (Stored Uint8))
          -> Tag
          -> Emitter a
          -> FrameHandler
mkHandler buf tag dst = mkFrameHandler ScopedFrameHandler
  { fhTag = tag
  , fhBegin = return ()
  , fhData = \ b off -> do
      assert $ off <? arrayLen buf
      store (buf ! toIx off) b
  , fhEnd = do
      result <- local izero
      unpackFrom_ (constRef buf) 0 $ munpack result
      emit dst $ constRef result
  }

useModule :: Module -> Tower e ()
useModule m = do
  towerModule m
  towerDepends m

demux :: ChanOutput (Stored Uint8)
      -> ChanInput (Struct "hmc5883l_sample")
      -> ChanInput (Struct "mpu6000_sample")
      -> ChanInput (Struct "ms5611_measurement")
      -> ChanInput (Struct "position")
      -> Tower e ()
demux src chanCompass chanGyro chanBaro chanGPS = do
  mapM_ useModule
    [ gpsTypesModule
    , hmc5883lTypesModule
    , mpu6000TypesModule
    , ms5611TypesModule
    , serializeModule
    , hxstreamModule
    ]
  mapM_ towerArtifact serializeArtifacts

  monitor "demux" $ do
    hxstate <- stateInit "hxstate" initStreamState
    buf <- stateInit "buf" (izero :: Init (Array 46 (Stored Uint8)))

    handler src "read_byte" $ do
      -- after each byte we can emit at most one of these:
      compass <- emitter chanCompass 1
      gyro <- emitter chanGyro 1
      baro <- emitter chanBaro 1
      gps <- emitter chanGPS 1
      callbackV $ \ nextchar -> noReturn $ decodes
        [ mkHandler buf 98 baro
        , mkHandler buf 99 compass
        , mkHandler buf 103 gyro
        , mkHandler buf 112 gps
        ] hxstate nextchar
