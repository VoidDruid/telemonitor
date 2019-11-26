{-# LANGUAGE ForeignFunctionInterface #-}

module Monitor where


import Foreign
import Foreign.C.Types

foreign import ccall unsafe "monitor.h number_of_processors"
    c_number_of_cores :: CLong

numberOfCores :: Integer
numberOfCores = fromIntegral c_number_of_cores
