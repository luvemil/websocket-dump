module Main where

import Lib

main :: IO ()
main = loadEnv >>= runEnv