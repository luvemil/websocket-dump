{-# LANGUAGE RecordWildCards #-}
module Lib.WS.Runner where

import           Control.Concurrent             ( forkIO )
import           Control.Monad                  ( forever )
import           Wuss
import qualified Network.WebSockets            as WS
import           Lib.WS.WSOptions

-- Build WS.ClientApp ()


runConfig :: WSConfig -> WS.ClientApp ()
runConfig WSConfig {..} conn = do
    _ <- forkIO $ onOpen conn
    forever $ WS.receiveData conn >>= onMessage

-- Out to IO ()


runWithOptions :: WSOptions -> IO ()
runWithOptions WSOptions {..} = runSecureClient host port path app
    where app = runConfig config
