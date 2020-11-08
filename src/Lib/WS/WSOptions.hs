module Lib.WS.WSOptions where

import           Data.ByteString.Lazy.Char8     ( ByteString )
import           Network.Socket
import qualified Network.WebSockets            as WS

data WSConfig
    = WSConfig
    { onOpen :: WS.ClientApp ()
    , onMessage :: ByteString -> IO ()
    }

data WSOptions = WSOptions
    { host :: HostName
    , port :: PortNumber
    , path :: String
    , config :: WSConfig
    }