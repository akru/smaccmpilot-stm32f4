{-# LANGUAGE NoMonomorphismRestriction #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE FlexibleInstances #-}
--
-- Stabilize.hs --- Pitch and roll stabilization PID controller.
--
-- Copyright (C) 2012, Galois, Inc.
-- All Rights Reserved.
--
-- TBD: License terms?
--

module Stabilize where

import Control.Applicative

import Ivory.Language

----------------------------------------------------------------------
-- Ivory Module


stabilizeModule :: Module
stabilizeModule = package "pid_stabilize" $ do
  defStruct (Proxy :: Proxy "PID")
  incl pid_update
  incl stabilize_from_angle
  incl stabilize_from_rate

----------------------------------------------------------------------
-- Ivory Utilities
--
-- If these are generally useful, they should probably be moved into a
-- "user-space" Ivory utility module.

-- | Infix structure field access and dereference.
--
-- This is a shorthand for 'deref $ s~>x'.
struct ~>* label = deref $ struct~>label
infixl 8 ~>*

-- | Modify the value stored at a reference by a function.
(%=) :: (IvoryType r, IvoryExpr a) => Ref (Stored a) -> (a -> a) -> Ivory r ()
ref %= f = do
  val <- deref ref
  store ref (f val)

-- | Increment the value stored at a reference.
(+=) :: (Num a, IvoryType r, IvoryExpr a) => Ref (Stored a) -> a -> Ivory r ()
ref += x = ref %= (+ x)

----------------------------------------------------------------------
-- Generic PID Controller

-- This is incorrectly called "PID" because I will be adding the
-- derivative term in once this is working with just PI.
[ivory|
  struct PID
    { pid_pGain  :: Stored IFloat
    ; pid_iGain  :: Stored IFloat
    ; pid_iState :: Stored IFloat
    ; pid_iMin   :: Stored IFloat
    ; pid_iMax   :: Stored IFloat
  }
|]

-- | Constrain a numeric value to the range [min..max].
constrain min max x = ((x <? min) ? (min, ((x >? max) ? (max, x))))

-- | Update a PID controller given an error value and return the
-- output value.
pid_update :: Def ('[(Ref (Struct "PID")), IFloat] :-> IFloat)
pid_update = proc "pid_update" $ \pid err -> do
  p_term <- fmap (* err) (pid~>*pid_pGain)
  i_min <- pid~>*pid_iMin
  i_max <- pid~>*pid_iMax
  pid~>pid_iState %= (constrain i_min i_max . (+ err))
  i_term <- liftA2 (*) (pid~>*pid_iGain) (pid~>*pid_iState)
  ret $ p_term + i_term

----------------------------------------------------------------------
-- Stabilization

-- | Convert an angle in radians to degrees.
degrees :: (Fractional a) => a -> a
degrees x = x * 57.295779513082320876798154814105

stabilize_from_angle :: Def ('[
  (Ref (Struct "PID")),         -- angle_pid
  (Ref (Struct "PID")),         -- rate_pid
  IFloat,                       -- stick_angle_norm
  IFloat,                       -- max_stick_angle_deg
  IFloat,                       -- sensor_angle_rad,
  IFloat,                       -- sensor_rate_rad_s
  IFloat                        -- max_servo_rate_rad_s
 ] :-> IFloat)
stabilize_from_angle = proc "stabilize_from_angle" $
  \angle_pid rate_pid stick_angle_norm
   max_stick_angle_deg sensor_angle_rad
   sensor_rate_rad_s max_servo_rate_rad_s -> do
  stick_angle_deg   <- assign $ stick_angle_norm * max_stick_angle_deg
  sensor_angle_deg  <- assign $ degrees sensor_angle_rad
  angle_error       <- assign $ stick_angle_deg - sensor_angle_deg
  rate_deg_s        <- call pid_update angle_pid angle_error
  sensor_rate_deg_s <- assign $ degrees sensor_rate_rad_s
  rate_error        <- assign $ rate_deg_s - sensor_rate_deg_s
  servo_rate_deg_s  <- call pid_update rate_pid rate_error
  servo_rate_norm   <- assign $
                       (constrain
                        (-max_servo_rate_rad_s)
                        max_servo_rate_rad_s
                        servo_rate_deg_s) / max_servo_rate_rad_s
  ret servo_rate_norm

-- | Return a normalized servo output given a normalized stick input
-- representing the desired rate.  Only uses the rate PID controller.
stabilize_from_rate :: Def ('[
  (Ref (Struct "PID")),         -- rate_pid
  IFloat,                       -- stick_rate_norm
  IFloat,                       -- max_stick_rate_deg_s
  IFloat,                       -- sensor_rate_rad_s
  IFloat                        -- max_servo_rate_rad_s
 ] :-> IFloat)
stabilize_from_rate = proc "stabilize_from_rate" $
  \rate_pid stick_rate_norm max_stick_rate_deg_s
   sensor_rate_rad_s max_servo_rate_rad_s -> do
  stick_rate_deg_s  <- assign $ stick_rate_norm * max_stick_rate_deg_s
  sensor_rate_deg_s <- assign $ degrees sensor_rate_rad_s
  rate_error        <- assign $ stick_rate_deg_s - sensor_rate_deg_s
  servo_rate_deg_s  <- call pid_update rate_pid rate_error
  servo_rate_norm   <- assign $
                       (constrain
                        (-max_servo_rate_rad_s)
                        max_servo_rate_rad_s
                        servo_rate_deg_s) / max_servo_rate_rad_s
  ret servo_rate_norm
