module Main where

import Params
import Relude

main :: IO ()
main = do
    params <- cmdLineParser
    print params
    putStrLn "Welcome to the machine"
