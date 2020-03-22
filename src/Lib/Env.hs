{-# LANGUAGE TypeApplications, KindSignatures, RankNTypes, MultiParamTypeClasses, ScopedTypeVariables #-}
module Lib.Env where

import           Lib.WS.Runner                  ( WSOptions )
import           Control.Monad.Reader           ( MonadReader
                                                , ask
                                                )

type Endpoint = String

data Env (m :: * -> *) = Env
    { envWSOptions :: WSOptions
    }

class Has field env where
    obtain :: env -> field

instance Has WSOptions (Env m) where
    obtain = envWSOptions

grab :: forall  field env m . (MonadReader env m, Has field env) => m field
grab = fmap (obtain @field) ask
{-# INLINE grab #-}
