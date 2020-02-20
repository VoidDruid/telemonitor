{-# LANGUAGE OverloadedStrings #-}

module Commands where

-- Std packages
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
 , "/start либо /help - это сообщение"
 , "/system - системная информация"
 , "/stats - основная статистика"
 , "/docker - запущенные контейнеры"
 , "/ram - информация о памяти"
 , "/disk - использование диска"
 , "/cpu - загруженность cpu"
 ]

-- | Message with main server stats - cpu, ram, disk, docker
statsMessage :: IO Text
statsMessage = do
  sysStats <- Monitor.sysStats
  ramStats <- Monitor.ramStats
  cpuStats <- Monitor.cpuStats
  diskStats <- Monitor.diskStats
  containerStats <- Monitor.containersStats
  return $ Text.unlines
           [ "*Системная информация*"
           , removeLastChar sysStats
           , "\n*CPU*"
           , removeLastChar cpuStats
           , "\n*Память*"
           , removeLastChar ramStats
           , "\n*Диск*"
           , removeLastChar diskStats
           , "\n*Docker контейнеры*"
           , removeLastChar containerStats
           ]
