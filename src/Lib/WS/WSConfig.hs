module Lib.WS.WSConfig where

import           Data.ByteString.Lazy.Char8     ( ByteString )
import qualified Network.WebSockets            as WS

data WSConfig
    = WSConfig
    { onOpen :: WS.ClientApp ()
    , onMessage :: ByteString -> IO ()
    } 