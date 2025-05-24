#ifndef _LWIPOPTS_H
#define _LWIPOPTS_H

// Use raw API only — no sequential/threaded API
#define NO_SYS                          1

// Don't build netconn or socket layers
#define LWIP_SOCKET                     0
#define LWIP_NETCONN                    0

// Enable needed protocol features
#define LWIP_NETIF_STATUS_CALLBACK      1
#define LWIP_NETIF_LINK_CALLBACK        1
#define LWIP_IPV4                       1
#define LWIP_TCP                        1
#define LWIP_UDP                        1
#define LWIP_DNS                        1

// Use system malloc
#define MEM_LIBC_MALLOC                 0
#define MEMP_MEM_MALLOC                 1
#define MEM_ALIGNMENT                   4

// Avoid struct timeval redefinition
#define LWIP_TIMEVAL_PRIVATE            0

#endif
