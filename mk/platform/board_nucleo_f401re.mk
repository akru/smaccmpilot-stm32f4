# -*- Mode: makefile-gmake; indent-tabs-mode: t; tab-width: 2 -*-
#
# board_nucleo_f401re.mk --- STM32F4 Nucleo F104RE board support
#
# Copyright (C) 2014, Galois, Inc.
# All Rights Reserved.
#
# This software is released under the "BSD3" license.  Read the file
# "LICENSE" for more information.
#
# Written by Pat Hickey <pat@galois.com>, 14 April, 2014
#

# In reality, the Nucleo F401RE does not have an HSE crystal, we're
# using the old HSE names because I don't want to generalize it everywhere,
# and also an option to use the HSI instead.

# Frequency of the internal HSI oscillator in Hz.
BOARD_HSE_FREQ := 8000000

# Add the HSE frequency to the default CFLAGS.
CFLAGS += -DHSE_VALUE=$(BOARD_HSE_FREQ)

CFLAGS += -DCONFIG_STM32F4_PLL_USE_HSI

# Add a preprocessor definition for this board.
CFLAGS += -DCONFIG_BOARD_NUCLEO_F401RE

# vim: set ft=make noet ts=2:
