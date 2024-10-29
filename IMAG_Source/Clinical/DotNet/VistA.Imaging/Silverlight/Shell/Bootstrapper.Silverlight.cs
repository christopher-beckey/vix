//-----------------------------------------------------------------------
// <copyright file="Bootstrapper.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.Shell
{
    using System.Configuration;
    using System.Windows;
    using Microsoft.Practices.Prism.Modularity;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Prism.UnityExtensions;
    using Microsoft.Practices.ServiceLocation;
    using Microsoft.Practices.Unity;
    using System.Windows.Controls;
    using System;

    /// <summary>
    /// Prism Unity Bootstrapper for the Imaging Shell
    /// </summary>
    public class Bootstrapper : UnityBootstrapper
    {
        /// <summary>
        /// Run the bootstrapper process.
        /// </summary>
        /// <param name="runWithDefaultConfiguration">
        /// If <see langword="true"/>, registers default Composite Application Library services in the container. This is the default behavior.
        /// </param>
        public override void Run(bool runWithDefaultConfiguration)
        {
            base.Run(runWithDefaultConfiguration);
        }

        /// <summary>
        /// Creates the shell or main window of the application.
        /// </summary>
        /// <returns>
        /// The shell of the application.
        /// </returns>
        protected override DependencyObject CreateShell()
        {
            return Container.Resolve<Shell>();
        }

        protected override IModuleCatalog CreateModuleCatalog()
        {
            ModuleCatalog catalog = Microsoft.Practices.Prism.Modularity.ModuleCatalog.CreateFromXaml(
                new Uri("/VistA.Imaging.Shell;component/ModuleCatalog.xaml", UriKind.Relative)); 
            return catalog;
        }

        /// <summary>
        /// Initializes the shell.
        /// </summary>
        protected override void InitializeShell()
        {
            base.InitializeShell();
            Application.Current.RootVisual = (UserControl)Shell;
            IRegionManager regionManager = ServiceLocator.Current.GetInstance<IRegionManager>();
            //regionManager.RegisterViewWithRegion(RegionNames.MainRegion, typeof(ModulesView));
        }
    }
}
