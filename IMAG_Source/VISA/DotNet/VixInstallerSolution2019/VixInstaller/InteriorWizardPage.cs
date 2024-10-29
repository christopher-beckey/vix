using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Text;
using System.Windows.Forms;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    /// <summary>
    /// Note that this class would be abstract, except that that would prevent the Visual Studio designer from
    /// working properly. This class is the base class for all interior wizard pages. It contributes a header bar at the
    /// top of the user control.
    /// </summary>
    public partial class InteriorWizardPage : WizardPage
    {
        protected InteriorWizardPage()
        {
            InitializeComponent();
        }

        protected InteriorWizardPage(IWizardForm wizForm, int pageIndex)
            : base(wizForm, pageIndex)
        {
            InitializeComponent();

        }

        #region protected properties
        protected String InteriorPageHeader
        {
            get { return this.textBoxInteriorHeader.Text; }
            set
            {
                if (value != null)
                {
                    this.textBoxInteriorHeader.Text = value;
                }
            }
        }

        protected String InteriorPageSubHeader
        {
            get { return this.textBoxInteriorSubHeader.Text; }
            set
            {
                if (value != null)
                {
                    this.textBoxInteriorSubHeader.Text = value;
                }
            }
        }
        #endregion
    }
}
