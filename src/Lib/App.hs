{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Lib.App
    ( App
    , Env(..)
    , runApp
    )
where

import           Control.Monad.Reader

type Endpoint = String

data Env
    = Env
    { endpoints :: [Endpoint]
    }

newtype App a
    = App
    { unApp :: ReaderT Env IO a
    } deriving (Functor, Applicative, Monad, MonadIO, MonadReader Env)


runApp :: App a -> Env -> IO a
runApp a env = runReaderT (unApp a) env
