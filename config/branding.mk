#
# Copyright (C) 2018-2024 StatiXOS
#
# SPDX-License-Identifier: Apache-2.0
#

# Set date and time
BUILD_DATE := $(shell date +%Y%m%d)

## Versioning System
# PenguinOS major version flavor. Only changes per major Android release.
PENGUIN_MAJOR_VERSION := celerity
PENGUIN_PLATFORM_VERSION := $(PLATFORM_VERSION)

ifdef PENGUIN_BUILDVERSION
    PENGUIN_MINOR_VERSION := $(PENGUIN_BUILDVERSION)
endif

# Build type: UNOFFICIAL (default), ALPHA, BETA, OFFICIAL or STABLE
ifndef PENGUIN_BUILD_TYPE
    PENGUIN_BUILD_TYPE := UNOFFICIAL
endif
PENGUIN_BUILD_VARIANT := $(shell echo $(PENGUIN_BUILD_TYPE) | tr '[:upper:]' '[:lower:]')

# Display version, e.g. "Celerity-Unofficial" or "Celerity-<minor>" for stable builds
ifeq ($(filter stable,$(PENGUIN_BUILD_VARIANT)),)
    PENGUIN_DISPLAY_VERSION := $(shell V1=$(PENGUIN_MAJOR_VERSION); V2=$(PENGUIN_BUILD_VARIANT); echo -n $${V1^}-$${V2^})
else
    PENGUIN_DISPLAY_VERSION := $(shell V1=$(PENGUIN_MAJOR_VERSION); echo -n $${V1^})-$(PENGUIN_MINOR_VERSION)
endif

PENGUIN_DEVICE := $(patsubst penguin_%,%,$(TARGET_PRODUCT))
PENGUIN_VERSION := PenguinOS-$(PENGUIN_MAJOR_VERSION)-$(BUILD_DATE)-$(PENGUIN_DEVICE)-$(PENGUIN_BUILD_TYPE)

# Fingerprint
ROM_FINGERPRINT := PenguinOS/$(PLATFORM_VERSION)/$(PENGUIN_BUILD_TYPE)/$(BUILD_DATE)
# Declare it's a Penguin build
PENGUIN_BUILD := true

# PenguinOS version properties
PRODUCT_SYSTEM_PROPERTIES += \
    ro.penguin.version=$(PENGUIN_MAJOR_VERSION)-$(PENGUIN_BUILD_TYPE)-$(BUILD_DATE) \
    ro.penguin.version.major=$(PENGUIN_MAJOR_VERSION) \
    ro.penguin.version.minor=$(PENGUIN_MINOR_VERSION) \
    ro.penguin.build.variant=$(PENGUIN_BUILD_VARIANT) \
    ro.mod.version=$(BUILD_ID)-$(BUILD_DATE)-$(PENGUIN_MAJOR_VERSION) \
    ro.penguin.fingerprint=$(ROM_FINGERPRINT) \
    ro.penguin.buildtype=$(PENGUIN_BUILD_TYPE)

# Compatibility properties read by PenguinOS/AOSPA apps (Updater, Settings)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.aospa.version=$(PENGUIN_DISPLAY_VERSION) \
    ro.aospa.version.major=$(PENGUIN_MAJOR_VERSION) \
    ro.aospa.version.minor=$(PENGUIN_MINOR_VERSION) \
    ro.aospa.build.variant=$(PENGUIN_BUILD_VARIANT)

## Signing
ifneq (eng,$(TARGET_BUILD_VARIANT))
    # Define security directory
    PROD_CERTS := vendor/penguin/build/target/product/security

    # Display a cleaner build number even on userdebug builds
    ifeq (userdebug,$(TARGET_BUILD_VARIANT))
        DISPLAY_ID := $(BUILD_ID)-$(TARGET_BUILD_VARIANT) $(BUILD_KEYS)
    else
        DISPLAY_ID := $(BUILD_ID) $(BUILD_KEYS)
    endif

    # Release keys
    ifneq (,$(wildcard $(PROD_CERTS)/releasekey.pk8))
        PRODUCT_DEFAULT_DEV_CERTIFICATE := $(PROD_CERTS)/releasekey
        # OEM unlock
        PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.oem_unlock_supported=1
        # Strip build keys info from display ID
        ifeq (userdebug,$(TARGET_BUILD_VARIANT))
            DISPLAY_ID := $(BUILD_ID)-$(TARGET_BUILD_VARIANT)
        else
            DISPLAY_ID := $(BUILD_ID)
        endif
    endif

    # Override display ID with the final value
    PRODUCT_BUILD_PROP_OVERRIDES += BuildDisplayId="$(DISPLAY_ID)"
    ifeq (userdebug,$(TARGET_BUILD_VARIANT))
        PRODUCT_BUILD_PROP_OVERRIDES += BuildDescOverride="$(DISPLAY_ID)"
    endif

    # OTA keys
    ifneq (,$(wildcard $(PROD_CERTS)/otakey.x509.pem))
        PRODUCT_OTA_PUBLIC_KEYS := $(PROD_CERTS)/otakey.x509.pem
    endif
endif
