module Lib.WS.WSOptions where

import           Network.Socket

data WSOptions = WSOptions
    { host :: HostName
    , port :: PortNumber
    , path :: String
    }