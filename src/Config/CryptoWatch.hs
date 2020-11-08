{-# LANGUAGE RecordWildCards #-}
module Config.CryptoWatch where

import qualified Data.ByteString.Lazy.Char8    as BS
import           Lib.WS.Actions
import           Lib.WS.WSOptions
import           Lib.WS.WSConfig
import           Control.Monad.IO.Class

krakenSubscription :: BS.ByteString
krakenSubscription =
    "{\"subscribe\":{\"subscriptions\":[{\"streamSubscription\":{\"resource\":\"markets:87:trades\"}}]}}"

cryptoWatchConfig :: WSConfig
cryptoWatchConfig =
    let onOpen    = openConnection krakenSubscription
        onMessage = liftIO . BS.putStrLn
    in  WSConfig { .. }

cwOptions :: String -> WSOptions
cwOptions apiKey =
    let host = "stream.cryptowat.ch"
        port = 443
        path = "/connect?apikey=" ++ apiKey
    in  WSOptions { .. }
