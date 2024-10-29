using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;

namespace MavenBuilder2
{
    public delegate void LogMessageDelegate(string msg);
    

    public partial class frmMain : Form
    {
        public frmMain()
        {
            InitializeComponent();
        }

        private MavenBuilderConfiguration mavenBuilderConfiguration = null;
        private Settings mSettings = null;

        private List<IAction> actions = new List<IAction>();
        private bool mbRunning = false;
        

        private void frmMain_Load(object sender, EventArgs e)
        {
            string builderConfigurationFilename = getApplicationDirectory() + "\\settings.xml";
            string appSettingsFilename = getApplicationDirectory() + "\\settings.xml";
            mSettings = new Settings(appSettingsFilename);

            if ((mSettings.MavenBuilderConfiguration != null) && (mSettings.MavenBuilderConfiguration.Length > 0))
            {
                LoadConfiguration(mSettings.MavenBuilderConfiguration, false);
            }
        }

        private void LoadConfiguration(string filename, bool saveAppSettings)
        {
            mavenBuilderConfiguration = new MavenBuilderConfiguration(filename);
            txtEclipseWorkspace.Text = mavenBuilderConfiguration.EclipseWorkspace;
            txtTomcatDir.Text = mavenBuilderConfiguration.TomcatDir;
            txtVIXBuildManifest.Text = mavenBuilderConfiguration.VixBuildManifest;
            txtMavenHome.Text = mavenBuilderConfiguration.Maven2Home;
            txtMavenRepository.Text = mavenBuilderConfiguration.MavenRepository;
            txtJreLibExtDir.Text = mavenBuilderConfiguration.JreLibExtDir;
            chkRunUnitTests.Checked = mavenBuilderConfiguration.RunUnitTests;
            chkUseBuildProject.Checked = mavenBuilderConfiguration.UseBuildProject;

            this.Text = "Maven Builder 2 - " + filename;
            if (mavenBuilderConfiguration.Loaded)
                DisplayProjects();
            if (saveAppSettings)
            {
                SaveSettings();
            }
        }

        private void SaveSettings()
        {
            mSettings.MavenBuilderConfiguration = mavenBuilderConfiguration.Filename;
            mSettings.Save();
        }

        private string getApplicationDirectory()
        {
            FileInfo file = new FileInfo(Application.ExecutablePath);
            return file.Directory.FullName;
        }

        private void ActionComplete(bool result)
        {
            if (this.InvokeRequired)
            {
                ActionCompleteDelegate d = new ActionCompleteDelegate(ActionComplete);
                this.Invoke(d, new object[] { result });
            }
            else
            {
                if (result)
                {
                    ProcessNextAction();
                }
                else
                {
                    LogMsg("Received error result from last action, not proceeding");
                    actions.Clear();
                    ProcessNextAction();
                }
            }
        }

        private void ProcessNextAction()
        {
            if (actions.Count > 0)
            {
                //tslActionCount.Text = "
                mbRunning = true;
                SetButtonsEnabled();
                tabControl1.SelectedIndex = 1;

                IAction action = actions[0];
                LogMsg("Running action '" + action.ActionName + "'.");
                
                actions.Remove(action);
                tslActionCount.Text = actions.Count + "";
                action.execute();
            }
            else
            {
                LogMsg("No more actions to process");
                tslActionCount.Text = "0";
                mbRunning = false;
                SetButtonsEnabled();
            }
        }


        private void btnLoadProjects_Click(object sender, EventArgs e)
        {
            setMavenBuilderConfiguration();
            SaveSettings();
            DisplayProjects();
        }

        private void DisplayProjects()
        {
            tcMain.SelectedIndex = 1;
            lstProjects.Items.Clear();
            VixBuildManifest manifest = new VixBuildManifest(txtVIXBuildManifest.Text);
            List<VixProject> projects = manifest.GetProjects(mavenBuilderConfiguration.UseBuildProject);
            foreach (VixProject vixProject in projects)
            {
                AddProjectToList(vixProject);
            }            
        }

