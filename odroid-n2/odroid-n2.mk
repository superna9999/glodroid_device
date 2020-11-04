# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/odroid-n2/device.mk)

PRODUCT_BOARD_PLATFORM := amlogic
PRODUCT_NAME := odroid-n2
PRODUCT_DEVICE := odroid-n2
PRODUCT_BRAND := ODROID-N2
PRODUCT_MODEL := odroid-n2
PRODUCT_MANUFACTURER := hardkernel
PRODUCT_HAS_EMMC := true

UBOOT_DEFCONFIG := odroid-n2_defconfig

KERNEL_DEFCONFIG := device/glodroid/platform/common/amlogic/amlogic_defconfig

AMLOGIC_FIP_SOC_FAMILY := g12b
AMLOGIC_FIP_FILES := vendor/amlogic/amlogic-boot-fip/odroid-n2

KERNEL_DTB_FILE := amlogic/meson-g12b-odroid-n2.dtb

SYSFS_MMC0_PATH := soc/ffe07000.mmc
