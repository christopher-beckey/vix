using System;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.Windows.Forms;

namespace MavenBuilder2
{
    public class BuildAction : BaseAction, IAction
    {
        private VixProject vixProject;
        private readonly bool mbRunUnitTests;
        

        public BuildAction(VixProject vixProject, MavenBuilderConfiguration mavenBuilderConfiguration, 
            LogMessageDelegate logMsgDelegate, bool runUnitTests) : base(mavenBuilderConfiguration, logMsgDelegate)
        {
            this.vixProject = vixProject;
            this.mbRunUnitTests = runUnitTests;
        }

        public void execute()
        {

            if (vixProject.ProjectType == "Other")
            {
                LogMsg("Project '" + vixProject.ProjectName + "' of type 'Other' cannot be built, skipping and continuing");
                ActionComplete(true);
            }
            else
            {
                try
                {
                    Process proc = new Process();
                    proc.StartInfo.FileName = mavenBuilderConfiguration.Maven2Home + "\\bin\\mvn.bat";
                    proc.StartInfo.WorkingDirectory = mavenBuilderConfiguration.EclipseWorkspace + "\\" + vixProject.ProjectName;
                    if (mbRunUnitTests)
                    {
                        proc.StartInfo.Arguments = "clean install";
                    }
                    else
                    {
                        proc.StartInfo.Arguments = "-Dmaven.test.skip=true clean install";
                    }
                    proc.StartInfo.UseShellExecute = false;
                    proc.StartInfo.RedirectStandardOutput = true;

                    proc.StartInfo.CreateNoWindow = true;
                    Application.DoEvents();
                    proc.OutputDataReceived += ReceiveMessage;
                    proc.EnableRaisingEvents = true;
                    proc.Exited += BuildComplete;
                    //proc.OutputDataReceived += new DataReceivedEventHandler(proc_OutputDataReceived);
                    proc.Start();

                    proc.BeginOutputReadLine();
                }
                catch (Exception ex)
                {
                    LogMsg("Error during build action, " + ex.Message);
                    ActionComplete(false);
                }
            }
        }

        private void ReceiveMessage(object sender, DataReceivedEventArgs e)
        {
            LogMsg(e.Data);
        }

        private void BuildComplete(object sender, EventArgs e)
        {

            Process proc = (Process)sender;
            int returnCode = proc.ExitCode;
            LogMsg("Build Complete, return code='" + returnCode + "'.");
            ActionComplete(returnCode == 0);
            //OnActionComplete(returnCode == 0);
        }


        public string ActionName
        {
            get { return "Build '" + vixProject.ProjectName + "'"; }
        }
    }
}
