#define CYW43_ARCH_THREADSAFE_BACKGROUND

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "pico/stdlib.h"
#include "pico/cyw43_arch.h"
#include "lwip/ip4_addr.h"
#include "lwip/netif.h"

#define MAX_NETWORKS 20
#define INPUT_BUFFER_LEN 64

typedef struct {
    char ssid[33];
    uint8_t auth;
} wifi_network_t;

wifi_network_t networks[MAX_NETWORKS];
int network_count = 0;
volatile bool scan_done = false;

int scan_result(void *env, const cyw43_ev_scan_result_t *result) {
    if (!result) {
        scan_done = true;
        return 0;
    }

    if (network_count < MAX_NETWORKS && strlen(result->ssid) > 0) {
        strncpy(networks[network_count].ssid, result->ssid, sizeof(networks[network_count].ssid) - 1);
        networks[network_count].auth = result->auth_mode;
        networks[network_count].ssid[sizeof(networks[network_count].ssid) - 1] = '\0';

        printf("[%2d] SSID: %-32s RSSI: %4d Auth: %d\n",
               network_count,
               networks[network_count].ssid,
               result->rssi,
               result->auth_mode);

        network_count++;
    }

    return 0;
}

void do_scan() {
    network_count = 0;
    scan_done = false;
    printf("\n🔍 Scanning for Wi-Fi networks...\n");

    cyw43_wifi_scan_options_t scan_options = {0};
    int err = cyw43_wifi_scan(&cyw43_state, &scan_options, NULL, scan_result);
    if (err != 0) {
        printf("❌ Failed to start scan: %d\n", err);
        return;
    }
    while (cyw43_wifi_scan_active(&cyw43_state)) {
        sleep_ms(100);
        tight_loop_contents();
        cyw43_arch_poll();
    }

    if (network_count == 0) {
        printf("❌ No Wi-Fi networks found.\n");
    } else {
        printf("✅ Scan complete. %d network(s) found.\n", network_count);
    }
}

void do_connect(int index) {
    if (index < 0 || index >= network_count) {
        printf("❌ Invalid network index.\n");
        return;
    }

    printf("Connecting to [%d] %s\n", index, networks[index].ssid);
    printf("Enter password:\n> ");

    char password[64] = {0};
    int i = 0;
    while (i < sizeof(password) - 1) {
        int c = getchar_timeout_us(0);
        if (c > 0 && c != '\n' && c != '\r') {
            password[i++] = (char)c;
            putchar('*'); fflush(stdout);
        } else if (c == '\r' || c == '\n') {
            password[i] = '\0';
            break;
        }
        sleep_ms(10);
    }

    printf("\nConnecting...\n");

    int result = cyw43_arch_wifi_connect_timeout_ms(
        networks[index].ssid,
        password,
        CYW43_AUTH_WPA2_AES_PSK,
        30000
    );

    if (result != 0) {
        printf("❌ Failed to connect. Error: %d\n", result);
        return;
    }

    struct netif *netif = &cyw43_state.netif[0];
    printf("✅ Connected! Waiting for IP address...\n");

    while (netif_is_link_up(netif) && netif->ip_addr.addr == 0) {
        sleep_ms(500);
        printf(".");
    }

    printf("\n📡 Assigned IP: %s\n", ipaddr_ntoa(&netif->ip_addr));
}

int main() {
    stdio_init_all();
    while (!stdio_usb_connected()) sleep_ms(100);

    printf("========= Pico W Wi-Fi CLI =========\n");
    printf("Commands:\n - list\n - connect <index>\n\n");

    if (cyw43_arch_init()) {
        printf("❌ Failed to initialize Wi-Fi\n");
        return 1;
    }

    cyw43_arch_enable_sta_mode();

    char input[INPUT_BUFFER_LEN];
    int pos = 0;

    printf("> ");
    while (true) {
        int c = getchar_timeout_us(0);
        if (c == '\r' || c == '\n') {
            input[pos] = '\0';
            printf("\n");

            if (strncmp(input, "list", 4) == 0) {
                do_scan();
            } else if (strncmp(input, "connect ", 8) == 0) {
                int index = atoi(&input[8]);
                do_connect(index);
            } else if (pos > 0) {
                printf("❓ Unknown command: %s\n", input);
            }

            printf("\n> ");
            pos = 0;
        } else if (c != PICO_ERROR_TIMEOUT && pos < INPUT_BUFFER_LEN - 1) {
            input[pos++] = (char)c;
            putchar(c);
        }

        sleep_ms(10);
    }

    cyw43_arch_deinit();
    return 0;
}
