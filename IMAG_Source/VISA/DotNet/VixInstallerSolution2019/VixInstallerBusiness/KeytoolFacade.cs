using System;
using log4net;
using System.Threading;
using System.Diagnostics;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public static class KeytoolFacade
    {
        private static readonly String TEMP_PATH = @"C:\TEMP";
 
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(KeytoolFacade).Name);
        }

        private static void RunKeytoolUtility(string batchFilename)
        {
            using (Process externalProcess = new Process())
            {
                externalProcess.StartInfo.FileName = batchFilename;
                externalProcess.StartInfo.Arguments = "";
                externalProcess.StartInfo.WorkingDirectory = TEMP_PATH;
                externalProcess.StartInfo.UseShellExecute = false;
                externalProcess.StartInfo.CreateNoWindow = true; // DKB - 5/25/10

                externalProcess.Start();

                try
                {
                    do
                    {
                        Thread.Sleep(500);
                        externalProcess.Refresh();
                    } while (!externalProcess.HasExited);
                }
                finally
                {
                    externalProcess.Close();
                }
            }
        }

        //Runs the cmd process - used to import the Laurel Bridge certificate into java cacerts to 
        //allow Network Activation of Laurel Bridge license to work
        public static string RunCmdProcess(string cmdName, string cmdArgs, string cmdPath)
        {
            string externalProcessOutput = "";
            try
            {
                Process externalProcess = new Process();
                externalProcess.StartInfo = new ProcessStartInfo("cmd.exe");
                externalProcess.StartInfo.FileName = cmdName;
                externalProcess.StartInfo.Arguments = cmdArgs;
                externalProcess.StartInfo.WorkingDirectory = cmdPath;
                externalProcess.StartInfo.RedirectStandardOutput = true;
                externalProcess.StartInfo.RedirectStandardError = true;
                externalProcess.StartInfo.UseShellExecute = false;
                externalProcess.StartInfo.Verb = "runas";
                externalProcess.StartInfo.CreateNoWindow = true;
                externalProcess.Start();
                Logger().Info("run cmd process line number 438");
                externalProcessOutput = externalProcess.StandardOutput.ReadToEnd();
                externalProcessOutput += externalProcess.StandardError.ReadToEnd();

                bool Completed = externalProcess.WaitForExit(120000);
                if (Completed)
                {
                    if (externalProcessOutput.Contains("Certificate was added to keystore"))
                    {
                        Logger().Info("Laurel Bridge Certificate imported into Java cacerts " + externalProcessOutput);
                    }
                    else if (externalProcessOutput.Contains("already exists"))
                    {
                        Logger().Info("Laurel Bridge Certificate already was in Java cacerts " + externalProcessOutput);
                    }
                    else
                    {
                        Logger().Info("Laurel Bridge Certificate attempt to import into Java cacerts completed " + externalProcessOutput);
                    }
                }
                else
                {
                    Logger().Error("Importing Laurel Bridge Certificate did not complete");
                }   
            }
            catch (Exception ex)
            {
                Logger().Error("Run cmd Laurel Bridge certificate Error: " + ex.ToString());
            }

            return externalProcessOutput;
        }
    }
}
