# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/vim3/device.mk)

PRODUCT_BOARD_PLATFORM := amlogic
PRODUCT_NAME := vim3
PRODUCT_DEVICE := vim3
PRODUCT_BRAND := VIM3
PRODUCT_MODEL := vim3
PRODUCT_MANUFACTURER := khadas
PRODUCT_HAS_EMMC := true

UBOOT_DEFCONFIG := khadas-vim3_defconfig

KERNEL_DEFCONFIG := device/glodroid/platform/common/amlogic/amlogic_defconfig

AMLOGIC_FIP_SOC_FAMILY := g12b
AMLOGIC_FIP_FILES := vendor/amlogic/amlogic-boot-fip/khadas-vim3

KERNEL_DTB_FILE := amlogic/meson-g12b-a311d-khadas-vim3.dtb

SYSFS_MMC0_PATH := soc/ffe07000.mmc
