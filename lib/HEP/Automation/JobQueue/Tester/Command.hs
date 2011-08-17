
module HEP.Automation.JobQueue.Tester.Command where

import HEP.Automation.JobQueue.Tester.Type
import HEP.Automation.JobQueue.Tester.Job

import HEP.Automation.Pipeline.Config
import HEP.Automation.JobQueue.Config 


commandLineProcess :: JobTester -> IO () 
commandLineProcess (Test conf mname job) = do 
  putStrLn "test called"
  lc <- readConfigFile conf 
  let datasetdir = datasetDir . lc_clientConfiguration $ lc
  jobTest datasetdir mname job
