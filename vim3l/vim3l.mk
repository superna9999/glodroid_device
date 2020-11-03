# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/vim3l/device.mk)

PRODUCT_BOARD_PLATFORM := amlogic
PRODUCT_NAME := vim3l
PRODUCT_DEVICE := vim3l
PRODUCT_BRAND := VIM3L
PRODUCT_MODEL := vim3l
PRODUCT_MANUFACTURER := khadas
PRODUCT_HAS_EMMC := true

UBOOT_DEFCONFIG := khadas-vim3l_defconfig

KERNEL_DEFCONFIG := device/glodroid/platform/common/amlogic/amlogic_defconfig

AMLOGIC_FIP_SOC_FAMILY := g12a
AMLOGIC_FIP_FILES := vendor/amlogic/amlogic-boot-fip/khadas-vim3l

KERNEL_DTB_FILE := amlogic/meson-sm1-khadas-vim3l.dtb

SYSFS_MMC0_PATH := soc/ffe07000.mmc
