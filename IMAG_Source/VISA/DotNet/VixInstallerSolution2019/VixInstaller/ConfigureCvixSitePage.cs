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
using System.IO;
using System.Xml;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class ConfigureCvixSitePage : gov.va.med.imaging.exchange.VixInstaller.ui.InteriorWizardPage
    {
        private static bool firstTime = true;
        private SitesFileDialog sitesFileDialog = new SitesFileDialog();
        private ImagingExchangeSiteService siteService = new ImagingExchangeSiteService();
        
        public ConfigureCvixSitePage()
        {
            InitializeComponent();
        }

        public ConfigureCvixSitePage(IWizardForm wizForm, int pageIndex)
            : base(wizForm, pageIndex)
        {
            InitializeComponent();
        }

        #region IWizardPage Members
        public override void Initialize()
        {
            this.InitializeBusinessFacadeDelegates();
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

            this.InteriorPageHeader = "Specify the CVIX site and site service information.";
            this.InteriorPageSubHeader = "Specify the location of vhasites.xml the click the Lookup Server Addresses button.";

            if (firstTime)
            {
                if (config.SiteServiceUri != null)
                {
                    this.textBoxSiteServiceUrl.Text = config.SiteServiceUri;
                }
                if (config.SiteNumber != null)
                {
                    this.textBoxSiteNumber.Text = config.SiteNumber;
                }
                else
                {
                    this.textBoxSiteNumber.Text = "2001";
                }

                if (config.SitesFile != null)
                {
                    this.textBoxSitesFile.Text = config.SitesFile;
                }

                config.CvixHttpConnectorPort = 80;
                config.CvixHttpsConnectorPort = 443;

                if (string.IsNullOrEmpty(config.SitesFile))
                {
                    config.SitesFile = @"c:\SiteService\vhasites.xml";
                }
                this.textBoxSitesFile.Text = config.SitesFile;
                
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
            //this.buttonLookup.Enabled = true;
            this.EnableDisableLookup();
            this.textBoxSiteNumber.ReadOnly = false;
            this.textBoxSiteNumber.Focus();
        }

        public override bool IsComplete()
        {
            bool isComplete = false;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            if (config.VistaServerName != null && config.VistaServerPort != null && 
                config.SiteServiceUri != null && config.SiteNumber != null &&
                config.SiteAbbreviation != null && config.SiteName != null
                )
            {
                isComplete = true;
            }
            return isComplete;
        }
        #endregion

        #region events
        private void buttonLookup_Click(object sender, EventArgs e)
        {
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            errorProvider.Clear();
            textBoxVistaServerName.Text = "";
            textBoxVistaServerPort.Text = "";
            config.VistaServerName = null;
            config.VistaServerPort = null;
            config.SiteServiceUri = null;
            config.SiteNumber = null;
            config.SiteAbbreviation = null;
            config.SiteName = null;
            WizardForm.EnableBackButton(false);
            WizardForm.EnableCancelButton(false);
            buttonLookup.Enabled = false;
            textBoxSiteNumber.Text = textBoxSiteNumber.Text.Trim();
            textBoxSiteNumber.ReadOnly = true;
            try
            {
                Cursor.Current = Cursors.WaitCursor;
                ImagingExchangeSiteTO site = null;

                site = GetSiteInfoFromFile(textBoxSitesFile.Text, textBoxSiteNumber.Text);
            
                if (site == null)
                {
                    errorProvider.SetError(this.textBoxSiteNumber, "Site number not found.");
                }
                else
                {
                    textBoxVistaServerName.Text = site.vistaServer;
                    textBoxVistaServerPort.Text = site.vistaPort.ToString();
                    textBoxVixServerName.Text = site.acceleratorServer;
                    textBoxVixServerPort.Text = site.acceleratorPort.ToString();
                    config.SiteName = site.siteName;
                    config.SiteAbbreviation = site.siteAbbr;
                    config.VistaServerName = textBoxVistaServerName.Text;
                    config.VistaServerPort = textBoxVistaServerPort.Text;
                    config.SiteServiceUri = textBoxSiteServiceUrl.Text;
                    config.SiteNumber = textBoxSiteNumber.Text.Trim();

                    config.SitesFile = textBoxSitesFile.Text;
                    if (string.IsNullOrEmpty(config.SitesFile))
                    {
                        config.SitesFile =  @"c:\SiteService\vhasites.xml";
                    }

                    config.SiteServiceUri = textBoxSiteServiceUrl.Text;
                    if (string.IsNullOrEmpty(config.SiteServiceUri))
                    {
                        config.SiteServiceUri = 
                         "http://localhost:" + site.acceleratorPort.ToString() +
                             "/VistaWebSvcs/ImagingExchangeSiteService.asmx";
                    }
                    
                    config.CvixHttpConnectorPort = 80;
                    config.CvixHttpsConnectorPort = 443;
                    
                    Logger().Info("Configuring VIX for site number " + config.SiteNumber + " (" + config.SiteName + ")");
                    Logger().Info("VistA server is " + config.VistaServerName + ":" + config.VistaServerPort);
                    Logger().Info("Site service is " + config.SiteServiceUri);
                }
            }
            catch (WebException ex)
            {
                errorProvider.SetError(this.textBoxSiteNumber, ex.Message);
            }
            finally
            {
                Cursor.Current = Cursors.Default;
                Initialize();
            }

        }

        private void textBoxSiteNumber_TextChanged(object sender, EventArgs e)
        {
            this.EnableDisableLookup();
        }

        private void buttonSelectSitesFile_Click(object sender, EventArgs e)
        {
            if (this.sitesFileDialog.ShowDialog() == DialogResult.OK)
            {
                textBoxSitesFile.Text = sitesFileDialog.SitesFile;
                Initialize();
            }
        }

        #endregion

        #region private methods

        ImagingExchangeSiteTO GetSiteInfoFromFile(string filespec, string siteNumber)
        {
            ImagingExchangeSiteTO site = null;
            XmlDocument sites = new XmlDocument();
            XmlNamespaceManager namespaceManager = new XmlNamespaceManager(sites.NameTable);
            namespaceManager.AddNamespace("ss", "http://med.va.gov/vistaweb/sitesTable");
            sites.Load(filespec);
            string xpath = "//ss:VhaSite[@ID='" + siteNumber + "']";
            XmlNode xmlSite = sites.SelectSingleNode(xpath, namespaceManager);
            if (xmlSite != null)
            {
                site = new ImagingExchangeSiteTO();
                site.siteNumber = siteNumber;
                site.siteName = xmlSite.Attributes["name"].Value.Trim();
                site.siteAbbr = xmlSite.Attributes["moniker"].Value.Trim();
                site.regionID = xmlSite.ParentNode.Attributes["ID"].Value.Trim();
                // VistA server and port
                XmlNode xmlVista = xmlSite.SelectSingleNode("./ss:DataSource[@protocol='VISTA' or @protocol='FHIE']", namespaceManager);
                Debug.Assert(xmlVista != null);
                site.vistaServer = xmlVista.Attributes["source"].Value.Trim();
                XmlAttribute attrib = xmlVista.Attributes["port"];
                if (attrib != null)
                {
                    string port = attrib.Value.Trim();
                    Int32 tryit;
                    if (Int32.TryParse(port, out tryit))
                    {
                        site.vistaPort = tryit;
                    }
                    else
                    {
                        throw new Exception("VistA port for site " + siteNumber + " is non-numeric: " + port);
                    }
                }
                else
                {
                    site.vistaPort = 9200;
                }
                // VIX server and port
                XmlNode xmlVix = xmlSite.SelectSingleNode("./ss:DataSource[@protocol='VIX']", namespaceManager);
                if (xmlVix != null)
                {
                    site.acceleratorServer = xmlVix.Attributes["source"].Value.Trim();
                    attrib = xmlVix.Attributes["port"];
                    if (attrib != null)
                    {
                        string port = attrib.Value.Trim();
                        Int32 tryit;
                        if (Int32.TryParse(port, out tryit))
                        {
                            site.acceleratorPort = tryit;
                        }
                        else
                        {
                            throw new Exception("VIX port for site " + siteNumber + " is non-numeric: " + port);
                        }
                    }
                    else
                    {
                        throw new Exception("VIX port for site " + siteNumber + " is missing");
                    }
                }
            }
            return site;
        }
        
        private void EnableDisableLookup()
        {
            if ((this.textBoxSiteNumber.Text.Trim().Length >= 3 && File.Exists(textBoxSitesFile.Text)) 
                || (this.textBoxSiteServiceUrl.Text.Trim().Length >= 5))
            {
                this.buttonLookup.Enabled = true;
            }
            else
            {
                this.buttonLookup.Enabled = false;
            }
        }
        #endregion

        private void textBoxVixServerName_TextChanged(object sender, EventArgs e)
        {

        }

    }
}

