{-# LANGUAGE ForeignFunctionInterface #-}

module Monitor.Bindings where

import Foreign
import Foreign.C.Types

minute = 60;
hour = minute * 60;
day = hour * 24;
megabyte = 1024 * 1024;

foreign import ccall unsafe "monitor.h number_of_cores" c_number_of_cores :: CLong
numberOfCores = fromIntegral c_number_of_cores 

foreign import ccall unsafe "monitor.h number_of_processes" c_number_of_processes :: CULong
numberOfProcesses = fromIntegral c_number_of_processes 

foreign import ccall unsafe "monitor.h uptime" c_uptime :: CLong
uptime = fromIntegral c_uptime / hour

foreign import ccall unsafe "monitor.h free_ram" c_free_ram :: CULong
freeRam = fromIntegral c_free_ram / megabyte

foreign import ccall unsafe "monitor.h total_ram" c_total_ram :: CULong
totalRam = fromIntegral c_total_ram / megabyte
