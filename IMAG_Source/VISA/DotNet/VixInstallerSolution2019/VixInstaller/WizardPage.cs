using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;
using log4net;
using gov.va.med.imaging.exchange.VixInstaller.business;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class WizardPage : UserControl, IWizardPage
    {
        protected ILog Logger()
        {
            return LogManager.GetLogger(this.GetType().Name);
        }

        protected virtual String Info(String infoMessage)
        {
            return infoMessage;
        }

        /// <summary>
        /// Wrap Application.DoEvents for use as a delegate.
        /// </summary>
        private void AppEvents()
        {
            Application.DoEvents();
        }

        private IWizardForm wizForm;
        private int pageIndex = 0;

        protected WizardPage() // used by the Visual Studio designer
        {
            InitializeComponent();
        }

        protected WizardPage(IWizardForm wizForm, int pageIndex) // user by the VixInstaller
        {
            InitializeComponent();
            this.wizForm = wizForm;
            this.pageIndex = pageIndex;
        }

        /// <summary>
        /// Initializes the delegates that allow the static business facade classes to provide feedback to the
        /// current Wizard Page.
        /// </summary>
        protected void InitializeBusinessFacadeDelegates()
        {
            JavaFacade.InfoDelegate = this.Info; // note Info method is virtual
            VixFacade.InfoDelegate = this.Info;
            VixFacade.AppEventsDelegate = this.AppEvents; // private to this base class
            LaurelBridgeFacade.InfoDelegate = this.Info;
            LaurelBridgeFacade.AppEventsDelegate = this.AppEvents;  //WFP-might still need to add this to ZFViewerFacade
            //WFP-Note sure this belongs here
            ZFViewerFacade.InfoDelegate = this.Info;
            BusinessFacade.InfoDelegate = this.Info;
            ListenerFacade.InfoDelegate = this.Info;
            
        }

        #region IWizardPage Members
        public virtual bool IsComplete() { return false; }
        public virtual int GetNextPageIndex() { return this.pageIndex + 1;} // most pages will use
        public virtual void Initialize()
        {
            this.InitializeBusinessFacadeDelegates();
        }
        public void RegisterDevModeChangeHandler()
        {
            this.WizardForm.OnDevModeChange += this.OnDevModeChange;
        }
        public void UnregisterDevModeChangeHandler()
        {
            this.WizardForm.OnDevModeChange -= this.OnDevModeChange;
        }
        #endregion

        #region Form Events
        protected virtual void OnDevModeChange(Object sender, EventArgs e)
        {
            this.Initialize();
        }
        #endregion

        #region properties 
        public int PageIndex
        {
            get { return this.pageIndex; }
        }

        protected IWizardForm WizardForm
        {
            get { return this.wizForm; }
        }

        #endregion
    }
}
