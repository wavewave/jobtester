{-# LANGUAGE DeriveDataTypeable #-}

module HEP.Automation.JobQueue.Tester.Type where

import System.Console.CmdArgs

data JobTester = Test { config :: FilePath 
                      , testconfig :: FilePath
                      , moduleName :: String 
                      , whatjob :: String }
               deriving (Show,Data,Typeable) 
test :: JobTester 
test = Test { config = "test.conf" 
            , testconfig = "testtest.conf"
            , moduleName = "" &= typ "MODULENAME" &= argPos 0
            , whatjob = "" &= typ "JOBTYPE" &= argPos 1
            }

mode = modes [test]
