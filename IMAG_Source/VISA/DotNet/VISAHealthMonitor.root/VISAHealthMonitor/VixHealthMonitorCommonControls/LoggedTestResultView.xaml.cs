using System.Windows;
using VISACommon;
using VISAHealthMonitorCommonControls.ViewModel;
using VixHealthMonitorCommonControls.ViewModel;

namespace VixHealthMonitorCommonControls
{
    /// <summary>
    /// Description for LoggedTestResultView.
    /// </summary>
    public partial class LoggedTestResultView : Window
    {
        /// <summary>
        /// Initializes a new instance of the LoggedTestResultView class.
        /// </summary>
        public LoggedTestResultView(VisaSource visaSource)
        {
            InitializeComponent();
            LoggedTestResultsViewModel viewModel = new LoggedTestResultsViewModel();
            viewModel.OnCloseWindowEvent += new CloseWindowDelegate(viewModel_OnCloseWindowEvent);
            this.DataContext = viewModel;
            viewModel.SetVisaSource(visaSource);
        }

        void viewModel_OnCloseWindowEvent()
        {
            this.Close();
        }
    }
}