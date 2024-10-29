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
    using System.Windows;

    using ImagingClient.Infrastructure;
    using ImagingClient.Infrastructure.Broker;
    using ImagingClient.Infrastructure.Logging;
    using ImagingClient.Infrastructure.User.Model;
    using ImagingClient.Infrastructure.Views;

    using log4net;

    using Microsoft.Practices.Prism.Logging;
    using Microsoft.Practices.Prism.Modularity;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Prism.UnityExtensions;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// The imaging shell bootstrapper.
    /// </summary>
    public class ImagingShellBootstrapper : UnityBootstrapper
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog logger = LogManager.GetLogger(typeof(ImagingShellBootstrapper));

        #endregion

        #region Public Methods

        /// <summary>
        /// The run.
        /// </summary>
        /// <param name="runWithDefaultConfiguration">
        /// The run with default configuration.
        /// </param>
        public override void Run(bool runWithDefaultConfiguration)
        {
            base.Run(runWithDefaultConfiguration);

            var manager = ServiceLocator.Current.GetInstance<IRegionManager>();
            // manager.RequestNavigate(RegionNames.MainRegion, "ImagingHomeView");

            //TLB - Disable custom VistA authentication, use RPC Broker instead
            //var loginWindow = ServiceLocator.Current.GetInstance<LoginWindow>();
            BrokerClient client = new BrokerClient();

            try
            {
                //loginWindow.Owner = (Window)this.Shell;
                //loginWindow.ShowDialog();
                if (client.AuthenticateUser())
                {
                    //Broker initialization moved to AuthenticateUser

                    MainWindowViewModel viewModel = (MainWindowViewModel)System.Windows.Application.Current.MainWindow.DataContext;
                    viewModel.UpdateMenus();

                    // If login is successful, navigate to Importer home
                    if (UserContext.IsLoginSuccessful)
                    {
                        // configures and starts the user idle timer
                        MainWindowViewModel vm = (MainWindowViewModel)((Window)this.Shell).DataContext;
                        vm.ConfigureAndStartTimer();

                        manager.RequestNavigate(RegionNames.MainRegion, "ImporterHomeView");
                    }
                }
                else
                {
                    throw new Exception("ERR: Authentication cannot be completed.");
                }
            }
            catch (Exception ex)
            {
                logger.Error("ERROR - ImagingShellBootstrapper - client.AuthenticateUser(): " + ex.Message);
                // Shutting down...
                logger.Info("Shutting down...");
                Application.Current.Shutdown();
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Creates the <see cref="T:Microsoft.Practices.Prism.Modularity.IModuleCatalog"/> used by Prism.
        /// </summary>
        /// <returns>The module catalog</returns>
        protected override IModuleCatalog CreateModuleCatalog()
        {
            return new DirectoryModuleCatalog { ModulePath = @"." };
        }

        /// <summary>
        /// Creates the shell or main window of the application.
        /// </summary>
        /// <returns>
        /// The shell of the application.
        /// </returns>
        protected override DependencyObject CreateShell()
        {
            return new MainWindow();
        }

        /// <summary>
        /// Create the <see cref="T:Microsoft.Practices.Prism.Logging.ILoggerFacade"/> used by the bootstrapper.
        /// </summary>
        /// <returns>An instance of the Log4NetLogger</returns>
        protected override ILoggerFacade CreateLogger()
        {
            return new Log4NetLogger();
        }

        /// <summary>
        /// The initialize shell.
        /// </summary>
        protected override void InitializeShell()
        {
            Application.Current.MainWindow = (Window)this.Shell;
            Application.Current.MainWindow.Show();
        }

        #endregion
    }
}