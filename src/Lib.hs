{-# LANGUAGE GeneralizedNewtypeDeriving, RecordWildCards, TypeApplications #-}

module Lib
    ( main
    )
where

import           Control.Monad.Reader
import           Lib.App
import           Lib.WS.Runner                  ( runWithOptions )
import           Lib.WS.WSOptions
import           Config
import           System.Environment

-- Debug implementation of env loader
loadEnv :: IO AppEnv
loadEnv = do
    cwApiKeyMaybe <- lookupEnv "CW_API_KEY"
    case cwApiKeyMaybe of
        Just apiKey -> pure . Env $ cwOptions apiKey
        Nothing     -> fail "CW_API_KEY not found"

-- Placeholder implementation of App
runEnv :: AppEnv -> IO ()
runEnv env = runApp env app
  where
    app = runWithOptions cryptoWatchConfig 

main :: IO ()
main = loadEnv >>= runEnv
