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
using VistA.Imaging.Telepathology.Worklist.ViewModel;
using System.Windows.Interop;
using VistA.Imaging.Telepathology.Worklist.Controls;

namespace VistA.Imaging.Telepathology.Worklist.Views
{
    /// <summary>
    /// Interaction logic for HealthSummaryListView.xaml
    /// </summary>
    public partial class HealthSummaryListView : Window
    {
        public HealthSummaryListView(HealthSummaryListViewModel viewModel)
        {
            InitializeComponent();

            this.DataContext = viewModel;

            viewModel.RequestClose += () => { Close(); };
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

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            if ((DataContext as HealthSummaryListViewModel) != null)
            {
                if ((DataContext as HealthSummaryListViewModel).IsModified)
                {
                    MessageBoxResult result = MessageBox.Show("The health summary settings has been modified. Do you want to save the changes?",
                                                "Confirmation", MessageBoxButton.YesNoCancel, MessageBoxImage.Question, MessageBoxResult.Cancel);
                    if (result == MessageBoxResult.Yes)
                    {
                        (DataContext as HealthSummaryListViewModel).SaveCommand.Execute(null);
                    }
                    else if (result == MessageBoxResult.Cancel)
                    {
                        e.Cancel = true;
                    }
                }
            }
        }
    }
}
