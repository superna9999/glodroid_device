# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/lepotato/device.mk)

PRODUCT_BOARD_PLATFORM := amlogic
PRODUCT_NAME := lepotato
PRODUCT_DEVICE := lepotato
PRODUCT_BRAND := AML-905X-CC
PRODUCT_MODEL := lepotato
PRODUCT_MANUFACTURER := Libre Computer
PRODUCT_HAS_EMMC := true

UBOOT_DEFCONFIG := libretech-cc_defconfig

KERNEL_DEFCONFIG := device/glodroid/platform/common/amlogic/amlogic_defconfig

AMLOGIC_FIP_SOC_FAMILY := gxl
AMLOGIC_FIP_FILES := vendor/amlogic/amlogic-boot-fip/lepotato

KERNEL_DTB_FILE := amlogic/meson-gxl-s905x-libretech-cc.dtb

SYSFS_MMC0_PATH := soc/d074000.mmc
