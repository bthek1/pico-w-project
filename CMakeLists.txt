cmake_minimum_required(VERSION 3.13)

# Set SDK path
set(PICO_SDK_PATH "${CMAKE_CURRENT_LIST_DIR}/lib/pico-sdk")

# Enable Wi-Fi and set board BEFORE SDK is initialized
set(PICO_BOARD pico_w)
set(PICO_CYW43_SUPPORTED 1)

include(${PICO_SDK_PATH}/pico_sdk_init.cmake)

project(pico_w_project C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

pico_sdk_init()

add_subdirectory(main)
