#include <unistd.h>
#include "monitor.h"

long number_of_processors() {
    return sysconf(_SC_NPROCESSORS_ONLN);
}
