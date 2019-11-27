{-# LANGUAGE OverloadedStrings #-}

module Commands where

import           Data.Text (Text)
import qualified Data.Text as Text

-- | A help message to show on conversation start with bot.
startMessage :: Text
startMessage = Text.unlines
 [ "Start message."
 , "Yay!"
 ]

-- | Message with main server stats - cpu, ram, disk.
statsMessage :: Text
statsMessage = Text.unlines
 [ "Stats message."
 , "Wow!"
 ]
