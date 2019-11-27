{-# LANGUAGE OverloadedStrings #-}

module Monitor where

import           Data.Text (Text)
import qualified Data.Text as Text

import qualified Monitor.Bindings as Bindings

ramStats :: Text
ramStats = Text.unlines
  [ "Total RAM: " <> Text.pack (show Bindings.totalRam)
  , "Free RAM: " <> Text.pack (show Bindings.freeRam)
  ]
