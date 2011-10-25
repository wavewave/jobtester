
module HEP.Automation.JobQueue.Tester.Command where

import HEP.Automation.JobQueue.Tester.Type
import HEP.Automation.JobQueue.Tester.Job

import HEP.Automation.Pipeline.Config
import HEP.Automation.JobQueue.Config 

import qualified HEP.Automation.MadGraph.Log as MadGraphLog 

import System.Log.Logger
import System.Log.Handler.Syslog
import System.Log.Handler.Simple
import System.Log.Handler (setFormatter)
import System.Log.Formatter

import System.IO

commandLineProcess :: JobTester -> IO () 
commandLineProcess (Test conf tconf mname job) = do 
  putStrLn "test called"
  startLog MadGraphLog.defaultLogChan
  lc <- readConfigFile conf 
  tc <- readTestConfigFile tconf
  startJob lc tc mname job 

startLog :: String -> IO () 
startLog logchanname = do 
  updateGlobalLogger logchanname (setLevel DEBUG)
  h <- streamHandler stderr DEBUG >>= \lh -> return $
         setFormatter lh 
           (simpleLogFormatter "[$time : $loggername : $prio] $msg")
  updateGlobalLogger logchanname (addHandler h) 