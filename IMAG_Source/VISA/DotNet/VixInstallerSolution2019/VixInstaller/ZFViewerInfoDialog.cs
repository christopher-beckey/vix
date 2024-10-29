using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Vix.Viewer.Install;
using gov.va.med.imaging.exchange.VixInstaller.business;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class ZFViewerInfoDialog : Form
    {
        public ZFViewerInfoDialog()
        {
            InitializeComponent();
            this.configControl1.AllowTabbableFields = true;
        }

        //WFP-find out why the fields are not automatically populated.
        //  They only appear after I click on each field.
        
        private void ConfigureViewerButton_Click(object sender, EventArgs e)
        {
            //FolderSelectDialog dialog = new FolderSelectDialog();
            //if(this.folderSelectDialog.ShowDialog()){
            //ZFViewerFacade.ViewerInstallPath = this.folderSelectDialog.InitialDirectory;
            //    return;
            //}
            ConfigManager.Instance.InstallPath = ZFViewerFacade.ViewerInstallPath;
            ConfigManager.Instance.ViewerProperties.VixServiceProperties.VixVersion = ZFViewerFacade.Manifest.MajorPatchNumber.ToString();
        }
        

        
        private void ZFViewerInfoDialog_Load(object sender, EventArgs e)
        {
            //ConfigManager.Instance.ViewerInstallServiceCommand.CanExecuteChanged += ViewerInstallServiceCommand_CanExecuteChanged;
            //ConfigManager.Instance.ViewerUninstallServiceCommand.CanExecuteChanged += ViewerUninstallServiceCommand_CanExecuteChanged;
            //ConfigManager.Instance.ViewerStartServiceCommand.CanExecuteChanged += ViewerStartServiceCommand_CanExecuteChanged;
            //ConfigManager.Instance.ViewerStopServiceCommand.CanExecuteChanged += ViewerStopServiceCommand_CanExecuteChanged;
            ConfigManager.Instance.SaveConfigurationCommand.CanExecuteChanged += SaveConfigurationCommand_CanExecuteChanged;

            //ConfigManager.Instance.RenderInstallServiceCommand.CanExecuteChanged += RenderInstallServiceCommand_CanExecuteChanged;
            //ConfigManager.Instance.RenderUninstallServiceCommand.CanExecuteChanged += RenderUninstallServiceCommand_CanExecuteChanged;
            //ConfigManager.Instance.RenderStartServiceCommand.CanExecuteChanged += RenderStartServiceCommand_CanExecuteChanged;
            //ConfigManager.Instance.RenderStopServiceCommand.CanExecuteChanged += RenderStopServiceCommand_CanExecuteChanged;
            //ConfigManager.Instance.RenderSaveConfigurationCommand.CanExecuteChanged += RenderSaveConfigurationCommand_CanExecuteChanged;


            //re-assign to an appropriate folder from ZFViewerFacade.
            //this.folderBrowserDialog.SelectedPath = ZFViewerFacade.ViewerInstallPath;

            this.labelErrorInfo.Visible = false;
            this.errorProvider.Clear();
        }
        
        /**
        void RenderSaveConfigurationCommand_CanExecuteChanged(object sender, EventArgs e)
        {
            RenderSaveButton.Enabled = ConfigManager.Instance.RenderSaveConfigurationCommand.CanExecute(null);
        }
        **/
        /*

        void RenderStopServiceCommand_CanExecuteChanged(object sender, EventArgs e)
        {
            RenderStopButton.Enabled = ConfigManager.Instance.RenderStopServiceCommand.CanExecute(null);
        }
        */
        /*

        void RenderStartServiceCommand_CanExecuteChanged(object sender, EventArgs e)
        {
            RenderStartButton.Enabled = ConfigManager.Instance.RenderStartServiceCommand.CanExecute(null);
        }
        */
        /*

        void RenderUninstallServiceCommand_CanExecuteChanged(object sender, EventArgs e)
        {
            RenderUninstallButton.Enabled = ConfigManager.Instance.RenderUninstallServiceCommand.CanExecute(null);
        }
        */
        /*

        void RenderInstallServiceCommand_CanExecuteChanged(object sender, EventArgs e)
        {
            RenderInstallButton.Enabled = ConfigManager.Instance.RenderInstallServiceCommand.CanExecute(null);
        }
        */

        
        void SaveConfigurationCommand_CanExecuteChanged(object sender, EventArgs e)
        {
            SaveConfigurationButton.Enabled = ConfigManager.Instance.SaveConfigurationCommand.CanExecute(null);
        }
        
        /*

        void ViewerStopServiceCommand_CanExecuteChanged(object sender, EventArgs e)
        {
            ViewerStopButton.Enabled = ConfigManager.Instance.ViewerStopServiceCommand.CanExecute(null);
        }
        */
        /*

        void ViewerStartServiceCommand_CanExecuteChanged(object sender, EventArgs e)
        {
            ViewerStartButton.Enabled = ConfigManager.Instance.ViewerStartServiceCommand.CanExecute(null);
        }
        */
        /*

        void ViewerUninstallServiceCommand_CanExecuteChanged(object sender, EventArgs e)
        {
            ViewerUninstallButton.Enabled = ConfigManager.Instance.ViewerUninstallServiceCommand.CanExecute(null);
        }
        */
        /*

        void ViewerInstallServiceCommand_CanExecuteChanged(object sender, EventArgs e)
        {
            ViewerInstallButton.Enabled = ConfigManager.Instance.ViewerInstallServiceCommand.CanExecute(null);
        }
        */
        /*

        private void ViewerInstallButton_Click(object sender, EventArgs e)
        {
            if (ConfigManager.Instance.ViewerInstallServiceCommand.CanExecute(null))
                ConfigManager.Instance.ViewerInstallServiceCommand.Execute(null);
        }

        private void ViewerUninstallButton_Click(object sender, EventArgs e)
        {
            if (ConfigManager.Instance.ViewerUninstallServiceCommand.CanExecute(null))
                ConfigManager.Instance.ViewerUninstallServiceCommand.Execute(null);
        }

        private void ViewerStartButton_Click(object sender, EventArgs e)
        {
            if (ConfigManager.Instance.ViewerStartServiceCommand.CanExecute(null))
                ConfigManager.Instance.ViewerStartServiceCommand.Execute(null);
        }

        private void ViewerStopButton_Click(object sender, EventArgs e)
        {
            if (ConfigManager.Instance.ViewerStopServiceCommand.CanExecute(null))
                ConfigManager.Instance.ViewerStopServiceCommand.Execute(null);
        }
        */

        private void SaveConfigurationButton_Click(object sender, EventArgs e)
        {
            if (ConfigManager.Instance.SaveConfigurationCommand.CanExecute(null))
                ConfigManager.Instance.SaveConfigurationCommand.Execute(null);
        }
        /*

        private void RenderInstallButton_Click(object sender, EventArgs e)
        {
            if (ConfigManager.Instance.RenderInstallServiceCommand.CanExecute(null))
                ConfigManager.Instance.RenderInstallServiceCommand.Execute(null);
        }

        private void RenderUninstallButton_Click(object sender, EventArgs e)
        {
            if (ConfigManager.Instance.RenderUninstallServiceCommand.CanExecute(null))
                ConfigManager.Instance.RenderUninstallServiceCommand.Execute(null);
        }

        private void RenderStartButton_Click(object sender, EventArgs e)
        {
            if (ConfigManager.Instance.RenderStartServiceCommand.CanExecute(null))
                ConfigManager.Instance.RenderStartServiceCommand.Execute(null);
        }

        private void RenderStopButton_Click(object sender, EventArgs e)
        {
            if (ConfigManager.Instance.RenderStopServiceCommand.CanExecute(null))
                ConfigManager.Instance.RenderStopServiceCommand.Execute(null);
        }
        */


        /**
        private void RenderSaveButton_Click(object sender, EventArgs e)
        {
            
            if (ConfigManager.Instance.RenderSaveConfigurationCommand.CanExecute(null))
                ConfigManager.Instance.RenderSaveConfigurationCommand.Execute(null);
            
        }
        **/
       
        
        private void configControl1_Load(object sender, EventArgs e)
        {

        }
        
        private void ZFViewerInfoDialog_FormClosing(object sender, FormClosingEventArgs e)
        {
            ViewerProperties viewerProperties = ConfigManager.Instance.ViewerProperties;
            ViewerServiceProperties viewerServiceProperties = viewerProperties.ViewerServiceProperties;
            RenderServiceProperties renderServiceProperties = viewerProperties.RenderServiceProperties;
            DatabaseProperties databaseProperties = viewerProperties.DatabaseProperties;
            
            if (databaseProperties.InstanceName == null || databaseProperties.InstanceName.Length == 0)
            {
                this.errorProvider.SetError(this.SaveConfigurationButton, "You must provide a SQL database name.");
                this.labelErrorInfo.Visible = true;
                e.Cancel = true;

            }
            
            if (renderServiceProperties.Port == 0)
            {
                this.errorProvider.SetError(this.SaveConfigurationButton, "You must provide a Render Service Port Number.");
                this.labelErrorInfo.Visible = true;
                e.Cancel = true;

            }

            if (databaseProperties.InstanceName == null || databaseProperties.InstanceName.Length == 0)
            {
                this.errorProvider.SetError(this.SaveConfigurationButton, "You must provide the SQL database name.");
                this.labelErrorInfo.Visible = true;
                e.Cancel = true;

            }
        }
    }
}
