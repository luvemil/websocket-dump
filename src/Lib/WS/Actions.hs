module Lib.WS.Actions where

import qualified Network.WebSockets            as WS
import qualified Data.Text.IO                  as T


openConnection :: WS.WebSocketsData a => a -> WS.ClientApp ()
openConnection msg conn = do
    WS.sendTextData conn msg

printMessage :: WS.ClientApp ()
printMessage conn = do
    msg <- WS.receiveData conn
    T.putStrLn msg