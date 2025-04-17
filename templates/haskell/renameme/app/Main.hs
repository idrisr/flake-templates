module Main where

import Params

main :: IO ()
main = do
    params <- cmdLineParser
    print params
    putStrLn "Welcome to the machine"
