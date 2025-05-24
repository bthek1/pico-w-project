#!/bin/bash

set -e  # Exit on error

# Define SDK path
SDK_PATH="./lib/pico-sdk"
BUILD_DIR="build"
CLEAN_BUILD=false

# Styling
INFO="\033[1;34m[INFO]\033[0m"
OK="\033[1;32m[ OK ]\033[0m"
WARN="\033[1;33m[WARN]\033[0m"
ERR="\033[1;31m[FAIL]\033[0m"

# Parse arguments
for arg in "$@"; do
    case $arg in
        --clean)
            CLEAN_BUILD=true
            shift
            ;;
        *)
            echo -e "$ERR Unknown option: $arg"
            echo -e "$INFO Usage: ./compile.sh [--clean]"
            exit 1
            ;;
    esac
done

# Step 1: Initialize git submodules if needed
if [ ! -f "$SDK_PATH/pico_sdk_init.cmake" ]; then
    echo -e "$INFO Initializing pico-sdk submodule..."
    git submodule update --init --recursive
    echo -e "$OK pico-sdk submodule initialized"
else
    echo -e "$OK pico-sdk already initialized"
fi

# Step 2: Prepare build directory
if [ "$CLEAN_BUILD" = true ]; then
    echo -e "$INFO Cleaning build directory..."
    rm -rf "$BUILD_DIR"
    echo -e "$OK Clean complete"
fi

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Step 3: Run CMake
echo -e "$INFO Running CMake..."
cmake .. && echo -e "$OK CMake configuration complete"

# Step 4: Compile
echo -e "$INFO Building project..."
make -j"$(nproc)" && echo -e "$OK Compilation finished"

# Step 5: Completion
UF2_FILE=$(find . -name "*.uf2" | head -n 1)
if [ -f "$UF2_FILE" ]; then
    echo -e "$OK Build complete: ${UF2_FILE}"
else
    echo -e "$WARN Build completed, but no .uf2 file found"
fi
