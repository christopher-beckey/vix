using System.Windows;
using VISACommon;
using VixHealthMonitorCommonControls.ViewModel;

namespace VixHealthMonitorCommonControls
{
    /// <summary>
    /// Description for VixSystemInformationView.
    /// </summary>
    public partial class VixSystemInformationView : Window
    {
        /// <summary>
        /// Initializes a new instance of the VixSystemInformationView class.
        /// </summary>
        public VixSystemInformationView(VisaSource visaSource)
        {
            InitializeComponent();
            VixSystemInformationViewModel viewModel = new VixSystemInformationViewModel();
            viewModel.OnCloseWindowEvent += 
                new VISAHealthMonitorCommonControls.ViewModel.CloseWindowDelegate(viewModel_OnCloseWindowEvent);
            this.DataContext = viewModel;
            viewModel.Initialize(visaSource);

        }

        void viewModel_OnCloseWindowEvent()
        {
            this.Close();
        }
    }
}