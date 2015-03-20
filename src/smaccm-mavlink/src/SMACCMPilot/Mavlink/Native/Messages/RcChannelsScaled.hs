{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_haskell.py

module SMACCMPilot.Mavlink.Native.Messages.RcChannelsScaled where

import Data.Word
import Data.Int
import Data.Sized.Matrix (Vector)
import Data.Serialize
import SMACCMPilot.Mavlink.Native.Serialize

rcChannelsScaledMsgId :: Word8
rcChannelsScaledMsgId = 34

rcChannelsScaledCrcExtra :: Word8
rcChannelsScaledCrcExtra = 237

data RcChannelsScaledMsg =
  RcChannelsScaledMsg
    { time_boot_ms :: Word32
    , chan1_scaled :: Int16
    , chan2_scaled :: Int16
    , chan3_scaled :: Int16
    , chan4_scaled :: Int16
    , chan5_scaled :: Int16
    , chan6_scaled :: Int16
    , chan7_scaled :: Int16
    , chan8_scaled :: Int16
    , port :: Word8
    , rssi :: Word8
    }

getRcChannelsScaledMsg :: Get RcChannelsScaledMsg
getRcChannelsScaledMsg = do
  time_boot_ms <- get
  chan1_scaled <- get
  chan2_scaled <- get
  chan3_scaled <- get
  chan4_scaled <- get
  chan5_scaled <- get
  chan6_scaled <- get
  chan7_scaled <- get
  chan8_scaled <- get
  port <- get
  rssi <- get
  return RcChannelsScaledMsg{..}

putRcChannelsScaledMsg :: RcChannelsScaledMsg -> Put
putRcChannelsScaledMsg RcChannelsScaledMsg{..} = do
  put time_boot_ms
  put chan1_scaled
  put chan2_scaled
  put chan3_scaled
  put chan4_scaled
  put chan5_scaled
  put chan6_scaled
  put chan7_scaled
  put chan8_scaled
  put port
  put rssi

