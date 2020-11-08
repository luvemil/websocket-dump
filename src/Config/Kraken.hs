{-# LANGUAGE RecordWildCards, OverloadedStrings #-}
module Config.Kraken where

import           Control.Concurrent             ( forkIO )
import           Control.Monad                  ( forever )
import           Data.Aeson
import           Data.Text
import qualified Data.ByteString.Lazy.Char8    as BS
import qualified Network.WebSockets            as WS
import           Lib.WS.WSOptions
import           Lib.WS.WSConfig
import           Lib.WS.Actions

import           Sources.Kraken.WS              ( decodeTicker )
import           Control.Monad.IO.Class


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
        onMessage msg = liftIO $
            case decodeTicker msg of
                Right t -> BS.putStrLn $ encode t
                Left  _ -> pure ()
    in  WSConfig { .. }

krakenOptions :: WSOptions
krakenOptions =
    let host = "ws.kraken.com"
        port = 443
        path = "/"
    in  WSOptions { .. }
