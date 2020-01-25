{-# LANGUAGE DeriveGeneric #-}
module Outputs.Ticker where

import           Data.Aeson
import           Data.Text
import           Data.Scientific
import           GHC.Generics

data Ticker = Ticker
    { ask :: Scientific
    , bid :: Scientific
    , price :: Scientific
    , pair :: Text
    , exchange :: Text
    } deriving Generic

instance ToJSON Ticker where
    toEncoding = genericToEncoding defaultOptions

class MapsToTicker a where
    getTicker :: a -> Ticker
