{-# LANGUAGE RecordWildCards, OverloadedStrings #-}
module Config where

import           Control.Concurrent             ( forkIO )
import           Control.Monad                  ( forever )
import           Data.Aeson
import           Data.Text
import qualified Data.ByteString.Lazy.Char8    as BS
import qualified Network.WebSockets            as WS
import           Lib.WS.Runner
import           Lib.WS.Actions


-- Kraken specific

krakenConfig :: WSConfig
krakenConfig =
    let fstMsg :: BS.ByteString
        fstMsg = encode $ object
            [ "event" .= ("subscribe" :: Text)
            , "pair" .= ["XBT/USD" :: Text]
            , "subscription" .= object ["name" .= ("ticker" :: Text)]
            ]
        onOpen    = openConnection fstMsg
        onMessage = printMessage
    in  WSConfig { .. }
