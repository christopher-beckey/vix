namespace VistA.Imaging.Telepathology.Worklist.Views
{
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
    using VistA.Imaging.Telepathology.Common.Model;
    using System.Windows.Interop;
    using VistA.Imaging.Telepathology.Worklist.Controls;

    /// <summary>
    /// Interaction logic for EverifyView.xaml
    /// </summary>
    public partial class EverifyView : Window
    {
        private IWorkListDataSource datasource;
        private int trial;
        private string siteID;

        public EverifyView()
        {
            InitializeComponent();

            this.datasource = null;
            lblTry.Visibility = Visibility.Hidden;
            this.trial = 0;
            this.Success = false;
            this.siteID = string.Empty;
        }

        public EverifyView(IWorkListDataSource source, string siteCode)
        {
            InitializeComponent();

            this.datasource = source;
            lblTry.Visibility = Visibility.Hidden;
            this.trial = 0;
            this.Success = false;
            this.siteID = siteCode;
        }

        private void btnVerify_Click(object sender, RoutedEventArgs e)
        {
            // try 3 times
            this.Success = datasource.VerifyESignature(this.siteID, edtEVerify.Password);
            this.trial++;

            if ((this.Success) || (this.trial >= 3))
            {
                Close();
            }
            else
            {
                lblTry.Visibility = Visibility.Visible;
            }
        }

        private void btnCancel_Click(object sender, RoutedEventArgs e)
        {
            this.Success = false;
            Close();
        }

        public bool Success { get; set; }

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
