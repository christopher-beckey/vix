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
using VistA.Imaging.Telepathology.Common.Controls;
using System.Windows.Interop;
using VistA.Imaging.Telepathology.Worklist.Controls;

namespace VistA.Imaging.Telepathology.Worklist.Views
{
    /// <summary>
    /// Interaction logic for MessageLog.xaml
    /// </summary>
    public partial class MessageLog : Window
    {
        public MessageLog(bool CanViewSystemLog)
        {
            InitializeComponent();

            string CommonAppDataPath = Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData);
            string VistAPath = @"\VistA\Imaging\Telepathology\Logs\Worklist.log";

            logViewer.DataContext = new LogViewModel(CommonAppDataPath + VistAPath, CanViewSystemLog);
        }

        private void Exit_Click(object sender, RoutedEventArgs e)
        {
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
