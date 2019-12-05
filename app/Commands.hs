{-# LANGUAGE OverloadedStrings #-}

module Commands where

import           Data.Text (Text)
import qualified Data.Text as Text
-- Local packages
import qualified Monitor

removeLastChar :: Text -> Text
removeLastChar text = Text.take (Text.length text - 1) text

-- | A help message to show on conversation start with bot.
startMessage :: Text
startMessage = Text.unlines
 [ "Доступные команды:"
 , "/start - это сообщение"
 , "/stats - основная статистика"
 ]

-- | Message with main server stats - cpu, ram, disk.
statsMessage :: Text
statsMessage = Text.unlines
 [ "Информация с сервера"
 , removeLastChar Monitor.sysStats
 , removeLastChar Monitor.ramStats
 ]
