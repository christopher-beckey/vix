using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Xml;
using System.IO;
using System.Windows.Forms;
using gov.va.med.imaging.exchange.VixInstaller.business;
using System.ServiceProcess;
using System.Threading;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class UndeployVixPage : gov.va.med.imaging.exchange.VixInstaller.ui.InteriorWizardPage
    {
        private bool uninstall = false;

        public UndeployVixPage()
        {
            InitializeComponent();
            uninstall = false;
        }

        public UndeployVixPage(IWizardForm wizForm, int pageIndex)
            : base(wizForm, pageIndex)
        {
            InitializeComponent();
            uninstall = false;
        }

        protected override String Info(String infoMessage)
        {
            this.textBoxInfo.AppendText(infoMessage + Environment.NewLine);
            return infoMessage;
        }

        #region IWizardPage Members
        public override void Initialize()
        {
            this.InitializeBusinessFacadeDelegates();
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

            if (config.VixRole == VixRoleType.DicomGateway)
            {
                this.InteriorPageHeader = @"Update HDIG components from " + config.PreviousProductVersionProp + " to " +
                    config.ProductVersionProp;
            }
            else
            {
                this.InteriorPageHeader = @"Update VIX components from " + config.PreviousProductVersionProp + " to " +
                    config.ProductVersionProp;
            }

            this.buttonUninstallViXWebApps.Text = "Uninstall version " + config.PreviousProductVersionProp;

            this.SetPageSubHeader();

            // set wizard form button state
            if (this.IsComplete() || this.IsUninstalled())
            {
                this.WizardForm.EnableNextButton(true);
                this.buttonUninstallViXWebApps.Enabled = false;
            }
            else
            {
                this.WizardForm.EnableNextButton(false);
            }


            this.WizardForm.EnableBackButton(true);
            this.WizardForm.EnableCancelButton(true);
        }

        public override bool IsComplete()
        {
            bool isComplete = false;

            if (VixFacade.IsVixInstalled() == false)
            {
                if (TomcatFacade.IsDeprecatedTomcatVersionInstalled() == false) // require that any deprecated version of Tomcat be uninstalled before continuing
                {
                    // do a java check if we are not in developer mode
                    if (this.WizardForm.IsDeveloperMode())
                    {
                        isComplete = true;
                    }
                    else
                    {
                        isComplete = !JavaFacade.IsDeprecatedJreInstalled();
                    }
                }
            }
            return isComplete;
        }

        #endregion

        #region private methods
        private void SetPageSubHeader()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (this.IsComplete())
            {
                this.InteriorPageSubHeader = "Uninstall complete. Click Next to continue.";
            }
            else
            {
                if (config.VixRole == VixRoleType.DicomGateway)
                {
                    this.InteriorPageSubHeader = "Click Uninstall button to remove existing HDIG web applications.";
                }
                else
                {
                    this.InteriorPageSubHeader = "Click Uninstall button to remove existing VIX web applications.";
                }
            }
        }
        #endregion

        #region events
        private void buttonUninstallViXWebApps_Click(object sender, EventArgs e)
        {
            try
            {
                Cursor.Current = Cursors.WaitCursor;
                this.buttonUninstallViXWebApps.Enabled = false;
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

                //determine patch number
                string fullVersionCurrent = config.ProductVersionProp;
                string[] versionPassArray = fullVersionCurrent.Split('.');
                string versionPassCurrent = versionPassArray[1];
                //determine prior patch number
                string fullVersionPrior;
                string versionPassPrior;
                if (config.PreviousProductVersionProp != null)
                {
                    fullVersionPrior = config.PreviousProductVersionProp;
                    string[] versionPassPriorArray = fullVersionPrior.Split('.');
                    versionPassPrior = versionPassPriorArray[1];
                }
                else
                {
                    fullVersionPrior = null;
                    versionPassPrior = null;
                }

                ZFViewerFacade.InstallZFViewerScriptsOnly();

                BusinessFacade.DeleteCache(config.LocalCacheDir);

                if (TomcatFacade.IsTomcatInstalled())
                {
                    bool isServicesStopped = true;
                    
                    ServiceControllerStatus status = ServiceUtilities.GetLocalServiceStatus(TomcatFacade.TomcatServiceName);
                    this.Info("The ApacheTomcat service (" + TomcatFacade.TomcatServiceName + ") is " + status.ToString("g"));
                    if (status != ServiceControllerStatus.Stopped)
                    {
                            
                        if (ClusterFacade.IsServerClusterNode())
                        {
                            MessageBox.Show("Use the Cluster Administrator to take the VIX service resource offline and then try again.",
                                "Clustered VIX - Additional action required", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                            return;
                        }
                        else
                        {
                            this.Info("Stopping ApacheTomcat service.");
                            // attempt to stop the service
                            ServiceUtilities.StopLocalService(TomcatFacade.TomcatServiceName);
                            do
                            {
                                Application.DoEvents();
                                Thread.Sleep(500);
                                status = ServiceUtilities.GetLocalServiceStatus(TomcatFacade.TomcatServiceName);
                            }
                            while (status == System.ServiceProcess.ServiceControllerStatus.StopPending);
                            status = ServiceUtilities.GetLocalServiceStatus(TomcatFacade.TomcatServiceName);
                            this.Info("The ApacheTomcat service is " + status.ToString("g"));
                            if (status != ServiceControllerStatus.Stopped)
                            {
                                MessageBox.Show("Please use the Service Manager to stop the ApacheTomcat service then try again.",
                                    "Cannot stop the ApacheTomcat service", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                                isServicesStopped = false;
                            }
                        }
                    }
                    
                    //now stop the ZFViewer services.
                    if (ZFViewerFacade.IsZFViewerInstalled())
                    {
                        bool viewerStopStatus = ZFViewerFacade.StopZFViewerServices();
                        if (!viewerStopStatus)
                        {
                            MessageBox.Show("Please use the Service Manager to stop the VIX Viewer and/or Render service then try again.",
                                "Cannot stop the VIX Viewer and/or Render service", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                            isServicesStopped = false;

                        }
                    }
                    
                    if (ListenerFacade.IsListenerInstalled())
                    {
                        bool listenerStopStatus = ListenerFacade.StopListenerService();
                        if (!listenerStopStatus)
                        {
                            MessageBox.Show("Please use the Service Manager to stop the ListenerTool service then try again.",
                                "Cannot stop the ListenerTool service", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                            isServicesStopped = false;
                        }
                    }

                    if (!isServicesStopped)
                    {
                        return;
                    }

                    //1 used for start of install process 2 used for end of install process
                    int installPassCase = 1;
                    //determine if for CVIX install or VIX
                    string vixRoleTypePass = "";
                    if (config.VixRole == VixRoleType.EnterpriseGateway)
                    {
                        vixRoleTypePass = "CVIX";
                    }
                    else
                    {
                        vixRoleTypePass = "VIX";
                    }

                    //Run process to create zip file of latest VIXBackup folder
                    BusinessFacade.VIXBackupZip(versionPassPrior);

                    //Run process to create single line history of install process to track each install
                    BusinessFacade.VIXBackupInstallHistory(fullVersionCurrent, fullVersionPrior, installPassCase);

                    //Run start of uninstall process - use to backup config files
                    BusinessFacade.RunStartOrEndOfInstallProcess(versionPassCurrent, versionPassPrior, installPassCase, vixRoleTypePass, config.ConfigCheck);

                    //Run process to delete old VIXBackup folders
                    BusinessFacade.VIXBackupDeleteOldDirs();

                    VixFacade.UndeployVixWebApplications(config);

                    if (TomcatFacade.IsDeprecatedTomcatVersionInstalled() == true)
                    {
                        this.Info("Uninstalling Tomcat version " + TomcatFacade.DeprecatedTomcatVersion);
                        TomcatFacade.UninstallDeprecatedTomcat();
                        if (TomcatFacade.IsDeprecatedTomcatServiceInstalled())
                        {
                            this.Info("Tomcat service is still installed - reboot required.");
                            DialogResult result = MessageBox.Show("A reboot is required to uininstall the Tomcat6 windows service. After rebooting please re-run the VIX Installation Service Wizard.",
                                "Reboot required.", MessageBoxButtons.OK);
                            return;
                        }
                    }
                    else
                    {
                        // TODO: someday it may be necessary to detect if a x86 version of the active tomcat version is installed on an x64 OS and force an uninstall
                    }
                }

                if (JavaFacade.IsJavaInstalled(false) == false)
                {
                    if (JavaFacade.IsDeprecatedJreInstalled())
                    {
                        this.Info("Uninstalling JRE version " + JavaFacade.DeprecatedJavaVersion);
                        JavaFacade.UninstallDeprecatedJre();
                    }
                    else
                    {
                        // TODO: someday it may be necessary to detect if a x86 version of the active JRE version is installed on an x64 OS and force an uninstall
                    }
                }

                // Removes the deprecated Laurel Bridge toolkit by renaming the installation directory, deleting environment
                // variables, and removing relevant directories from the path environment variable
                if (LaurelBridgeFacade.IsDeprecatedLaurelBridgeInstalled())
                {
                    this.Info("Removing existing prior Laurel Bridge DCF toolkit version " + LaurelBridgeFacade.GetDeprecatedLaurelBridgeVersion());
                    LaurelBridgeFacade.RemoveLaurelBridgeInstallation(config);
                    LaurelBridgeFacade.DeleteOldDeprecatedDcfRoot(config.RenamedDeprecatedDcfRoot);
                    LaurelBridgeFacade.SaveRenamedDeprecatedDcfRoot(config.RenamedDeprecatedDcfRoot); // save only the deprecated root to disk so we dont lose it
                }

                // uninstall LibreOffice
                this.Info("Checking LibreOffice");
                VixManifest WorkManifest = TomcatFacade.Manifest;
                XmlNode OfficeNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']");
                XmlNode OfficeNodeUninstall;
                if (OfficeNode != null)
                {
                    string appPath = OfficeNode.Attributes["appRootRelativeFolder"].Value.Trim();
                    //1 used for prior LibreOffice uninstall, 2 used for current LibreOffice uninstall 
                    int librePassCase = 1;

                    if (BusinessFacade.IsOfficeRegKeyPresent(librePassCase))
                    {
                        OfficeNodeUninstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='LibreOffice']/UninstallCommand");
                        string UninstallCommand = null;
                        if (OfficeNodeUninstall != null)
                        {
                            UninstallCommand = OfficeNodeUninstall.InnerXml.Trim();
                            if (UninstallCommand.ToLower() != "no_upgrade")
                            {
                                System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
                                externalProcess.StartInfo.UseShellExecute = false;
                                externalProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                                externalProcess.StartInfo.FileName = "msiexec.exe";
                                externalProcess.StartInfo.Arguments = UninstallCommand;
                                bool Completed = false;
                                try
                                {
                                    externalProcess.Start();
                                    Completed = externalProcess.WaitForExit(600000);
                                }
                                catch (Exception EX)
                                {
                                    this.Info("LibreOffice Uninstall recieved error " + EX.ToString());
                                }
                                if (Completed)
                                {
                                    //Remove LibreOffice from PATH environment variable - only if prior version of LibreOffice uninstalled
                                    string appPath2 = appPath.Replace(@"\\", @"\");
                                    string librePath = $@"C:{appPath2}\program";
                                    string librePathOld = $@"C:\{appPath2}\\program";           
                                    string workPath = Environment.GetEnvironmentVariable("Path", EnvironmentVariableTarget.Machine);
                                    IEnumerable<string> filteredList = workPath.Split(';').Where(x => string.Compare(x, librePath, true) != 0 && string.Compare(x, librePathOld, true) != 0);
                                    workPath = string.Join(";", filteredList);
                                    Environment.SetEnvironmentVariable("Path", workPath, EnvironmentVariableTarget.Machine);
                                    this.Info("Uninstalling LibreOffice Completed");
                                }
                                else
                                {
                                    this.Info("LibreOffice Uninstall Did Not Complete");
                                }
                            }
                            else
                            {
                                this.Info("No Uninstall for LibreOffice required");
                            }
                        }
                        else
                        {
                            this.Info("LibreOffice Uninstall Did Not Complete No Uninstall Entry");
                        }
                    }
                    else
                    {
                        this.Info("Prior LibreOffice version is not installed on this machine");
                    }
                }
                else
                {
                    this.Info("LibreOffice Uninstall Did Not Complete No Manifest Entry");
                }

                // uninstall PowerShell
                this.Info("Checking PowerShell");
                XmlNode PowerShellNode = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']");
                XmlNode PowerShellNodeUninstall;
                if (PowerShellNode != null)
                {
                    //1 used for prior PowerShell uninstall, 2 used for current PowerShell uninstall 
                    int powerShellPassCase = 1;

                    if (BusinessFacade.IsPowerShellRegKeyPresent(powerShellPassCase))
                    {
                        PowerShellNodeUninstall = WorkManifest.ManifestDoc.SelectSingleNode("VixManifest/Prerequisites/Prerequisite[@name='PowerShell']/UninstallCommand");
                        string UninstallCommand = null;
                        if (PowerShellNodeUninstall != null)
                        {
                            UninstallCommand = PowerShellNodeUninstall.InnerXml.Trim();
                            if (UninstallCommand.ToLower() != "no_upgrade")
                            {
                                System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
                                externalProcess.StartInfo.UseShellExecute = false;
                                externalProcess.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
                                externalProcess.StartInfo.FileName = "msiexec.exe";
                                externalProcess.StartInfo.Arguments = UninstallCommand;
                                bool Completed = false;
                                try
                                {
                                    externalProcess.Start();
                                    Completed = externalProcess.WaitForExit(600000);
                                }
                                catch (Exception EX)
                                {
                                    this.Info("PowerShell Uninstall recieved error " + EX.ToString());
                                }
                                if (Completed)
                                {
                                    this.Info("Uninstalling PowerShell Completed");
                                }
                                else
                                {
                                    this.Info("PowerShell Uninstall Did Not Complete");
                                }
                            }
                            else
                            {
                                this.Info("No Uninstall for PowerShell required");
                            }
                        }
                        else
                        {
                            this.Info("PowerShell Uninstall Did Not Complete No Uninstall Entry");
                        }
                    }
                    else
                    {
                        this.Info("Prior PowerShell version is not installed on this machine");
                    }
                }
                else
                {
                    this.Info("PowerShell Uninstall Did Not Complete No Manifest Entry");
                }

                if (ZFViewerFacade.IsZFViewerInstalled())
                {
                    bool isBackedUp = ZFViewerFacade.BackupZFViewerCfgFiles();
                    if (!isBackedUp)
                    {
                        this.Info("Failed to backup Image Viewer/Render Configuration files");
                    }
					
                    if (!ZFViewerFacade.PurgeZFViewerCache())
                    {
                        this.Info("Failed to purge Viewer Cache.");
                    }

                    if (ZFViewerFacade.IsDeprecatedZFViewerInstalled(config.PreviousProductVersionProp))
                    {
                        bool isServicesRemoved = ZFViewerFacade.DestroyZFViewerWindowsServices();
                        if (!isServicesRemoved)
                        {
                            this.Info("Failed to remove Image Viewer and/or Image Render Windows Services.");
                        }

                        bool isZFViewerUninstalled = ZFViewerFacade.UninstallZFViewer();
                        if (!isZFViewerUninstalled)
                        {
                            this.Info("Failed to uninstall Image Viewer version " + ZFViewerFacade.GetDeprecatedZFViewerVersion(config.PreviousProductVersionProp));
                        }
                    }
                    else
                    {
                        // TODO: someday it may be necessary to detect if a x86 version of the active JRE version is installed on an x64 OS and force an uninstall
                    }

                    if (!ZFViewerFacade.PurgeZFViewerRenderDatabase(versionPassPrior))
                    {
                        this.Info("Failed to purge existing Image Render Database.");
                        this.Info("Please manually purge ViewRender database");
                    }
                }

                if (ListenerFacade.IsListenerInstalled())
                {
                    if (ListenerFacade.IsDeprecatedListenerInstalled())
                    {
                        bool isListenerServiceRemoved = ListenerFacade.DestroyListenerWindowsService();
                        if (!isListenerServiceRemoved)
                        {
                            this.Info("Failed to remove Listener Tool Windows Services.");
                        }

                        bool isListenerUninstalled = ListenerFacade.UninstallListener();
                        if (!isListenerServiceRemoved)
                        {
                            this.Info("Failed to uninstall the Listener Tool version " + ListenerFacade.GetDeprecatedListenerVersion());
                        }
                    }
                }

                this.Info("Press Next to continue.");
                this.SetUninstall(true);
            }
            finally
            {
                Cursor.Current = Cursors.Default;
                this.buttonUninstallViXWebApps.Enabled = true;
                this.Initialize();
            }
        }

        private void SetUninstall(bool uninstall)
        {
            this.uninstall = uninstall;
        }

        private bool IsUninstalled()
        {
            return uninstall;
        }

        
        
        #endregion

     }
}
