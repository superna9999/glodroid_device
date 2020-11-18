# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)
#
# Makefile for ARM trusted firmware (ATF)

ifeq ($(TARGET_ARCH),arm64)
ifneq ($(PRODUCT_BOARD_PLATFORM),amlogic)

#-------------------------------------------------------------------------------
LOCAL_PATH := $(call my-dir)

#-------------------------------------------------------------------------------
ATF_SRC		:= external/arm-trusted-firmware

#-------------------------------------------------------------------------------

$(ATF_BINARY): $(sort $(shell find -L $(ATF_SRC)))
	$(MAKE_COMMON) -C $(ATF_SRC) BUILD_BASE=$$(readlink -f $(ATF_OUT)) PLAT=$(ATF_PLAT) DEBUG=1 bl31

endif
endif
