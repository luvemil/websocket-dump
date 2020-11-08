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

-- Debug implementation of env loader
loadEnv :: IO AppEnv
loadEnv =
    let config = krakenConfig
        host   = "ws.kraken.com"
        port   = 443
        path   = "/"
    in  pure . Env $ WSOptions { .. }

-- Placeholder implementation of App
runEnv :: AppEnv -> IO ()
runEnv env = runApp env app
  where
    app = do
        wsOptions <- grab @WSOptions
        liftIO $ runWithOptions wsOptions
