# Android makefile to build kernel as a part of Android build

#-------------------------------------------------------------------------------
LOCAL_PATH := $(call my-dir)
#-------------------------------------------------------------------------------
ifeq ($(TARGET_PREBUILT_KERNEL),)

#-------------------------------------------------------------------------------
ifeq ($(PRODUCT_BOARD_PLATFORM),sunxi)
KERNEL_SRC		:= kernel/glodroid-sunxi
endif
ifeq ($(PRODUCT_BOARD_PLATFORM),broadcom)
KERNEL_SRC		:= kernel/glodroid-broadcom
endif
ifeq ($(PRODUCT_BOARD_PLATFORM),amlogic)
KERNEL_SRC		:= kernel/glodroid-sunxi
endif

KERNEL_FRAGMENTS	:= \
    $(LOCAL_PATH)/android-base.config \
    $(LOCAL_PATH)/android-recommended.config \
    $(LOCAL_PATH)/android-extra.config \
    $(KERNEL_FRAGMENTS)

ifeq ($(TARGET_ARCH),arm64)
KERNEL_FRAGMENTS	+= \
    $(LOCAL_PATH)/android-recommended-arm64.config \
    $(LOCAL_PATH)/android-extra-arm64.config
else
KERNEL_FRAGMENTS	+= \
    $(LOCAL_PATH)/android-recommended-arm.config \
    $(LOCAL_PATH)/android-extra-arm.config
endif

KERNEL_OUT		:= $(PRODUCT_OUT)/obj/KERNEL_OBJ
KERNEL_MODULES_OUT 	:= $(PRODUCT_OUT)/obj/KERNEL_MODULES
KERNEL_VERSION_FILE     := $(KERNEL_OUT)/include/config/kernel.release
TARGET_VENDOR_MODULES   := $(TARGET_OUT_VENDOR)/lib/modules

KERNEL_BOOT_DIR		:= arch/$(TARGET_ARCH)/boot
ifeq ($(TARGET_ARCH),arm64)
KERNEL_TARGET		:= Image
else
KERNEL_TARGET		:= zImage
endif
KERNEL_BINARY		:= $(KERNEL_OUT)/$(KERNEL_BOOT_DIR)/$(KERNEL_TARGET)
KERNEL_COMPRESSED	:= $(KERNEL_OUT)/$(KERNEL_BOOT_DIR)/Image.lz4
ifeq ($(TARGET_ARCH),arm64)
KERNEL_IMAGE		:= $(KERNEL_COMPRESSED)
else
KERNEL_IMAGE		:= $(KERNEL_BINARY)
endif
KERNEL_DTS_DIR		:= $(KERNEL_BOOT_DIR)/dts
KERNEL_DTB_OUT		:= $(KERNEL_OUT)/$(KERNEL_DTS_DIR)
ANDROID_DTS_OVERLAY	?= $(LOCAL_PATH)/empty.dts
ANDROID_DTBO		:= $(KERNEL_DTB_OUT)/fstab-android-sdcard.dtbo
BOARD_PREBUILT_DTBOIMAGE := $(PRODUCT_OUT)/boot_dtbo.img
MKDTBOIMG		:= $(HOST_OUT_EXECUTABLES)/mkdtboimg.py

GEN_DTBCFG		:= $(PRODUCT_OUT)/gen/DTBO/dtbo.cfg

KMAKE := \
    $(MAKE_COMMON) \
    -C $(KERNEL_SRC) O=$$(readlink -f $(KERNEL_OUT)) \
    DTC_FLAGS='--symbols' \

#-------------------------------------------------------------------------------
$(KERNEL_OUT)/.config: $(KERNEL_DEFCONFIG) $(KERNEL_FRAGMENTS) $(sort $(shell find -L $(KERNEL_SRC)))
	cp $(KERNEL_DEFCONFIG) $(KERNEL_OUT)/.config
	$(KMAKE) olddefconfig
	PATH=/usr/bin:/bin:$$PATH $(KERNEL_SRC)/scripts/kconfig/merge_config.sh -m -O $(KERNEL_OUT)/ $(KERNEL_OUT)/.config $(KERNEL_FRAGMENTS)
	$(KMAKE) olddefconfig

$(KERNEL_BINARY): $(sort $(shell find -L $(KERNEL_SRC))) $(KERNEL_OUT)/.config
	$(KMAKE) $(KERNEL_TARGET) dtbs modules

$(KERNEL_COMPRESSED): $(KERNEL_BINARY)
	rm -f $@
	prebuilts/misc/linux-x86/lz4/lz4c -c1 $< $@

# Modules

$(KERNEL_MODULES_OUT): $(KERNEL_BINARY)
	rm -rf $@
	$(KMAKE) INSTALL_MOD_PATH=$$(readlink -f $@) modules_install

$(TARGET_VENDOR_MODULES)/modules.dep : $(KERNEL_MODULES_OUT)
	rm -rf $(TARGET_VENDOR_MODULES)/kernel
	rm -f $(TARGET_VENDOR_MODULES)/modules.*
	mkdir -p $(TARGET_VENDOR_MODULES)
	D1=$</lib/modules/$$(cat $(KERNEL_VERSION_FILE)); \
	    cp -r $${D1}/modules.dep $${D1}/modules.order $${D1}/modules.alias $${D1}/kernel $(TARGET_VENDOR_MODULES)
	D2=/vendor/lib/modules/kernel/; sed -e"s|^kernel/|$${D2}|; s| kernel/| $${D2}|g" -i $(TARGET_VENDOR_MODULES)/modules.dep

$(PRODUCT_OUT)/vendor.img: $(TARGET_VENDOR_MODULES)/modules.dep

#-------------------------------------------------------------------------------
$(ANDROID_DTBO): $(ANDROID_DTS_OVERLAY)
	rm -f $@
	./prebuilts/misc/linux-x86/dtc/dtc -@ -I dts -O dtb -o $@ $<

$(GEN_DTBCFG):
	mkdir -p $(dir $@)
	echo "# DTBO image configuration file for GloDroid project. Autogenerated, do not change!" > $@
	echo "  page_size=4096" >> $@
ifeq ($(PRODUCT_DEVICE),pinephone)
	echo "$(KERNEL_DTB_OUT)/$(KERNEL_DTB_FILE_PP11)" >> $@
	echo "  id=0x00000011" >> $@
	echo "$(KERNEL_DTB_OUT)/$(KERNEL_DTB_FILE_PP12)" >> $@
	echo "  id=0x00000012" >> $@
else
	echo "$(KERNEL_DTB_OUT)/$(KERNEL_DTB_FILE)" >> $@
	echo "  id=0x00000100" >> $@
endif
	echo "$(ANDROID_DTBO)" >> $@
	echo "  id=0x00000FFF" >> $@

$(BOARD_PREBUILT_DTBOIMAGE): $(GEN_DTBCFG) $(ANDROID_DTBO) $(KERNEL_BINARY) $(MKDTBOIMG)
	$(call pretty,"Target dtb image: $@")
	$(MKDTBOIMG) cfg_create $@ $<

#-------------------------------------------------------------------------------
$(PRODUCT_OUT)/kernel: $(KERNEL_IMAGE) $(KERNEL_MODULES_OUT)
	cp -v $< $@

#-------------------------------------------------------------------------------

include $(LOCAL_PATH)/rtl8189es-mod.mk
include $(LOCAL_PATH)/rtl8189fs-mod.mk

endif # TARGET_PREBUILT_KERNEL
