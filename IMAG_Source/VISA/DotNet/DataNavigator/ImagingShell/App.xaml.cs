/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */


using System;
using System.Net.Http;
using System.Text;
using System.Windows;
using ImagingClient.Infrastructure.Exceptions;
using ImagingClient.Infrastructure.Views;
using log4net;

namespace ImagingShell
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        private static ILog Logger = LogManager.GetLogger(typeof(App));
        private const int DatabaseConnectionErrorCode = 800;

        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

#if (DEBUG)
            RunInDebugMode();
#else
            RunInReleaseMode();
#endif
            try
            {
                ShutdownMode = ShutdownMode.OnMainWindowClose;
            }
            catch (Exception)
            {
            }
        }

        private static void RunInDebugMode()
        {
            var bootstrapper = new ImagingShellBootstrapper();
            bootstrapper.Run();
        }

        private static void RunInReleaseMode()
        {
            AppDomain.CurrentDomain.UnhandledException += AppDomainUnhandledException;
            try
            {
                var bootstrapper = new ImagingShellBootstrapper();
                bootstrapper.Run();
            }
            catch (Exception ex)
            {
                HandleException(ex);
            }
        }

        private static void AppDomainUnhandledException(object sender, UnhandledExceptionEventArgs e)
        {
            HandleException(e.ExceptionObject as Exception);
        }

        private static void HandleException(Exception ex)
        {
            if (ex == null)
                return;

//            ExceptionPolicy.HandleException(ex, "Default Policy");
//            MessageBox.Show(StockTraderRI.Properties.Resources.UnhandledException);
            Environment.Exit(1);
        }



        public App() : base()
        {
            this.Dispatcher.UnhandledException += OnDispatcherUnhandledException;
        }

        void OnDispatcherUnhandledException(object sender, System.Windows.Threading.DispatcherUnhandledExceptionEventArgs e)
        {
            // Put up a friendly message if the VIX server is down.
            if (e.Exception is HttpException)
            {
                MessageBox.Show(
                    "Unable to connect to the VIX server.", 
                    "VIX Unavailable", 
                    MessageBoxButton.OK,
                    MessageBoxImage.Error);

                // Log the message to log4net
                String logMessage = e.Exception.Message + "\n" + e.Exception.StackTrace;
                Logger.Error(logMessage);

            }
            else if (e.Exception is ServerException && ((ServerException)e.Exception).ErrorCode == DatabaseConnectionErrorCode)
            {
                MessageBox.Show(
                    "Unable to connect to the VistA server.",
                    "VistA Unavailable",
                    MessageBoxButton.OK,
                    MessageBoxImage.Error);

                // Log the message to log4net
                String logMessage = e.Exception.Message + "\n" + e.Exception.StackTrace;
                Logger.Error(logMessage);

            }
            else
            {
                ExceptionWindow window = new ExceptionWindow(e.Exception);
                window.ShowDialog();

                // Log the message to log4net
                String logMessage = e.Exception.Message + "\n" + e.Exception.StackTrace;
                Logger.Error(logMessage);
            }

            e.Handled = true;

        }
    }
}
