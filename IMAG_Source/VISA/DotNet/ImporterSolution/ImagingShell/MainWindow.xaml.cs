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
    using System.ComponentModel;
    using System.Windows;
    using System.Windows.Controls;
    using System.Windows.Input;
    using ImagingClient.Infrastructure;
    using ImagingClient.Infrastructure.Broker;
    using ImagingClient.Infrastructure.Commands;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.User.Model;
    using ImagingClient.Infrastructure.Utilities;
    using ImagingClient.Infrastructure.Views;
    using log4net;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.ServiceLocation;
    using System.IO;

    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow
    {
        #region Constants and Fields 

        /// <summary>
        /// The importer temp folder.
        /// </summary>
        private readonly string importerTempFolder =
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "Importer");

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(MainWindow));

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="MainWindow"/> class.
        /// </summary>
        public MainWindow()
        {
            this.InitializeComponent();
            this.Name = "MainWindow";
            var viewModel = new MainWindowViewModel();
            this.DataContext = viewModel;
            viewModel.UIDispatcher = this.Dispatcher;

            // Register for the login event
            viewModel.ShowLoginWindow += this.OnShowLoginWindow;

            // Register for the logout event
            viewModel.ShowLogoutWindow += this.OnShowLogoutWindow;

            //Register for the countdown message event
            viewModel.ShowCountdownMessage += this.OnShowCountdownMessage;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets the view model.
        /// </summary>
        /// <value>
        /// The view model.
        /// </value>
        public MainWindowViewModel ViewModel
        {
            get { return (MainWindowViewModel) DataContext;  }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// The on show countdown message.
        /// </summary>
        public void OnShowCountdownMessage()
        {
            var countDownMessage = new ImagingClient.Infrastructure.Views.MessageBox(MessageTypes.Warning, true, this.Dispatcher);

            countDownMessage.Owner = this;
            countDownMessage.ShowDialog();
            
            // if there is no response from the user then a timeout will occurr
            if (countDownMessage.GetUserResponse() == MessageBoxResult.None)
            {
                UserContext.TimeoutOccurred = true;
            }
        }

        /// <summary>
        /// The on show login window.
        /// </summary>
        public void OnShowLoginWindow()
        {
            //TLB - Disable custom VistA authentication, use RPC Broker instead
            var loginWindow = ServiceLocator.Current.GetInstance<LoginWindow>();
            BrokerClient client = new BrokerClient();

            try
            {
                //loginWindow.Owner = this;
                //loginWindow.ShowDialog();
                if (client.AuthenticateUser())
                {
                    //Broker initialization moved to AuthenticateUser
                }
                else
                {
                    throw new Exception("ERR: Authentication cannot be completed.");
                }
            }
            catch (Exception ex)
            {
                Logger.Error("ERROR - MainWindow - client.AuthenticateUser(): " + ex.Message);
                // Shutting down...
                Logger.Info("Shutting down...");
                Application.Current.Shutdown();
            }
        }

        /// <summary>
        /// The on show logout window.
        /// </summary>
        public void OnShowLogoutWindow()
        {
            var logoutWindow = ServiceLocator.Current.GetInstance<LogoutWindow>();

            try
            {
                logoutWindow.Owner = this;
                logoutWindow.ShowDialog();
            }
            catch (Exception ex)
            {
                Logger.Error("ERROR - MainWindow: " + ex.Message);
                // Shutting down...
                Logger.Info("Shutting down...");
                Application.Current.Shutdown();
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Creates a menu item.
        /// </summary>
        /// <param name="header">The header.</param>
        /// <param name="command">The command.</param>
        /// <returns></returns>
        private MenuItem CreateMenuItem(String header, ICommand command)
        {
            return new MenuItem() {Header = header, Command = command };
        }

        /// <summary>
        /// Deletes the temp non dicom files.
        /// </summary>
        private void DeleteTempNonDicomFiles()
        {
            string scannedInDirectory = Path.Combine(this.importerTempFolder, "Scanned_In");

            if (Directory.Exists(scannedInDirectory))
            {
                string[] filePaths = Directory.GetFiles(scannedInDirectory);

                // Deletes all of the files in the Scanned_in folder.
                foreach (string filePath in filePaths)
                {
                    File.Delete(filePath);
                }
            }
        }

        /// <summary>
        /// The exit item_ click.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void ExitItem_Click(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        /// <summary>
        /// The on window closing.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void OnWindowClosing(object sender, CancelEventArgs e)
        {
            if (CompositeCommands.TimeoutClearReconcileCommand.CanExecute(e) && UserContext.TimeoutOccurred)
            {
                CompositeCommands.TimeoutClearReconcileCommand.Execute(e);
            }

            if (CompositeCommands.ShutdownCommand.CanExecute(e))
            {
                CompositeCommands.ShutdownCommand.Execute(e);
            }

            if (!e.Cancel)
            {
                var manager = ServiceLocator.Current.GetInstance<IRegionManager>();
                manager.RequestNavigate(RegionNames.MainRegion, ImagingViewNames.ImagingClientHomeView);

                this.DeleteTempNonDicomFiles();

                Application.Current.Shutdown();
            }
        }

        /// <summary>
        /// The view user manual_ click.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void ViewUserManual_Click(object sender, RoutedEventArgs e)
        {
            FileLauncherUtilities.ViewUserManual(this.Dispatcher);
        }

        /// <summary>
        /// Handles the Click event of the ViewAboutWindow control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.RoutedEventArgs"/> instance containing the event data.</param>
        private void ViewAboutWindow_Click(object sender, RoutedEventArgs e)
        {
            var aboutWindow = ServiceLocator.Current.GetInstance<AboutWindow>();
            aboutWindow.Title = "About DICOM Importer";
            aboutWindow.SubscribeToNewUserLogin();
            aboutWindow.ShowDialog();
        }

        /// <summary>
        /// The window_ key down.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void Window_KeyDown(object sender, KeyEventArgs e)
        {
            switch (e.Key)
            {
                case Key.F1:
                    {
                        FileLauncherUtilities.ViewUserManual(this.Dispatcher);
                        break;
                    }
            }
        }

        #endregion
    }
}
