{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Lib.App
    ( App
    , runApp
    , AppEnv
    )
where

import           Control.Monad.Reader
import           Lib.Env

type AppEnv = Env App

newtype App a = App
    { unApp :: ReaderT AppEnv IO a
    } deriving (Functor, Applicative, Monad, MonadIO, MonadReader AppEnv)


runApp :: App a -> AppEnv -> IO a
runApp a env = runReaderT (unApp a) env
