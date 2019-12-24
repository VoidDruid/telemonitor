{-# LANGUAGE OverloadedStrings #-}

module Monitor where

import           Numeric
import           Data.Text (Text)
import qualified Data.Text as Text
-- Local packages
import qualified Monitor.Bindings as Bindings

-- | Return string, representing Double with 2 decimal places
formatDouble :: Double -> Text
formatDouble floatNum = Text.pack $ showFFloat (Just 2) floatNum ""
-- | Turn any instance of 'Show' into Text
toText :: Show a => a -> Text
toText = Text.pack . show

-- Transform stats to text

ramStats' :: IO [Text]
ramStats' = do
  totalRam <- Bindings.totalRam
  freeRam <- Bindings.freeRam
  return [ "Total RAM: " <> formatDouble totalRam <> " mb"
         , "Free RAM: " <> formatDouble freeRam <> " mb"
         ]

sysStats' :: IO [Text]
sysStats' = do
  uptime <- Bindings.uptime
  processes <- Bindings.numberOfProcesses
  return [ "Uptime: " <> formatDouble uptime <> " hours"
         , "Running processes: " <> toText processes
         ]

-- General functions, that return IO Text, joined with '\n'

ramStats = Text.unlines <$> ramStats'
sysStats = Text.unlines <$> sysStats'
