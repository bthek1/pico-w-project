// This must be defined before any #include from cyw43
#define CYW43_ARCH_THREADSAFE_BACKGROUND

#include "pico/stdlib.h"
#include "pico/cyw43_arch.h"

int main() {
    stdio_init_all();

    if (cyw43_arch_init()) {
        printf("Wi-Fi init failed\n");
        return 1;
    }

    while (true) {
        // Use onboard Wi-Fi chip's LED
        cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN, 1);
        sleep_ms(500);
        cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN, 0);
        sleep_ms(500);
        printf("Blinking LED\n");
    }

    return 0;
}
