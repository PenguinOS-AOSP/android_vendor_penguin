#
# Copyright (C) 2018-2022 StatiXOS
#
# SPDX-License-Identifier: Apache-2.0
#

# Include librsjni explicitly to workaround GMS issue
PRODUCT_PACKAGES += \
    librsjni

# TFLite service.
PRODUCT_PACKAGES += libtensorflowlite_jni

# APEX
DISABLE_DEXPREOPT_CHECK := true

PRODUCT_MAINLINE_BLUETOOTH_SEPOLICY_DEV_CERTIFICATES=vendor/penguin/build/target/product/security
PRODUCT_MAINLINE_NFC_SEPOLICY_DEV_CERTIFICATES=vendor/penguin/build/target/product/security

# Some useful shell based utilities for Android
PRODUCT_PACKAGES += \
    htop \
    nano \
    vim

# Charger images
PRODUCT_PACKAGES += \
    charger_res_images \
    charger_res_images_vendor_pixel
