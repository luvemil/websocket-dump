{-# LANGUAGE RecordWildCards #-}
module Lib.WS.Runner where

import           Control.Concurrent             ( forkIO )
import           Control.Monad                  ( forever )
import           Wuss
import qualified Network.WebSockets            as WS
import           Lib.WS.WSConfig
import           Lib.WS.WSOptions
import           Lib.App
import           Control.Monad.IO.Class         ( liftIO )

-- Build WS.ClientApp ()


runConfig :: WSConfig -> WS.ClientApp ()
runConfig WSConfig {..} conn = do
    _ <- forkIO $ onOpen conn
    forever $ WS.receiveData conn >>= onMessage

-- Out to IO ()


runWithOptions :: WSConfig -> App ()
runWithOptions actions = do
    WSOptions {..} <- grab @WSOptions
    liftIO $ runSecureClient host port path app
    where app = runConfig actions
