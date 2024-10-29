using System.Windows;
using VISACommon;
using VISAHealthMonitorCommon.wiki;
using VISAHealthMonitorCommonControls.ViewModel;

namespace VISAHealthMonitorCommonControls
{
    /// <summary>
    /// Description for VixAdministratorsView.
    /// </summary>
    public partial class VixAdministratorsView : Window
    {
        /// <summary>
        /// Initializes a new instance of the VixAdministratorsView class.
        /// </summary>
        public VixAdministratorsView(VisaSource visaSource, WikiConfiguration wikiConfiguration)
        {
            InitializeComponent();
            VixAdministratorsViewModel viewModel = new VixAdministratorsViewModel();
            this.DataContext = viewModel;
            viewModel.OnCloseWindowEvent += new CloseVixAdministratorsWindowDelegate(viewModel_OnCloseWindowEvent);
            viewModel.SetInitialValues(wikiConfiguration, visaSource);
        }

        void viewModel_OnCloseWindowEvent()
        {
            this.Close();
        }
    }
}