{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_ivory.py

module SMACCMPilot.Mavlink.Messages.Statustext where

import SMACCMPilot.Mavlink.Pack
import SMACCMPilot.Mavlink.Unpack
import SMACCMPilot.Mavlink.Send

import Ivory.Language
import Ivory.Stdlib

statustextMsgId :: Uint8
statustextMsgId = 253

statustextCrcExtra :: Uint8
statustextCrcExtra = 83

statustextModule :: Module
statustextModule = package "mavlink_statustext_msg" $ do
  depend packModule
  depend mavlinkSendModule
  incl mkStatustextSender
  incl statustextUnpack
  defStruct (Proxy :: Proxy "statustext_msg")

[ivory|
struct statustext_msg
  { severity :: Stored Uint8
  ; text :: Array 50 (Stored Uint8)
  }
|]

mkStatustextSender ::
  Def ('[ ConstRef s0 (Struct "statustext_msg")
        , Ref s1 (Stored Uint8) -- seqNum
        , Ref s1 MavlinkArray -- tx buffer
        ] :-> ())
mkStatustextSender =
  proc "mavlink_statustext_msg_send"
  $ \msg seqNum sendArr -> body
  $ do
  arr <- local (iarray [] :: Init (Array 51 (Stored Uint8)))
  let buf = toCArray arr
  call_ pack buf 0 =<< deref (msg ~> severity)
  arrayPack buf 1 (msg ~> text)
  -- 6: header len, 2: CRC len
  let usedLen = 6 + 51 + 2 :: Integer
  let sendArrLen = arrayLen sendArr
  if sendArrLen < usedLen
    then error "statustext payload is too large for 51 sender!"
    else do -- Copy, leaving room for the payload
            arrCopy sendArr arr 6
            call_ mavlinkSendWithWriter
                    statustextMsgId
                    statustextCrcExtra
                    51
                    seqNum
                    sendArr
            let usedLenIx = fromInteger usedLen
            -- Zero out the unused portion of the array.
            for (fromInteger sendArrLen - usedLenIx) $ \ix ->
              store (sendArr ! (ix + usedLenIx)) 0
            retVoid

instance MavlinkUnpackableMsg "statustext_msg" where
    unpackMsg = ( statustextUnpack , statustextMsgId )

statustextUnpack :: Def ('[ Ref s1 (Struct "statustext_msg")
                             , ConstRef s2 (CArray (Stored Uint8))
                             ] :-> () )
statustextUnpack = proc "mavlink_statustext_unpack" $ \ msg buf -> body $ do
  store (msg ~> severity) =<< call unpack buf 0
  arrayUnpack buf 1 (msg ~> text)