        private void AddProjectToList(VixProject vixProject)
        {
            ListViewItem item = new ListViewItem();
            item.Tag = vixProject;
            item.Text = vixProject.BuildOrder + "";
            item.SubItems.Add(vixProject.ProjectName);
            item.SubItems.Add(vixProject.ProjectType);
            lstProjects.Items.Add(item);
        }
        /*
        private void BuildProject(VixProject vixProject)
        {            
            AddBuildAction(vixProject);
            ProcessNextAction();
            

            
            mbBuilding = true;
            mCurrentProject = vixProject;
            SetButtonsEnabled();
            tabControl1.SelectedIndex = 1;
            Process proc = new Process();
            proc.StartInfo.FileName = mavenBuilderConfiguration.Maven2Home + "\\bin\\mvn.bat";
            proc.StartInfo.WorkingDirectory = mavenBuilderConfiguration.EclipseWorkspace + "\\" + vixProject.ProjectName;
            proc.StartInfo.Arguments = "clean install";
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
             
            
        }*/

        private void SetButtonsEnabled()
        {
            btnLoadProjects.Enabled = !mbRunning;
            cxProjects.Enabled = !mbRunning;
            btnBuildChecked.Enabled = !mbRunning;
            btnDeployChecked.Enabled = !mbRunning;
        }

        /*
        private void BuildComplete(object sender, EventArgs e)
        {
            
            if (this.InvokeRequired)
            {
                EventHandler d = new EventHandler(BuildComplete);
                this.Invoke(d, new object[] { sender, e });
            }
            else
            {
                mbBuilding = false;
                //LogMsg("Build Complete (" + sender.GetType().ToString() + ")");
                Process proc = (Process)sender;
                LogMsg("Build Complete, return code='" + proc.ExitCode + "'.");
                SetButtonsEnabled();
                if (mbDeployProject)
                {
                    DeployProject(mCurrentProject);
                }
                mCurrentProject = null;
            }
        }

        private void ReceiveMessage(object sender, DataReceivedEventArgs e)
        {
            LogMsg(e.Data);
        }*/

        /*
        private void DeployProject(VixProject vixProject)
        {

            
            if (vixProject.ProjectType == "AppJar")
            {
                string filename = vixProject.ProjectName + "-0.1.jar";
                string jarFile = mavenBuilderConfiguration.EclipseWorkspace + "\\" + vixProject.ProjectName + "\\target\\" + filename;
                if (File.Exists(jarFile))
                {
                    string targetFilename = mavenBuilderConfiguration.TomcatDir + "\\lib\\" + filename ;
                    LogMsg("Copying file '" + jarFile + "' to '" + targetFilename + "'.");
                    File.Copy(jarFile, targetFilename);
                    //File.Copy(jarFile
                }
                else
                {
                    LogMsg("Cannot find jar file '" + jarFile + "'.");
                }
            }
            else
            {
                LogMsg("Project Type '" + vixProject.ProjectType + "' not yet supported");
            }
        }    */

        private void LogMsg(string msg)
        {
            if (txtOutput.InvokeRequired)
            {
                LogMessageDelegate d = new LogMessageDelegate(LogMsg);
                this.Invoke(d, new object[] { msg });
            }
            else
            {
                txtOutput.AppendText(msg + "\n");
            }
        }

        private void BuildChecked()
        {
            if (lstProjects.CheckedItems.Count > 0)
            {
                foreach (ListViewItem item in lstProjects.CheckedItems)
                {
                    VixProject vixProject = (VixProject)item.Tag;
                    AddBuildAction(vixProject);
                }
                ProcessNextAction();
            }
        }

        private void DeployChecked()
        {
            if (lstProjects.CheckedItems.Count > 0)
            {                
                foreach (ListViewItem item in lstProjects.CheckedItems)
                {
                    VixProject vixProject = (VixProject)item.Tag;
                    AddDeployAction(vixProject);
                }

                ProcessNextAction();
            }
        }

        private void BuildAndDeployChecked()
        {
            if (lstProjects.CheckedItems.Count > 0)
            {
                foreach (ListViewItem item in lstProjects.CheckedItems)
                {
                    VixProject vixProject = (VixProject)item.Tag;
                    AddBuildAction(vixProject);
                }
                foreach (ListViewItem item in lstProjects.CheckedItems)
                {
                    VixProject vixProject = (VixProject)item.Tag;
                    AddDeployAction(vixProject);
                }

                ProcessNextAction();
            }
        }

        private void buildToolStripMenuItem_Click(object sender, EventArgs e)
        {
            BuildChecked();
        }

        private void buildAndDeployToolStripMenuItem_Click(object sender, EventArgs e)
        {
            BuildAndDeployChecked();
        }

