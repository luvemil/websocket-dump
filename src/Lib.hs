{-# LANGUAGE GeneralizedNewtypeDeriving, RecordWildCards, TypeApplications #-}

module Lib
    ( loadEnv
    , runEnv
    )
where

import           Control.Monad.Reader
import           Lib.App
import           Lib.WS.Runner                  ( WSOptions(..)
                                                , runWithOptions
                                                )
import           Config
import           System.Environment

-- Debug implementation of env loader
loadEnv :: IO AppEnv
loadEnv = do
    cwApiKeyMaybe <- lookupEnv "CW_API_KEY"
    case cwApiKeyMaybe of
        Just apiKey -> pure . Env $ cwOptions apiKey
        Nothing -> fail "CW_API_KEY not found"

-- Placeholder implementation of App
runEnv :: AppEnv -> IO ()
runEnv env = runApp env app
  where
    app = do
        wsOptions <- grab @WSOptions
        liftIO $ runWithOptions wsOptions
