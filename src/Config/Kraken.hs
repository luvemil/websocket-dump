{-# LANGUAGE RecordWildCards, OverloadedStrings #-}
module Config.Kraken where

import           Control.Concurrent             ( forkIO )
import           Control.Monad                  ( forever )
import           Data.Aeson
import           Data.Text
import qualified Data.ByteString.Lazy.Char8    as BS
import qualified Network.WebSockets            as WS
import           Lib.WS.WSOptions
import           Lib.WS.Actions

import           Sources.Kraken.WS              ( decodeTicker )


-- Kraken specific

krakenConfig :: WSConfig
krakenConfig =
    let fstMsg :: BS.ByteString
        fstMsg = encode $ object
            [ "event" .= ("subscribe" :: Text)
            , "pair" .= (["XBT/USD", "ETH/USD", "XRP/USD"] :: [Text])
            , "subscription" .= object ["name" .= ("ticker" :: Text)]
            ]
        onOpen = openConnection fstMsg
        onMessage msg = do
            case (decodeTicker msg) of
                Right t -> BS.putStrLn $ encode t
                Left  f -> pure ()
    in  WSConfig { .. }

krakenOptions :: WSOptions
krakenOptions =
    let config = krakenConfig
        host = "ws.kraken.com"
        port = 443
        path = "/"
    in WSOptions {..}