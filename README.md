[smaccmpilot-stm32f4](http://github.com/galoisinc/smaccmpilot-stm32f4)
==============================

The [SMACCMPilot project][smaccmpilot.org] is an embedded systems software
research project by [Galois, Inc][galois]. We're building open-source autopilot
software for small unmanned aerial vehicles (UAVs) using new high-assurance
software methods.

Complete documentation for this repository and related SMACCMPilot work is
available at [smaccmpilot.org][].

[galois]: http://corp.galois.com
[smaccmpilot.org]: http://smaccmpilot.org

## Contents

This repository contains both the flight controller implementation and board
support package for the SMACCMPilot project. This includes both C sources and
Haskell sources for [Ivory language][ivory] programs.

[ivory]: http://smaccmpilot.org/software/ivory-overview.html

#### Apps

The `/apps` directory contains sources for building applications. The
primary SMACCMPilot flight controller application is called `stabilize`,
other applications are for development or testing.

Note that test application sources exist elsewhere in the tree as well.

#### Ivory

The `/ivory` directory contains the SMACCMPilot Ivory sources. These sources
are built according to the Cabal package `smaccmpilot`.

#### Src

The `/src` directory contains static libraries used by SMACCMPilot, including
the MAVLink implementation, board support package, and others. Some of these
static libraries include Ivory sources as well.

#### Generated

The `/generated` directory is the destination for C sources generated by
Ivory. At this time it contains the build scripts for one library,
`flight-generated`, which is the output of the SMACCMPilot Ivory found in
`/ivory`.

## Dependencies

This repository has several external dependencies which may be burdensome to
install. For convenience, we have provided a [smaccmpilot-build][] repository
which packages this repository and all of the required dependencies using git
submodules. We recommend you [clone smaccmpilot-build][smaccmpilot-build] and
follow the documentation instructions for [prerequisites][] and [building][].

[smaccmpilot-build]: http://github.com/galoisinc/smaccmpilot-build
[prerequisites]: http://smaccmpilot.org/software/prerequisites.html
[building]: http://smaccmpilot.org/software/build.html

### Ivory Language

This repository includes Haskell sources for [Ivory language][ivory] programs.
The Ivory language compiler will generates C sources as part of the build
process.

You'll need to install the `smaccpilot` Cabal package in the `/ivory` subdirectory
and provide the [Ivory language][ivory-lang] and [Tower framework][tower]
dependencies.

[ivory-lang]: http://github.com/galoisinc/ivory
[tower]: http://github.com/galoisinc/tower

The Ivory language requires the [GHC Haskell Compiler][ghc] version 7.6.2 or
greater.

[ghc]: http://www.haskell.org/ghc

### Cortex-M4 Toolchain

Download and unpack the [gcc-arm-embedded toolchain][1].

[1]:https://launchpad.net/gcc-arm-embedded

### FreeRTOS

[Download the latest FreeRTOS][2] release. We're using version 7.3.0.

Unpack the ZIP file in a directory near the smaccmpilot-stm32f4 tree: the same
parent directory is best. We will refer to the path of the unzipped source
tree during build configuration.

[2]: http://sourceforge.net/projects/freertos/files/

### ArduPilot

Many of the libraries in the SMACCMPilot software are from the ArduPilot
project.

Clone the [Galois fork of the ArduPilot repo][22], using the `master` branch.
Keep this clone in a directory near the smaccmpilot-stm32f4 tree, as you did
with the FreeRTOS sources.

[22]:https://github.com/GaloisInc/ardupilot.git

## Configuration File

  1. Copy `Config.mk.example` to `Config.mk`.  Open this file in a text editor.
  2. Set `CONFIG_CORTEX_M4_PREFIX` to the location of the Cortex-M4 toolchain.
  3. Set `CONFIG_FREERTOS_PREFIX` to the location of the FreeRTOS source.
  3. Set `CONFIG_ARDUPILOT_PREFIX` to the location of the Ardupilot source.
  4. Set `CONFIG_BOARD` to `fmu_v17` for the PX4FMU, or `stm32f4-discovery`.

## Compiling

  1. Simply run `make` from the top-level directory.  You can also specify
     a specific target such as `libhwf4.a`.
  2. Build output is placed in the `build` directory.  The test program images
     are in the `build/$(CONFIG_ARCH)/$(CONFIG_BOARD)/img` directory.

