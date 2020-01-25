{-# LANGUAGE GeneralizedNewtypeDeriving, RecordWildCards #-}

module Lib
    ( loadEnv
    , runEnv
    )
where

import           Control.Monad.Reader
import           Lib.App
import           Lib.Env
import           Lib.WS.Runner                  ( WSOptions(..)
                                                , runWithOptions
                                                )
import           Config

-- Debug implementation of env loader
loadEnv :: IO Env
loadEnv =
    let config = krakenConfig
        host   = "ws.kraken.com"
        port   = 443
        path   = "/"
    in  pure . Env $ WSOptions { .. }

-- Placeholder implementation of App
runEnv :: Env -> IO ()
runEnv env = runApp app env
  where
    app = do
        Env {..} <- ask
        liftIO $ runWithOptions wsOptions
