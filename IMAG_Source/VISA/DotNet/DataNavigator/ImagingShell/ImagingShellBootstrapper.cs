//-----------------------------------------------------------------------
// <copyright file="ImagingShellBootstrapper.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace ImagingShell
{
    using System.Configuration;
    using System.Windows;
    using ImagingClient.Infrastructure;
    using ImagingClient.Infrastructure.Views;
    using ImagingClient.Infrastructure.User.Model;
    using log4net;
    using Microsoft.Practices.Prism.Modularity;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Prism.UnityExtensions;
    using Microsoft.Practices.ServiceLocation;
    using Microsoft.Practices.Unity;
    using Microsoft.Practices.Unity.Configuration;
    using ImagingShell.Views;

    /// <summary>
    /// Prism Unity Bootstrapper for the Imaging Shell
    /// </summary>
    public class ImagingShellBootstrapper : UnityBootstrapper
    {
        /// <summary>
        /// Logger for the bootstrapper
        /// </summary>
        private static ILog logger = LogManager.GetLogger(typeof(ImagingShellBootstrapper));

        /// <summary>
        /// Run the bootstrapper process.
        /// </summary>
        /// <param name="runWithDefaultConfiguration">
        /// If <see langword="true"/>, registers default Composite Application Library services in the container. This is the default behavior.
        /// </param>
        public override void Run(bool runWithDefaultConfiguration)
        {
            base.Run(runWithDefaultConfiguration);
            Application.Current.MainWindow.Show();
            logger.Debug("Requesting login...");
            LoginWindow loginWindow = ServiceLocator.Current.GetInstance<LoginWindow>();
            loginWindow.Owner = (Window)Shell;
            loginWindow.ShowDialog();

            // navigates to the Data Navigation View if login is successful. 
            if (UserContext.IsLoginSuccessful)
            {
                IRegionManager manager = ServiceLocator.Current.GetInstance<IRegionManager>();
                manager.RequestNavigate(RegionNames.MainRegion, "DataNavigator.DataNavigationView");
            }
        }

        /// <summary>
        /// Creates the shell or main window of the application.
        /// </summary>
        /// <returns>
        /// The shell of the application.
        /// </returns>
        protected override DependencyObject CreateShell()
        {
            return Container.Resolve<MainWindow>();
        }

        /// <summary>
        /// Creates the <see cref="T:Microsoft.Practices.Prism.Modularity.IModuleCatalog"/> used by Prism.
        /// </summary>
        /// <returns>The <see cref="T:Microsoft.Practices.Prism.Modularity.IModuleCatalog"/> used by Prism.</returns>
        protected override IModuleCatalog CreateModuleCatalog()
        {
            return new DirectoryModuleCatalog() { ModulePath = @"." };
        }

        /// <summary>
        /// Configures the Microsoft.Practices.Unity.IUnityContainer from the unity configuration section in the app.config
        /// </summary>
        protected override void ConfigureContainer()
        {
            base.ConfigureContainer();
            UnityConfigurationSection unitySection = (UnityConfigurationSection)ConfigurationManager.GetSection("unity");
            if (unitySection != null)
            {
                this.Container.LoadConfiguration(unitySection);
            }
        }

        /// <summary>
        /// Initializes the shell.
        /// </summary>
        protected override void InitializeShell()
        {
            base.InitializeShell();
            Application.Current.MainWindow = (Window)Shell;
            IRegionManager regionManager = ServiceLocator.Current.GetInstance<IRegionManager>();
            regionManager.RegisterViewWithRegion(RegionNames.MainRegion, typeof(ModulesView));
        }
    }
}
