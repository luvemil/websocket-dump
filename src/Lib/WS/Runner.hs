{-# LANGUAGE RecordWildCards #-}
module Lib.WS.Runner where

import           Control.Concurrent             ( forkIO )
import           Control.Monad                  ( forever )
import           Wuss
import           Network.Socket
import qualified Network.WebSockets            as WS

-- Build WS.ClientApp ()

data WSConfig
    = WSConfig
    { onOpen :: WS.ClientApp ()
    , onMessage :: WS.ClientApp ()
    }

runConfig :: WSConfig -> WS.ClientApp ()
runConfig WSConfig {..} conn = do
    _ <- forkIO $ onOpen conn
    forever $ onMessage conn

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
