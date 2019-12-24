{-# LANGUAGE OverloadedStrings #-}

module Monitor where

import           Data.Text (Text)
import qualified Data.Text as Text

import qualified Monitor.Bindings as Bindings

toText :: Show a => a -> Text
toText = Text.pack . show

ramStats' :: [Text]
ramStats' =
  [ "Total RAM: " <> toText Bindings.totalRam
  , "Free RAM: " <> toText Bindings.freeRam
  ]

sysStats' :: [Text]
sysStats' =
  [ "Uptime: " <> toText Bindings.uptime
  , "Running processes: " <> toText Bindings.numberOfProcesses
  ]

-- General functions, that return Text, joined with '\n'
ramStats = Text.unlines ramStats'
sysStats = Text.unlines sysStats'
