using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace MavenBuilder2
{
    public class DeployAction : BaseAction, IAction
    {
        private VixProject vixProject;

        public DeployAction(VixProject vixProject, MavenBuilderConfiguration mavenBuilderConfiguration, 
            LogMessageDelegate logMsgDelegate) : base   (mavenBuilderConfiguration, logMsgDelegate)
        {
            this.vixProject = vixProject;
            this.mavenBuilderConfiguration = mavenBuilderConfiguration;
            this.logMsgDelegate = logMsgDelegate;
        }

        public void execute()
        {
            try
            {
                switch (vixProject.ProjectType)
                {
                    case "AppJar":
                        string filename = vixProject.ProjectName + "-" + vixProject.ProjectVersion + ".jar";
                        string jarFile = mavenBuilderConfiguration.EclipseWorkspace + "\\" + vixProject.ProjectName + "\\target\\" + filename;
                        if (File.Exists(jarFile))
                        {
                            string targetFilename = mavenBuilderConfiguration.TomcatDir + "\\lib\\" + filename;
                            LogMsg("Copying file '" + jarFile + "' to '" + targetFilename + "'.");
                            File.Copy(jarFile, targetFilename, true);
                            //OnActionComplete(true);
                        }
                        else
                        {
                            LogMsg("Cannot find jar file '" + jarFile + "'.");
                        }
                        break;
                    case "AppExtensionJar":
                        filename = vixProject.ProjectName + "-" + vixProject.ProjectVersion + ".jar";
                        jarFile = mavenBuilderConfiguration.EclipseWorkspace + "\\" + vixProject.ProjectName + "\\target\\" + filename;
                        if (File.Exists(jarFile))
                        {
                            string targetFilename = mavenBuilderConfiguration.JreLibExtDir + "\\" + filename;
                            LogMsg("Copying file '" + jarFile + "' to '" + targetFilename + "'.");
                            File.Copy(jarFile, targetFilename, true);
                            //OnActionComplete(true);
                        }
                        else
                        {
                            LogMsg("Cannot find jar file '" + jarFile + "'.");
                        }
                        break;
                    case "AppWar":
                        string sourceDirectory = mavenBuilderConfiguration.EclipseWorkspace + "\\" + vixProject.ProjectName +
                            "\\target\\" + vixProject.ProjectName + "-" + vixProject.ProjectVersion;
                        if (Directory.Exists(sourceDirectory))
                        {
                            string targetDirectory = mavenBuilderConfiguration.TomcatDir + "\\webapps\\" + vixProject.ProjectName;
                            CopyDirectory(sourceDirectory, targetDirectory);
                            //DirectoryInfo dir = new DirectoryInfo(sourceDirectory);
                            
                        }
                        else
                        {
                            LogMsg("Cannot find web app directory '" + sourceDirectory + "'.");
                        }

                        break;
                    case "Other":
                        LogMsg("Project Type '" + vixProject.ProjectType + "' does not need to be deployed");
                        break;
                    default:
                        LogMsg("Project Type '" + vixProject.ProjectType + "' not yet supported");
                        break;

                }
                ActionComplete(true);// always returning true for now...
            }
            catch (Exception ex)
            {
                LogMsg("Error deploying project, " + ex.Message);
                ActionComplete(false);
            }            
        }

        private void CopyDirectory(string sourceDirectory, string targetDirectory)
        {
            LogMsg("Copying output from '" + sourceDirectory + "' to '" + targetDirectory + "'.");
            //DirectoryInfo source = new DirectoryInfo(sourceDirectory);
            //Microsoft.VisualBasic.VBCodeProvider
            Microsoft.VisualBasic.FileIO.FileSystem.CopyDirectory(sourceDirectory, targetDirectory, true);
        }

        public string ActionName
        {
            get { return "Deploy '" + vixProject.ProjectName + "'"; }
        }
    }
}
