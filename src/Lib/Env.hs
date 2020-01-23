module Lib.Env where

type Endpoint = String

data Env
    = Env
    { endpoints :: [Endpoint]
    }