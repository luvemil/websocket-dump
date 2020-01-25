{-# LANGUAGE RecordWildCards, OverloadedStrings #-}
module Sources.Kraken.WS where

import           Data.Aeson
import           Data.Text
import           Data.Scientific
import           Data.StringNum
import           Data.ByteString.Lazy.Char8     ( ByteString )
import           Outputs.Ticker
import           Data.Either
import           Control.Monad

data WSTicker
    = WSTicker
    { ask :: Scientific
    , bid :: Scientific
    , price :: Scientific
    }

instance FromJSON WSTicker where
    parseJSON = withObject "kraken-ticker" $ \obj -> do
        a <- obj .: "a"
        b <- obj .: "b"
        c <- obj .: "c"
        let ask   = mapOnFirst3 unwrap a
            bid   = mapOnFirst3 unwrap b
            price = mapOnFirst2 unwrap c
        return $ WSTicker { .. }
      where
        -- | mapOnFirst2 and mapOnFirst3 are used to get the unwrapped value
        -- | of a StringNum for a Pair and a Triple respectively, but also to
        -- | force the remaining members of the triple into having a precise
        -- | type.
        mapOnFirst2 :: (a -> b) -> (a, Value) -> b
        mapOnFirst2 f (x, _) = f x
        mapOnFirst3 :: (a -> b) -> (a, Value, Value) -> b
        mapOnFirst3 f (x, _, _) = f x

type ChannelID = Integer
type ChannelName = Text
type AssetPair = Text
newtype WrappedWSTicker = WrappedWSTicker
    { unwrapMessage :: (ChannelID, WSTicker, ChannelName, AssetPair)
    }

instance MapsToTicker WrappedWSTicker where
    getTicker (WrappedWSTicker (_, WSTicker {..}, _, pair)) =
        Ticker { exchange = "kraken", .. }

instance FromJSON WrappedWSTicker where
    parseJSON a@(Array _) = do
        unwrapped <- parseJSON a
        return $ WrappedWSTicker unwrapped
    parseJSON _ = fail "Not a supported message"

decodeTicker :: ByteString -> Either String Ticker
decodeTicker =
    let helper :: WrappedWSTicker -> Ticker
        helper = getTicker
    in  liftM helper . eitherDecode
