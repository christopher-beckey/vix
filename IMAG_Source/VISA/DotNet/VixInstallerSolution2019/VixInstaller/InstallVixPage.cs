using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;
using System.Threading;
using gov.va.med.imaging.exchange.VixInstaller.business;
using System.Configuration;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class InstallVixPage : gov.va.med.imaging.exchange.VixInstaller.ui.InteriorWizardPage
    {
        private BiaCredentialsDialog biaCredentialsDialog = new BiaCredentialsDialog();
        private ZFViewerInfoDialog viewerRenderInfoDialog = new ZFViewerInfoDialog();
        private static bool firstTime = true;

        public InstallVixPage()
        {
            InitializeComponent();
        }

        public InstallVixPage(IWizardForm wizForm, int pageIndex)
            : base(wizForm, pageIndex)
        {
            InitializeComponent();
        }

        protected override String Info(String infoMessage)
        {
            this.textBoxInfo.AppendText(infoMessage + Environment.NewLine);
            return infoMessage;
        }

        #region IWizardPage Members
        public override void Initialize()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (firstTime)
            {
                this.InitializeBusinessFacadeDelegates();
                firstTime = false;
                config.ConfigCheck = false; //always initialize with unchecked
            }

            if (config.VixRole == VixRoleType.DicomGateway)
            {
                this.InteriorPageHeader = "Install the HDIG.";
            }
            else
            {
                this.InteriorPageHeader = "Install the VIX and VIX Viewer/Render Services.";
            }

            //if (VixFacade.Manifest.MajorPatchNumber == 34)
            if (config.VixRole == VixRoleType.DicomGateway)
            {
                this.WizardForm.GetVixConfigurationParameters().BiaPassword = "N/A for DICOM deployment1";
                this.WizardForm.GetVixConfigurationParameters().BiaUsername = "N/A for DICOM deployment2";
            }
            else
            {
                this.WizardForm.GetVixConfigurationParameters().VdigAccessor = "N/A for non DICOM deployment1";
                this.WizardForm.GetVixConfigurationParameters().VdigVerifier = "N/A for non DICOM deployment2";
            }

            if (this.WizardForm.IsDeveloperMode())
            {
                //if (VixFacade.Manifest.MajorPatchNumber == 34)
                if (VixFacade.Manifest.ContainsVixRole(VixRoleType.DicomGateway) || VixFacade.Manifest.ContainsVixRole(VixRoleType.RelayVix))
                {
                    this.buttonConfigBiaCredentials.Visible = false;
                }
                else
                {
                    this.buttonConfigBiaCredentials.Visible = false;
                }

                this.checkBoxConfig.Visible = true;

                if (config.VixRole == VixRoleType.EnterpriseGateway)
                {
                    this.checkBoxConfig.Text = "Update server.xml, DxDataSourceProvider-1.0.config, & MIXDataSource-1.0.config as if new installation";
                }
            }
            else
            {
                this.buttonConfigBiaCredentials.Visible = false;
                this.checkBoxConfig.Visible = false;
            }

            // set wizard form button state
            if (this.IsComplete())
            {
                if (config.VixRole == VixRoleType.DicomGateway)
                {
                    this.InteriorPageSubHeader = "The HDIG has been installed. Click Finish to exit the wizard.";
                }
                else
                {
                    this.InteriorPageSubHeader = "Install complete. Click Finish to end.";
                }
                this.WizardForm.EnableFinishButton(true);
                this.WizardForm.EnableBackButton(false);
                this.WizardForm.EnableCancelButton(false);
                this.buttonInstall.Enabled = false;
                this.buttonConfigBiaCredentials.Enabled = false;

                //if (config.VixRole != VixRoleType.DicomGateway)
                //{
                //    String vixRole = (config.VixRole == VixRoleType.EnterpriseGateway) ? "CVIX" : "VIX";
                //    GetVixVersion(vixRole, "\"" +  TomcatFacade.TomcatConfigurationFolder + "\"");
                //}
            }
            else
            {
                this.InteriorPageSubHeader = "Click Install to begin.";
                this.WizardForm.EnableNextButton(false);
                this.WizardForm.EnableBackButton(true);
                this.WizardForm.EnableCancelButton(true);
                this.buttonInstall.Enabled = true;
                this.buttonConfigBiaCredentials.Enabled = false;
            }
        }

        //public void GetVixVersion(String vixRole, String conf)
        //{
        //    Logger().Info("Calling Post " + vixRole + " install to update catalina.properties");
        //    ProcessStartInfo startInfo = new ProcessStartInfo();
        //    startInfo.UseShellExecute = true;
        //    startInfo.FileName = "VixGetVersion.exe";
        //    startInfo.WindowStyle = ProcessWindowStyle.Normal;
        //    startInfo.Arguments = vixRole + " " + conf;
        //    Process.Start(startInfo);
        //}

        public override bool IsComplete()
        {
			bool isComplete = false;
			if (ZFViewerFacade.IsZFViewerInstalled() && VixFacade.IsVixInstalled())
			{
				isComplete = true;
			}			
            return isComplete;
        }

        #endregion

        #region events
        private void buttonInstall_Click(object sender, EventArgs e)
        {
            //if (VixFacade.Manifest.MajorPatchNumber == 83)
            //{
            //    IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            //    // HACK ALERT - for P83T31 VIX prevent federation interface response for VistARad if P90/P101 is not installed
            //    DialogResult result = MessageBox.Show("If a test version of one of the following VistARad patches is installed at your site, click \"Yes\"\nto enable VistARad support.\n\nMAG*3.0*90\nMAG*3.0*101\n\nIf you click \"No\" and install a VistARad test patch after this point, you will need to reinstall the VIX service.",
            //        "Enable VistARad support?", MessageBoxButtons.YesNo);
            //    if (result == DialogResult.Yes)
            //    {
            //        config.IsPatch90orPatch101Installed = true;
            //    }
            //    else
            //    {
            //        config.IsPatch90orPatch101Installed = false;
            //    }
            //}
            this.InteriorPageSubHeader = "Installing...";
            this.InstallVixandVixViewerServices();
        }

        private void buttonConfigBiaCredentials_Click(object sender, EventArgs e)
        {
            if (this.biaCredentialsDialog.ShowDialog() == DialogResult.OK) // ask for password associated with the admin account
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.BiaUsername = this.biaCredentialsDialog.Username;
                config.BiaPassword = this.biaCredentialsDialog.Password;
            }
        }

        private void checkBoxConfig_CheckedChanged(object sender, EventArgs e)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            config.ConfigCheck = (this.checkBoxConfig.Checked == true) ? true : false;
        }

        #endregion

        #region vix install methods

        private void InstallVixandVixViewerServices()
        {
            this.WizardForm.EnableBackButton(false);
            this.WizardForm.EnableCancelButton(false);
            this.buttonInstall.Enabled = false;
            this.buttonConfigBiaCredentials.Enabled = false;
            try
            {
                Cursor.Current = Cursors.WaitCursor;
				
                // report on ZFViewer install status
                if (ZFViewerFacade.IsZFViewerInstalled())
                {
                    //reinstall ZFViewer
                    this.ReInstallZFViewer();
                }
                else
                {
                    //install ZFViewer
                    this.Logger().Info(this.Info("Installing ZFViewer"));
                    this.InstallZFViewer();
                    this.Logger().Info(this.Info("Creating ZFViewer services"));
                    ZFViewerFacade.CreateZFViewerWindowsService();
                }
								
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                //String payloadPath = VixFacade.Manifest.PayloadPath;
                //bool isDeveloperMode = WizardForm.IsDeveloperMode();

                //set symbolic link for TIFF to PDF files in VIX Render cache (VAI-307)
                CreatePDFFilesLink();
                VixFacade.InstallVix(config); //, isDeveloperMode);
            }
            finally
            {
                Cursor.Current = Cursors.Default;
                this.Initialize();
                if (ClusterFacade.IsServerClusterNode())
                {
                    this.ProvideAdditionalClusterInstructions();
                }
            }
        }

        private void CreatePDFFilesLink()
        {
            try
            {
                string pdfFilesPath = ZFViewerFacade.ViewerInstallPath + "\\VIX.Viewer.Service\\Viewer\\Files";
                string renderCachePath = ZFViewerFacade.GetImageRenderCacheDirectory();
                string renderCacheFilesPath = renderCachePath + "\\Files";
                if (Directory.Exists(pdfFilesPath))
                {
                    Directory.Delete(pdfFilesPath);
                }
                VixFacade.CreateSymbolicLink(pdfFilesPath, renderCacheFilesPath, 0x1);
                Logger().Info("Added symbolic link for PDF files to VIXRenderCache.");
            }
            catch (Exception ex)
            {
                Logger().Info("Exception while adding symbolic link for PDF files to VIXRenderCache: " + ex.Message);
            }
        }

        private void InstallZFViewer()
        {
            //unzip Viewer and Render services
            if (!ZFViewerFacade.IsZFViewerInstalled())
            {
                ZFViewerFacade.InstallZFViewer();

                if (ZFViewerFacade.isZFViewerCfgBackupFilesExist())
                {
                    ZFViewerFacade.RestoreZFViewerCfgFiles();
                }

                this.viewerRenderInfoDialog.FormClosing += viewerRenderInfoDialog_FormClosing;

                if (this.viewerRenderInfoDialog.ShowDialog() != DialogResult.Cancel)
                {
                    ZFViewerFacade.ResetSecurityConfiguration();
                }

                this.viewerRenderInfoDialog.FormClosing -= viewerRenderInfoDialog_FormClosing;
            }
        }

        private void ProvideAdditionalClusterInstructions()
        {
            string message = null;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (config.IsNewVixInstallation())
            {
                if (config.AreBothNodesInstalled() == true)
                {
                    message = "You have installed the VIX service on " + Environment.MachineName + ". The VIX service has been installed on both " + Environment.MachineName + " and " + config.GetOtherNode() + ". To complete the installation use Cluster Administrator to add the VIX service as a resource to the Imaging Resources group and then bring the VIX service resource online.";
                }
                else
                {
                    message = "You have installed the VIX service on  " + Environment.MachineName + ". Your next step is to use Cluster Administrator to transfer the Imaging Resources group to the second cluster server and repeat the VIX installation.";
                }
            }
            else
            {
                if (config.AreBothNodesUpdated() == true)
                {
                    message = "You have updated the VIX service on " + Environment.MachineName + ". The VIX service has been updated on both " + Environment.MachineName + " and " + config.GetOtherNode() + ". To complete the update use Cluster Administrator to bring the VIX service resource online.";
                }
                else
                {
                    message = "You have updated the VIX service on " + Environment.MachineName + ". Your next step is to use Cluster Administrator to transfer the Imaging Resources group to " + config.GetOtherNode() + " and repeat the VIX installation.";
                }
            }
            Debug.Assert(message != null);
            MessageBox.Show(message, "Clustered VIX - Additional action required", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
            Logger().Info("Additional Setup Instructions:");
            Logger().Info(message);
        }
		
		private void ReInstallZFViewer()
        {
            ZFViewerFacade.StopZFViewerServices();

            bool isBackedUp = ZFViewerFacade.BackupZFViewerCfgFiles();
            if (!isBackedUp)
            {
                this.Info("Failed to backup Image Viewer/Render Configuration files");
            }

            bool isServicesRemoved = ZFViewerFacade.DestroyZFViewerWindowsServices();
            if (!isServicesRemoved)
            {
                this.Info("Failed to remove Image Viewer and/or Image Render Windows Services.");
            }

            if (!ZFViewerFacade.DeleteViewerPaths())
            {
                Info("Failed to remove existing Listener installation");
            }

            if (!ZFViewerFacade.PurgeZFViewerRenderDatabase())
            {
                Info("Failed to purge existing Image Render Database.");
                Info("Please manually purge ViewRender database");
            }

            if (!ZFViewerFacade.PurgeZFViewerCache())
            {
                this.Info("Failed to purge Viewer Cache.");
            }

            ZFViewerFacade.InstallZFViewer();

            if (ZFViewerFacade.isZFViewerCfgBackupFilesExist())
            {
                ZFViewerFacade.RestoreZFViewerCfgFiles();
            }

            this.viewerRenderInfoDialog.FormClosing += viewerRenderInfoDialog_FormClosing;

            if (this.viewerRenderInfoDialog.ShowDialog() != DialogResult.Cancel)
            {
                ZFViewerFacade.ResetSecurityConfiguration();
            }

            this.Info("Create Viewer/Render Services");
            ZFViewerFacade.CreateZFViewerWindowsService();

            this.viewerRenderInfoDialog.FormClosing -= viewerRenderInfoDialog_FormClosing;
        }
		
		void viewerRenderInfoDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (ZFViewerFacade.RequireToSaveConfiguration())
            {
                //ZFViewerFacade.SaveConfiguration();
                MessageBox.Show("Please save changes before closing");
                e.Cancel = true;
            }
        }

        #endregion

    }
}

