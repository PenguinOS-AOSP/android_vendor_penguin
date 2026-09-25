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

# Only use our certificates when release keys have been generated
ifneq ($(wildcard vendor/penguin/build/target/product/security/bluetooth.x509.pem),)
PRODUCT_MAINLINE_BLUETOOTH_SEPOLICY_DEV_CERTIFICATES=vendor/penguin/build/target/product/security
endif
ifneq ($(wildcard vendor/penguin/build/target/product/security/nfc.x509.pem),)
PRODUCT_MAINLINE_NFC_SEPOLICY_DEV_CERTIFICATES=vendor/penguin/build/target/product/security
endif

# Some useful shell based utilities for Android
PRODUCT_PACKAGES += \
    htop \
    nano \
    vim

# Charger images
PRODUCT_PACKAGES += \
    charger_res_images
