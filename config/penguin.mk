#
# SPDX-FileCopyrightText: Paranoid Android
# SPDX-FileCopyrightText: PenguinOS
# SPDX-License-Identifier: Apache-2.0
#
# PenguinOS product configuration, adapted from vendor/aospa/target/product/aospa-target.mk
# for an AOSP (non-CLO) base. CLO-only components (QTI telephony-ext, vndfwk detect,
# Snapdragon Clang, device/qcom/common) are intentionally left out.
#

# b/344511668
PRODUCT_PACKAGES += \
    android.software.credentials.prebuilt.xml

# Enable allowlist for some aosp packages that should not be scanned in a "stopped" state
PRODUCT_PACKAGES += initial-package-stopped-states-aosp.xml

# Abstruct
PRODUCT_PACKAGES += \
    Abstruct

# PenguinOS Setup Wizard (overrides the AOSP Provision stub)
PRODUCT_PACKAGES += \
    PenguinSetupWizard

ifeq ($(TARGET_USES_BLUR), true)
# ro.custom.blur.enable is what BlurController and BlurUtils fall back to when
# Settings.Global.disable_window_blurs has never been written.
PRODUCT_PRODUCT_PROPERTIES += \
    ro.custom.blur.enable=true \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1
endif

# Audio
# Increase volume level steps
PRODUCT_SYSTEM_PROPERTIES += \
    ro.config.media_vol_steps=30

# Boot Animation
$(call inherit-product, vendor/penguin/bootanimation/bootanimation.mk)

# Camera
PRODUCT_PACKAGES += \
    Aperture

# curl
PRODUCT_PACKAGES += \
    curl

# Dex2oat
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    dalvik.vm.dex2oat64.enabled=true

# Dexpreopt
# Don't dexpreopt prebuilts. (For GMS).
DONT_DEXPREOPT_PREBUILTS := true

PRODUCT_DEXPREOPT_SPEED_APPS += \
    Launcher3QuickStep \
    SystemUI

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.systemuicompilerfilter=speed

# Display
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    debug.sf.frame_rate_multiple_threshold=60 \
    ro.surface_flinger.enable_frame_rate_override=false

# EGL - Blobcache configuration
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.egl.blobcache.multifile=true \
    ro.egl.blobcache.multifile_limit=33554432

# Exfat FS
PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat

# Fonts
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/penguin/fonts/,$(TARGET_COPY_OUT_PRODUCT)/fonts) \
    vendor/penguin/target/config/fonts_customization.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/fonts_customization.xml

# Firewall
PRODUCT_PACKAGES += \
    Datura

# GameSpace
PRODUCT_PACKAGES += \
    GameSpace

# Gestures
PRODUCT_PACKAGES += \
    vendor.aospa.power-service

# Google
PRODUCT_PRODUCT_PROPERTIES += \
    remote_provisioning.enable_rkpd=true \
    remote_provisioning.hostname=remoteprovisioning.googleapis.com

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    vendor/penguin/target/config/penguin_vendor_framework_compatibility_matrix.xml

PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.manager@1.0 \
    android.hidl.base@1.0.vendor \
    android.hidl.manager@1.0.vendor

# Java Optimizations
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
SYSTEM_OPTIMIZE_JAVA := true
SYSTEMUI_OPTIMIZE_JAVA := true

# Keystore Compatibility
PRODUCT_COPY_FILES += \
    vendor/penguin/prebuilt/etc/keystore-compat.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/keystore-compat.rc

# LMOFreeform
PRODUCT_PACKAGES += \
    LMOFreeform \
    LMOFreeformSidebar

# MTE
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.arm64.memtag.system_server=off

# OmniJaws
PRODUCT_PACKAGES += \
    OmniJaws

# One Handed Mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Overlays
$(call inherit-product, vendor/penguin/config/overlays.mk)

# Paranoid Sense
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml

# Enable Sense service for 64-bit only
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=$(TARGET_SUPPORTS_64_BIT_APPS)

# Permissions
PRODUCT_COPY_FILES += \
    vendor/penguin/target/config/permissions/default_permissions_com.google.android.deskclock.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default_permissions_com.google.android.deskclock.xml \
    vendor/penguin/target/config/permissions/privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-hotword.xml \
    vendor/penguin/target/config/permissions/org.lineageos.health.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.health.xml

# Preinstalled Packages
PRODUCT_COPY_FILES += \
    vendor/penguin/target/config/preinstalled-packages-penguin.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/preinstalled-packages-penguin.xml

# Privapp-permissions
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.control_privapp_permissions?=log

# Sensitive Phone Numbers
ifneq ($(TARGET_NO_TELEPHONY), true)
PRODUCT_COPY_FILES += \
    vendor/penguin/target/config/sensitive_pn.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sensitive_pn.xml
endif

# StrictMode
ifneq ($(TARGET_BUILD_VARIANT),eng)
# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.strictmode.disable=true
endif

# Telephony
ifneq ($(TARGET_NO_TELEPHONY), true)
PRODUCT_PACKAGES += \
    Dialer \
    Stk
endif

# TextClassifier
PRODUCT_PACKAGES += \
    libtextclassifier_annotator_en_model \
    libtextclassifier_annotator_universal_model \
    libtextclassifier_actions_suggestions_universal_model \
    libtextclassifier_lang_id_model

# TFLite
$(call inherit-product, vendor/penguin/misc/ax_tflite/common.mk)

# Theme Picker
PRODUCT_PACKAGES += \
    ThemePicker

# Updater
PRODUCT_PACKAGES += \
    Updater \
    update_engine \
    update_verifier \
    update_engine_sideload

# WiFi
PRODUCT_PACKAGES += \
    libwpa_client
