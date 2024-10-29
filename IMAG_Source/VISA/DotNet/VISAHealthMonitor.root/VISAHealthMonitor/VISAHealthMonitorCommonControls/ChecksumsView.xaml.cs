using System.Windows;
using VISACommon;
using VISAChecksums;
using VISAHealthMonitorCommonControls.ViewModel;
using VISAHealthMonitorCommon.wiki;

namespace VISAHealthMonitorCommonControls
{
    /// <summary>
    /// Description for ChecksumsView.
    /// </summary>
    public partial class ChecksumsView : Window
    {
        /// <summary>
        /// Initializes a new instance of the ChecksumsView class.
        /// </summary>
        public ChecksumsView(VisaSource visaSource, VisaType visaType, WikiConfiguration wikiConfiguration)
        {
            InitializeComponent();
            ChecksumsViewModel viewModel = new ChecksumsViewModel();
            viewModel.OnCloseWindowEvent += new CloseWindowDelegate(viewModel_OnCloseWindowEvent);
            this.DataContext = viewModel;
            viewModel.Initialize(wikiConfiguration, visaSource, visaType);
        }

        void viewModel_OnCloseWindowEvent()
        {
            this.Close();
        }
    }
}