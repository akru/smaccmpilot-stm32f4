{-# LANGUAGE DataKinds #-}
{-# LANGUAGE RecordWildCards #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}

-- Autogenerated Mavlink v1.0 implementation: see smavgen_haskell.py

module SMACCMPilot.Mavlink.Native.Messages.Data32 where

import Data.Word
import Data.Int
import Data.Sized.Matrix (Vector)
import Data.Serialize
import SMACCMPilot.Mavlink.Native.Serialize

data32MsgId :: Word8
data32MsgId = 170

data32CrcExtra :: Word8
data32CrcExtra = 240

data Data32Msg =
  Data32Msg
    { data32_type :: Word8
    , len :: Word8
    , data32 :: Vector 32 Word8
    }

getData32Msg :: Get Data32Msg
getData32Msg = do
  data32_type <- get
  len <- get
  data32 <- get
  return Data32Msg{..}

putData32Msg :: Data32Msg -> Put
putData32Msg Data32Msg{..} = do
  put data32_type
  put len
  put data32

