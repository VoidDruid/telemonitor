#ifndef H_MONITOR
#define H_MONITOR
// comments are params for haskell bindings generator
long number_of_cores();  // fromIntegral
unsigned long number_of_processes();  // fromIntegral
unsigned long free_ram();  // fromIntegral | / megabyte
unsigned long total_ram();  // fromIntegral | / megabyte
# endif
