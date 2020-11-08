{-# LANGUAGE RecordWildCards #-}
module Lib.WS.Runner where

import           Control.Concurrent             ( forkIO )
import           Control.Monad                  ( forever )
import           Wuss
import qualified Network.WebSockets            as WS
import           Network.Socket
import           Lib.WS.WSConfig
import           Lib.WS.WSOptions
import           Lib.App
import           UnliftIO

-- Build WS.ClientApp ()

runSecureClientUnlifted
    :: MonadUnliftIO m => HostName -> PortNumber -> String -> (WS.Connection -> m a) -> m a
runSecureClientUnlifted host port str inner =
    withRunInIO $ \runInIO ->
        runSecureClient host port str (runInIO . inner)


runConfig :: WSConfig -> (WS.Connection -> App ())
runConfig WSConfig {..} conn = do
    _ <- liftIO . forkIO $ onOpen conn
    forever $ do
        msg <- liftIO $ WS.receiveData conn
        onMessage msg

-- Out to IO ()
runWithOptions :: WSConfig -> App ()
runWithOptions config = do
    WSOptions {..} <- grab @WSOptions
    runSecureClientUnlifted host port path app
    where app = runConfig config
