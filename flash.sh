#!/bin/bash

set -e

# Styling
INFO="\033[1;34m[INFO]\033[0m"
OK="\033[1;32m[ OK ]\033[0m"
ERR="\033[1;31m[FAIL]\033[0m"

# Step 1: Resolve UF2 file path from folder name or default
SEARCH_FOLDER="build/main"  # default folder
if [ -n "$1" ]; then
    SEARCH_FOLDER="build/$1"
    echo -e "$INFO Searching in: $SEARCH_FOLDER"
else
    echo -e "$INFO No folder provided. Defaulting to: $SEARCH_FOLDER"
fi

UF2_FILE=$(find "$SEARCH_FOLDER" -name "*.uf2" | head -n 1)

if [ -z "$UF2_FILE" ] || [ ! -f "$UF2_FILE" ]; then
    echo -e "$ERR No .uf2 file found in $SEARCH_FOLDER."
    echo -e "$INFO Usage: ./flash.sh [relative_build_folder]  (e.g., ./flash.sh lib/pico-examples/blink)"
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
