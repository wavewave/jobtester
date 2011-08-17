module Main where

import System.Console.CmdArgs

import HEP.Automation.JobQueue.Tester.Type
import HEP.Automation.JobQueue.Tester.Command


main :: IO ()
main = do 
  putStrLn "jobtester"
  param <- cmdArgs mode
  
  putStrLn $ show param
  commandLineProcess param 
