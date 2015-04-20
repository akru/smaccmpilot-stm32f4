
# Need to use absolute paths so that the IVORY_REPO may be exported for a
# recursive Makefile call

CURRENT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

IVORY_REPO ?= $(CURRENT_DIR)/../../../ivory
TOWER_REPO ?= $(CURRENT_DIR)/../../../tower
BSP_REPO ?= $(CURRENT_DIR)/../../../ivory-tower-stm32
GIDL_REPO ?= ../../../gidl
SCARGOT_REPO ?= ../../../s-cargot

default: smaccm-comm-schema-native
default: smaccm-comm-schema-tower

test: smaccm-comm-schema-native-test
test: smaccm-comm-schema-tower-test

.PHONY: smaccm-comm-schema-native
smaccm-comm-schema-native:
	cabal exec gidl -- -b haskell \
		-i smaccm-comm-schema.idl \
		-o smaccm-comm-schema-native \
		-p smaccm-comm-schema-native \
		-n SMACCMPilot.Comm.Native

.PHONY: smaccm-comm-schema-tower
smaccm-comm-schema-tower:
	cabal exec gidl -- -b tower \
		-i smaccm-comm-schema.idl \
		-o smaccm-comm-schema-tower \
		-p smaccm-comm-schema-tower \
		-n SMACCMPilot.Comm

smaccm-comm-schema-native-test: smaccm-comm-schema-native
	make -C smaccm-comm-schema-native create-sandbox
	make -C smaccm-comm-schema-native
	make -C smaccm-comm-schema-native test

smaccm-comm-schema-tower-test: smaccm-comm-schema-tower
	IVORY_REPO=$(IVORY_REPO) \
	TOWER_REPO=$(TOWER_REPO) \
	BSP_REPO=$(BSP_REPO) \
		make -C smaccm-comm-schema-tower create-sandbox
	make -C smaccm-comm-schema-tower
	make -C smaccm-comm-schema-tower test

create-sandbox:
	cabal sandbox init
	cabal sandbox add-source $(IVORY_REPO)/ivory-artifact
	cabal sandbox add-source $(SCARGOT_REPO)
	cabal sandbox add-source $(GIDL_REPO)
	cabal install gidl


clean:
	-rm -rf smaccm-comm-schema-native
	-rm -rf smaccm-comm-schema-tower

distclean: clean
	-rm -rf dist

clean-sandbox: distclean
	-rm -rf .cabal-sandbox
	-rm -rf cabal.sandbox.config
