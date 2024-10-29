using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;
using System.Threading;
using gov.va.med.imaging.exchange.VixInstaller.business;
using System.Xml;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class PrerequisiteChecklistPage : InteriorWizardPage
    {
        private System.Diagnostics.Process externalProcess = null;
        private VixCredentialsDialog tomcatDialog = new VixCredentialsDialog();
        private LaurelBridgeInfoDialog laurelBridgeDialog = new LaurelBridgeInfoDialog();
        private FederationInfoDialog federationInfoDialog = new FederationInfoDialog();
        private ServiceAccountDialog serviceAccountDialog = new ServiceAccountDialog();
        private bool reapplyServiceAccount = (TomcatFacade.IsActiveTomcatVersionInstalled() == false) &&
            WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName);
        private string _LibreOfficeVersion = "";
        private string _PSVersion = "";
        private int freeDiskSpaceGB = -1;
        private int neededDiskSpaceGB = 2;

        //private bool dcfReinstallComplete = false;

        public PrerequisiteChecklistPage()
        {
            InitializeComponent();
        }

        public PrerequisiteChecklistPage(IWizardForm wizForm, int pageIndex)
            : base(wizForm, pageIndex)
        {
            InitializeComponent();
            if (this.reapplyServiceAccount)
            {
                this.buttonTomcatServiceAccount.Text = "Assign";
            }
        }

        //protected override String Info(String infoMessage)
        //{
        //    this.InteriorPageSubHeader = infoMessage;
        //    return infoMessage;
        //}

        #region IWizardPage Members
        public override void Initialize()
        {
            this.InitializeBusinessFacadeDelegates();
            //BusinessFacade.InfoDelegate = null; // we dont want this output in the subheader
            //LaurelBridgeFacade.InfoDelegate = null; // we dont want this output in the subheader
            // restore the page header
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

            if (config.VixRole == VixRoleType.DicomGateway)
            {
                this.InteriorPageHeader = "Install the HDIG Prerequisites.";
            }
            else
            {
                this.InteriorPageHeader = "Install the VIX Prerequisites.";
            }

            this.SetAdministratorPrerequisiteState();
            this.SetOSPrerequisiteState();
            this.SetSpacePrerequisiteState();
            this.SetJavaPrerequisiteState();
            this.SetTomcatPrerequisiteState();
            this.SetLaurelBridgePrerequisiteState();
            this.SetTomcatServiceAccountPrerequisiteState();
            this.SetOfficePrerequisiteState();
            this.SetPowerShellPrerequisiteState();
            this.SetVixCertificatePrerequisiteState();
            
            // set the sub header for the page
            this.SetPageSubHeader();

            // set wizard form button state
            if (this.Visible)
            {
                if (this.IsComplete())
                {
                    this.WizardForm.EnableNextButton(true);
                }
                else
                {
                    this.WizardForm.EnableNextButton(false);
                }
                this.WizardForm.EnableBackButton(true);
                this.WizardForm.EnableCancelButton(true);
            }
        }

        public override bool IsComplete()
        { 
            bool isComplete = false;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            bool devMode = this.WizardForm.IsDeveloperMode();
            if (BusinessFacade.IsLoggedInUserAnAdministrator() && BusinessFacade.IsOperatingSystemApproved(config, devMode) && freeDiskSpaceGB >= neededDiskSpaceGB &&
                JavaFacade.IsJavaInstalled(devMode) && TomcatFacade.IsActiveTomcatVersionInstalled() &&
                (LaurelBridgeFacade.IsLaurelBridgeRequired(config) == false || (LaurelBridgeFacade.IsDeprecatedLaurelBridgeInstalled() == false && LaurelBridgeFacade.IsLaurelBridgeLicensed())) && 
                WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName) &&
                this.reapplyServiceAccount == false && VixFacade.IsFederationCertificateInstalledOrNotRequired(config) && IsOfficeInstalled() && IsPowerShellInstalled())
            {
                isComplete = true;
            }
            return isComplete;
        }

        #endregion

        #region events

        private void buttonJava_Click(object sender, EventArgs e)
        {
            this.buttonJava.Enabled = false;
            this.InstallJava();
        }

        /// <summary>
        /// Get the tomcat administrator credentials from the user and then install tomcat.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void buttonTomcat_Click(object sender, EventArgs e)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (config.TomcatAdminPassword == null)
            {
                if (this.tomcatDialog.ShowDialog() != DialogResult.OK) // ask for password associated with the admin account
                {
                    return;
                }
                config.TomcatAdminPassword = this.tomcatDialog.Password;
            }
            this.buttonTomcat.Enabled = false;
            Application.DoEvents();
            this.InstallTomcat();
        }

        private void buttonLaurelBridge_Click(object sender, EventArgs e)
        {
            this.buttonLaurelBridge.Enabled = false;
            Application.DoEvents();
            this.InstallAndLicenseLaurelBridgeToolkit(LaurelBridgeFacade.GetActiveDcfRootFromManifest());    
        }

        private void buttonTomcatServiceAccount_Click(object sender, EventArgs e)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            bool invokeServiceDialog = false;

            if (config.ApacheTomcatPassword == null)
            {
                invokeServiceDialog = true;
            }
            else if (this.reapplyServiceAccount)
            {
                invokeServiceDialog = true;
            }
            else if (WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName) == false)
            {
                invokeServiceDialog = true;
            }

            if (invokeServiceDialog && this.serviceAccountDialog.ShowDialog() == DialogResult.OK) // ask for password associated with the admin account
            {
                config.ApacheTomcatPassword = this.serviceAccountDialog.Password;
            }

            if (config.ApacheTomcatPassword != null)
            {
                this.buttonTomcatServiceAccount.Enabled = false;
                Application.DoEvents();
                this.ConfigureServiceAccount();
            }
        }

        private void buttonVixCertificate_Click(object sender, EventArgs e)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (VixFacade.IsFederationCertificateInstalledOrNotRequired(config) == false)
            {
                DialogResult result = this.federationInfoDialog.ShowDialog();

                if ( result == DialogResult.OK) // Cancel will skip this
                {
                    this.buttonVixCertificate.Enabled = false;
                    Application.DoEvents();

                    string certStoreDir = VixFacade.GetVixCertificateStoreDir();
                    if (!Directory.Exists(certStoreDir))
                    {
                        Directory.CreateDirectory(certStoreDir);
                    }
                    ZipUtilities.ImprovedExtractToDirectory(this.federationInfoDialog.CertificatePath, certStoreDir, ZipUtilities.Overwrite.Always);
                }
                this.Initialize();
            }
        }

        #endregion

        #region install methods
        private void ConfigureServiceAccount()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            try
            {
                Cursor.Current = Cursors.WaitCursor;
                String username = TomcatFacade.ServiceAccountUsername;
                String password = config.ApacheTomcatPassword;

                if (WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName) == true)
                {
                    this.Logger().Info(this.Info("Updating service account password for " + username + "."));
                    if (WindowsUserUtilities.UpdateServiceAccountPassword(username, password) == true)
                    {
                        Application.DoEvents();
                        this.Logger().Info("Setting service account " + username + " privileges.");
                        LsaUtilities.SetServiceAccountPrivleges(username);
                        Application.DoEvents();
                    }
                    else
                    {
                        DialogResult result = MessageBox.Show("The password that you supplied does not meet the complexity requirements of this computer. Please try again.",
                            "Service account password update failed!", MessageBoxButtons.OK);
                        config.ApacheTomcatPassword = null;
                    }
                }

                if (WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName) == false)
                {
                    this.Logger().Info(this.Info("Creating service account " + username + "."));
                    if (WindowsUserUtilities.CreateServiceAccount(username, password, "VIX service account") == true)
                    {
                        Application.DoEvents();
                        this.Logger().Info("Setting service account " + username + " privileges.");
                        LsaUtilities.SetServiceAccountPrivleges(username);
                        Application.DoEvents();
                    }
                    else
                    {
                        DialogResult result = MessageBox.Show("The password that you supplied does not meet the complexity requirements of this computer. Please try again.",
                            "Service account creation failed!", MessageBoxButtons.OK);
                        config.ApacheTomcatPassword = null;
                    }
                }

                if (WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName) == true)
                {
					this.Logger().Info("Setting " + TomcatFacade.TomcatServiceName + " service to run under " + username + " account.");
                    //string domain = Environment.MachineName;
                    ServiceUtilities.SetServiceCredentials(TomcatFacade.TomcatServiceName, username, password, ClusterFacade.IsServerClusterNode());
					if (this.reapplyServiceAccount)
					{
						this.reapplyServiceAccount = false;
					}
					Application.DoEvents();
				}
            }
            finally
            {
                Cursor.Current = Cursors.Default;
                this.Initialize();
            }
        }

        private void InstallAndLicenseLaurelBridgeToolkit(string dcfPath)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            try
            {
                Cursor.Current = Cursors.WaitCursor;
                this.WizardForm.EnableBackButton(false);
                this.WizardForm.EnableCancelButton(false);
                this.WizardForm.EnableNextButton(false);

                if (LaurelBridgeFacade.IsLaurelBridgeInstalled() == false)
                {
                    //import Laurel Bridge certificate into Java cacerts
                    BusinessFacade.ImportLaurelBridgeCertIntoCacerts();

                    string errorMessage = "";
                    if (LaurelBridgeFacade.InstallLaurelBridgeDcfToolkit(dcfPath, ref errorMessage) == false)
                    {
                        string message = @"The Laurel Bridge DCF toolkit could not be installed due to the following error: " + errorMessage;
                        MessageBox.Show(message, "Error installing DCF toolkit", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                }

                if (LaurelBridgeFacade.IsLaurelBridgeInstalled() == true && LaurelBridgeFacade.IsLaurelBridgeLicensed() == false)
                {
                    //import Laurel Bridge certificate into Java cacerts
                    BusinessFacade.ImportLaurelBridgeCertIntoCacerts();

                    // License toolkit with a VA enterprise license. The UI will provide feedback about errors.
                    string deprecatedDcfRoot = LaurelBridgeFacade.GetDeprecatedRenamedRootDirspec(dcfPath);
                    if (Directory.Exists(deprecatedDcfRoot))
                    {
                        string deprecatedDcfCfg = "";
                        try
                        {
                            deprecatedDcfCfg = Path.Combine(deprecatedDcfRoot, @"cfg\");
                            string dcfCfg = Path.Combine(dcfPath, @"cfg\");
                            string lbSystemInfo = "systeminfo";
                            if (File.Exists(Path.Combine(deprecatedDcfCfg, lbSystemInfo)))
                            {
                                File.Copy(Path.Combine(deprecatedDcfCfg, lbSystemInfo), Path.Combine(dcfCfg, lbSystemInfo), true);

                                // For an upgraded verson of Laurel Bridge once the license is copied into the installation folder the
                                // deprecated renamed Laurel Bridge folder can be deleted.
                                LaurelBridgeFacade.DeleteDeprecatedDcfRoot(deprecatedDcfRoot);
                            }
                            else
                            {
                                string message = "Cannot restore Laurel Bridge license file from " + deprecatedDcfCfg + " as file did not exist";
                                Info(message);
                            }
                        }
                        catch (Exception ex)
                        {
                            string message = "Cannot restore Laurel Bridge license file from " + deprecatedDcfCfg + "\nException message is\n" + ex.Message;
                            Info(message);
                        }
                    }

                    string macAddress = LaurelBridgeFacade.GetMacAddressFromDeprecatedKeyFile(deprecatedDcfRoot);
                    LaurelBridgeFacade.LicenseLaurelBridgeDcfToolkitWithEnterpriseLicense(macAddress);
                }
            }
            finally
            {
                Cursor.Current = Cursors.Default;
                this.Initialize();
            }
        }

        private void InstallTomcat()
        {
                Cursor.Current = Cursors.WaitCursor;
                this.Logger().Info("Installing Apache Tomcat version " + TomcatFacade.ActiveTomcatVersion);
                this.InteriorPageHeader = "Installing Apache Tomcat version " + TomcatFacade.ActiveTomcatVersion;
                this.InteriorPageSubHeader = "This may take over five minutes to complete.";
                this.WizardForm.EnableBackButton(false);
                this.WizardForm.EnableCancelButton(false);
                this.WizardForm.EnableNextButton(false);
                Cursor.Current = Cursors.WaitCursor;

                String exe = TomcatFacade.InstallerFilespec;
                this.Logger().Info("Tomcat Installer: " + exe);
                
                externalProcess = new System.Diagnostics.Process();
                // Handle the Exited event that the Process class fires.
                externalProcess.Exited += new System.EventHandler(this.TomcatInstallComplete);
                externalProcess.EnableRaisingEvents = true;
                externalProcess.SynchronizingObject = this;
                externalProcess.StartInfo.FileName = exe;
                externalProcess.StartInfo.Arguments = "/S";
                externalProcess.Start();
        }

        private void InstallOffice()
        {
            Cursor.Current = Cursors.WaitCursor;
            VixManifest WorkManifest = TomcatFacade.Manifest;
            XmlNode OfficeNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']");
            XmlNode OfficeNodeInstall;
            string appPath = "";
            string ManPath = "";
            if (OfficeNode != null)
            {
                OfficeNodeInstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']/InstallCommand");
                String RelativePath = OfficeNode.Attributes["payloadRelativeFolder"].Value.Trim();
                ManPath = Path.Combine(WorkManifest.PayloadPath, RelativePath);
                _LibreOfficeVersion = OfficeNode.Attributes["version"].Value.Trim();
                appPath = OfficeNode.Attributes["appRootRelativeFolder"].Value.Trim();
            }
            else
            {
                Logger().Error("LibreOffice Not in Manifest File.");
                Cursor.Current = Cursors.Default;
                this.Initialize();
                return;
            }

            this.Logger().Info("Installing LibreOffice version " + _LibreOfficeVersion);
            this.InteriorPageHeader = "Installing LibreOffice version " + _LibreOfficeVersion;
            this.InteriorPageSubHeader = "This usually takes a few minutes to complete.";
            this.WizardForm.EnableBackButton(false);
            this.WizardForm.EnableCancelButton(false);
            this.WizardForm.EnableNextButton(false);
            Cursor.Current = Cursors.WaitCursor;
            this.Logger().Info("Office Installer");

            externalProcess = new System.Diagnostics.Process();
            externalProcess.StartInfo.UseShellExecute = false;
			if (!Directory.Exists(ManPath))
			{
				Logger().Error("LibreOffice working directory Missing " + ManPath);
				Cursor.Current = Cursors.Default;
                this.Initialize();
				return;	
			}
            externalProcess.StartInfo.WorkingDirectory = ManPath;
            externalProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
            externalProcess.StartInfo.FileName = "msiexec.exe";
            externalProcess.StartInfo.Arguments = OfficeNodeInstall.InnerXml.Trim();
            //externalProcess.StartInfo.Arguments = "/i LibreOffice_7.0.6_Win_x64.msi /q /norestart ALLUSERS=1 CREATEDESKTOPLINK=0 ISCHECKFORPRODUCTUPDATES=0 QUICKSTART=1 UI_LANGS=en_US";          
            externalProcess.Start();

            bool Completed = externalProcess.WaitForExit(600000);
            if (Completed)
            {
                this.Logger().Info("Installing LibreOffice Install Completed");
                //Remove LibreOffice from PATH environment variable - added to avoid duplicate entry of LibreOffice in PATH             
                string appPath2 = appPath.Replace(@"\\", @"\");
                string librePath = $@"C:{appPath2}\program";
                string librePathOld = $@"C:\{appPath2}\\program";           
                string workPath = Environment.GetEnvironmentVariable("Path", EnvironmentVariableTarget.Machine);
                IEnumerable<string> filteredList = workPath.Split(';').Where(x => string.Compare(x, librePath, true) != 0 && string.Compare(x, librePathOld, true) != 0);
                workPath = string.Join(";", filteredList);
                Environment.SetEnvironmentVariable("Path", workPath, EnvironmentVariableTarget.Machine);
                //Add LibreOffice to PATH environment variable
                string workPathNew = Environment.GetEnvironmentVariable("Path", EnvironmentVariableTarget.Machine);
                workPathNew = workPathNew + ";" + librePath;
                Environment.SetEnvironmentVariable( "Path", workPathNew, EnvironmentVariableTarget.Machine);
                Cursor.Current = Cursors.Default;
                this.Initialize();
            }
            else
            {
              Logger().Error("LibreOffice Install Did Not Complete");
            }
         }

        private void InstallPowerShell()
        {
            Cursor.Current = Cursors.WaitCursor;
            VixManifest WorkManifest = TomcatFacade.Manifest;
            XmlNode PSNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']");
            XmlNode PSNodeInstall;
            string PSManPath = "";
            if (PSNode != null)
            {
                PSNodeInstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']/InstallCommand");
                String PSRelativePath = PSNode.Attributes["payloadRelativeFolder"].Value.Trim();
                PSManPath = Path.Combine(WorkManifest.PayloadPath, PSRelativePath);
                _PSVersion = PSNode.Attributes["version"].Value.Trim();
            }
            else
            {
                Logger().Error("PowerShell Not in Manifest File.");
                Cursor.Current = Cursors.Default;
                this.Initialize();
                return;
            }

            this.Logger().Info("Installing PowerShell version " + _PSVersion);
            this.InteriorPageHeader = "Installing PowerShell version " + _PSVersion;
            this.InteriorPageSubHeader = "This usually takes a few minutes to complete.";
            this.WizardForm.EnableBackButton(false);
            this.WizardForm.EnableCancelButton(false);
            this.WizardForm.EnableNextButton(false);
            Cursor.Current = Cursors.WaitCursor;
            this.Logger().Info("PowerShell Installer");

            externalProcess = new System.Diagnostics.Process();
            externalProcess.StartInfo.UseShellExecute = false;
            if (!Directory.Exists(PSManPath))
            {
                Logger().Error("PowerShell working directory Missing " + PSManPath);
                Cursor.Current = Cursors.Default;
                this.Initialize();
                return;
            }
            externalProcess.StartInfo.WorkingDirectory = PSManPath;
            externalProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
            externalProcess.StartInfo.FileName = "msiexec.exe";
            externalProcess.StartInfo.Arguments = PSNodeInstall.InnerXml.Trim();
            externalProcess.Start();

            bool Completed = externalProcess.WaitForExit(600000);
            if (Completed)
            {
                this.Logger().Info("Installing PowerShell Install Completed");
                Cursor.Current = Cursors.Default;
                this.Initialize();
            }
            else
            {
                Logger().Error("PowerShell Install Did Not Complete");
            }
        }

        private void InstallJava()
        {
            bool devMode = this.WizardForm.IsDeveloperMode();

            if (JavaFacade.IsJavaInstalledInWrongDirectory(devMode)) // this can happen on HDIG installs when installing for the first time over a legacy gateway
            {
                this.Logger().Warn("Java Runtime Environment version " + JavaFacade.ActiveJavaVersion + " is already installed in " + JavaFacade.GetActiveJrePathLocationIndependent());
                this.Logger().Warn("Performing uninstall so that the JRE may be re-installed in " + JavaFacade.GetActiveJavaPath(true)); // true means JRE not JDK
                JavaFacade.UninstallActiveJre();
            }

            this.Logger().Info("Installing the Java Runtime Environment version " + JavaFacade.ActiveJavaVersion);
            this.Logger().Info("Installer is located at: " + JavaFacade.GetInstallerFilespec());
            this.InteriorPageHeader = "Installing the Java Runtime Environment version " + JavaFacade.ActiveJavaVersion;
            this.InteriorPageSubHeader = "This may take over five minutes to complete.";
            this.WizardForm.EnableBackButton(false);
            this.WizardForm.EnableCancelButton(false);
            this.WizardForm.EnableNextButton(false);
            Cursor.Current = Cursors.WaitCursor;

            String exe = JavaFacade.GetInstallerFilespec();
            this.Logger().Info("Installer Filespec: " + exe);

            externalProcess = new System.Diagnostics.Process();
            // Handle the Exited event that the Process class fires.
            externalProcess.Exited += new System.EventHandler(this.JavaInstallComplete);
            externalProcess.EnableRaisingEvents = true;
            externalProcess.SynchronizingObject = this;
            externalProcess.StartInfo.FileName = exe;
            
            //JRE6
            //externalProcess.StartInfo.Arguments = "/s /v \"/qn REBOOT=Suppress JAVAUPDATE=0 INSTALLDIR=\\\"" + JavaFacade.GetActiveJavaPath(true) + "\\\"";
            //JRE8
            externalProcess.StartInfo.Arguments = "/s INSTALLDIR=\\\"" + JavaFacade.GetActiveJavaPath(true) + "\\\" AUTO_UPDATE=Disable";
            
            //externalProcess.StartInfo.Arguments = " /s STATIC=1 INSTALLDIR=\"" + JavaFacade.GetActiveJavaPath(true) + "\"";
            this.Logger().Info("Arguments: " + externalProcess.StartInfo.Arguments);
            externalProcess.Start();
        }    

        private void JavaInstallComplete(object sender, System.EventArgs e)
        {
            Process p = sender as Process;
            // TODO: check for process error
            p.Close();
            p = null;


            // append to the path
            String javaPath = JavaFacade.GetActiveJavaPath(JavaFacade.IsActiveJreInstalled());
            String path = Environment.GetEnvironmentVariable("path", EnvironmentVariableTarget.Machine);
            if (path == null)
            {
                Environment.SetEnvironmentVariable("path", javaPath, EnvironmentVariableTarget.Machine);
            }
            else // prepend to path to get so that this java is found before MS java in the Windows\system32 dir
            {
                if (!path.Contains(javaPath))
                {
                    path = javaPath + @"\bin;" + path;
                    path = path.Replace(";;", ";"); // case sensisitive
                    this.Logger().Info("Adding " + path + " to the Windows PATH environment variable");
                    Environment.SetEnvironmentVariable("path", path, EnvironmentVariableTarget.Machine);
                }
            }

            Cursor.Current = Cursors.Default;
            this.Initialize();
            this.WizardForm.LoadMuseConfig();                     
        }

        private void TomcatInstallComplete(object sender, System.EventArgs e)
        {
            Process p = sender as Process;
            // TODO: check for process error
            p.Close();
            p = null;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            TomcatFacade.ConfigureTomcatUsers(config);
            TomcatFacade.ConfigureTomcatService(config);

            Cursor.Current = Cursors.Default;
            this.Initialize();
        }

        #endregion

        #region initialize methods

        private bool DisableAllPageButtons()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            return (!BusinessFacade.IsLoggedInUserAnAdministrator() || !BusinessFacade.IsOperatingSystemApproved(config, this.WizardForm.IsDeveloperMode())) ? true : false;
        }

        private void SetAdministratorPrerequisiteState()
        {
            String loggedInUser = BusinessFacade.GetLoggedInUserName();
            // report on administrator role prerequisite
            if (BusinessFacade.IsLoggedInUserAnAdministrator())
            {
                labelUserIsAdmin.Text = loggedInUser + " has the Administrator role.";
                pictureBoxUserIsAdmin.Image = global::VixInstaller.Properties.Resources.check;
            }
            else
            {
                labelUserIsAdmin.Text = BusinessFacade.GetLoggedInUserName() + " does not have Administrator role.";
                pictureBoxUserIsAdmin.Image = global::VixInstaller.Properties.Resources.error;
            }
        }
        
        private void SetSpacePrerequisiteState()
        {
            Logger().Info("Entered SetSpacePrerequisiteState() method.");
            // report on DiskSpace install status
           
            freeDiskSpaceGB = BusinessFacade.GetTotalFreeSpace();
            string freeSpaceDetect;

            if (freeDiskSpaceGB >= neededDiskSpaceGB)
            {
                freeSpaceDetect = "Sufficient free disk space detected.";
                labelSpace.Text = freeSpaceDetect;
                pictureBoxSpace.Image = global::VixInstaller.Properties.Resources.check;
            }
            else
            {
                if (freeDiskSpaceGB == -1)
                {
                    freeSpaceDetect = "Unable to detect free disk space.";
                    labelSpace.Text = freeSpaceDetect;
                    pictureBoxSpace.Image = global::VixInstaller.Properties.Resources.error;                  
                }
                else
                {
                    freeSpaceDetect = "Insufficient free disk space detected, " + neededDiskSpaceGB + " GBs of free space required.";
                    labelSpace.Text = freeSpaceDetect;
                    pictureBoxSpace.Image = global::VixInstaller.Properties.Resources.error;                   
                }
            }
            Logger().Info(freeSpaceDetect);
        }

        private void SetOSPrerequisiteState()
        {
            String info = null;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

            if (BusinessFacade.IsOperatingSystemApproved(ref info, config, this.WizardForm.IsDeveloperMode()))
            {
                pictureBoxOS.Image = global::VixInstaller.Properties.Resources.check;
            }
            else
            {
                pictureBoxOS.Image = global::VixInstaller.Properties.Resources.error;
            }
            labelOS.Text = info;
        }

        private void SetJavaPrerequisiteState()
        {
            String info = null;
            // report on Java install status and set install button state
            if (JavaFacade.IsJavaInstalled(ref info, this.WizardForm.IsDeveloperMode()))
            {
                pictureBoxJava.Image = global::VixInstaller.Properties.Resources.check;
                buttonJava.Enabled = false;
            }
            else
            {
                pictureBoxJava.Image = global::VixInstaller.Properties.Resources.error;
                buttonJava.Enabled = this.DisableAllPageButtons() ? false : true;
                if (buttonJava.Enabled == true)
                {
                    buttonJava.Focus();
                }
            }
            labelJava.Text = info;
        }

        private void SetTomcatPrerequisiteState()
        {
            Logger().Info("Entered SetTomcatPrerequisiteState() method.");
            // report on Tomcat install status and set install button state
            if (TomcatFacade.IsActiveTomcatVersionInstalled())
            {
                labelTomcat.Text = "Apache Tomcat version " + TomcatFacade.ActiveTomcatVersion + " is installed.";
                pictureBoxTomcat.Image = global::VixInstaller.Properties.Resources.check;
                buttonTomcat.Enabled = false;
            }
            else
            {
                labelTomcat.Text = "Apache Tomcat version " + TomcatFacade.ActiveTomcatVersion + " is not installed.";
                pictureBoxTomcat.Image = global::VixInstaller.Properties.Resources.error;
                if (JavaFacade.IsJavaInstalled(this.WizardForm.IsDeveloperMode()))
                {
                    buttonTomcat.Enabled = this.DisableAllPageButtons() ? false : true;
                    if (buttonTomcat.Enabled == true)
                    {
                        buttonTomcat.Focus();
                    }
                }
                else
                {
                    buttonTomcat.Enabled = false; // Java must be installed first
                }
            }
        }

        private bool IsOfficeInstalled()
        {
            VixManifest WorkManifest = TomcatFacade.Manifest;
            XmlNode OfficeNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']");
            _LibreOfficeVersion = OfficeNode.Attributes["version"].Value.Trim();

            //1 used for prior LibreOffice uninstall, 2 used for current LibreOffice uninstall 
            int librePassCase = 2;

            if (BusinessFacade.IsOfficeRegKeyPresent(librePassCase))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private bool IsPowerShellInstalled()
        {
            VixManifest WorkManifest = TomcatFacade.Manifest;
            XmlNode PowerShellNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']");
            _PSVersion = PowerShellNode.Attributes["version"].Value.Trim();

            //1 used for prior PowerShell uninstall, 2 used for current PowerShell uninstall 
            int powershellPassCase = 2;

            if (BusinessFacade.IsPowerShellRegKeyPresent(powershellPassCase))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        private void SetOfficePrerequisiteState()
        {
            Logger().Info("Entered SetOfficePrerequisiteState() method.");
            // report on LibreOffice install status and set install button state
            VixManifest WorkManifest = TomcatFacade.Manifest;
            XmlNode OfficeNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']");
            _LibreOfficeVersion = OfficeNode.Attributes["version"].Value.Trim();

            if (IsOfficeInstalled())
            {
                labelOffice.Text = "LibreOffice version " + _LibreOfficeVersion + " is installed.";
                pictureBoxOffice.Image = global::VixInstaller.Properties.Resources.check;
                buttonOffice.Enabled = false;
            }
            else
            {
                labelOffice.Text = "LibreOffice version " + _LibreOfficeVersion + " is not installed ";
                pictureBoxOffice.Image = global::VixInstaller.Properties.Resources.error;
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                if (JavaFacade.IsJavaInstalled(this.WizardForm.IsDeveloperMode()) && TomcatFacade.IsActiveTomcatVersionInstalled() &&
                    (LaurelBridgeFacade.IsLaurelBridgeRequired(config) == false || (LaurelBridgeFacade.IsDeprecatedLaurelBridgeInstalled() == false && LaurelBridgeFacade.IsLaurelBridgeLicensed())) && 
                    WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName) && (this.reapplyServiceAccount == false) && VixFacade.IsFederationCertificateInstalledOrNotRequired(config))
                {
                    buttonOffice.Enabled = this.DisableAllPageButtons() ? false : true;
                    if (buttonOffice.Enabled == true)
                    {
                        buttonOffice.Focus();
                    }
                }
                else
                {
                    buttonOffice.Enabled = false;                
                }
             }
        }

        private void SetPowerShellPrerequisiteState()
        {
            Logger().Info("Entered SetPowerShellPrerequisiteState() method.");
            // report on PowerShell install status and set install button state
            VixManifest WorkManifest = TomcatFacade.Manifest;
            XmlNode OfficeNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']");
            _PSVersion = OfficeNode.Attributes["version"].Value.Trim();

            if (IsPowerShellInstalled())
            {
                labelPowerShell.Text = "PowerShell version " + _PSVersion + " is installed.";
                pictureBoxPowerShell.Image = global::VixInstaller.Properties.Resources.check;
                buttonPowerShell.Enabled = false;
            }
            else
            {
                labelPowerShell.Text = "PowerShell version " + _PSVersion + " is not installed ";
                pictureBoxPowerShell.Image = global::VixInstaller.Properties.Resources.error;
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                if (JavaFacade.IsJavaInstalled(this.WizardForm.IsDeveloperMode()) && TomcatFacade.IsActiveTomcatVersionInstalled() &&
                    (LaurelBridgeFacade.IsLaurelBridgeRequired(config) == false || (LaurelBridgeFacade.IsDeprecatedLaurelBridgeInstalled() == false && LaurelBridgeFacade.IsLaurelBridgeLicensed())) &&
                    WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName) && (this.reapplyServiceAccount == false) && VixFacade.IsFederationCertificateInstalledOrNotRequired(config) && IsOfficeInstalled())
                {
                    buttonPowerShell.Enabled = this.DisableAllPageButtons() ? false : true;
                    if (buttonPowerShell.Enabled == true)
                    {
                        buttonPowerShell.Focus();
                    }
                }
                else
                {
                    buttonPowerShell.Enabled = false;
                }
            }
        }

        private void SetLaurelBridgePrerequisiteState()
        {
            // report on Laurel Bridge status
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

            if (LaurelBridgeFacade.IsLaurelBridgeRequired(config) == false)
            {
                labelLaurelBridge.Text = "The Laurel Bridge DICOM toolkit is not required.";
                pictureBoxLaurelBridge.Image = global::VixInstaller.Properties.Resources.check;
                buttonLaurelBridge.Enabled = false;
            }
            else if (LaurelBridgeFacade.IsDeprecatedLaurelBridgeInstalled())
            {
                labelLaurelBridge.Text = "Deprecated Laurel Bridge DICOM toolkit is installed.";
                pictureBoxLaurelBridge.Image = global::VixInstaller.Properties.Resources.error;
                buttonLaurelBridge.Enabled = true;
            }
            else if (LaurelBridgeFacade.IsLaurelBridgeLicensed()) // installed and licensed
            {
                labelLaurelBridge.Text = "The Laurel Bridge DICOM toolkit is installed.";
                pictureBoxLaurelBridge.Image = global::VixInstaller.Properties.Resources.check;
                buttonLaurelBridge.Enabled = false;
            }
            else if (LaurelBridgeFacade.IsLaurelBridgeInstalled()) // installed but not licensed
            {
                labelLaurelBridge.Text = "The Laurel Bridge DICOM toolkit is not licensed.";
                pictureBoxLaurelBridge.Image = global::VixInstaller.Properties.Resources.error;
                buttonLaurelBridge.Enabled = true;
            }
            else
            {
                labelLaurelBridge.Text = "The Laurel Bridge DICOM toolkit is not installed.";
                pictureBoxLaurelBridge.Image = global::VixInstaller.Properties.Resources.error;
                if (JavaFacade.IsJavaInstalled(this.WizardForm.IsDeveloperMode()) && TomcatFacade.IsActiveTomcatVersionInstalled())
                {
                    buttonLaurelBridge.Enabled = this.DisableAllPageButtons() ? false : true;
                    if (buttonLaurelBridge.Enabled == true)
                    {
                        buttonLaurelBridge.Focus();
                    }
                }
                else
                {
                    buttonLaurelBridge.Enabled = false;
                }
            }
        }

        private void SetTomcatServiceAccountPrerequisiteState()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName) && (this.reapplyServiceAccount == false))
            {
                labelTomcatServiceAccount.Text = "The service account has been configured.";
                pictureBoxTomcatServiceAccount.Image = global::VixInstaller.Properties.Resources.check;
                buttonTomcatServiceAccount.Enabled = false;
            }
            else
            {
                if (reapplyServiceAccount)
                {
                    labelTomcatServiceAccount.Text = "The service account must be reassigned to the Apache Tomcat service.";
                }
                else
                {
                    labelTomcatServiceAccount.Text = "The service account has not been created yet.";
                }
                pictureBoxTomcatServiceAccount.Image = global::VixInstaller.Properties.Resources.error;
                if (JavaFacade.IsJavaInstalled(this.WizardForm.IsDeveloperMode()) && TomcatFacade.IsActiveTomcatVersionInstalled() &&
                    (LaurelBridgeFacade.IsLaurelBridgeRequired(config) == false || (LaurelBridgeFacade.IsDeprecatedLaurelBridgeInstalled() == false && LaurelBridgeFacade.IsLaurelBridgeLicensed())))
                {
                    buttonTomcatServiceAccount.Enabled = this.DisableAllPageButtons() ? false : true;
                    if (buttonTomcatServiceAccount.Enabled == true)
                    {
                        buttonTomcatServiceAccount.Focus();
                    }
                }
                else
                {
                    buttonTomcatServiceAccount.Enabled = false;
                }
            }
        }

        private void SetVixCertificatePrerequisiteState()
        {
            // report on VIX Federation certificate status
            // either the certificate not required or is already installed or we know the location of the certificate installation zip filespec
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

            if (config.VixRole == VixRoleType.DicomGateway)
            {
                labelVixCertificate.Text = "A security certificate is not required.";
                pictureBoxVixCertificate.Image = global::VixInstaller.Properties.Resources.check;
                buttonVixCertificate.Enabled = false;
            }
            else if (VixFacade.IsFederationCertificateInstalledOrNotRequired(config))
            {
                labelVixCertificate.Text = "The VIX security certificate is installed.";
                pictureBoxVixCertificate.Image = global::VixInstaller.Properties.Resources.check;
                buttonVixCertificate.Enabled = false;
            }
            else
            {
                labelVixCertificate.Text = "The VIX security certificate is not installed.";
                pictureBoxVixCertificate.Image = global::VixInstaller.Properties.Resources.error;
                if (JavaFacade.IsJavaInstalled(this.WizardForm.IsDeveloperMode()) && TomcatFacade.IsActiveTomcatVersionInstalled() &&
                    (LaurelBridgeFacade.IsLaurelBridgeRequired(config) == false || (LaurelBridgeFacade.IsDeprecatedLaurelBridgeInstalled() == false && LaurelBridgeFacade.IsLaurelBridgeLicensed())) && 
                    WindowsUserUtilities.LocalAccountExists(TomcatFacade.TomcatServiceAccountName) && (this.reapplyServiceAccount == false))
                {
                    buttonVixCertificate.Enabled = this.DisableAllPageButtons() ? false : true;
                    if (buttonVixCertificate.Enabled == true)
                    {
                        buttonVixCertificate.Focus();
                    }
                }
                else
                {
                    buttonVixCertificate.Enabled = false;
                }
            }
        }

        private void SetListenerPrerequisiteState()
        {
            //add calls to install the Listener Tool (piggyback on the Tomcat install)
            if (!ListenerFacade.IsListenerInstalled())
            {
                if (!ListenerFacade.InstallListener())
                {
                    Logger().Info("Listener Tool failed to install.  But the Installation process will continue.");
                }
                else
                {
                    ListenerFacade.CreateListenerWindowsService();
                    //ServiceUtilities.SetServiceCredentials(ListenerFacade.LISTENER_SERVICE_NAME, "LocalService", "", ClusterFacade.IsServerClusterNode());
                }
            }
        }

        private void SetPageSubHeader()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (this.IsComplete())
            {
                if (config.VixRole == VixRoleType.DicomGateway)
                {
                    this.InteriorPageSubHeader = "All prerequisites for the HDIG installation have been met. To continue, click Next..";
                }
                else
                {
                    this.SetListenerPrerequisiteState();
                    this.InteriorPageSubHeader = "All prerequisites for the VIX installation have been met. To continue, click Next..";
                }
            }
            else if (this.DisableAllPageButtons())
            {
                if (!BusinessFacade.IsOperatingSystemApproved(config, this.WizardForm.IsDeveloperMode()))
                {
                    if (config.VixRole == VixRoleType.DicomGateway)
                    {
                        this.InteriorPageSubHeader = "The HDIG is only approved for installation on Windows Server 2003. Click Cancel to exit the wizard.";
                    }
                    else
                    {
                        this.InteriorPageSubHeader = "The VIX is only approved for installation on Windows Server 2003. Click Cancel to exit the wizard.";
                    }
                }
                else
                {
                    if (config.VixRole == VixRoleType.DicomGateway)
                    {
                        this.InteriorPageSubHeader = "The HDIG Installer must be run by an Administrator. " + BusinessFacade.GetLoggedInUserName() + " does not have the Administrator role on this computer. Click Cancel to exit the wizard.";
                    }
                    else
                    {
                        this.InteriorPageSubHeader = "The VIX Installer must be run by an Administrator. " + BusinessFacade.GetLoggedInUserName() + " does not have the Administrator role on this computer. Click Cancel to exit the wizard.";
                    }
                }
            }
            else
            {
                //TODO: build a sub header based on next task.
                if (this.buttonJava.Enabled)
                {
                    this.InteriorPageSubHeader = "Click Install to install the Java Runtime Environment.";
                }
                else if (this.buttonTomcat.Enabled)
                {
                    this.InteriorPageSubHeader = "Click Install to install Apache Tomcat. You will be prompted to enter a password for the Tomcat admin account.";
                }
                else if (this.buttonLaurelBridge.Enabled)
                {
                    //if (this.IsDcfToolkitRefreshRequired())
                    //{
                    //    this.InteriorPageSubHeader = "Click Install to reinstall the Laurel Bridge DICOM toolkit.";
                    //}
                    //else
                    //{
                    this.InteriorPageSubHeader = "Click Install to install the Laurel Bridge DICOM toolkit. You may be prompted to activate the toolkit license.";
                    //}
                }
                else if (this.buttonTomcatServiceAccount.Enabled)
                {
                    this.InteriorPageSubHeader = $"Click {buttonTomcatServiceAccount.Text} to create and configure the Tomcat service account. You will be prompted to enter a password for the service account.";
                }
                else if (this.buttonVixCertificate.Enabled)
                {
                    this.InteriorPageSubHeader = "Click Install to specify the location of the VIX security certificate.";
                }
                else if (this.buttonOffice.Enabled)
                {
                    this.InteriorPageSubHeader = "Click Install to install LibreOffice.";
                }
                else if (this.buttonPowerShell.Enabled)
                {
                    this.InteriorPageSubHeader = "Click Install to install PowerShell.";
                }
            }
        }

        #endregion

        private void PrerequisiteChecklistPage_Load(object sender, EventArgs e)
        {

        }

        private void labelTomcatServiceAccount_DoubleClick(object sender, EventArgs e)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

            String username = TomcatFacade.ServiceAccountUsername;

            if (this.serviceAccountDialog.ShowDialog() == DialogResult.OK) // ask for password associated with the admin account
            {
                username = this.serviceAccountDialog.Username;
                config.ApacheTomcatPassword = this.serviceAccountDialog.Password;
            }

            if ((config.ApacheTomcatPassword != null) && (username != null))
            {
                TomcatFacade.TomcatServiceAccountName = username;
                TomcatFacade.ServiceAccountUsername = username;
                this.buttonTomcatServiceAccount.Enabled = false;
                Application.DoEvents();
                this.ConfigureServiceAccount();
            }
        }

        private void buttonOffice_Click(object sender, EventArgs e)
        {
            this.buttonOffice.Enabled = false;
            Application.DoEvents();
            InstallOffice();
        }

        private void buttonPowerShell_Click(object sender, EventArgs e)
        {
            this.buttonPowerShell.Enabled = false;
            Application.DoEvents();
            InstallPowerShell();
        }

        /**
        private void ConfigureWindowServices()
        {
            ServiceUtilities.SetServiceCredentials(ZFViewerFacade.ViewerServiceAccountName, "LocalService", "", ClusterFacade.IsServerClusterNode());
            ServiceUtilities.SetServiceCredentials(ZFViewerFacade.RenderServiceAccountName, "LocalService", "", ClusterFacade.IsServerClusterNode());
        }
        **/

        /// <summary>
        /// Perform the service setup that would ordinarily be done using tomcat5w.exe. 
        /// Currently this sets memory options for the JVM, and configures service failure actions
        /// </summary>
        /**
        private void SetZFViewerFailureActions()
        {
            //ConfigureTomcatJvmMemory(config);
            // if running on a HAC node then do not configure recovery options for the Tomcat service.
            if (ClusterFacade.IsServerClusterNode() == false)
            {
                ServiceUtilities.SetServiceFailureActions(ZFViewerFacade.ViewerServiceAccountName);
                ServiceUtilities.SetServiceFailureActions(ZFViewerFacade.RenderServiceAccountName);
            }
        }
        **/
    }
}
