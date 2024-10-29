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
namespace ImagingShell
{
    using System;
    using System.Net.Http;
    using System.Windows;
    using System.Windows.Threading;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Exceptions;
    using ImagingClient.Infrastructure.Views;

    using log4net;

    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App
    {
        #region Constants and Fields

        /// <summary>
        /// The database connection error code.
        /// </summary>
        private const int DatabaseConnectionErrorCode = 800;

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(App));

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="App"/> class.
        /// </summary>
        public App()
        {
            this.Dispatcher.UnhandledException += this.OnDispatcherUnhandledException;
        }

        #endregion

        #region Methods

        /// <summary>
        /// The on startup.
        /// </summary>
        /// <param name="e">
        /// The e.
        /// </param>
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
                this.ShutdownMode = ShutdownMode.OnMainWindowClose;
            }
            catch //(Exception ex)
            {
                //Logger.Error(ex);
            }
        }

        /// <summary>
        /// The app domain unhandled exception.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private static void AppDomainUnhandledException(object sender, UnhandledExceptionEventArgs e)
        {
            HandleException(e.ExceptionObject as Exception);
        }

        /// <summary>
        /// The handle exception.
        /// </summary>
        /// <param name="ex">
        /// The ex.
        /// </param>
        private static void HandleException(Exception ex)
        {
            if (ex == null)
            {
                return;
            }

            // ExceptionPolicy.HandleException(ex, "Default Policy");
            // MessageBox.Show(StockTraderRI.Properties.Resources.UnhandledException);
            Environment.Exit(1);
        }

        /// <summary>
        /// The run in debug mode.
        /// </summary>
        private static void RunInDebugMode()
        {
            var bootstrapper = new ImagingShellBootstrapper();
            bootstrapper.Run();
        }

        /// <summary>
        /// The run in release mode.
        /// </summary>
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

        /// <summary>
        /// The on dispatcher unhandled exception.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void OnDispatcherUnhandledException(object sender, DispatcherUnhandledExceptionEventArgs e)
        {
            // Put up a friendly message if the VIX server is down.
            if (e.Exception is HttpException)
            {
                var dialogService = new DialogService();
                dialogService.ShowAlertBox(this.Dispatcher, "Unable to connect to the VIX server.", 
                                           "VIX Unavailable", MessageTypes.Error);

                // Log the message to log4net
                string logMessage = e.Exception.Message + "\n" + e.Exception.StackTrace;
                Logger.Error(logMessage);
            }
            else if (e.Exception is ServerException
                     && ((ServerException)e.Exception).ErrorCode == DatabaseConnectionErrorCode)
            {
                var dialogService = new DialogService();
                dialogService.ShowAlertBox(this.Dispatcher, "Unable to connect to the VistA server.", 
                                           "VistA Unavailable", MessageTypes.Error);

                // Log the message to log4net
                string logMessage = e.Exception.Message + "\n" + e.Exception.StackTrace;
                Logger.Error(logMessage);
            }
            else
            {
                var window = new ExceptionWindow(e.Exception);
                window.SubscribeToNewUserLogin();
                window.ShowDialog();
            }

            e.Handled = true;
        }

        #endregion
    }
}