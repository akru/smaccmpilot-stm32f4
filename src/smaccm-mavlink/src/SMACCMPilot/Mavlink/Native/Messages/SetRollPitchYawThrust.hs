{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_haskell.py

module SMACCMPilot.Mavlink.Native.Messages.SetRollPitchYawThrust where

import Data.Word
import Data.Int
import Data.Sized.Matrix (Vector)
import Data.Serialize
import SMACCMPilot.Mavlink.Native.Serialize

setRollPitchYawThrustMsgId :: Word8
setRollPitchYawThrustMsgId = 56

setRollPitchYawThrustCrcExtra :: Word8
setRollPitchYawThrustCrcExtra = 100

data SetRollPitchYawThrustMsg =
  SetRollPitchYawThrustMsg
    { roll :: Float
    , pitch :: Float
    , yaw :: Float
    , thrust :: Float
    , target_system :: Word8
    , target_component :: Word8
    }

getSetRollPitchYawThrustMsg :: Get SetRollPitchYawThrustMsg
getSetRollPitchYawThrustMsg = do
  roll <- get
  pitch <- get
  yaw <- get
  thrust <- get
  target_system <- get
  target_component <- get
  return SetRollPitchYawThrustMsg{..}

putSetRollPitchYawThrustMsg :: SetRollPitchYawThrustMsg -> Put
putSetRollPitchYawThrustMsg SetRollPitchYawThrustMsg{..} = do
  put roll
  put pitch
  put yaw
  put thrust
  put target_system
  put target_component

