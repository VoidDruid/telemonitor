{-# LANGUAGE OverloadedStrings #-}

module Main where

-- Std packages
import           Control.Applicative              ((<|>))
import           Control.Monad.Trans              (liftIO)
import           System.Environment               (lookupEnv)
-- External packages
import qualified Telegram.Bot.API                 as Telegram
import           Telegram.Bot.Simple
import           Telegram.Bot.Simple.Debug
import           Telegram.Bot.Simple.UpdateParser
import           Data.List.Split                  (splitOn)
-- Local packages
import Model
import qualified Commands
import qualified Monitor
import qualified Auth

-- | Actions bot can perform.
data Action
  = NoAction        -- ^ Perform no action.
  | Stats           -- ^ Show all machine stats
  | System          -- ^ Main system stats
  | Docker          -- ^ Show info about containers
  | Ram             -- ^ Show RAM usage
  | Disk            -- ^ Show disk usage
  | Cpu             -- ^ Show CPU usage
  | Start           -- ^ Display help message
  | Help            -- ^ Display help message
  deriving (Show)

-- | Processes incoming 'Telegram.Update's and turns them into 'Action's.
handleUpdate :: Model -> Telegram.Update -> Maybe Action
handleUpdate model update = case authorizer model update of
  Just string -> Nothing  -- TODO
  Nothing -> parseUpdate (
        Stats <$ command "stats"
    <|> System <$ command "system"
    <|> Docker <$ command "docker"
    <|> Ram <$ command "ram"
    <|> Disk <$ command "disk"
    <|> Cpu <$ command "cpu"
    <|> Start <$ command "start"
    <|> Help <$ command "help" ) update

help model = model <# do
  replyText Commands.startMessage
  pure NoAction

ioReply model reply = model <# do  -- not sure what "<#" means in this context
  replyT <- liftIO reply
  replyText replyT
  pure NoAction

-- | Handle action recieved from 'handleUpdate'
handleAction :: Action -> Model -> Eff Action Model
handleAction action model = case action of
  NoAction -> pure model
  Start -> help model
  Help -> help model
  Stats -> ioReply model Commands.statsMessage
  System -> ioReply model Monitor.sysStats
  Ram -> ioReply model Monitor.ramStats
  Cpu -> ioReply model Monitor.cpuStats
  Disk -> ioReply model Monitor.diskStats
  Docker -> ioReply model Monitor.containersStats

-- | Create bot environment and start bot
run :: Telegram.Token -> IO ()
run token = do
  env <- Telegram.defaultTelegramClientEnv token
  run_level <- lookupEnv "RUN_LEVEL"
  rawIds <- lookupEnv "ADMIN_IDS"
  let
    adminIds :: [Telegram.ChatId]
    adminIds = case rawIds of {
      Nothing -> [] ;
      Just rawIdsString -> map (Telegram.ChatId . read) (splitOn "," rawIdsString)
    }
  let bot = BotApp { 
    botInitialModel = Model
      { authorizer = Auth.authorizeUpdate adminIds
      }
    , botAction = flip handleUpdate
    , botHandler = handleAction
    , botJobs = []
    }
  case run_level of 
    Just "production" -> startBot_ bot env
    _ -> startBot_ (traceBotDefault bot) env

main :: IO ()
main = getEnvToken "TELEMONITOR_TOKEN" >>= run
