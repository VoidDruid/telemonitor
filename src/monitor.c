#include <unistd.h>
#include <linux/kernel.h>
#include <sys/sysinfo.h>
#include "monitor.h"

struct sysinfo get_sysinfo() {
    struct sysinfo si;
    sysinfo(&si);
    return si;
}

long number_of_cores() {
    return sysconf(_SC_NPROCESSORS_ONLN);
}

unsigned long free_ram() {
    struct sysinfo si = get_sysinfo();
    return si.freeram;
}

unsigned long total_ram() {
    struct sysinfo si = get_sysinfo();
    return si.totalram;
}

unsigned long number_of_processes() {
    struct sysinfo si = get_sysinfo();
    return si.procs;
}
