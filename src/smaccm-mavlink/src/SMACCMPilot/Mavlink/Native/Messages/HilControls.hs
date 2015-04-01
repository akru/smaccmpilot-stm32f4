{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_haskell.py

module SMACCMPilot.Mavlink.Native.Messages.HilControls where

import Data.Word
import Data.Int
import Data.Sized.Matrix (Vector)
import Data.Serialize
import SMACCMPilot.Mavlink.Native.Serialize

hilControlsMsgId :: Word8
hilControlsMsgId = 91

hilControlsCrcExtra :: Word8
hilControlsCrcExtra = 63

data HilControlsMsg =
  HilControlsMsg
    { time_usec :: Word64
    , roll_ailerons :: Float
    , pitch_elevator :: Float
    , yaw_rudder :: Float
    , throttle :: Float
    , aux1 :: Float
    , aux2 :: Float
    , aux3 :: Float
    , aux4 :: Float
    , mode :: Word8
    , nav_mode :: Word8
    }

getHilControlsMsg :: Get HilControlsMsg
getHilControlsMsg = do
  time_usec <- get
  roll_ailerons <- get
  pitch_elevator <- get
  yaw_rudder <- get
  throttle <- get
  aux1 <- get
  aux2 <- get
  aux3 <- get
  aux4 <- get
  mode <- get
  nav_mode <- get
  return HilControlsMsg{..}

putHilControlsMsg :: HilControlsMsg -> Put
putHilControlsMsg HilControlsMsg{..} = do
  put time_usec
  put roll_ailerons
  put pitch_elevator
  put yaw_rudder
  put throttle
  put aux1
  put aux2
  put aux3
  put aux4
  put mode
  put nav_mode

