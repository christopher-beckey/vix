using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.IO;
using System.Text;
using System.Windows.Forms;
using gov.va.med.imaging.exchange.VixInstaller.business;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class NewInstallWelcomePage : WizardPage
    {
        public NewInstallWelcomePage()
        {
            InitializeComponent();
        }

        public NewInstallWelcomePage(IWizardForm wizForm, int pageIndex)
            : base(wizForm, pageIndex)
        {
            InitializeComponent();
        }

        #region IWizardPage Members
        public override bool IsComplete()
        {
            throw new Exception("The method or operation is not implemented.");
        }

        public override void Initialize()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            this.InitializeBusinessFacadeDelegates();

            if (config.VixRole == VixRoleType.DicomGateway)
            {
                this.pictureBox1.Image = global::VixInstaller.Properties.Resources.HDIG;
                this.textBoxWelcomeHeader.Text = "Welcome to the HDIG Service Installation Wizard";
            }
            else
            {
                this.pictureBox1.Image = global::VixInstaller.Properties.Resources.VixInstaller;
                this.textBoxWelcomeHeader.Text = "Welcome to the VIX Service Installation Wizard";
            }

            this.WizardForm.EnableBackButton(false);
            this.WizardForm.EnableCancelButton(true);

            string vixconfig = Environment.GetEnvironmentVariable("vixconfig", EnvironmentVariableTarget.Machine);
            if (vixconfig != null)
            {
                vixconfig = vixconfig.Replace("/", @"\");
            }

            string vixcache = Environment.GetEnvironmentVariable("vixcache", EnvironmentVariableTarget.Machine);
            if (vixcache != null)
            {
                vixcache = vixcache.Replace("/", @"\");
            }

            if (config.IsNewVixInstallation() == true && config.VixDeploymentOption == VixDeploymentType.FocClusterNode && vixconfig != null && Directory.Exists(vixconfig) == false)
            {
                this.WizardForm.EnableNextButton(false);
                this.textBoxWelcomeText.Text = "Error: cannot access the VIX configuration directory " + vixconfig + ".\r\n\r\n" + config.VixServerNameProp + " does not own the resource group that contains the shared drive where the VIX configuration folder resides.\r\n\r\nPress cancel to exit.";
            }
            else if (config.IsNewVixInstallation() == true && config.VixDeploymentOption == VixDeploymentType.FocClusterNode && vixcache != null && Directory.Exists(vixcache) == false)
            {
                this.WizardForm.EnableNextButton(false);
                this.textBoxWelcomeText.Text = "Error: cannot access the VIX cache directory " + vixcache + ".\r\n\r\n" + config.VixServerNameProp + " does not own the resource group that contains the shared drive where the VIX cache folder resides.\r\n\r\nPress cancel to exit.";
            }
            else
            {
                this.WizardForm.EnableNextButton(true);
                this.textBoxWelcomeText.Text = VixFacade.Manifest.WelcomeMessage;
            }

            if (config.VixRole == VixRoleType.DicomGateway)
            {
                ulong totalPhysicalMemory = TomcatFacade.GetPhysicalMemorySizeInBytes();
                double physicalMemoryInGb = (double)totalPhysicalMemory / (double)(1024 * 1024 * 1024);
                if (physicalMemoryInGb < 3.5)
                {
                    string titleBar = "Windows reports " + physicalMemoryInGb.ToString("##0.00")
                                      + "GB of physical memory";
                    string message =
                        "Recommendation is for at least 4GB of physical RAM to avoid potential reception problems and resource issues.\n" + 
                        "Note: Windows may report less RAM than is actually installed.\n\n" + 
                        "Click OK to continue with the installation.";

                    DialogResult result = MessageBox.Show(
                        message,
                        titleBar,
                        MessageBoxButtons.OKCancel,
                        MessageBoxIcon.Warning);

                    if (result == DialogResult.Cancel)
                    {
                        if (this.ParentForm != null)
                        {
                            this.ParentForm.Close();
                        }
                    }
                }
            }

        }

        #endregion

    }
}
