{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_haskell.py

module SMACCMPilot.Mavlink.Native.Messages.SetLocalPositionSetpoint where

import Data.Word
import Data.Int
import Data.Sized.Matrix (Vector)
import Data.Serialize
import SMACCMPilot.Mavlink.Native.Serialize

setLocalPositionSetpointMsgId :: Word8
setLocalPositionSetpointMsgId = 50

setLocalPositionSetpointCrcExtra :: Word8
setLocalPositionSetpointCrcExtra = 214

data SetLocalPositionSetpointMsg =
  SetLocalPositionSetpointMsg
    { x :: Float
    , y :: Float
    , z :: Float
    , yaw :: Float
    , target_system :: Word8
    , target_component :: Word8
    , coordinate_frame :: Word8
    }

getSetLocalPositionSetpointMsg :: Get SetLocalPositionSetpointMsg
getSetLocalPositionSetpointMsg = do
  x <- get
  y <- get
  z <- get
  yaw <- get
  target_system <- get
  target_component <- get
  coordinate_frame <- get
  return SetLocalPositionSetpointMsg{..}

putSetLocalPositionSetpointMsg :: SetLocalPositionSetpointMsg -> Put
putSetLocalPositionSetpointMsg SetLocalPositionSetpointMsg{..} = do
  put x
  put y
  put z
  put yaw
  put target_system
  put target_component
  put coordinate_frame

