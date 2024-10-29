//-----------------------------------------------------------------------
// <copyright file="DataNavigatorModule.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator
{
    using System;
    using System.Configuration;
    using System.Diagnostics.Contracts;
    using System.Runtime.Caching;
    using ImagingClient.Infrastructure.Configuration;
    using ImagingClient.Infrastructure.Prism.Modularity;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Unity;
    using VistA.Imaging.DataNavigator.Repositories;
    using VistA.Imaging.DataNavigator.ViewModels;
    using VistA.Imaging.DataNavigator.ViewModels.Factories;
    using VistA.Imaging.DataNavigator.Views;
    using VistaCommon;
    using VistaCommon.gov.va.med;

    /// <summary>
    /// TODO: Provide summary section in the documentation header.
    /// </summary>
    public class DataNavigatorModule : UnityModule
    {
        private static Uri dataDictionaryServicesRootUrl;

        /// <summary>
        /// Initializes a new instance of the <see cref="DataNavigatorModule"/> class.
        /// </summary>
        /// <param name="container">The IUnityContainer container of the application</param>
        /// <param name="regionManager">The Region Manager of the application</param>
        public DataNavigatorModule(IUnityContainer container, IRegionManager regionManager)
            : base(container, regionManager)
        {
            Contract.Requires<ArgumentNullException>(container != null);
            Contract.Requires<ArgumentNullException>(regionManager != null);
            RegionManager.RegisterViewWithRegion("Modules", typeof(LaunchView));
        }

        public static Uri DataDictionaryServicesRootUrl
        {
            get
            {
                if (dataDictionaryServicesRootUrl == null)
                {
                    Configuration config = AssemblyConfigurationManager.GetConfiguration(typeof(DataNavigatorModule).Assembly);
                    if (config != null)
                    {
                        KeyValueConfigurationElement urlElement = config.AppSettings.Settings["DataDictionaryServicesUrl"];
                        string url;
                        if (urlElement == null || string.IsNullOrWhiteSpace(urlElement.Value))
                        {
                            SiteAddress address = SiteServiceHelper.GetSite(ConfigurationManager.AppSettings["SiteId"]);
                            url = "http://" + address.VixHost + ":" + address.VixPort + "/dd/services";
                        }
                        else
                        {
                            url = urlElement.Value;
                        }

                        dataDictionaryServicesRootUrl = new Uri(url);
                    }
                }

                return dataDictionaryServicesRootUrl;
            }
        }

        /// <summary>
        /// Initializes the module
        /// </summary>
        public override void Initialize()
        {
            base.Initialize();

            Container.RegisterInstance<ObjectCache>(new MemoryCache("DataNavigator Cache"));

            // Repositories
            Container.RegisterType<IFilemanFileRepository, FilemanFileRepository>(new ContainerControlledLifetimeManager());
            Container.RegisterType<IFilemanEntryRepository, FilemanEntryRepository>(new ContainerControlledLifetimeManager());

            // Factories
            Container.RegisterType<IHierarchicalEntryViewModelFactory, HierarchicalEntryViewModelFactory>(
                new ContainerControlledLifetimeManager());
            Container.RegisterType<IHierarchicalEntryLoadViewModelFactory, HierarchicalEntryLoadViewModelFactory>(
                new ContainerControlledLifetimeManager());

            // ViewModels
            Container.RegisterType<LaunchViewModel>(new ContainerControlledLifetimeManager());
            Container.RegisterType<DataNavigationViewModel>(new ContainerControlledLifetimeManager());

            // Views
            Container.RegisterType<object, LaunchView>("DataNavigator.LaunchView", new ContainerControlledLifetimeManager());
            Container.RegisterType<object, DataNavigationView>(
                "DataNavigator.DataNavigationView",
                new ContainerControlledLifetimeManager());
        }
    }
}
