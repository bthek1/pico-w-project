cmake_minimum_required(VERSION 3.13)

# Set SDK path
set(PICO_SDK_PATH "${CMAKE_CURRENT_LIST_DIR}/lib/pico-sdk")

# Enable Wi-Fi and set board BEFORE SDK is initialized
set(PICO_BOARD pico_w)
set(PICO_CYW43_SUPPORTED 1)
set(PICO_CYW43_LWIP_MQTT 1)   # ✅ MUST be set before adding pico-examples

set(WIFI_SSID "THEKKEL_MESH")
set(WIFI_PASSWORD "81168040")
set(MQTT_SERVER "192.168.2.106")  # or "test.mosquitto.org"


include(${PICO_SDK_PATH}/pico_sdk_init.cmake)

project(pico_w_project C CXX ASM)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)

pico_sdk_init()

add_subdirectory(main)
# Add pico-examples directory as a subproject
add_subdirectory(lib/pico-examples)