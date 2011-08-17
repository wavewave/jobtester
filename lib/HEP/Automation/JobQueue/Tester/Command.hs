
module HEP.Automation.JobQueue.Tester.Command where

import HEP.Automation.JobQueue.Tester.Type
import HEP.Automation.JobQueue.Tester.Job

import HEP.Automation.Pipeline.Config
import HEP.Automation.JobQueue.Config 


commandLineProcess :: JobTester -> IO () 
commandLineProcess (Test conf tconf mname job) = do 
  putStrLn "test called"
  lc <- readConfigFile conf 
  tc <- readTestConfigFile conf
  startJob lc tc mname job