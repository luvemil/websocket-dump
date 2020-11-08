{-# LANGUAGE RecordWildCards #-}
module Config.CryptoWatch where

import qualified Data.ByteString.Lazy.Char8    as BS
import           Lib.WS.Runner
import           Lib.WS.Actions

krakenSubscription :: BS.ByteString
krakenSubscription =
    "{\"subscribe\":{\"subscriptions\":[{\"streamSubscription\":{\"resource\":\"markets:87:trades\"}}]}}"

cryptoWatchConfig :: WSConfig
cryptoWatchConfig =
    let onOpen = openConnection krakenSubscription
        onMessage = BS.putStrLn
    in WSConfig {..}

cwOptions :: String -> WSOptions
cwOptions apiKey = 
    let config = cryptoWatchConfig
        host = "wss://stream.cryptowat.ch"
        port = 443
        path = "/connect?apikey=" ++ apiKey
    in WSOptions {..}