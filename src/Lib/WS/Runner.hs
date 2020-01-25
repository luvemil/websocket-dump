{-# LANGUAGE RecordWildCards #-}
module Lib.WS.Runner where

import           Control.Concurrent             ( forkIO )
import           Control.Monad                  ( forever )
import           Data.ByteString.Lazy.Char8     ( ByteString )
import           Wuss
import           Network.Socket
import qualified Network.WebSockets            as WS

-- Build WS.ClientApp ()

data WSConfig
    = WSConfig
    { onOpen :: WS.ClientApp ()
    , onMessage :: ByteString -> IO ()
    }

runConfig :: WSConfig -> WS.ClientApp ()
runConfig WSConfig {..} conn = do
    _ <- forkIO $ onOpen conn
    forever $ WS.receiveData conn >>= onMessage

-- Out to IO ()

data WSOptions = WSOptions
    { host :: HostName
    , port :: PortNumber
    , path :: String
    , config :: WSConfig
    }

runWithOptions :: WSOptions -> IO ()
runWithOptions WSOptions {..} = runSecureClient host port path app
    where app = runConfig config
