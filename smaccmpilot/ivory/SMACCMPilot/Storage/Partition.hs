{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE ScopedTypeVariables #-}
--
-- Partition.hs --- Simple EEPROM partitioning.
--
-- Copyright (C) 2013, Galois, Inc.
-- All Rights Reserved.
--

module SMACCMPilot.Storage.Partition (
  -- * Types
  MaxPartitions, PartitionID,

  -- * Partition IDs
  partitionInvalid, partitionParamA, partitionParamB,

  -- * Ivory Functions
  partition_size,
  partition_start,
  partition_in_bounds,
  partition_read,
  partition_write,

  -- * Ivory Module
  partitionModule
) where

import Ivory.Language

import IvoryHelpers
import SMACCMPilot.Storage.EEPROM

----------------------------------------------------------------------
-- Partition Table

{-
-- | Structure containing the size and bounds of a partition.
[ivory|
 struct partition_info
 { partition_info_id    :: (Stored Uint8)
 ; partition_info_size  :: (Stored Uint16)
 ; partition_info_start :: (Stored Uint16)
 }
|]

-- | Partition data, as a constant global array.
partition_table :: ConstMemArea (Array 3 (Struct "partition_info"))
partition_table = constArea "g_partition_table" $ iarray
  [ istruct
     [ partition_info_id    .= ival 0
     , partition_info_size  .= ival 0
     , partition_info_start .= ival 0]
  , istruct
     [ partition_info_id    .= ival 1
     , partition_info_size  .= ival 0x1000
     , partition_info_start .= ival 0x0000]
  , istruct
     [ partition_info_id    .= ival 2
     , partition_info_size  .= ival 0x1000
     , partition_info_start .= ival 0x1000]
  ]
-}

-- | Maximum number of partitions.
type MaxPartitions = 3

-- | Partition IDs.
type PartitionID = Ix MaxPartitions

partitionInvalid :: PartitionID
partitionInvalid = 0

partitionParamA :: PartitionID
partitionParamA = 1

partitionParamB :: PartitionID
partitionParamB = 2

-- | Partition data, as a constant global array of sizes.
partition_table :: MemArea (Array MaxPartitions (Stored Uint16))
partition_table = area "g_partition_table" $ Just $ iarray
  [ ival 0x0000                 -- 0: invalid
  , ival 0x1000                 -- 1: ParamA
  , ival 0x1000                 -- 2: ParamB
  ]

-- | Return the size in bytes of a partition.
partition_size :: Def ('[PartitionID] :-> Uint16)
partition_size = proc "partition_size" $ \pid -> body $ do
  tab  <- addrOf partition_table
  size <- deref (tab ! pid)
  ret size

-- | Return the start address of a partition.
partition_start :: Def ('[PartitionID] :-> Uint16)
partition_start = proc "partition_start" $ \pid -> body $ do
  tab    <- addrOf partition_table
  result <- local (ival 0)
  for pid $ \ix -> do
    size <- deref (tab ! ix)
    result += size
  ret =<< deref result

-- | Return true if a partition-relative address plus offset lies
-- within the bounds of a partition.
partition_in_bounds :: Def ('[PartitionID, Uint16, Uint16] :-> IBool)
partition_in_bounds = proc "partition_in_bounds" $ \pid base off -> body $ do
  size  <- call partition_size pid
  addr  <- assign (base + off)
  ret (addr <? size)

----------------------------------------------------------------------
-- Partition I/O

-- | Read a block of data from a partition.  Returns true if the read
-- is successful, false if an EEPROM error occurs or the access is out
-- of bounds.
partition_read :: Def ('[ PartitionID                   -- partition
                        , Uint16                        -- offset
                        , Ref s (CArray (Stored Uint8)) -- buf
                        , Uint16] :-> IBool)            -- len
partition_read = proc "partition_read" $ \pid addr buf len -> body $ do
  start_ok <- call partition_in_bounds pid addr 0
  end_ok   <- call partition_in_bounds pid addr len
  ift (iNot (start_ok .&& end_ok))
    (ret false)

  start   <- call partition_start pid
  read_ok <- call eeprom_read (addr + start) buf (safeCast len)
  ret read_ok

-- | Write a block of data to a partition.  Returns true if the write
-- is successful, false if an EEPROM error occurs or the access is out
-- of bounds.
partition_write :: Def ('[ PartitionID                        -- partition
                         , Uint16                             -- offset
                         , ConstRef s (CArray (Stored Uint8)) -- buf
                         , Uint16] :-> IBool)                 -- len
partition_write = proc "partition_write" $ \pid addr buf len -> body $ do
  start_ok <- call partition_in_bounds pid addr 0
  end_ok   <- call partition_in_bounds pid addr len
  ift (iNot (start_ok .&& end_ok))
    (ret false)

  start    <- call partition_start pid
  write_ok <- call eeprom_write (addr + start) buf (safeCast len)
  ret write_ok

----------------------------------------------------------------------
-- Ivory Module

partitionModule :: Module
partitionModule = package "storage_partition" $ do
  depend eepromModule
  defMemArea partition_table
  incl partition_size
  incl partition_start
  incl partition_in_bounds
  incl partition_read
  incl partition_write