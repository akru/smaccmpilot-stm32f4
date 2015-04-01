{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_haskell.py

module SMACCMPilot.Mavlink.Native.Messages.HighresImu where

import Data.Word
import Data.Int
import Data.Sized.Matrix (Vector)
import Data.Serialize
import SMACCMPilot.Mavlink.Native.Serialize

highresImuMsgId :: Word8
highresImuMsgId = 105

highresImuCrcExtra :: Word8
highresImuCrcExtra = 93

data HighresImuMsg =
  HighresImuMsg
    { time_usec :: Word64
    , xacc :: Float
    , yacc :: Float
    , zacc :: Float
    , xgyro :: Float
    , ygyro :: Float
    , zgyro :: Float
    , xmag :: Float
    , ymag :: Float
    , zmag :: Float
    , abs_pressure :: Float
    , diff_pressure :: Float
    , pressure_alt :: Float
    , temperature :: Float
    , fields_updated :: Word16
    }

getHighresImuMsg :: Get HighresImuMsg
getHighresImuMsg = do
  time_usec <- get
  xacc <- get
  yacc <- get
  zacc <- get
  xgyro <- get
  ygyro <- get
  zgyro <- get
  xmag <- get
  ymag <- get
  zmag <- get
  abs_pressure <- get
  diff_pressure <- get
  pressure_alt <- get
  temperature <- get
  fields_updated <- get
  return HighresImuMsg{..}

putHighresImuMsg :: HighresImuMsg -> Put
putHighresImuMsg HighresImuMsg{..} = do
  put time_usec
  put xacc
  put yacc
  put zacc
  put xgyro
  put ygyro
  put zgyro
  put xmag
  put ymag
  put zmag
  put abs_pressure
  put diff_pressure
  put pressure_alt
  put temperature
  put fields_updated

