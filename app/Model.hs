module Model where

import qualified Telegram.Bot.API as Telegram

data Model = Model
  { authorizer :: Telegram.Update -> Maybe String
  }
  deriving (Show)

instance Show (a -> b) where
    show _ = "<authorizer>"
