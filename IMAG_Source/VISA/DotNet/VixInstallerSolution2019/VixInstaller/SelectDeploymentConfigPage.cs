using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using gov.va.med.imaging.exchange.VixInstaller.business;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class SelectDeploymentConfigPage : gov.va.med.imaging.exchange.VixInstaller.ui.InteriorWizardPage
    {
        VixDeploymentConfiguration[] vixDeploymentConfigurations = null;
        private bool firstTime = true;
        private bool enableEventHandlers = true;

        public SelectDeploymentConfigPage()
        {
            InitializeComponent();
        }

        public SelectDeploymentConfigPage(IWizardForm wizForm, int pageIndex)
            : base(wizForm, pageIndex)
        {
            InitializeComponent();
        }

        #region IWizardPage Members
        public override void Initialize()
        {
            if (firstTime == true)
            {
                this.InitializeBusinessFacadeDelegates();
                this.InteriorPageHeader = @"Specify the type of VIX deployment.";
                this.vixDeploymentConfigurations = VixFacade.Manifest.VixDeploymentConfigurations;
                this.enableEventHandlers = false;
                this.listBoxDeployConfig.DataSource = this.vixDeploymentConfigurations;
                this.listBoxDeployConfig.DisplayMember = "ShortDescription";
                this.listBoxDeployConfig.ValueMember = "VixRole";
                int selectedIndex = this.GetIndexByExistingDeploymentOption();
                if (selectedIndex >= 0)
                {
                    this.listBoxDeployConfig.SelectedIndex = selectedIndex;
                }
                this.DeploymentChangedHandler();
                this.enableEventHandlers = true;
                firstTime = false;
            }

            this.SetPageSubHeader();

            if (IsComplete() == true)
            {
                this.WizardForm.EnableNextButton(true);
            }
            else
            {
                this.WizardForm.EnableNextButton(false);
            }
            this.WizardForm.EnableBackButton(true);
            this.WizardForm.EnableCancelButton(true);
        }

        public override bool IsComplete()
        {
            bool isComplete = false;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

            if (config.VixDeploymentOption == VixDeploymentType.SingleServer || config.VixDeploymentOption == VixDeploymentType.FirstFocClusterNode)
            {
                isComplete = true;
            }
//            else if (config.VixDeploymentOption == VixDeploymentType.SecondFocClusterNode && )

            return isComplete;
        }

        #endregion

        #region private methods
        private void SetPageSubHeader()
        {
            this.InteriorPageSubHeader = "Select the type of VIX deployment, then click the Next button to continue.";
        }

        private int GetIndexByExistingDeploymentOption()
        {
            int index = -1;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();

            for (int i = 0; i < vixDeploymentConfigurations.Length; i++)
            {
                if (config.VixRole == vixDeploymentConfigurations[i].VixRole)
                {
                    index = i;
                    break;
                }
            }

            return index;
        }

        /// <summary>
        /// 
        /// </summary>
        private void DeploymentChangedHandler()
        {
            int selectedIndex = this.listBoxDeployConfig.SelectedIndex;
            this.textBoxDeployDescription.Text = vixDeploymentConfigurations[this.listBoxDeployConfig.SelectedIndex].Description;
            IVixConfigurationParameters config = this.WizardForm.GetVixConfigurationParameters();
            config.VixRole = vixDeploymentConfigurations[this.listBoxDeployConfig.SelectedIndex].VixRole;
        }
        #endregion

        #region events
        private void listBoxDeployConfig_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (this.enableEventHandlers)
            {
                this.DeploymentChangedHandler();
            }
        }

        #endregion

    }
}

