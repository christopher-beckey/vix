using GalaSoft.MvvmLight;
using VISAHealthMonitorCommon.wiki;
using System;
using VISACommon;
using VISAHealthMonitorCommon;
using System.Collections.ObjectModel;
using System.Windows;
using GalaSoft.MvvmLight.Command;
using System.Text;

namespace VISAHealthMonitorCommonControls.ViewModel
{
    public delegate void CloseVixAdministratorsWindowDelegate();

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
    public class VixAdministratorsViewModel : ViewModelBase
    {
        public WikiConfiguration WikiConfiguration { get; set; }
        public VisaSource VisaSource { get; set; }
        public string SiteName { get; set; }
        public ListViewSortedCollectionViewSource VixAdministrators { get; private set; }
        public string StatusMessage { get; set; }
        public Visibility ErrorIconVisibility { get; set; }
        public string Title { get; set; }
        public event CloseVixAdministratorsWindowDelegate OnCloseWindowEvent;
        public object SelectedItem { get; set; }
        public RelayCommand CloseCommand { get; set; }
        public RelayCommand SendEmailCommand { get; set; }
        public RelayCommand CopyNameCommand { get; set; }
        public RelayCommand CopyToClipboardCommand { get; set; }

        /// <summary>
        /// Initializes a new instance of the VixAdministratorsViewModel class.
        /// </summary>
        public VixAdministratorsViewModel()
        {
            if (IsInDesignMode)
            {
            ////    // Code runs in Blend --> create design time data.
                SetStatusMessage("Status Message", false);
            }
            else
            {
            // Code runs "for real": Connect to service, etc...
                VixAdministrators = new ListViewSortedCollectionViewSource();
                ClearStatusMessage();
            }
            CloseCommand = new RelayCommand(() => CloseWindow());
            SendEmailCommand = new RelayCommand(() => SendEmail());
            CopyToClipboardCommand = new RelayCommand(() => CopyToClipboard());
        }

        private void CopyToClipboard()
        {
            if (SelectedItem != null)
            {
                VixAdministrator vixAdministrator = (VixAdministrator)SelectedItem;
                SetClipboardText(vixAdministrator.ToString());
            }
        }

        private void SetClipboardText(string text)
        {
            Clipboard.SetText(text);
        }

        private void SendEmail()
        {
            if (VixAdministrators != null)
            {
                StringBuilder url = new StringBuilder();
                StringBuilder sendTo = new StringBuilder();
                string prefix = "";
                foreach (VixAdministrator vixAdministrator in VixAdministrators.Sources.View)
                {
                    if (!string.IsNullOrEmpty(vixAdministrator.Email))
                    {
                        sendTo.Append(prefix);
                        sendTo.Append(vixAdministrator.Email);
                        prefix = ";";
                    }
                }
                if (sendTo.Length > 0)
                {
                    url.Append("mailto:");
                    url.Append(sendTo.ToString());
                    url.Append("?subject=VIX Email Notification - " + VisaSource.Name);

                    VixHealthMonitorHelper.LaunchUrl(url.ToString());
                }
                else
                {
                    MessageBox.Show("No email addresses found");
                }
            }
        }

        private void CloseWindow()
        {
            if (OnCloseWindowEvent != null)
                OnCloseWindowEvent();
        }

        public void SetInitialValues(WikiConfiguration wikiConfiguration, VisaSource visaSource)
        {
            this.WikiConfiguration = wikiConfiguration;
            this.VisaSource = visaSource;
            VaSite site = (VaSite)VisaSource;
            this.SiteName = site.DisplayName;
            this.Title = site.DisplayName + "- VIX Administrators";            
            LoadVixAdministrators(site);
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

        private void LoadVixAdministrators(VaSite site)
        {
            try
            {
                
                ObservableCollection<VixAdministrator> administrators =
                        new ObservableCollection<VixAdministrator>(VixAdministratorsHelper.GetSiteAdministrators(WikiConfiguration, site.SiteNumber, 30));
                VixAdministrators.SetSource(administrators);
            }
            catch (Exception ex)
            {
                SetStatusMessage(ex.Message, true);
            }
        }

        ////public override void Cleanup()
        ////{
        ////    // Clean own resources if needed

        ////    base.Cleanup();
        ////}
    }
}