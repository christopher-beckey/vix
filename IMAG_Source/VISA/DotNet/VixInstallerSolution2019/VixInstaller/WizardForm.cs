using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Diagnostics;
using log4net;
using gov.va.med.imaging.exchange.VixInstaller.business;
using System.Configuration;
using System.IO;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public sealed partial class WizardForm : Form, IWizardForm
    {
        private ILog Logger()
        {
            return LogManager.GetLogger(this.GetType().Name);
        }

        private bool isDeveloperMode = false;
        public event EventHandler OnDevModeChange;
        private List<WizardPage> wizardPages = new List<WizardPage>();
        private Stack<WizardPage> previousWizardPages = new Stack<WizardPage>();
        private WizardPage currentWizardPage = null;
        private VixConfigurationParameters config = null;
        private VixManifest manifest = null;
        public MuseFacade MuseConfig { get; set; }

        public WizardForm()
        {
            InitializeComponent();
        }

        #region IWizardForm Members

        public void EnableCancelButton(bool isEnabled)
        {
            this.buttonCancel.Enabled = isEnabled;
        }

        public void EnableNextButton(bool isEnabled)
        {
            this.buttonNext.Text = "&Next >";
            this.buttonNext.Enabled = isEnabled;
            if (isEnabled == true)
            {
                this.buttonNext.Focus();
            }
        }

        public void EnableBackButton(bool isEnabled)
        {
            this.buttonBack.Enabled = isEnabled;
        }

        public void EnableFinishButton(bool isEnabled)
        {
            this.buttonNext.Text = "Finish";
            this.buttonNext.Enabled = isEnabled;
        }

        public bool IsDeveloperMode()
        {
            return this.isDeveloperMode;
        }

        public int GetWizardPageIndex(String fullyQualifiedWizardPageClassName)
        {
            int wizardPageIndex = -1;
            WizardPage page = null;

            for (int i=0 ; i < this.wizardPages.Count ; i++)
            {
                page = this.wizardPages[i];
                if (page.GetType().FullName == fullyQualifiedWizardPageClassName)
                {
                    wizardPageIndex = i;
                    break;
                }
            }

            Debug.Assert(wizardPageIndex >= 0);
            return wizardPageIndex;
        }

        public IVixConfigurationParameters GetVixConfigurationParameters()
        {
            return (IVixConfigurationParameters) this.config;
        }

        public MuseFacade GetMuseConfig()
        {
            return this.MuseConfig;
        }

        #endregion

        #region events
        private void WizardForm_Load(object sender, EventArgs e)
        {
            this.manifest = new VixManifest(Application.StartupPath);
            VixFacade.Manifest = this.manifest;
            TomcatFacade.Manifest = this.manifest;
            JavaFacade.Manifest = this.manifest;
            BusinessFacade.Manifest = this.manifest;
            LaurelBridgeFacade.Manifest = this.manifest;
            ZFViewerFacade.Manifest = this.manifest;
            ListenerFacade.Manifest = this.manifest;

            // Get a new or existing VIX configuration
            this.config = VixConfigurationParameters.GetVixConfiguration(this.manifest.FullyQualifiedPatchNumber, "Marklar", "R00tbeer", false); // false means not a patch - full wizard is used

            // provide a developer override to force the Laurel Bridge prerequisite not to be required
            string isLaurelBridgeRequiredSetting = ConfigurationManager.AppSettings["IsLaurelBridgeRequired"];
            if (isLaurelBridgeRequiredSetting != null)
            {
                bool isLaurelBridgeRequired;
                if (Boolean.TryParse(isLaurelBridgeRequiredSetting, out isLaurelBridgeRequired) == true)
                {
                    this.config.IsLaurelBridgeRequired = isLaurelBridgeRequired;
                }
            }

            if (this.config.VixRole != VixRoleType.EnterpriseGateway)
            {
                LoadMuseConfig();                        
            }
            
            LoadWizardPages();

            // moved after LoadWizardPates which is where the VIX role is currently determined
            SetApplicationTitleBar();// set the Wizard Form title to indicate patch number

            this.ChangeWizardPage(0);
        }

        public void LoadMuseConfig()
        {
            MuseConfig = LoadConfigJar();
        }

        private void buttonCancel_Click(object sender, EventArgs e)
        {
            DialogResult result = MessageBox.Show("Do you really want to quit the VIX Service Installation Wizard?", "VIX Installation is not complete", MessageBoxButtons.YesNo);
            if (result == DialogResult.Yes)
            {
                this.Close();
            }
        }

        private void labelDevMode_Click(object sender, EventArgs e)
        {
            this.isDeveloperMode = !this.isDeveloperMode;
            SetApplicationTitleBar();// set the Wizard Form title to indicate the status change
            OnDevModeChange(this, EventArgs.Empty);
        }

        private void buttonNext_Click(object sender, EventArgs e)
        {
            if (this.buttonNext.Text == "Finish")
            {
                this.Close();
            }
            else
            {
                this.previousWizardPages.Push(this.currentWizardPage);
                this.ChangeWizardPage(this.currentWizardPage.GetNextPageIndex());
            }
        }

        private void buttonBack_Click(object sender, EventArgs e)
        {
            Debug.Assert(this.previousWizardPages.Count > 0);
            this.currentWizardPage = this.previousWizardPages.Pop();
            this.ChangeWizardPage(this.currentWizardPage.PageIndex);
        }

        #endregion

        #region private methods and properties

        private void SetApplicationTitleBar()
        {
            if (this.manifest.ContainsVixRole(VixRoleType.DicomGateway))
            {
                this.Text = "HDIG Service Installation Wizard";
            }
            else if (this.manifest.ContainsVixRole(VixRoleType.RelayVix))
            {
                this.Text = "rVIX Service Installation Wizard";
            }
            else if (this.manifest.ContainsVixRole(VixRoleType.EnterpriseGateway))
            {
                this.Text = "cVIX Service Installation Wizard";
            }
            else //TODO: Patch 104 will need to be much smarter here.
            {
                this.Text = "VIX Service Installation Wizard";
            }
            this.Text += " " + this.manifest.FullyQualifiedPatchNumber;
            if (this.isDeveloperMode == true)
            {
                this.Text += " - Developer Mode";
            }
        }

        private void ChangeWizardPage(int pageIndex)
        {
            Debug.Assert(pageIndex < this.wizardPages.Count);
            this.wizardPages[pageIndex].Dock = DockStyle.Fill;
            this.panelWizardPageContainer.Controls.Clear();
            this.panelWizardPageContainer.Controls.Add(this.wizardPages[pageIndex]);
            if (this.currentWizardPage != null) // this won't be set yet for the welcome page
            {
                this.currentWizardPage.UnregisterDevModeChangeHandler();
            }
            this.currentWizardPage = this.wizardPages[pageIndex];
            this.currentWizardPage.Initialize();
            this.currentWizardPage.RegisterDevModeChangeHandler();
            this.currentWizardPage.Focus();
            Logger().Info("Display wizard page " + this.currentWizardPage.GetType().Name);
        }

        private void LoadWizardPages()
        {
            // for patch 83 determine if we can load the deployment configuration page for the mini vix
            string allowMiniVixAppSetting = ConfigurationManager.AppSettings["AllowP83WorkgroupInstall"];
            bool allowMiniVix;
            Boolean.TryParse(allowMiniVixAppSetting, out allowMiniVix);

            // get the deployment configurations
            VixDeploymentConfiguration[] deployConfigs = this.manifest.VixDeploymentConfigurations;

            // load wizard pages
            int pageIndex = 0;
            this.wizardPages.Add(new NewInstallWelcomePage(this as IWizardForm, pageIndex++));
            if (VixFacade.IsVixInstalled()) // we are updating a previously installed ViX - in this one case only, allow the JDK without checking developer mode
            {
                // add page to stop ViX and un-install web applications
                this.wizardPages.Add(new UndeployVixPage(this as IWizardForm, pageIndex++));
            }
            else
            {
                if (this.config.VixRole == VixRoleType.SiteVix) // bad in that it requires that the Site VIX manifest have two deployment configurations
                {
                    Debug.Assert(deployConfigs.Length > 1);
                    if (allowMiniVix)
                    {
                        this.wizardPages.Add(new SelectDeploymentConfigPage(this as IWizardForm, pageIndex++));
                    }
                }
                else if (deployConfigs.Length > 1)
                {
                    this.wizardPages.Add(new SelectDeploymentConfigPage(this as IWizardForm, pageIndex++));
                }

                #region deprecated - patch based initialization
                //if (manifest.MajorPatchNumber == 83 || manifest.MajorPatchNumber == 119 || manifest.MajorPatchNumber == 104) //TODO: remove in P83 maintenance patch as the mini VIX will become official
                //{
                //    if (allowMiniVix)
                //    {
                //        this.wizardPages.Add(new SelectDeploymentConfigPage(this as IWizardForm, pageIndex++));
                //    }

                //    if (deployConfigs.Length == 1) // 104 CVIX
                //    {
                //        config.VixRole = deployConfigs[0].VixRole;
                //        if (config.VixRole == VixRoleType.EnterpriseGateway) // sanity check
                //        {
                //            config.HttpConnectorPort = 80; // one time default change
                //        }
                //    }
                //    else
                //    {
                //        config.VixRole = VixRoleType.SiteVix; // 104 VIX, 119 VIX
                //    }
                //}
                //else if (deployConfigs.Length == 1) // we know what the vix role will be so set it - P34 does this
                //{
                //    config.VixRole = deployConfigs[0].VixRole;
                //}
                //else if (deployConfigs.Length > 1)
                //{
                //    this.wizardPages.Add(new SelectDeploymentConfigPage(this as IWizardForm, pageIndex++));
                //}
                #endregion
            }
            Logger().Info("this.config.VixRole = " + this.config.VixRole);
            if (this.config.VixRole == VixRoleType.EnterpriseGateway)
            {
                this.wizardPages.Add(new ConfigureCvixSitePage(this as IWizardForm, pageIndex++));
            }
            else
            {
                this.wizardPages.Add(new ConfigureVixSitePage(this as IWizardForm, pageIndex++));
            }

            if (this.config.VixRole == VixRoleType.DicomGateway) // need to make decisions on the prerequisites page based on this - DKB 8/17/10
            {
                this.wizardPages.Add(new ConfigureDicomPage(this as IWizardForm, pageIndex++));
            }

            this.wizardPages.Add(new PrerequisiteChecklistPage(this as IWizardForm, pageIndex++));
            this.wizardPages.Add(new ConfigureVixCachePage(this as IWizardForm, pageIndex++));

            if (manifest.MajorPatchNumber >= 130)
            {
                this.wizardPages.Add(new ConfigureVistaPage(this as IWizardForm, pageIndex++));
            }
            
            if (this.manifest.ContainsVixRole(VixRoleType.SiteVix) && !this.manifest.ContainsVixRole(VixRoleType.RelayVix))
            {
                this.wizardPages.Add(new ConfigureMusePage(this as IWizardForm, pageIndex++));
            }

            if (this.config.VixRole == VixRoleType.EnterpriseGateway)
            {
                //this.wizardPages.Add(new ConfigureXcaPage(this as IWizardForm, pageIndex++));
                this.wizardPages.Add(new ConfigureDoDPage(this as IWizardForm, pageIndex++));
            }

            this.wizardPages.Add(new InstallVixPage(this as IWizardForm, pageIndex++));
        }

        public MuseFacade LoadConfigJar() {
            try 
            { 
                //load the parameters for the MuseDataSource-1.0.config
                string cmdParamaJar = "MuseDataSourceProvider-0.1.jar";
                string cmdParamPackage = "gov.va.med.imaging.musedatasource.MuseDataSourceProvider";

                string processOutput = VixFacade.ReadViXConfigurationFiles(config, cmdParamaJar, cmdParamPackage);

                if (processOutput.Contains("CurrentMuseConfig:") && processOutput.Length>20)
                { 
                    string remainingprocessOutput = processOutput.Substring(processOutput.LastIndexOf("CurrentMuseConfig:"));
                    string[] splitOutput = remainingprocessOutput.Split(new string[] { "//" }, StringSplitOptions.None);

                    if (splitOutput.Length>=8)
                    {
                        bool MuseEnabled = System.Convert.ToBoolean(splitOutput[1]);

                        //VAI-1105 MUSE and MUSE NX support, if the protocol was set as something other than http or https force http in
                        //comboBoxMuseProtocol so dropdown option is selected
                        var protocolList = new List<string> {"http", "https"};
                        int resultProtocol = protocolList.IndexOf(splitOutput[7]);
                        string MuseProtocol = resultProtocol != -1 ? splitOutput[7]: "http";

                        return new MuseFacade(!(MuseEnabled), splitOutput[2], splitOutput[3], splitOutput[4], splitOutput[5], splitOutput[6], MuseProtocol);
                    }                    
                }
            }
            catch (Exception ex)
            {
                Logger().Info(ex.Message);
            }
            return new MuseFacade();
        }
        
        #endregion
    }
}
