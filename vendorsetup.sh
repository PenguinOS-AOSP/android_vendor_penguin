#!/bin/bash

# Color variables
YELLOW='\033[1;33m'
RESET='\033[0m'

# Check if the welcome message has already been shown
if [ -z "${WELCOME_SHOWN}" ]; then

    # Welcome message
    echo -e "Welcome to ${YELLOW}PenguinOS!${RESET}"

    # Additional instructions
    echo -e "\nPenguinOS on AOSP uses the StatiX build system. StatiX device trees work with these renames:"
    echo -e "  - statix_<device>.mk        -> penguin_<device>.mk (PRODUCT_NAME := penguin_<device>)"
    echo -e "  - vendor/statix/config/*.mk -> vendor/penguin/config/*.mk"
    echo -e "  - STATIX_* variables        -> PENGUIN_* variables"
    echo -e "\nBuild with: brunch penguin_<device>-cp2a-userdebug\n"

    export WELCOME_SHOWN=true

else
    echo -e "Welcome to ${YELLOW}PenguinOS!${RESET}"
    echo -e "Environment ready."
fi

# Override host metadata to make builds more reproducible and avoid leaking info
export BUILD_USERNAME=nobody
export BUILD_HOSTNAME=android-build

# Override build number
export BUILD_NUMBER=$(date +%y%m%d%S)

# Skip header ABI checks (custom ROMs change library ABIs)
export SKIP_ABI_CHECKS=true
