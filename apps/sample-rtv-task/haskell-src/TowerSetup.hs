
-- Put all includes, etc. in Tower () and out of tasks
-- Make use of queues easier by external tasks
-- unused vars in, e.g., taskbody_verify_updates_2 in tower.c

{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import System.Environment (getArgs)

import Types
import CheckerTask
import Checker

import Ivory.Tower

import Ivory.Language
import qualified Ivory.Tower.Compile.FreeRTOS as F
import qualified Ivory.Compile.C.CmdlineFrontend as C


--------------------------------------------------------------------------------
-- Record Assigment
--------------------------------------------------------------------------------

legacyHdr :: String
legacyHdr = "legacy.h"

--------------------------------------------------------------------------------
-- Legacy tasks: wrappers for the tasks.
--------------------------------------------------------------------------------

-- Types
type Clk = Stored Sint32
type ClkEmitterType s = '[ConstRef s Clk] :-> ()

-- Externs
clkEmitter :: (SingI n) => ChannelEmitter n Clk -> Def (ClkEmitterType s)
clkEmitter ch = proc "clkEmitter" $ \r -> body $ emit_ ch r

read_clock_block :: Def ('[ProcPtr (ClkEmitterType s)] :-> ())
read_clock_block = importProc "read_clock_block" legacyHdr

update_time_init :: Def ('[ProcPtr ('[AssignRef s] :-> ())] :-> ())
update_time_init = importProc "update_time_init" legacyHdr

update_time_block :: Def ('[Sint32] :-> ())
update_time_block = importProc "update_time_block" legacyHdr

-- Task wrapper: task reads a logical clock and passes the result to
-- updateTimeTask.
readClockTask :: (SingI n) => ChannelSource n Clk -> Task ()
readClockTask clkSrc = do
  clk <- withChannelEmitter clkSrc "clkSrc"
  let clkEmitterProc = clkEmitter clk
  taskModuleDef $ incl clkEmitterProc
  onPeriod 1000 $ \_now -> -- once per sec
    call_ read_clock_block $ procPtr clkEmitterProc

-- Task wrapper: task reads the channel and updates its local state witht the
-- time.
updateTimeTask :: (SingI n, SingI m)
               => ChannelSink n Clk -> ChannelSource m AssignStruct -> Task ()
updateTimeTask clk chk = do
  rx <- withChannelReceiver clk "timeRx"
  newVal <- withChannelEmitter chk "newVal"
  let recordEmitProc = recordEmit newVal
  taskModuleDef $ do
    incl recordEmitProc
    incl update_time_init
  taskInit $
    call_ update_time_init $ procPtr recordEmitProc
  onChannelV rx $ \time -> do
    call_ update_time_block time

--------------------------------------------------------------------------------

tasks :: Tower ()
tasks = do
  (chkSrc, chkSink) <- channel
  (clkSrc, clkSink) <- channel
  task "verify_updates" $ checkerTask chkSink
  task "readClockTask"  $ readClockTask clkSrc
  task "updateTimeTask" $ updateTimeTask clkSink chkSrc

--------------------------------------------------------------------------------

main :: IO ()
main = do
  args <- getArgs
  let (_, objs) = F.compile tasks

  -- C.runCompiler objs C.initialOpts
  C.compileWith
    Nothing
    (Just [F.searchDir])
    (checksMod : objs)

  checker (verbose args)

  -- graphvizToFile "out.dot" asm
  where
  verbose args = "--verbose" `elem` args
              || "-v" `elem` args

--------------------------------------------------------------------------------
