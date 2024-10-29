using GalaSoft.MvvmLight;
using VISACommon;
using GalaSoft.MvvmLight.Command;
using System.Windows;
using VISAHealthMonitorCommon.jmx;
using System;
using System.Windows.Input;

namespace VISAHealthMonitorCommonControls.ViewModel
{
    public delegate void CloseJmxWindowDelegate();

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
    public class JmxViewModel : ViewModelBase
    {
        public VisaSource VisaSource { get;  set; }
        public event CloseJmxWindowDelegate OnCloseWindowEvent;
        public string Title { get; private set; }
        public string SiteName { get; private set; }
        public RelayCommand GetValueCommand { get; private set; }
        public RelayCommand CloseCommand { get; set; }
        public string StatusMessage { get; set; }
        public Visibility ErrorIconVisibility { get; set; }
        public string ObjectName { get; set; }
        public string Attribute { get; set; }
        public string Output { get; set; }
        public Cursor Cursor { get; set; }

        /// <summary>
        /// Initializes a new instance of the JmxViewModel class.
        /// </summary>
        public JmxViewModel()
        {
            if (IsInDesignMode)
            {
                // Code runs in Blend --> create design time data.
                Title = "JMX";
            }
            else
            {
                // Code runs "for real": Connect to service, etc...
            }
            GetValueCommand = new RelayCommand(() => GetValue());
            CloseCommand = new RelayCommand(() => CloseWindow());
            ClearStatusMessage();
        }

        private void GetValue()
        {
            try
            {
                this.Cursor = Cursors.Wait;
                Output = "";
                Output = JmxUtility.GetJmxBeanValue(VisaSource, ObjectName, Attribute);
            }
            catch (Exception ex)
            {
                SetStatusMessage(ex.Message, true);
            }
            finally
            {
                this.Cursor = Cursors.Arrow;
            }
        }

        private void CloseWindow()
        {
            if (OnCloseWindowEvent != null)
                OnCloseWindowEvent();
        }

        public void Initialize(VisaSource visaSource)
        {
            this.VisaSource = visaSource;
            VaSite site = (VaSite)VisaSource;
            this.SiteName = site.DisplayName;
            this.Title = site.DisplayName + "- JMX";            
        }

        private void ClearStatusMessage()
        {
            SetStatusMessage("", false);
        }

        private void SetStatusMessage(string msg, bool error)
        {
            if (error)
            {
                ErrorIconVisibility = Visibility.Visible;
            }
            else
            {
                ErrorIconVisibility = Visibility.Collapsed;
            }
            StatusMessage = msg;
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}