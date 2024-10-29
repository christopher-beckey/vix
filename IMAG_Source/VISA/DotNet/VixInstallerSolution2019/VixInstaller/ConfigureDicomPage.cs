using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;
using System.IO;
using gov.va.med.imaging.exchange.VixInstaller.business;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class ConfigureDicomPage : gov.va.med.imaging.exchange.VixInstaller.ui.InteriorWizardPage
    {
        private static bool firstTime = true;
        private static bool enableEvents = true;

        public ConfigureDicomPage()
        {
            InitializeComponent();
        }

        public ConfigureDicomPage(IWizardForm wizForm, int pageIndex)
            : base(wizForm, pageIndex)
        {
            InitializeComponent();
        }

        #region IWizardPage Members
        public override void Initialize()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (firstTime)
            {
                enableEvents = false;
                this.InitializeBusinessFacadeDelegates();
                this.InteriorPageHeader = @"Specify the DICOM configuration.";
                this.LoadConfigurationInfo();
                this.WizardForm.EnableBackButton(true);
                this.WizardForm.EnableCancelButton(true);
                firstTime = false;
                enableEvents = true;
            }

            //this.ConfigurePageForDeveloperMode();

            this.SetPageSubHeader();

            // set wizard form button state
            if (this.IsComplete())
            {
                this.WizardForm.EnableNextButton(true);
            }
            else
            {
                this.WizardForm.EnableNextButton(false);
            }
        }

        public override bool IsComplete()
        {
            bool isComplete = false;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

            if (config.HasDicomConfiguration())
            {
                isComplete = true;
            }

            return isComplete;
        }

        #endregion

        #region events

        private void textBoxDicomGatewayServer_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.DicomImageGatewayServer = null; // validation will re-initialize
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void textBoxDicomGatewayPort_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.DicomImageGatewayPort = null; // validation will re-initialize
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void textBoxUsername_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.VdigAccessor = null; // validation will re-initialize
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void textBoxPassword_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.VdigVerifier = null; // validation will re-initialize
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void textBoxConfirmPassword_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.VdigVerifier = null; // validation will re-initialize
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void textBoxNotificationEmailAddresses_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.VdigVerifier = null; // validation will re-initialize
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void checkBoxDicomListenerEnabled_CheckedChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void checkBoxArchiveEnabled_CheckedChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void checkBoxIconGenerationEnabled_CheckedChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void buttonConfirm_Click(object sender, EventArgs e)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            bool validated = true;
            this.errorProvider.Clear();
            this.labelErrorInfo.Visible = false;

            validated &= this.ValidateServerAddress();
            validated &= this.ValidateServerPort();
            validated &= this.ValidateCredentials();
            validated &= this.ValidateServices();
            validated &= this.ValidateNotificationEmailAddresses();

            if (validated)
            {
                this.SaveConfigurationInfo();
                this.buttonConfirm.Enabled = false;
                this.Initialize();
            }
            else
            {
                this.labelErrorInfo.Visible = true;
            }
        }

        #endregion

        #region private methods

        private void LoadConfigurationInfo()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            enableEvents = false;
            if (config.DicomImageGatewayPort != "60001")
            {
                config.DicomImageGatewayPort = "60001";
            }
            this.textBoxDicomGatewayServer.Text = (config.DicomImageGatewayServer == null) ? "" : config.DicomImageGatewayServer;
            this.textBoxDicomGatewayPort.Text = (config.DicomImageGatewayPort == null) ? "" : config.DicomImageGatewayPort;
            this.textBoxUsername.Text = (config.VdigAccessor == null) ? "" : config.VdigAccessor;
            this.textBoxPassword.Text = (config.VdigAccessor == null) ? "" : config.VdigVerifier;
            this.textBoxConfirmPassword.Text = (config.VdigVerifier == null) ? "" : config.VdigVerifier;
            this.checkBoxArchiveEnabled.Checked = config.ArchiveEnabled;
            this.checkBoxDicomListenerEnabled.Checked = config.DicomListenerEnabled;
            this.checkBoxIconGenerationEnabled.Checked = config.IconGenerationEnabled;
            this.textBoxNotificationEmailAddresses.Text = config.NotificationEmailAddresses;
            enableEvents = true;
        }

        private void SaveConfigurationInfo()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            config.DicomImageGatewayServer = (this.textBoxDicomGatewayServer.Text == "") ? null : this.textBoxDicomGatewayServer.Text;
            config.DicomImageGatewayPort = (this.textBoxDicomGatewayPort.Text == "") ? null : this.textBoxDicomGatewayPort.Text;
            config.VdigAccessor = (this.textBoxUsername.Text == "") ? null : this.textBoxUsername.Text;
            config.VdigVerifier = (this.textBoxPassword.Text == "") ? null : this.textBoxPassword.Text;
            config.ArchiveEnabled = this.checkBoxArchiveEnabled.Checked;
            config.DicomListenerEnabled = this.checkBoxDicomListenerEnabled.Checked;
            config.IconGenerationEnabled = this.checkBoxIconGenerationEnabled.Checked;
            config.NotificationEmailAddresses = this.textBoxNotificationEmailAddresses.Text;
        }
        
        private void SetPageSubHeader()
        {
            if (this.IsComplete())
            {
                this.InteriorPageSubHeader = "The DICOM configuration has been specified. Click Next to continue.";
            }
            else
            {
                this.InteriorPageSubHeader = "Enter the requried DICOM configuration information.";
            }
        }

        private bool ValidateServerAddress()
        {
            bool validated = true;

            if (this.textBoxDicomGatewayServer.Text.Trim() == "")
            {
                this.errorProvider.SetError(this.textBoxDicomGatewayServer, "The server must be specified.");
                validated = false;
            }
            return validated;
        }

        private bool ValidateNotificationEmailAddresses()
        {
            bool validated = true;

            if (this.textBoxNotificationEmailAddresses.Text.Trim() == "")
            {
                this.errorProvider.SetError(this.textBoxNotificationEmailAddresses, "One or more comma seperated notification email addresses must be specified.");
                validated = false;
            }
            return validated;
        }

        private bool ValidateServerPort()
        {
            bool validated = true;

            if (this.textBoxDicomGatewayPort.Text.Trim() == "")
            {
                this.errorProvider.SetError(this.textBoxDicomGatewayPort, "The server port must be specified.");
                validated = false;
            }
            else
            {
                int result;
                if (Int32.TryParse(this.textBoxDicomGatewayPort.Text, out result) == false)
                {
                    this.errorProvider.SetError(this.textBoxDicomGatewayPort, "The server port is malformed.");
                    validated = false;
                }
            }

            return validated;
        }


        private bool ValidateCredentials()
        {
            bool validated = true;

            if (this.textBoxUsername.Text.Trim().Length == 0)
            {
                this.errorProvider.SetError(this.textBoxUsername, "You must provide a access code.");
                this.labelErrorInfo.Visible = true;
                validated = false;
            }

            if (this.textBoxPassword.Text.Trim().Length == 0)
            {
                this.errorProvider.SetError(this.textBoxPassword, "You must provide a verify code.");
                this.labelErrorInfo.Visible = true;
                validated = false;
            }

            if (this.textBoxConfirmPassword.Text.Trim().Length == 0)
            {
                this.errorProvider.SetError(this.textBoxConfirmPassword, "You must provide a verify code.");
                validated = false;
            }
            else if (this.textBoxPassword.Text != this.textBoxConfirmPassword.Text)
            {
                this.errorProvider.SetError(this.textBoxConfirmPassword, "Verify codes do not match. Please re-type.");
                this.labelErrorInfo.Visible = true;
                validated = false;
            }

            return validated;
        }

        private bool ValidateServices()
        {
            bool validated = true;

            if (this.checkBoxDicomListenerEnabled.Checked == false && this.checkBoxArchiveEnabled.Checked == false && this.checkBoxIconGenerationEnabled.Checked == false)
            {
                this.errorProvider.SetError(this.checkBoxDicomListenerEnabled, "At least one service must be selected.");
                this.errorProvider.SetError(this.checkBoxArchiveEnabled, "At least one service must be selected.");
                this.errorProvider.SetError(this.checkBoxIconGenerationEnabled, "At least one service must be selected.");
                this.labelErrorInfo.Visible = true;
                validated = false;
            }

            return validated;
        }

        #endregion


    }
}

