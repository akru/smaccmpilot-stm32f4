# -*- Mode: makefile-gmake; indent-tabs-mode: t; tab-width: 2 -*-
#
# platform_nucleo_f401re.mk --- STM32F4 Nucleo-F401RE board support
#
# Copyright (C) 2014, Galois, Inc.
# All Rights Reserved.
#
# This software is released under the "BSD3" license.  Read the file
# "LICENSE" for more information.
#
# Written by Pat Hickey    <pat@galois.com>,     April 14, 2014
#

include mk/platform/toolchain_stm32f4.mk
include mk/platform/board_nucleo_f401re.mk

# platform argument for tower builds
nucleo_f401re_freertos_TOWER_PLATFORM := nucleo_f401re

# operating system argument for tower builds
nucleo_f401re_freertos_TOWER_OS := freertos

# vim: set ft=make noet ts=2:
