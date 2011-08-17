module HEP.Automation.JobQueue.Tester.Job where

import HEP.Automation.JobQueue.Config
import HEP.Automation.JobQueue.JobQueue
import HEP.Automation.JobQueue.JobType

import HEP.Storage.WebDAV

import HEP.Util.GHC.Plugins
import Unsafe.Coerce

import HEP.Automation.Pipeline.Config
import HEP.Automation.Pipeline.Job
import HEP.Automation.Pipeline.Job.Match

import Control.Concurrent

startJob :: LocalConfiguration -> TestConfiguration -> String -> String 
         -> IO ()  
startJob lc tc mname job = do 
  let wdavserver = WebDAVServer (tc_storageurl tc)
      datasetdir = datasetDir . lc_clientConfiguration $ lc
  jinfos <- getJobInfos datasetdir mname job
  mapM_ (doJob wdavserver lc) jinfos 


getJobInfos :: String-> String -> String -> IO [JobInfo]
getJobInfos datasetdir mname job = do 
  let fullmname = "HEP.Automation.MadGraph.Dataset." ++ mname
  value <- pluginCompile datasetdir fullmname "(eventsets,webdavdir)" 
  let (eventsets,webdavdir) = unsafeCoerce value :: ([EventSet],WebDAVRemoteDir)
  jobdetails <- case job of
                  "atlas_lhco"  -> return $ map (flip (MathAnal "atlas_lhco") webdavdir) eventsets
                  "tev_reco"    -> return $ map (flip (MathAnal "tev_reco") webdavdir) eventsets
                  "tev_top_afb" -> return $ map (flip (MathAnal "tev_top_afb") webdavdir) eventsets
                  "tevpythia"   -> return $ map (flip (MathAnal "tevpythia") webdavdir) eventsets
                  "eventgen"    -> return $ map (flip EventGen webdavdir) eventsets
                  _ -> error "atlas_lhco tev_reco tev_top_afb tevpythia eventgen"
  return $ map (\x -> JobInfo { jobinfo_id = 0, jobinfo_detail = x, jobinfo_status = Unassigned, jobinfo_priority = NonUrgent} ) jobdetails 
 
--   putStrLn "test ended "
{-  putStrLn $ "sending " ++ show (length eventsets) ++ " jobs"
  mapM_ (\x -> sendJob url x NonUrgent >> threadDelay 50000) jobdetails -}


doJob :: WebDAVServer -> LocalConfiguration -> JobInfo -> IO () 
doJob wdavserver lc jinfo = do 
  putStrLn "starting job"
  let wc = WorkConfig lc wdavserver
      job = jobMatch jinfo
  putStrLn $ "Work Configuration = " ++ show wc 
  pipeline_checkSystem job wc jinfo 
  threadDelay 10000000
  pipeline_startWork job wc jinfo
  threadDelay 10000000
  pipeline_startTest job wc jinfo 
  threadDelay 10000000
  pipeline_uploadWork job wc jinfo
  threadDelay 10000000
  return () 