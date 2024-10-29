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
    public partial class ConfigureMusePage : gov.va.med.imaging.exchange.VixInstaller.ui.InteriorWizardPage
    {
        private static bool firstTime = true;
        private static bool enableEvents = true;
        public MuseFacade MuseConfig { get; set; }

        public ConfigureMusePage()
        {
            InitializeComponent();
        }

        public ConfigureMusePage(IWizardForm wizForm, int pageIndex)
            : base(wizForm, pageIndex)
        {
            InitializeComponent();
        }

        #region IWizardPage Members
        public override void Initialize()
        {
            if (firstTime)
            {
                enableEvents = false;
                this.InitializeBusinessFacadeDelegates();
                this.LoadConfigurationInfo();
                this.InteriorPageHeader = @"Specify the MUSE or MUSE NX configuration.";               
                this.checkBoxMuse.Checked = MuseConfig.MuseEnabled; // fires the CheckedChanged event to enable controls
                this.WizardForm.EnableBackButton(true);
                this.WizardForm.EnableCancelButton(true);
                firstTime = false;
                enableEvents = true;
            }

            this.SetPageSubHeader();

            if (this.checkBoxMuse.Checked == true)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                this.buttonShowHide.Enabled = true; 
                this.buttonConfirm.Enabled = config.HasMuseConfiguration() ? false : true; // saved config means nothing to validate until changes made
            }
            else
            {
                this.buttonShowHide.Enabled = false;
                this.buttonConfirm.Enabled = false;
            }

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

            if (this.checkBoxMuse.Checked == false)
            {
                isComplete = true;
            }
            else if (config.HasMuseConfiguration())
            {
                isComplete = true;
            }

            return isComplete;
        }

        #endregion

        #region events
        private void textBoxMuseSiteNum_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.MuseSiteNum = null; // validation will re-initialize
                this.buttonShowHide.Enabled = true;
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void textBoxMuseHost_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.MuseHostname = null; // validation will re-initialize
                this.buttonShowHide.Enabled = true;
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void textBoxMuseUsername_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.MuseUsername = null; // validation will re-initialize
                this.buttonShowHide.Enabled = true;
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void textBoxMusePassword_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.MusePassword = null; // validation will re-initialize
                this.buttonShowHide.Enabled = true;
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void textBoxMuseConfirmPassword_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.MusePassword = null; // validation will re-initialize
                this.buttonShowHide.Enabled = true;
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void textBoxMusePort_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.MusePort = null; // validation will re-initialize
                this.buttonShowHide.Enabled = true;
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void comboBoxMuseProtocol_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
                config.MuseProtocol = null; // validation will re-initialize
                this.buttonShowHide.Enabled = true;
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }
        }

        private void textBoxMuseSiteNum_KeyPress(object sender, KeyPressEventArgs e)
        {
            e.Handled = !char.IsDigit(e.KeyChar) && !char.IsControl(e.KeyChar);
        }

        private void textBoxMusePort_KeyPress(object sender, KeyPressEventArgs e)
        {
            e.Handled = !char.IsNumber(e.KeyChar) && !char.IsControl(e.KeyChar);
        }

        private void buttonConfirm_Click(object sender, EventArgs e)
        {
            bool validated = true;
            this.errorProvider.Clear();
            this.labelErrorInfo.Visible = false;

            validated &= this.ValidateCredentials();

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

        private void checkBoxMuse_CheckedChanged(object sender, EventArgs e)
        {
            if (this.checkBoxMuse.Checked == true)
            {
                this.EnableControls(true);
            }
            else
            {
                this.EnableControls(false);
                this.ResetConfigurationInfo();
            }
            this.Initialize();
        }

        private void buttonShowHide_Click(object sender, EventArgs e)
        {
            if (textBoxMuseUsername.UseSystemPasswordChar == true || textBoxMuseUsername.UseSystemPasswordChar == true || textBoxMuseConfirmPassword.UseSystemPasswordChar == true)
            {
                textBoxMuseUsername.UseSystemPasswordChar = false;
                textBoxMusePassword.UseSystemPasswordChar = false;
                textBoxMuseConfirmPassword.UseSystemPasswordChar = false;
                buttonShowHide.Text = "Hide";
            }
            else
            {
                textBoxMuseUsername.UseSystemPasswordChar = true;
                textBoxMusePassword.UseSystemPasswordChar = true;
                textBoxMuseConfirmPassword.UseSystemPasswordChar = true;
                buttonShowHide.Text = "Show";
            }
        }

        #endregion

        #region private methods

        private void EnableControls(bool enable)
        {
            this.textBoxMuseSiteNum.Enabled = enable;
            this.textBoxMuseSiteNum.BackColor = (enable == true) ? SystemColors.Window : SystemColors.Control;
            this.textBoxMuseHost.Enabled = enable;
            this.textBoxMuseHost.BackColor = (enable == true) ? SystemColors.Window : SystemColors.Control;
            this.textBoxMuseUsername.Enabled = enable;
            this.textBoxMuseUsername.BackColor = (enable == true) ? SystemColors.Window : SystemColors.Control;
            this.textBoxMusePassword.Enabled = enable;
            this.textBoxMusePassword.BackColor = (enable == true) ? SystemColors.Window : SystemColors.Control;
            this.textBoxMuseConfirmPassword.Enabled = enable;
            this.textBoxMuseConfirmPassword.BackColor = (enable == true) ? SystemColors.Window : SystemColors.Control;
            this.textBoxMusePort.Enabled = enable;
            this.textBoxMusePort.BackColor = (enable == true) ? SystemColors.Window : SystemColors.Control;
            this.comboBoxMuseProtocol.Enabled = enable;
            this.comboBoxMuseProtocol.BackColor = (enable == true) ? SystemColors.Window : SystemColors.Control;
        }

        private void ResetConfigurationInfo()
        {
            enableEvents = false;
            this.textBoxMuseSiteNum.Text = "";
            this.textBoxMuseHost.Text = "";
            this.textBoxMuseUsername.Text = "";
            this.textBoxMusePassword.Text = "";
            this.textBoxMuseConfirmPassword.Text = "";
            this.textBoxMusePort.Text = "8100";
            this.comboBoxMuseProtocol.Text = "http";
            this.SaveConfigurationInfo();
            enableEvents = true;
        }

        private void LoadConfigurationInfo()
        {
            MuseConfig = this.WizardForm.GetMuseConfig();
            enableEvents = false;
            this.checkBoxMuse.Checked = MuseConfig.MuseEnabled;
            this.textBoxMuseSiteNum.Text = (MuseConfig.MuseSiteNum == null || !MuseConfig.MuseEnabled) ? "" : MuseConfig.MuseSiteNum;
            this.textBoxMuseHost.Text = (MuseConfig.MuseHostname == null || !MuseConfig.MuseEnabled) ? "" : MuseConfig.MuseHostname;
            this.textBoxMuseUsername.Text = (MuseConfig.MuseUsername == null || !MuseConfig.MuseEnabled) ? "" : MuseConfig.MuseUsername;
            this.textBoxMusePassword.Text = (MuseConfig.MusePassword == null || !MuseConfig.MuseEnabled) ? "" : MuseConfig.MusePassword;
            this.textBoxMuseConfirmPassword.Text = this.textBoxMusePassword.Text;
            this.textBoxMusePort.Text = (MuseConfig.MusePort == null || !MuseConfig.MuseEnabled) ? "" : MuseConfig.MusePort;
            this.comboBoxMuseProtocol.Text = this.comboBoxMuseProtocol.GetItemText((MuseConfig.MuseProtocol == null || !MuseConfig.MuseEnabled) ? "" : MuseConfig.MuseProtocol);
            enableEvents = true;
        }

        private void SaveConfigurationInfo()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            config.MuseEnabled = (this.checkBoxMuse.Checked == true) ? true : false;
            config.MuseSiteNum = (this.textBoxMuseSiteNum.Text == "") ? null : this.textBoxMuseSiteNum.Text;
            config.MuseHostname = (this.textBoxMuseHost.Text == "") ? null : this.textBoxMuseHost.Text;
            config.MuseUsername = (this.textBoxMuseUsername.Text == "") ? null : this.textBoxMuseUsername.Text;
            config.MusePassword = (this.textBoxMusePassword.Text == "") ? null : this.textBoxMusePassword.Text;
            config.MusePort = (this.textBoxMusePort.Text == "") ? null : this.textBoxMusePort.Text;
            config.MuseProtocol = (this.comboBoxMuseProtocol.Text == "") ? null : this.comboBoxMuseProtocol.Text;
        }
        
        private void SetPageSubHeader()
        {
            if (this.IsComplete())
            {
                if (this.checkBoxMuse.Checked == true)
                {
                    this.InteriorPageSubHeader = "The MUSE or MUSE NX configuration has been specified. Click Next to continue.";
                }
                else
                {
                    this.InteriorPageSubHeader = "No MUSE or MUSE NX specified. Click Next to continue.";
                }
            }
            else
            {
                this.InteriorPageSubHeader = "Please enter the required MUSE or MUSE NX configuration information and click the Confirm button. The MUSE labels below also apply to MUSE NX.";
            }
        }

        private bool ValidateCredentials()
        {
            bool validated = true;

            if (this.textBoxMuseSiteNum.Text.Trim().Length == 0)
            {
                this.errorProvider.SetError(this.textBoxMuseSiteNum, "You must provide a single-digit MUSE site number.");
                this.labelErrorInfo.Visible = true;
                validated = false;
            }

            if (this.textBoxMuseHost.Text.Trim().Length == 0)
            {
                this.errorProvider.SetError(this.textBoxMuseHost, "You must provide a MUSE server host.");
                this.labelErrorInfo.Visible = true;
                validated = false;
            }

            if (this.textBoxMuseUsername.Text.Trim().Length == 0)
            {
                this.errorProvider.SetError(this.textBoxMuseUsername, "You must provide a MUSE username.");
                this.labelErrorInfo.Visible = true;
                validated = false;
            }

            if (this.textBoxMusePassword.Text.Trim().Length == 0)
            {
                this.errorProvider.SetError(this.textBoxMusePassword, "You must provide a MUSE password.");
                this.labelErrorInfo.Visible = true;
                validated = false;
            }

            if (this.textBoxMuseConfirmPassword.Text.Trim().Length == 0)
            {
                this.errorProvider.SetError(this.textBoxMuseConfirmPassword, "You must provide a MUSE password.");
                validated = false;
            }
            else if (this.textBoxMusePassword.Text != this.textBoxMuseConfirmPassword.Text)
            {
                this.errorProvider.SetError(this.textBoxMuseConfirmPassword, "Passwords do not match. Please re-type.");
                this.labelErrorInfo.Visible = true;
                validated = false;
            }

            if (this.textBoxMusePort.Text.Trim().Length == 0)
            {
                this.errorProvider.SetError(this.textBoxMusePort, "You must provide a MUSE port number.");
                this.labelErrorInfo.Visible = true;
                validated = false;
            }

            if (this.comboBoxMuseProtocol.Text.Trim().Length == 0 || this.comboBoxMuseProtocol.SelectedIndex == -1)
            {
                this.errorProvider.SetError(this.comboBoxMuseProtocol, "You must select a MUSE protocol (http or https).");
                this.labelErrorInfo.Visible = true;
                validated = false;
            }

            return validated;
        }

        #endregion

    }
}