        private void AddBuildAction(VixProject vixProject)
        {
            BuildAction action = new BuildAction(vixProject, mavenBuilderConfiguration, 
                LogMsg, chkRunUnitTests.Checked);
            action.OnActionCompleteEvent += ActionComplete;
            actions.Add(action);
        }

        private void AddDeployAction(VixProject vixProject)
        {
            DeployAction action = new DeployAction(vixProject, mavenBuilderConfiguration, LogMsg);
            action.OnActionCompleteEvent += ActionComplete;
            actions.Add(action);
        }

        private void SetAllChecked(bool checkedValue)
        {
            foreach (ListViewItem item in lstProjects.Items)
            {
                item.Checked = checkedValue;
            }
        }

        private void btnCheckAll_Click(object sender, EventArgs e)
        {
            SetAllChecked(true);
        }

        private void btnUncheckAll_Click(object sender, EventArgs e)
        {
            SetAllChecked(false);
        }

        private void buildToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            if (lstProjects.SelectedItems.Count > 0)
            {
                VixProject vixProject = (VixProject)lstProjects.SelectedItems[0].Tag;
                AddBuildAction(vixProject);
                ProcessNextAction();
            }
        }

        private void buildAndDeployToolStripMenuItem1_Click(object sender, EventArgs e)
        {
            if (lstProjects.SelectedItems.Count > 0)
            {
                VixProject vixProject = (VixProject)lstProjects.SelectedItems[0].Tag;
                AddBuildAction(vixProject);
                AddDeployAction(vixProject);
                ProcessNextAction();
            }
        }

        private void btnBuildChecked_Click(object sender, EventArgs e)
        {
            BuildChecked();
        }

        private void btnDeployChecked_Click(object sender, EventArgs e)
        {
            //BuildAndDeployChecked();
            DeployChecked();
        }

        private void frmMain_FormClosing(object sender, FormClosingEventArgs e)
        {
            SaveSettings();
        }

        private void aboutToolStripMenuItem_Click(object sender, EventArgs e)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("MavenBuilder2");
            sb.Append(Application.ProductVersion);
            MessageBox.Show(sb.ToString(), "About", 
                MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private readonly string mstrSettingsFilter = "XML Files (*.xml)|*.xml";

        private void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            openFileDialog1.Filter = mstrSettingsFilter;
            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                LoadConfiguration(openFileDialog1.FileName, true);
            }
        }

        private void setMavenBuilderConfiguration()
        {
            mavenBuilderConfiguration.EclipseWorkspace = txtEclipseWorkspace.Text;
            mavenBuilderConfiguration.Maven2Home = txtMavenHome.Text;
            mavenBuilderConfiguration.MavenRepository = txtMavenRepository.Text;
            mavenBuilderConfiguration.TomcatDir = txtTomcatDir.Text;
            mavenBuilderConfiguration.VixBuildManifest = txtVIXBuildManifest.Text;
            mavenBuilderConfiguration.JreLibExtDir = txtJreLibExtDir.Text;
            mavenBuilderConfiguration.RunUnitTests = chkRunUnitTests.Checked;
            mavenBuilderConfiguration.UseBuildProject = chkUseBuildProject.Checked;
        }

        private void SaveConfiguration(string filename)
        {
            if (mavenBuilderConfiguration == null)
                mavenBuilderConfiguration = new MavenBuilderConfiguration(filename);

            setMavenBuilderConfiguration();
            
            mavenBuilderConfiguration.Save(filename);
        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            saveFileDialog1.Filter = mstrSettingsFilter;
            if (saveFileDialog1.ShowDialog() == DialogResult.OK)
            {
                SaveConfiguration(saveFileDialog1.FileName);
            }
        }

        private void deployToolStripMenuItem_Click(object sender, EventArgs e)
        {
            if (lstProjects.SelectedItems.Count > 0)
            {
                VixProject vixProject = (VixProject)lstProjects.SelectedItems[0].Tag;
                AddDeployAction(vixProject);
                ProcessNextAction();
            }
        }

        private void deployCheckedToolStripMenuItem_Click(object sender, EventArgs e)
        {
            DeployChecked();
        }

        private void clearToolStripMenuItem_Click(object sender, EventArgs e)
        {
            txtOutput.Clear();
        }

        private void tcMain_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (tcMain.SelectedIndex == 1)
            {
                lstProjects.Focus();
            }
        }
    }
}