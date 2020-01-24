{-# LANGUAGE GeneralizedNewtypeDeriving, RecordWildCards #-}

module Lib
    ( main
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
dummyApp :: App ()
dummyApp = do
    Env {..} <- ask
    liftIO $ runWithOptions wsOptions

main :: IO ()
main = loadEnv >>= \e -> runApp dummyApp e
