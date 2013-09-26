{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_ivory.py

module SMACCMPilot.Mavlink.Messages.RawPressure where

import SMACCMPilot.Mavlink.Pack
import SMACCMPilot.Mavlink.Unpack
import SMACCMPilot.Mavlink.Send

import Ivory.Language
import Ivory.Stdlib

rawPressureMsgId :: Uint8
rawPressureMsgId = 28

rawPressureCrcExtra :: Uint8
rawPressureCrcExtra = 67

rawPressureModule :: Module
rawPressureModule = package "mavlink_raw_pressure_msg" $ do
  depend packModule
  depend mavlinkSendModule
  incl mkRawPressureSender
  incl rawPressureUnpack
  defStruct (Proxy :: Proxy "raw_pressure_msg")

[ivory|
struct raw_pressure_msg
  { time_usec :: Stored Uint64
  ; press_abs :: Stored Sint16
  ; press_diff1 :: Stored Sint16
  ; press_diff2 :: Stored Sint16
  ; temperature :: Stored Sint16
  }
|]

mkRawPressureSender ::
  Def ('[ ConstRef s0 (Struct "raw_pressure_msg")
        , Ref s1 (Stored Uint8) -- seqNum
        , Ref s1 MavlinkArray -- tx buffer
        ] :-> ())
mkRawPressureSender =
  proc "mavlink_raw_pressure_msg_send"
  $ \msg seqNum sendArr -> body
  $ do
  arr <- local (iarray [] :: Init (Array 16 (Stored Uint8)))
  let buf = toCArray arr
  call_ pack buf 0 =<< deref (msg ~> time_usec)
  call_ pack buf 8 =<< deref (msg ~> press_abs)
  call_ pack buf 10 =<< deref (msg ~> press_diff1)
  call_ pack buf 12 =<< deref (msg ~> press_diff2)
  call_ pack buf 14 =<< deref (msg ~> temperature)
  -- 6: header len, 2: CRC len
  let usedLen = 6 + 16 + 2 :: Integer
  let sendArrLen = arrayLen sendArr
  if sendArrLen < usedLen
    then error "rawPressure payload is too large for 16 sender!"
    else do -- Copy, leaving room for the payload
            arrCopy sendArr arr 6
            call_ mavlinkSendWithWriter
                    rawPressureMsgId
                    rawPressureCrcExtra
                    16
                    seqNum
                    sendArr
            let usedLenIx = fromInteger usedLen
            -- Zero out the unused portion of the array.
            for (fromInteger sendArrLen - usedLenIx) $ \ix ->
              store (sendArr ! (ix + usedLenIx)) 0
            retVoid

instance MavlinkUnpackableMsg "raw_pressure_msg" where
    unpackMsg = ( rawPressureUnpack , rawPressureMsgId )

rawPressureUnpack :: Def ('[ Ref s1 (Struct "raw_pressure_msg")
                             , ConstRef s2 (CArray (Stored Uint8))
                             ] :-> () )
rawPressureUnpack = proc "mavlink_raw_pressure_unpack" $ \ msg buf -> body $ do
  store (msg ~> time_usec) =<< call unpack buf 0
  store (msg ~> press_abs) =<< call unpack buf 8
  store (msg ~> press_diff1) =<< call unpack buf 10
  store (msg ~> press_diff2) =<< call unpack buf 12
  store (msg ~> temperature) =<< call unpack buf 14

