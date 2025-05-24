#!/bin/bash

set -e

# Styling
INFO="\033[1;34m[INFO]\033[0m"
OK="\033[1;32m[ OK ]\033[0m"
ERR="\033[1;31m[FAIL]\033[0m"

# Step 1: Find the UF2 file
UF2_FILE=$(find build/ -name "*.uf2" | head -n 1)

if [ -z "$UF2_FILE" ]; then
    echo -e "$ERR No .uf2 file found in build/. Please run ./compile.sh first."
    exit 1
fi

echo -e "$INFO Found firmware: $UF2_FILE"

# Step 2: Detect Pico W mount point
PICO_MOUNT=$(find /media/$USER -type d -name "RPI-RP2" 2>/dev/null | head -n 1)

if [ -z "$PICO_MOUNT" ]; then
    echo -e "$ERR Could not find RPI-RP2 mount. Please connect your Pico W in BOOTSEL mode."
    exit 1
fi

echo -e "$INFO Pico W mounted at: $PICO_MOUNT"

# Step 3: Copy the firmware
cp "$UF2_FILE" "$PICO_MOUNT"
sync

echo -e "$OK Firmware flashed to Pico W successfully."
