{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ScopedTypeVariables #-}

module SMACCMPilot.Hardware.MS5611.Manager where

import Ivory.Language
import Ivory.Stdlib
import Ivory.Tower

import SMACCMPilot.Hardware.MS5611.Regs
import SMACCMPilot.Hardware.MS5611.Types
import SMACCMPilot.Hardware.MS5611.Mode
import SMACCMPilot.Hardware.MS5611.Calibration (measurement)

-- lol, modularity
data MS5611Impl req res ident
  = MS5611Impl
      { ms5611_command_req         :: forall s eff
                                    . (GetAlloc eff ~ Scope s)
                                   => ident
                                   -> Command
                                   -> Ivory eff (ConstRef (Stack s) req)
      , ms5611_prom_fetch_req      :: forall s eff
                                    . (GetAlloc eff ~ Scope s)
                                   => ident
                                   -> Ivory eff (ConstRef (Stack s) req)
      , ms5611_adc_fetch_req       :: forall s eff
                                    . (GetAlloc eff ~ Scope s)
                                   => ident
                                   -> Ivory eff (ConstRef (Stack s) req)
      , ms5611_res_code            :: forall s eff
                                    . Ref s res
                                   -> Ivory eff Uint8
      , ms5611_res_prom            :: forall s eff
                                    . Ref s res
                                   -> Ivory eff Uint16
      , ms5611_res_sample          :: forall s eff
                                    . ConstRef s res
                                   -> Ivory eff Uint32
      }


ms5611SensorManager :: forall req res ident e
                     . (IvoryArea req, IvoryZero req, IvoryArea res, IvoryZero res)
                    => MS5611Impl req res ident
                    -> ChanInput  req
                    -> ChanOutput res
                    -> ChanOutput (Stored ITime)
                    -> ChanInput  (Struct "ms5611_measurement")
                    -> ident
                    -> Tower e ()
ms5611SensorManager i req_chan res_chan init_chan meas_chan addr = do
  towerModule  ms5611TypesModule
  towerDepends ms5611TypesModule

  p <- period (Milliseconds 10) -- ADC conversion period.
  monitor "ms5611SensorManager" $ do
    sample      <- state "sample"
    calibration <- state "calibration"
    meas        <- state "measurement"
    continuationMode <- stateInit "continuationMode" (ival idle)
    coroutineHandler init_chan res_chan "ms5611" $ do
      req_e <- emitter req_chan 1
      meas_e <- emitter meas_chan 1
      return $ CoroutineBody $ \yield -> do

        let getPROM prom ref = do
              read_req <- ms5611_command_req i addr (PromRead prom)
              emit req_e read_req
              read_res <- yield
              initi2csuccess read_res
              fetch_req <- ms5611_prom_fetch_req i addr
              emit req_e fetch_req
              fetch_res <- yield
              initi2csuccess fetch_res
              u16 <- ms5611_res_prom i fetch_res
              store ref u16

            initi2csuccess res = do
              c <- ms5611_res_code i res
              when (c >? 0) (store (meas ~> initfail) true)

            samplei2csuccess :: Ref s res
                             -> Ivory eff ()
            samplei2csuccess res = do
              c <- ms5611_res_code i res
              when (c >? 0) (store (meas ~> sampfail) true)

            transaction :: (GetAlloc eff ~ Scope s)
                        => Ivory eff (Ref s2 res)
                        -> Ivory eff (ConstRef s1 req)
                        -> Ivory eff (Ref s2 res)
            transaction y req = do
              startTransaction req
              finishTransaction y

            startTransaction :: (GetAlloc eff ~ Scope s)
                             => Ivory eff (ConstRef s1 req)
                             -> Ivory eff ()
            startTransaction req = do
              r <- req
              emit req_e r

            finishTransaction :: Ivory eff (Ref s res)
                              -> Ivory eff (Ref s res)
            finishTransaction y = do
              res <- y
              samplei2csuccess res
              return res

        -- Indicate to the periodic handler that we need to reset the chip.
        -- At least 3ms must pass between sending the reset and doing any other
        -- transaction. To ensure this is the case, we schedule both the reset
        -- and a following garbage transaction on the 10ms periodic clock.
        store continuationMode sendReset
        _ <- finishTransaction yield
        -- The periodic handler has sent the reset, we need to wait for the
        -- periodic handler to fire once more before continuing
        store continuationMode waitReset
        _ <- finishTransaction yield
        -- Reset sequence completed, signal to the periodic handler to not
        -- start any more transactions
        store continuationMode initializing
        -- The periodic handler started a PROM Read of the Reserved PROM field.
        -- We need to finish fetching this field or else the chip will nack the
        -- next fetch.
        _ <- transaction yield $ ms5611_prom_fetch_req i addr

        -- Now we're ready to read the calibration coefficients from the PROM.
        arrayMap $ \ ix ->
          getPROM (Coeff ix) (calibration ~> coeff ! ix)

        -- Start the measurement sample cycle. Requires us to convert and fetch
        -- both the temperature and pressure from the sensor.
        forever $ do
          store (meas ~> sampfail) false

          -- Start an adc conversion. We must wait ~9ms for the conversion to
          -- complete before reading
          _ <- transaction yield $ ms5611_command_req i addr (ConvertD1 OSR4096)

          -- Yield until the periodic handler starts an ADCRead
          -- request.
          -- Note that the first time after init, this may happen less than
          -- ~10ms after the above transaction started, so the d1 value may be
          -- hosed.  XXX fix that afterwards.
          store continuationMode running
          _ <- finishTransaction yield

          -- The converted value is now in the register: fetch it.
          adc_d1_read  <- transaction yield $ ms5611_adc_fetch_req i addr

          press <- ms5611_res_sample i (constRef adc_d1_read)
          store (sample ~> sample_pressure) press

          -- Start an adc conversion. We must wait ~9ms for the conversion to
          -- complete before reading
          _ <- transaction yield $ ms5611_command_req i addr (ConvertD2 OSR4096)

          -- Yield until the periodic handler runs and starts an ADCRead
          -- request.
          _ <- finishTransaction yield

          -- The converted value is now in the register: fetch it.
          adc_d2_read <- transaction yield $ ms5611_adc_fetch_req i addr

          temp <- ms5611_res_sample i (constRef adc_d2_read)
          store (sample ~> sample_temperature) temp
          getTime >>= store (sample ~> sample_time)

          measurement (constRef calibration) (constRef sample) meas
          emit meas_e (constRef meas)


    handler p "periodic" $ do
      req_e <- emitter req_chan 1
      callback $ const $ do
        -- This handler always sends the start of a transaction for the
        -- coroutine handler above to complete.
        let startTransaction req = do
              r <- req
              emit req_e r

        -- The coroutineMode state is used to signal between the two handlers
        -- which transaction should be started.
        cm <- deref continuationMode
        cond_
          [ (cm ==? idle) ==> do
              -- Do Nothing!
              -- The coroutine will set the state to waitReset next.
              return ()
          , (cm ==? sendReset) ==> do
              -- Send a reset request to the chip. Must wait a minimum of 3ms
              -- before starting any other transactions!
              startTransaction $ ms5611_command_req i addr Reset
          , (cm ==? waitReset) ==> do
              -- Send a (meaningless) PROM Read transaction, signaling to the
              -- coroutine handler that 10ms has passed since the chip was reset
              startTransaction $ ms5611_command_req i addr (PromRead Reserved)
          , (cm ==? initializing) ==> do
              -- Do Nothing!
              -- The coroutine handler is taking care of post-reset
              -- initialization, which has no timing requirements.
              return ()
          , (cm ==? running) ==> do
              -- The coroutine is currently yielded, waiting for an ADCRead
              -- to be kicked off every 10ms.
              startTransaction $ ms5611_command_req i addr ADCRead
          ]


----

u32_from_3_bytes :: Uint8 -> Uint8 -> Uint8 -> Uint32
u32_from_3_bytes h m l = h' + m' + l'
  where
  h' = (safeCast h) `iShiftL` 16
  m' = (safeCast m) `iShiftL` 8
  l' = (safeCast l)

u16_from_2_bytes :: Uint8 -> Uint8 -> Uint16
u16_from_2_bytes h l = h' + l'
  where
  h' = (safeCast h) `iShiftL` 8
  l' = (safeCast l)

