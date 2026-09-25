ifeq ($(TARGET_USE_QTI_BT_STACK),true)
PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/commonsys/packages/apps/Bluetooth \
    vendor/qcom/opensource/commonsys/system/bt/conf
endif #TARGET_USE_QTI_BT_STACK

include device/statix/sepolicy/common/sepolicy.mk
include vendor/penguin/sepolicy/sepolicy.mk
include vendor/penguin/config/BoardConfigSoong.mk
