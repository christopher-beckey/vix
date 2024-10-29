using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;
using gov.va.med.imaging.exchange.VixInstaller.business;
using System.Net;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class ConfigureVixSitePage : gov.va.med.imaging.exchange.VixInstaller.ui.InteriorWizardPage
    {
        private ImagingExchangeSiteService siteService = new ImagingExchangeSiteService();
        private static bool firstTime = true;

        public ConfigureVixSitePage()
        {
            InitializeComponent();
        }

        public ConfigureVixSitePage(IWizardForm wizForm, int pageIndex)
            : base(wizForm, pageIndex)
        {
            InitializeComponent();
        }

        #region IWizardPage Members
        public override void Initialize()
        {
            this.InitializeBusinessFacadeDelegates();
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

            if (config.VixRole == VixRoleType.DicomGateway)
            {
                this.InteriorPageHeader = "Specify the VA site the HDIG will service.";
                this.InteriorPageSubHeader = "Specify the VA site number for this HDIG then click the Lookup Server Addresses button.";
            }
            else
            {
                this.InteriorPageHeader = "Specify the VA site the VIX will service.";
                this.InteriorPageSubHeader = "Specify the VA site number for this VIX then click the Lookup Server Addresses button.";
            }

            //this.EnableDisableLookup();

            if (firstTime) // we are updating a previously installed VIX
            {
                if (config.SiteServiceUri != null)
                {
                    this.textBoxSiteServiceUrl.Text = config.SiteServiceUri;
                }
                if (config.SiteNumber != null)
                {
                    this.textBoxSiteNumber.Text = config.SiteNumber;
                }

                if (config.VixRole == VixRoleType.DicomGateway)
                {
                    this.labelVixServerName.Visible = false;
                    this.labelVixServerPort.Visible = false;
                    this.textBoxVixServerName.Visible = false;
                    this.textBoxVixServerPort.Visible = false;
                }
                firstTime = false;
            }

            if (this.WizardForm.IsDeveloperMode())
            {
                this.groupBoxSiteServiceUri.Visible = true;
            }
            else
            {
                this.groupBoxSiteServiceUri.Visible = false;
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
            this.WizardForm.EnableBackButton(true);
            this.WizardForm.EnableCancelButton(true);
            this.EnableDisableLookup();
            //this.buttonLookup.Enabled = true;
            this.textBoxSiteNumber.ReadOnly = false;
            this.textBoxSiteNumber.Focus();
        }

        public override bool IsComplete()
        {
            bool isComplete = false;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (config.VistaServerName != null && config.VistaServerPort != null && config.SiteServiceUri != null && config.SiteNumber != null &&
                config.SiteAbbreviation != null && config.SiteName != null)
            {
                isComplete = true;
            }
            return isComplete;
        }
        #endregion

        private void buttonLookup_Click(object sender, EventArgs e)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            this.errorProvider.Clear();
            this.textBoxVistaServerName.Text = "";
            this.textBoxVistaServerPort.Text = "";
            config.VistaServerName = null;
            config.VistaServerPort = null;
            config.SiteServiceUri = null;
            config.SiteNumber = null;
            config.SiteAbbreviation = null;
            config.SiteName = null;
            siteService.Url = this.textBoxSiteServiceUrl.Text;
            this.WizardForm.EnableBackButton(false);
            this.WizardForm.EnableCancelButton(false);
            this.buttonLookup.Enabled = false;
            textBoxSiteNumber.Text = textBoxSiteNumber.Text.Trim();
            this.textBoxSiteNumber.ReadOnly = true;
            try
            {
                Cursor.Current = Cursors.WaitCursor;
                ImagingExchangeSiteTO site = siteService.getSite(this.textBoxSiteNumber.Text);
                if (site.vistaServer == null)
                {
                    this.errorProvider.SetError(this.textBoxSiteNumber, "Site number not found.");
                }
                else
                {
                    //TODO: harden
                    this.textBoxVistaServerName.Text = site.vistaServer;
                    this.textBoxVistaServerPort.Text = site.vistaPort.ToString();
                    this.textBoxVixServerName.Text = site.acceleratorServer;
                    this.textBoxVixServerPort.Text = site.acceleratorPort.ToString();
                    config.SiteName = site.siteName;
                    config.SiteAbbreviation = site.siteAbbr;
                    config.VistaServerName = this.textBoxVistaServerName.Text;
                    config.VistaServerPort = this.textBoxVistaServerPort.Text;
                    config.SiteServiceUri = this.textBoxSiteServiceUrl.Text;
                    config.SiteNumber = this.textBoxSiteNumber.Text;
                    this.Logger().Info("Configuring VIX for site number " + config.SiteNumber + " (" + config.SiteName + ")");
                    this.Logger().Info("VistA server is " + config.VistaServerName + ":" + config.VistaServerPort);
                    this.Logger().Info("Using site service at " + config.SiteServiceUri);
                }
            }
            catch (WebException ex)
            {
                this.errorProvider.SetError(this.textBoxSiteNumber, ex.Message);
            }
            finally
            {
                Cursor.Current = Cursors.Default;
                this.Initialize();
            }
        }

        private void EnableDisableLookup()
        {
            if (this.textBoxSiteNumber.Text.Trim().Length >= 3)
            {
                this.buttonLookup.Enabled = true;
            }
            else
            {
                this.buttonLookup.Enabled = false;
            }
        }

        private void textBoxSiteNumber_TextChanged(object sender, EventArgs e)
        {
            this.EnableDisableLookup();
        }

    }
}

