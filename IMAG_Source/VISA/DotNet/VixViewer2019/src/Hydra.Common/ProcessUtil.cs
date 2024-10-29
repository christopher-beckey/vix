using System;
using System.Diagnostics;
using System.IO; //VAI-707
using System.Text;

namespace Hydra.Common
{
    public class ProcessUtil
    {
        public static long GetMemoryUsageKB()
        {
            using (var process = Process.GetCurrentProcess())
            {
                using (var counter = new PerformanceCounter("Process", "Working Set - Private", process.ProcessName))
                {
                    return counter.RawValue / 1024;
                }
            }
        }

        /// <summary>
        /// Execute an external program and return its stdout and stderr, if any
        /// </summary>
        /// <param name="dir">The working directory or an empty string if the program is in the PATH env var</param>
        /// <param name="program">The program to execute</param>
        /// <param name="args">The arguments to the program</param>
        /// <param name="errorMsg">(out) an error message</param>
        /// <param name="msTimeout">(optional) millesecond timeout that defaults to 30 seconds</param>
        /// <returns>If successful, string from stdout. If unsuccessful, null and errorMsg is set to stderr.</returns>
        /// <remarks>Added for VAI-707. Modified for VAI-903 to be more robust.</remarks>
        public static string RunExternalProcess(string dir, string program, string args, out string errorMsg, int msTimeout = 30000)
        {
            string result = null;
            errorMsg = "";
            bool timeout = false;
            StringBuilder output = new StringBuilder();
            StringBuilder error = new StringBuilder();
            Process proc = new Process();
            DataReceivedEventHandler CaptureOutput = (o, e) => { output.Append(e.Data); };
            DataReceivedEventHandler CaptureError = (o, e) => { error.Append(e.Data); };
            try
            {
                if (!string.IsNullOrWhiteSpace(dir)) proc.StartInfo.WorkingDirectory = dir;
                proc.StartInfo.FileName = program;
                proc.StartInfo.Arguments = args; //redirect stderr to stdout
                proc.StartInfo.UseShellExecute = false;
                proc.StartInfo.RedirectStandardOutput = true;
                proc.StartInfo.RedirectStandardError = true;
                proc.StartInfo.LoadUserProfile = true;
                proc.StartInfo.CreateNoWindow = true;
                proc.OutputDataReceived += CaptureOutput;
                proc.ErrorDataReceived += CaptureError;
                proc.EnableRaisingEvents = true;
                proc.Start();
                proc.BeginOutputReadLine(); // Start the asynchronous read of the stdout stream
                proc.BeginErrorReadLine(); // Start the asynchronous read of the stderr stream
                // See https://docs.microsoft.com/en-us/dotnet/api/system.diagnostics.process.waitforexit?view=netframework-4.8
                if (!proc.WaitForExit(msTimeout)) // Wait for the process to finish, up to the timeout
                {
                    //process is still running
                    proc.Kill();
                    timeout = true;
                    Debug.WriteLine($"Process killed after timeout exceeded ({program} {args})"); //TODO - log this
                }
                else
                {
                    proc.WaitForExit(); //needed for async output event to be completed
                }

                if (proc.ExitCode != 0)
                {
                    errorMsg = $"The call ({program} {args}) failed: {error.ToString()}";
                }
                proc.Close();
            }
            catch (Exception ex)
            {
                errorMsg = ex.ToString();
            }
            finally
            {
                result = output.ToString();
                proc.Dispose();
            }
            if (timeout)
            {
                errorMsg = $"Process timed out after {msTimeout} ms: ({program} {args})";
            }
            return result;
        }
    }
}
