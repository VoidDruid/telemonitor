{-# LANGUAGE OverloadedStrings #-}

module Main where

-- Std packages
import           Control.Applicative              ((<|>))
import           Control.Monad.Trans              (liftIO)
-- External packages
import qualified Telegram.Bot.API                 as Telegram
import           Telegram.Bot.Simple
import           Telegram.Bot.Simple.Debug
import           Telegram.Bot.Simple.UpdateParser
-- Local packages
import qualified Commands

-- | Bot conversation state model.
data Model = Model deriving (Show)

-- | Actions bot can perform.
data Action
  = NoAction        -- ^ Perform no action.
  | Stats           -- ^ Show main machine stats
  | Start           -- ^ Display start message.
  deriving (Show)

-- | Bot application.
bot :: BotApp Model Action
bot = BotApp
  { botInitialModel = Model
  , botAction = flip handleUpdate
  , botHandler = handleAction
  , botJobs = []  -- TODO: why is this here?
  }

-- | Processes incoming 'Telegram.Update's and turns them into 'Action's.
handleUpdate :: Model -> Telegram.Update -> Maybe Action
handleUpdate _ = parseUpdate
    $ Stats <$ command "stats"
  <|> Start <$ command "start"

-- | Handle action recieved from 'handleUpdate'
handleAction :: Action -> Model -> Eff Action Model
handleAction action model = case action of
  NoAction -> pure model
  Start -> model <# do
    replyText Commands.startMessage
    pure NoAction
  Stats -> model <# do  -- TODO: what the hell does "<#" mean in this context?
    stats <- liftIO Commands.statsMessage
    replyText stats   -- TODO: how does "liftIO" work here, exactly?
    pure NoAction  -- TODO: if we just write "Stats -> do", in the end we have to put "pure model". Why?

-- | Create bot environment and start bot
run :: Telegram.Token -> IO ()
run token = do
  env <- Telegram.defaultTelegramClientEnv token
  startBot_ (traceBotDefault bot) env

main :: IO ()
main = getEnvToken "TELEMONITOR_TOKEN" >>= run
