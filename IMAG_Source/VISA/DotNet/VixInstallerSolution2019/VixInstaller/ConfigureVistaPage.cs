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
    public partial class ConfigureVistaPage : gov.va.med.imaging.exchange.VixInstaller.ui.InteriorWizardPage
    {
        private static bool firstTime = true;
        private static bool enableEvents = true;

        public ConfigureVistaPage()
        {
            InitializeComponent();
        }

        public ConfigureVistaPage(IWizardForm wizForm, int pageIndex)
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
                this.InteriorPageHeader = @"Specify the VistA and email configuration.";
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

            if (config.HasVistaConfiguration())
            {
                isComplete = true;
            }

            return isComplete;
        }

        #endregion

        #region events

        private void textBoxUsername_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.VistaAccessor = null; // validation will re-initialize
                this.buttonShowHide.Enabled = true;
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
                config.VistaVerifier = null; // validation will re-initialize
                this.buttonShowHide.Enabled = true;
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
                config.VistaVerifier = null; // validation will re-initialize
                this.buttonShowHide.Enabled = true;
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
                config.VistaVerifier = null; // validation will re-initialize
                this.buttonShowHide.Enabled = true;
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

            validated &= this.ValidateCredentials();
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

        private void buttonShowHide_Click(object sender, EventArgs e)
        {
            if (textBoxUsername.UseSystemPasswordChar == true || textBoxPassword.UseSystemPasswordChar == true || textBoxConfirmPassword.UseSystemPasswordChar == true)
            {
                textBoxUsername.UseSystemPasswordChar = false;
                textBoxPassword.UseSystemPasswordChar = false;
                textBoxConfirmPassword.UseSystemPasswordChar = false;
                buttonShowHide.Text = "Hide";
            }
            else
            {
                textBoxUsername.UseSystemPasswordChar = true;
                textBoxPassword.UseSystemPasswordChar = true;
                textBoxConfirmPassword.UseSystemPasswordChar = true;
                buttonShowHide.Text = "Show";
            }
        }

        #endregion

        #region private methods

        private void LoadConfigurationInfo()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            enableEvents = false;
            this.textBoxUsername.Text =  "";
            this.textBoxPassword.Text =  "";
            this.textBoxConfirmPassword.Text = "";
            this.textBoxNotificationEmailAddresses.Text = config.NotificationEmailAddresses;
            enableEvents = true;
        }

        private void SaveConfigurationInfo()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            config.VistaAccessor = (this.textBoxUsername.Text == "") ? null : this.textBoxUsername.Text;
            config.VistaVerifier = (this.textBoxPassword.Text == "") ? null : this.textBoxPassword.Text;
            config.NotificationEmailAddresses = this.textBoxNotificationEmailAddresses.Text;
        }
        
        private void SetPageSubHeader()
        {
            if (this.IsComplete())
            {
                this.InteriorPageSubHeader = "The VistA and email configuration has been specified. Click Next to continue.";
            }
            else
            {
                this.InteriorPageSubHeader = "Enter the required VistA and email configuration information.";
            }
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

        #endregion


    }
}

