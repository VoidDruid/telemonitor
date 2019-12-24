{-# LANGUAGE ForeignFunctionInterface #-}

module Monitor.Bindings where

import Foreign
import Foreign.C.Types

minute = 60;
hour = minute * 60;
day = hour * 24;
megabyte = 1024 * 1024;

foreign import ccall unsafe "monitor.h number_of_cores" c_number_of_cores :: IO CLong
numberOfCores =  fromIntegral <$> c_number_of_cores

foreign import ccall unsafe "monitor.h number_of_processes" c_number_of_processes :: IO CULong
numberOfProcesses =  fromIntegral <$> c_number_of_processes

foreign import ccall unsafe "monitor.h uptime" c_uptime :: IO CLong
uptime = (/ hour) . fromIntegral <$> c_uptime

foreign import ccall unsafe "monitor.h free_ram" c_free_ram :: IO CULong
freeRam = (/ megabyte) . fromIntegral <$> c_free_ram

foreign import ccall unsafe "monitor.h total_ram" c_total_ram :: IO CULong
totalRam = (/ megabyte) . fromIntegral <$> c_total_ram
