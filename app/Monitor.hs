{-# LANGUAGE OverloadedStrings #-}

module Monitor where

import           Data.Text (Text)
import qualified Data.Text as Text

import qualified Monitor.Bindings as Bindings

ramStats' :: [Text]
ramStats' =
  [ "Total RAM: " <> Text.pack (show Bindings.totalRam)
  , "Free RAM: " <> Text.pack (show Bindings.freeRam)
  ]

sysStats' :: [Text]
sysStats' = ("Uptime: " <> (Text.pack . show $ Bindings.uptime)) : ramStats'

-- Util functions that return Text
ramStats = Text.unlines ramStats'
sysStats = Text.unlines sysStats'
