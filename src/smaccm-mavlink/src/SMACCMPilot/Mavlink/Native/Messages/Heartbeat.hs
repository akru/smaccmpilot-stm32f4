{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_haskell.py

module SMACCMPilot.Mavlink.Native.Messages.Heartbeat where

import Data.Word
import Data.Int
import Data.Sized.Matrix (Vector)
import Data.Serialize
import SMACCMPilot.Mavlink.Native.Serialize

heartbeatMsgId :: Word8
heartbeatMsgId = 0

heartbeatCrcExtra :: Word8
heartbeatCrcExtra = 50

data HeartbeatMsg =
  HeartbeatMsg
    { custom_mode :: Word32
    , mavtype :: Word8
    , autopilot :: Word8
    , base_mode :: Word8
    , system_status :: Word8
    , mavlink_version :: Word8
    }

getHeartbeatMsg :: Get HeartbeatMsg
getHeartbeatMsg = do
  custom_mode <- get
  mavtype <- get
  autopilot <- get
  base_mode <- get
  system_status <- get
  mavlink_version <- get
  return HeartbeatMsg{..}

putHeartbeatMsg :: HeartbeatMsg -> Put
putHeartbeatMsg HeartbeatMsg{..} = do
  put custom_mode
  put mavtype
  put autopilot
  put base_mode
  put system_status
  put mavlink_version

