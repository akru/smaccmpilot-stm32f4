{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_haskell.py

module SMACCMPilot.Mavlink.Native.Messages.GlobalPositionInt where

import Data.Word
import Data.Int
import Data.Sized.Matrix (Vector)
import Data.Serialize
import SMACCMPilot.Mavlink.Native.Serialize

globalPositionIntMsgId :: Word8
globalPositionIntMsgId = 33

globalPositionIntCrcExtra :: Word8
globalPositionIntCrcExtra = 104

data GlobalPositionIntMsg =
  GlobalPositionIntMsg
    { time_boot_ms :: Word32
    , lat :: Int16
    , lon :: Int16
    , alt :: Int16
    , relative_alt :: Int16
    , vx :: Int16
    , vy :: Int16
    , vz :: Int16
    , hdg :: Word16
    }

getGlobalPositionIntMsg :: Get GlobalPositionIntMsg
getGlobalPositionIntMsg = do
  time_boot_ms <- get
  lat <- get
  lon <- get
  alt <- get
  relative_alt <- get
  vx <- get
  vy <- get
  vz <- get
  hdg <- get
  return GlobalPositionIntMsg{..}

putGlobalPositionIntMsg :: GlobalPositionIntMsg -> Put
putGlobalPositionIntMsg GlobalPositionIntMsg{..} = do
  put time_boot_ms
  put lat
  put lon
  put alt
  put relative_alt
  put vx
  put vy
  put vz
  put hdg

