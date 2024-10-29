using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using VistA.Imaging.Telepathology.Worklist.DataSource;
using VistA.Imaging.Telepathology.Common.VixModels;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows.Interop;
using VistA.Imaging.Telepathology.Worklist.Controls;

namespace VistA.Imaging.Telepathology.Worklist.Views
{
    /// <summary>
    /// Interaction logic for SelectUserView.xaml
    /// </summary>
    public partial class SelectUserView : Window, INotifyPropertyChanged
    {
        public SelectUserView()
        {
            InitializeComponent();

            this.DataSource = null;
            this.ModalResult = false;
            this.SelectedUser = null;
            this.SearchItems = new ObservableCollection<PathologyFieldValue>();
            this.SiteID = string.Empty;
        }

        public SelectUserView(IWorkListDataSource datasource, string siteID)
        {
            InitializeComponent();

            this.DataSource = datasource;
            this.SearchItems = new ObservableCollection<PathologyFieldValue>();
            this.ModalResult = false;
            this.SelectedUser = null;
            this.SiteID = siteID;
        }

        /// <remarks>
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </remarks>
        /// <summary>
        /// Event to be raised when a property is changed
        /// </summary>
#pragma warning disable 0067
        // Warning disabled because the event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 0067

        public IWorkListDataSource DataSource { get; set; }

        public string SiteID { get; set; }

        public ObservableCollection<PathologyFieldValue> SearchItems { get; set; }

        public PathologyFieldValue SelectedUser { get; set; }

        public bool ModalResult { get; set; }

        private void Search_Click(object sender, RoutedEventArgs e)
        {
            if ((string.IsNullOrWhiteSpace(searchBox.Text)) || (searchBox.Text.Length < 2))
            {
                MessageBox.Show("Please enter at least 2 characters before searching.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            PathologyFieldValuesType searchResult = DataSource.SearchPathologyItems(this.SiteID, "users", searchBox.Text);
            this.SearchItems = searchResult.FieldList;
            if ((this.SearchItems == null) || (this.SearchItems.Count == 0))
            {
                MessageBox.Show("Couldn't find any user that matches the description.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            this.SelectedUser = this.SearchItems[0];
        }

        private void OK_Click(object sender, RoutedEventArgs e)
        {
            if (this.SelectedUser == null)
            {
                MessageBox.Show("Please select a user.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            this.ModalResult = true;
            Close();
        }

        private void Cancel_Click(object sender, RoutedEventArgs e)
        {
            this.ModalResult = false;
            Close();
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            // timer for application timeout. Once the application times out, it will exit discarding changes
            HwndSource osMessageListener = HwndSource.FromHwnd(new WindowInteropHelper(this).Handle);
            osMessageListener.AddHook(new HwndSourceHook(UserActivityCheck));
        }

        private IntPtr UserActivityCheck(IntPtr hwnd, int msg, IntPtr wParam, IntPtr lParam, ref bool handled)
        {
            //  if the user is still active then reset the timer, add more if needed
            if ((msg >= 0x0200 && msg <= 0x020A) || (msg <= 0x0106 && msg >= 0x00A0) || msg == 0x0021)
            {
                ShutdownTimer.ResetTimer();
            }

            return IntPtr.Zero;
        }
    }
}
