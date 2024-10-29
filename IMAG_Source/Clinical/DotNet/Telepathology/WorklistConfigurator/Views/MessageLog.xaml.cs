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

namespace VistA.Imaging.Telepathology.Configurator.Views
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
            string VistAPath = @"\VistA\Imaging\Telepathology\Logs\Configurator.log";

            logViewer.DataContext = new LogViewModel(CommonAppDataPath + VistAPath, CanViewSystemLog);
        }

        private void Exit_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }
    }
}
