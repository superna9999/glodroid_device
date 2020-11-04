# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2020 Roman Stratiienko (r.stratiienko@gmail.com)

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, device/glodroid/common/device-common.mk)
$(call inherit-product, device/glodroid/common/bluetooth/no-bluetooth.mk)

DEVICE_TYPE := tv

PRODUCT_COPY_FILES += \
    device/glodroid/odroid_n2/audio.odroid_n2.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio.odroid_n2.xml
