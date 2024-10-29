using GalaSoft.MvvmLight;
using VISAHealthMonitorCommonControls.ViewModel;
using VISACommon;
using VISAHealthMonitorCommon;
using GalaSoft.MvvmLight.Command;
using VixHealthMonitorCommon.testresult;
using System.Windows;
using System;
using System.Windows.Input;

namespace VixHealthMonitorCommonControls.ViewModel
{
    /// <summary>
    /// This class contains properties that a View can data bind to.
    /// <para>
    /// Use the <strong>mvvminpc</strong> snippet to add bindable properties to this ViewModel.
    /// </para>
    /// <para>
    /// You can also use Blend to data bind with the tool's support.
    /// </para>
    /// <para>
    /// See http://www.galasoft.ch/mvvm/getstarted
    /// </para>
    /// </summary>
    public class LoggedTestResultsViewModel : ViewModelBase
    {
        public event CloseWindowDelegate OnCloseWindowEvent;
        public VisaSource VisaSource { get; private set; }
        public string Title { get; set; }
        public ListViewSortedCollectionViewSource TestResultsList { get; private set; }
        public RelayCommand<string> SortTestResultsCommand { get; set; }
        public RelayCommand CloseCommand { get; set; }
        public RelayCommand RefreshCommand { get; set; }
        public string StatusMessage { get; set; }
        public Visibility ErrorIconVisibility { get; set; }
        public Cursor Cursor { get; set; }

        /// <summary>
        /// Initializes a new instance of the LoggedTestResultsViewModel class.
        /// </summary>
        public LoggedTestResultsViewModel()
        {
            if (IsInDesignMode)
            {
                ////    // Code runs in Blend --> create design time data.
            }
            else
            {
                // Code runs "for real": Connect to service, etc...
            }
            TestResultsList = new ListViewSortedCollectionViewSource();
            SortTestResultsCommand = new RelayCommand<string>(val => TestResultsList.Sort(val));
            CloseCommand = new RelayCommand(() => Close());
            RefreshCommand = new RelayCommand(() => LoadTestResults());
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}

        public void SetVisaSource(VisaSource visaSource)
        {
            this.VisaSource = visaSource;
            Title = VisaSource.DisplayName + " - Test Results";
            LoadTestResults();
        }

        private void LoadTestResults()
        {
            TestResultsList.ClearSource();
            StatusMessage = "";
            ErrorIconVisibility = Visibility.Collapsed;
            try
            {
                this.Cursor = Cursors.Wait;
                if (VisaHealthTestResultManager.Manager.IsInitialized)
                {
                    System.Collections.ObjectModel.ObservableCollection<VixHealthMonitorCommon.testresult.VisaHealthTestResult> results =
                        new System.Collections.ObjectModel.ObservableCollection<VixHealthMonitorCommon.testresult.VisaHealthTestResult>(
                            VisaHealthTestResultManager.Manager.GetVisaSourceTestResults(VisaSource));

                    TestResultsList.SetSource(results);
                }
            }
            catch (Exception ex)
            {
                StatusMessage = ex.Message;
                ErrorIconVisibility = Visibility.Visible;
            }
            finally
            {
                this.Cursor = Cursors.Arrow;
            }
        }

        private void Close()
        {
            if (OnCloseWindowEvent != null)
                OnCloseWindowEvent();
        }
    }
}