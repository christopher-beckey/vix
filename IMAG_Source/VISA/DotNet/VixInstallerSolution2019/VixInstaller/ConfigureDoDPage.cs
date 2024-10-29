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
    public partial class ConfigureDoDPage : gov.va.med.imaging.exchange.VixInstaller.ui.InteriorWizardPage
    {
        private static bool firstTime = true;
        private static bool enableEvents = true;
        private static bool isComplete = false;

        public ConfigureDoDPage()
        {
            InitializeComponent();
        }

        public ConfigureDoDPage(IWizardForm wizForm, int pageIndex)
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
                this.InteriorPageHeader = @"Configure DoD connector";
                this.LoadConfigurationInfo();
                this.WizardForm.EnableBackButton(true);
                this.WizardForm.EnableCancelButton(true);
                this.WizardForm.EnableNextButton(false);
                firstTime = false;
                enableEvents = true;
            }

            this.SetPageSubHeader();

            if (BusinessFacade.IsVCPlusPlus2008RedistributableInstalled())
            {
                this.labelVCPlusPlus2008Runtime.Text = "The Visual Studio 2008 VC++ runtime is installed.";
                this.buttonVCPlusPlus2008Runtime.Enabled = false;
            }
            else
            {
                this.labelVCPlusPlus2008Runtime.Text = "The Visual Studio 2008 VC++ runtime is not installed.";
                this.buttonVCPlusPlus2008Runtime.Enabled = true;
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
            return isComplete;
        }

        #endregion

        #region events

        private void textBoxStation200UserName_TextChanged(object sender, EventArgs e)
        {
            if (enableEvents)
            {
                this.buttonConfirm.Enabled = true;
                this.Initialize();
                this.WizardForm.EnableNextButton(false);
            }

        }

        
        private void buttonVCPlusPlus2008Runtime_Click(object sender, EventArgs e)
        {
            if (BusinessFacade.IsVCPlusPlus2008RedistributableInstalled() == false)
            {
                this.buttonVCPlusPlus2008Runtime.Enabled = false;
                Application.DoEvents();
                if (BusinessFacade.InstallVCPlusPlus2008Redistributable() == false)
                {
                    errorProvider.SetError(buttonVCPlusPlus2008Runtime, "Could not install VS 2008 C++ Runtime.");
                }
                this.Initialize();
            }
        }

        private void buttonConfirm_Click(object sender, EventArgs e)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            bool validated = true;
            this.errorProvider.Clear();
            this.labelErrorInfo.Visible = false;

            validated = this.ValidateConnectorPort(this.textBoxDoDConnectorPort);

            if (this.textBoxStation200UserName.Text.Trim().Length == 0)
            {
                this.errorProvider.SetError(this.textBoxStation200UserName, "You must provide a Station 200 username");
                validated = false;
            }

            if (string.IsNullOrEmpty(this.textBoxDoDConnectorHost.Text))
            {
                this.errorProvider.SetError(this.textBoxDoDConnectorHost, "You must provide DoD Connector Host IP");
                validated = false;
            }
            
            if (string.IsNullOrEmpty(this.textBoxProvider.Text))
            {
                this.errorProvider.SetError(this.textBoxProvider, "You must provide DoD Connector Provider");
                validated = false;
            }

            if (string.IsNullOrEmpty(this.textBoxLoinc.Text))
            {
                this.errorProvider.SetError(this.textBoxLoinc, "You must provide DoD Connector LOINC");
                validated = false;
            }

            if (string.IsNullOrEmpty(this.textBoxRequestSource.Text))
            {
                this.errorProvider.SetError(this.textBoxRequestSource, "You must provide DoD Connector Request Source");
                validated = false;
            }

            if (validated)
            {
                this.SaveConfigurationInfo();
                this.buttonConfirm.Enabled = false;
                this.WizardForm.EnableNextButton(true);
                isComplete = true;
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
            
            this.textBoxStation200UserName.Text = (config.Station200UserName == null) ? "" : config.Station200UserName;
            this.textBoxDoDConnectorHost.Text = (config.DoDConnectorHost == null) ? "" : config.DoDConnectorHost.ToString();
            this.textBoxDoDConnectorPort.Text = config.DoDConnectorPort.ToString();
            this.textBoxProvider.Text = (config.DoDConnectorProvider == null) ? "" : config.DoDConnectorProvider.ToString();
            this.textBoxLoinc.Text = (config.DoDConnectorLoinc == null) ? "" : config.DoDConnectorLoinc.ToString();
            this.textBoxRequestSource.Text = (config.DoDConnectorRequestSource == null) ? "" : config.DoDConnectorRequestSource.ToString();
            
            enableEvents = true;
        }

        private void SaveConfigurationInfo()
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            
            config.Station200UserName = (this.textBoxStation200UserName.Text == "") ? null : this.textBoxStation200UserName.Text.Trim();
            config.DoDConnectorHost = (this.textBoxDoDConnectorHost.Text == "") ? null : this.textBoxDoDConnectorHost.Text.Trim();
            config.DoDConnectorPort = Int32.Parse(this.textBoxDoDConnectorPort.Text);
            config.DoDConnectorProvider = (this.textBoxProvider.Text == "") ? null : this.textBoxProvider.Text.Trim();
            config.DoDConnectorLoinc = (this.textBoxLoinc.Text == "") ? null : this.textBoxLoinc.Text.Trim();
            config.DoDConnectorRequestSource = (this.textBoxRequestSource.Text == "") ? null : this.textBoxRequestSource.Text.Trim();

            
        }
        
        private void SetPageSubHeader()
        {
            if (this.IsComplete())
            {
                this.InteriorPageSubHeader = "The CVIX connections have specified. Click Next to continue.";
            }
            else
            {
                this.InteriorPageSubHeader = "Enter the requried CVIX connection information.";
            }
        }

        private bool ValidateConnectorPort(TextBox box)
        {
            bool validated = true;
            int port;

            if (Int32.TryParse(box.Text, out port))
            {
                if (port <= 0)
                {
                    this.errorProvider.SetError(box, "Port must be > 0");
                    this.labelErrorInfo.Visible = true;
                    validated = false;
                }
            }
            else
            {
                this.errorProvider.SetError(box, "Port must be numeric");
                this.labelErrorInfo.Visible = true;
                validated = false;
            }

            return validated;
        }





        #endregion
    }
}

