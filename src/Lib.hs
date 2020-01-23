{-# LANGUAGE GeneralizedNewtypeDeriving, RecordWildCards #-}

module Lib
    ( main
    )
where

import           Control.Monad.Reader
import           Lib.App
import           Lib.Env

-- Debug implementation of env loader
loadEnv :: IO Env
loadEnv = pure $ Env ["wss://echo.websocket.org"]

-- Placeholder implementation of App
dummyApp :: App ()
dummyApp = do
    Env {..} <- ask
    liftIO $ putStrLn "Endpoints:"
    liftIO $ forM_ endpoints $ \e -> do
        putStrLn $ " - " ++ e

main :: IO ()
main = loadEnv >>= \e -> runApp dummyApp e
