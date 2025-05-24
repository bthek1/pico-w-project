add_executable(pico_w_project
    main.c
)

target_link_libraries(pico_w_project
    pico_stdlib
    pico_cyw43_arch_lwip_threadsafe_background
)

pico_add_extra_outputs(pico_w_project)

include_directories(${CMAKE_CURRENT_LIST_DIR})  # for lwipopts.h
