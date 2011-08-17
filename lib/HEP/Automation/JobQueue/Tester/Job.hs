module HEP.Automation.JobQueue.Tester.Job where

import HEP.Automation.JobQueue.JobQueue
import HEP.Automation.JobQueue.Tester.Plugins

jobTest :: String-> String -> String -> IO ()
jobTest datasetdir mname job = do 
  (eventsets,webdavdir) <- pluginCompile datasetdir mname 
  jobdetails <- case job of
                  "atlas_lhco"  -> return $ map (flip (MathAnal "atlas_lhco") webdavdir) eventsets
                  "tev_reco"    -> return $ map (flip (MathAnal "tev_reco") webdavdir) eventsets
                  "tev_top_afb" -> return $ map (flip (MathAnal "tev_top_afb") webdavdir) eventsets
                  "tevpythia"   -> return $ map (flip (MathAnal "tevpythia") webdavdir) eventsets
                  "eventgen"    -> return $ map (flip EventGen webdavdir) eventsets
                  _ -> error "atlas_lhco tev_reco tev_top_afb tevpythia eventgen"
  putStrLn "test ended "
{-  putStrLn $ "sending " ++ show (length eventsets) ++ " jobs"
  mapM_ (\x -> sendJob url x NonUrgent >> threadDelay 50000) jobdetails -}
