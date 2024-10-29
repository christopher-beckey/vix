using System.Windows;
using GalaSoft.MvvmLight.Threading;

namespace VixHealthMonitor
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        public static string[] mArgs = null;

        static App()
        {
            DispatcherHelper.Initialize();
        }

        private void Application_Startup(object sender, StartupEventArgs e)
        {
            if(e.Args.Length > 0)
                mArgs = e.Args;
        }
    }
}
