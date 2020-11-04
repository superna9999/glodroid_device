# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/vim2/device.mk)

PRODUCT_BOARD_PLATFORM := amlogic
PRODUCT_NAME := vim2
PRODUCT_DEVICE := vim2
PRODUCT_BRAND := VIM2
PRODUCT_MODEL := vim2
PRODUCT_MANUFACTURER := khadas
PRODUCT_HAS_EMMC := true

UBOOT_DEFCONFIG := khadas-vim2_defconfig

KERNEL_DEFCONFIG := device/glodroid/platform/common/amlogic/amlogic_defconfig

AMLOGIC_FIP_SOC_FAMILY := gxm
AMLOGIC_FIP_FILES := vendor/amlogic/amlogic-boot-fip/khadas-vim2

KERNEL_DTB_FILE := amlogic/meson-gxm-khadas-vim2.dtb

SYSFS_MMC0_PATH := soc/d0074000.mmc
