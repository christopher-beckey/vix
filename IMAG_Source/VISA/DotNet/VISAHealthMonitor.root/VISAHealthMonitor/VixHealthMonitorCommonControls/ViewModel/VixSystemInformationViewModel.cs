using GalaSoft.MvvmLight;
using VISACommon;
using VISAHealthMonitorCommonControls.ViewModel;
using GalaSoft.MvvmLight.Command;
using System.Windows;
using System.Windows.Input;
using System;
using VISAHealthMonitorCommon.jmx;
using VISAHealthMonitorCommon;
using System.Collections.ObjectModel;

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
    public class VixSystemInformationViewModel : ViewModelBase
    {
        public event CloseWindowDelegate OnCloseWindowEvent;
        public VisaSource VisaSource { get; private set; }
        public string Title { get; set; }
        public RelayCommand CloseCommand { get; set; }
        public RelayCommand RefreshCommand { get; set; }
        public string StatusMessage { get; set; }
        public Visibility ErrorIconVisibility { get; set; }
        public Cursor Cursor { get; set; }
        public JmxSystemProperties JmxSystemProperties { get; private set; }
        public ListViewSortedCollectionViewSource JmxSystemPropertyValuesList { get; private set; }
        public RelayCommand<string> SortSystemPropertiesCommand { get; set; }
        public object SelectedItem { get; set; }
        public RelayCommand CopyToClipboardCommand { get; private set; }

        public string TomcatVersion { get; private set; }


        /// <summary>
        /// Initializes a new instance of the VixSystemInformationViewModel class.
        /// </summary>
        public VixSystemInformationViewModel()
        {
            if (IsInDesignMode)
            {
            ////    // Code runs in Blend --> create design time data.
            }
            else
            {
            ////    // Code runs "for real": Connect to service, etc...
            }
            CloseCommand = new RelayCommand(() => Close());
            RefreshCommand = new RelayCommand(() => LoadSystemInformation());
            JmxSystemProperties = JmxSystemProperties.Empty();
            JmxSystemPropertyValuesList = new ListViewSortedCollectionViewSource();
            SortSystemPropertiesCommand = new RelayCommand<string>(val => JmxSystemPropertyValuesList.Sort(val));
            CopyToClipboardCommand = new RelayCommand(() => CopyToClipboard());
            JmxSystemPropertyValuesList.Sort("Name");

            TomcatVersion = "";
        }

        public void Initialize(VisaSource visaSource)
        {
            this.VisaSource = visaSource;
            Title = VisaSource.DisplayName + " - System Information";
            LoadSystemInformation();
        }

        private void CopyToClipboard()
        {
            if (SelectedItem != null)
            {
                JmxSystemProperty property = (JmxSystemProperty)SelectedItem;
                Clipboard.SetText(property.Name + "=" + property.Value);
            }
        }

        private void LoadSystemInformation()
        {
            StatusMessage = "";
            TomcatVersion = "";
            ErrorIconVisibility = Visibility.Collapsed;
            JmxSystemProperties = JmxSystemProperties.Empty();
            try
            {
                this.Cursor = Cursors.Wait;

                this.JmxSystemProperties = 
                    JmxSystemProperties.Parse(
                        JmxUtility.GetJmxBeanValue(VisaSource, KnownJmxAttribute.SystemProperties)
                    );

                JmxSystemPropertyValuesList.SetSource(new ObservableCollection<JmxSystemProperty>(JmxSystemProperties.Values.Values));
                LoadOtherJmxProperties();

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

        private void LoadOtherJmxProperties()
        {
            TomcatVersion =
                JmxUtility.GetJmxBeanValue(VisaSource, KnownJmxAttribute.TomcatServerInfo);
        }

        private void Close()
        {
            if (OnCloseWindowEvent != null)
                OnCloseWindowEvent();
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}