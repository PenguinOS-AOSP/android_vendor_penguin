#
# Copyright (C) 2018-2022 StatiXOS
#
# SPDX-License-Identifier: Apache-2.0
#

include vendor/penguin/build/core/pathmap.mk
include vendor/penguin/build/core/utils.mk

# Conditionally call QCOM makefiles
ifeq ($(PRODUCT_USES_QCOM_HARDWARE), true)
include hardware/qcom-caf/common/build/core/ProductConfigQcom.mk
endif

# Google - GMS, Pixel, and Mainline Modules
ifneq ($(TARGET_DOES_NOT_USE_GAPPS), true)
$(call inherit-product-if-exists, vendor/gms/products/gms.mk)
$(call inherit-product-if-exists, vendor/gms/common/common-vendor.mk)
$(call inherit-product-if-exists, vendor/google/pixel/config.mk)
# Anything including updatable_apex.mk should have done so by now.
ifeq ($(TARGET_FLATTEN_APEX), false)
$(call inherit-product-if-exists, vendor/partner_modules/build/mainline_modules.mk)
else
$(call inherit-product-if-exists, vendor/partner_modules/build/mainline_modules_flatten_apex.mk)
endif
endif

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true \
    dalvik.vm.debug.alloc=0 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dataroaming=false \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent \
    ro.com.android.dateformat=MM-dd-yyyy \
    persist.sys.disable_rescue=true \
    ro.build.selinux=1

# Lineage interfaces
PRODUCT_PACKAGES += \
    framework_compatibility_matrix.lineage.xml

# Enable Material Design 3 Expressive
PRODUCT_PRODUCT_PROPERTIES += \
    is_expressive_design_enabled=true

# Enable the new fast charging threshold
PRODUCT_PRODUCT_PROPERTIES += \
    charging_string.apply_v2=true

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

# Copy over some Penguin assets
PRODUCT_COPY_FILES += \
    vendor/penguin/prebuilt/etc/init.penguin.rc:system/etc/init/init.penguin.rc \
    vendor/penguin/prebuilt/etc/permissions/privapp-permissions-penguin-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-penguin-product.xml \
    vendor/penguin/prebuilt/etc/permissions/privapp-permissions-penguin-se.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-penguin-se.xml


# Packages
include vendor/penguin/config/packages.mk

# Branding
include vendor/penguin/config/branding.mk

# PenguinOS product configuration
include vendor/penguin/config/penguin.mk

# Private signing keys (vendor/lineage-priv/keys, generated with gen_keys.py)
-include vendor/lineage-priv/keys/keys.mk

# Artifact path requirements
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/etc/pvmfw.bin \
    system/etc/init/init.penguin.rc \
    system/lib/libRSSupport.so \
    system/lib/libblasV8.so \
    system/lib/librsjni.so \
    system/lib64/libRSSupport.so \
    system/lib64/libblasV8.so \
    system/lib64/librsjni.so \
    system/lib64/libtensorflowlite_jni.so

# Flags
ifeq ($(TARGET_BUILD_VARIANT), user)
    PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
    PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
    PRODUCT_SYSTEM_SERVER_DEBUG_INFO := false
    WITH_DEXPREOPT_DEBUG_INFO := false
endif
