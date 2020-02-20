{-# LANGUAGE OverloadedStrings #-}

module Monitor where

-- Std packages
import           Numeric
import           Data.Text (Text)
import qualified Data.Text as Text
import           Data.Time (getCurrentTime)
-- External packages
import Docker.Client
-- Local packages
import qualified Monitor.Bindings as Bindings

-- | From any lisy returns pairs (index, element)
enumerate = zip [0..]
-- | Return string, representing Double with 2 decimal places
formatDouble :: Double -> Text
formatDouble floatNum = Text.pack $ showFFloat (Just 2) floatNum ""
-- | Turn any instance of 'Show' into Text
toText :: Show a => a -> Text
toText = Text.pack . show

-- Transform stats to text

ramStats' :: IO [Text]
ramStats' = do
  totalRam <- Bindings.totalRam
  freeRam <- Bindings.freeRam
  return [ "Всего RAM: " <> formatDouble totalRam <> " mb"
         , "Свободная RAM: " <> formatDouble freeRam <> " mb"
         ]

sysStats' :: IO [Text]
sysStats' = do
  uptime <- Bindings.uptime
  processes <- Bindings.numberOfProcesses
  return [ "Uptime: " <> formatDouble uptime <> " часов"
         , "Запущенных процессов: " <> toText processes
         ]

-- General functions, that return IO Text, joined with '\n'

ramStats = Text.unlines <$> ramStats'
sysStats = Text.unlines <$> sysStats'
diskStats = toText <$> getCurrentTime
cpuStats = toText <$> getCurrentTime

-- Docker stats

dockerEndpoint :: String
dockerEndpoint = "/var/run/docker.sock"

-- | Get container info as Text
getContainerInfo :: Container -> Text
getContainerInfo containerRecord = 
  Text.intercalate " " [
      Text.tail . head . containerNames $ containerRecord
    , "-"
    , Text.toLower . toText $ containerState containerRecord
    ]

makeContainersInfo :: [Container] -> Text
makeContainersInfo containers = 
  Text.unlines [
    Text.concat [toText (index + 1), ") ", getContainerInfo container]
    | (index, container) <- enumerate containers
  ]

-- | Get list of running containers
containersStats :: IO Text
containersStats = do
    h <- unixHttpHandler dockerEndpoint
    runDockerT (defaultClientOpts, h) $ do
        containters <- listContainers defaultListOpts
        case containters of
            Left err -> return (toText err)
            Right value -> return (makeContainersInfo  value)
