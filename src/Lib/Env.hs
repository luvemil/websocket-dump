module Lib.Env where

import           Lib.WS.Runner                  ( WSOptions(..) )

type Endpoint = String

data Env
    = Env
    { wsOptions :: WSOptions
    }
