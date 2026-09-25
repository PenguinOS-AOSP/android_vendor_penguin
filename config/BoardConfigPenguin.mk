ifeq ($(TARGET_USE_QTI_BT_STACK),true)
PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/commonsys/packages/apps/Bluetooth \
    vendor/qcom/opensource/commonsys/system/bt/conf
endif #TARGET_USE_QTI_BT_STACK

include device/statix/sepolicy/common/sepolicy.mk
include vendor/penguin/sepolicy/sepolicy.mk
include vendor/penguin/config/BoardConfigSoong.mk

# vendor/google/pixel (PenguinOS GMS) ships its own turbo_adapter and flipendo
# policy; drop the duplicate hardware/google/pixel-sepolicy copies added above.
ifneq ($(wildcard vendor/google/pixel/sepolicy),)
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS := $(filter-out hardware/google/pixel-sepolicy/%,$(SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS))
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS := $(filter-out hardware/google/pixel-sepolicy/%,$(SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS))
endif
