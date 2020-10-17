module Auth where

import Data.Maybe

import qualified Telegram.Bot.API as Telegram

authorizeUpdate :: [Telegram.ChatId] -> Telegram.Update -> Maybe String
authorizeUpdate adminIds update = case Telegram.updateChatId update of
    Nothing -> Just "Invalid chat"
    Just chatId -> if chatId `elem` adminIds
        then Nothing
        else Just "Invalid user"
