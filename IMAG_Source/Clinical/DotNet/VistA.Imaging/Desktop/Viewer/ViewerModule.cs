// -----------------------------------------------------------------------
// <copyright file="ViewerModule.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 11/30/2011
//   Site Name:  Washington OI Field Office, Silver Spring, MD
//   Developer: vhaiswgraver
//   Description: 
//         ;; +--------------------------------------------------------------------+
//         ;; Property of the US Government.
//         ;; No permission to copy or redistribute this software is given.
//         ;; Use of unreleased versions of this software requires the user
//         ;;  to execute a written test agreement with the VistA Imaging
//         ;;  Development Office of the Department of Veterans Affairs,
//         ;;  telephone (301) 734-0100.
//         ;;
//         ;; The Food and Drug Administration classifies this software as
//         ;; a Class II medical device.  As such, it may not be changed
//         ;; in any way.  Modifications to this software may result in an
//         ;; adulterated medical device under 21CFR820, the use of which
//         ;; is considered to be a violation of US Federal Statutes.
//         ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.Viewer
{
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Unity;
    using NLog;
    using VistA.Imaging.DataSources;
    using VistA.Imaging.Facades;
    using VistA.Imaging.Log;
    using VistA.Imaging.Prism.Modularity;
    using VistA.Imaging.Services.SiteService.ImagingExchange;
    using VistA.Imaging.Viewer.ViewModels;
    using VistA.Imaging.Viewer.Views;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class ViewerModule : UnityModule
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ViewerModule"/> class.
        /// </summary>
        /// <param name="container">The application's container.</param>
        /// <param name="regionManager">The application's region manager.</param>
        public ViewerModule(IUnityContainer container, IRegionManager regionManager)
            : base(container, regionManager)
        {
            this.Name = "VistA Imaging Viewer";
        }

        /// <summary>
        /// Initializes the module
        /// </summary>
        public override void Initialize()
        {
            base.Initialize();

            // Creates and configures the in memory logger.
            MemoryTarget target = new MemoryTarget();
            this.Container.RegisterInstance<MemoryTarget>(target);
            NLog.Config.SimpleConfigurator.ConfigureForTargetLogging(target, LogLevel.Debug);
 
            ImagingExchangeSiteServiceSoapClient imagingExchangeSiteService = null;

#if SILVERLIGHT
            imagingExchangeSiteService = new ImagingExchangeSiteServiceSoapClient(
                "ImagingExchangeSiteServiceSoap",
                App.Current.AwivParameters.SiteServiceUrl.ToString());
#else
            imagingExchangeSiteService = new ImagingExchangeSiteServiceSoapClient(
                "ImagingExchangeSiteServiceSoap",
                System.Configuration.ConfigurationManager.AppSettings["SiteService"]);
#endif

            // Register Services
            this.Container.RegisterInstance<ImagingExchangeSiteServiceSoap>(imagingExchangeSiteService);
            this.Container.RegisterInstance<ImagingExchangeSiteServiceSoapClient>(imagingExchangeSiteService);

            // Register DataSources
            this.Container.RegisterType<ISiteConnectionInfoDataSource, SiteConnectionInfoDataSource>(new ContainerControlledLifetimeManager());
            this.Container.RegisterType<IServiceGroupInfoDatasource, ServiceGroupInfoDatasource>(new ContainerControlledLifetimeManager());

            // Register Facades
            this.Container.RegisterType<ISiteConnectionInfoFacade, SiteConnectionInfoFacade>(new ContainerControlledLifetimeManager());
            this.Container.RegisterType<IPatientFacade, PatientFacade>(new ContainerControlledLifetimeManager());

            // Register ViewModels
            this.Container.RegisterType<ArtifactInstanceViewModel, ArtifactInstanceViewModel>(new ContainerControlledLifetimeManager());
            this.Container.RegisterType<ArtifactSelectionViewModel, ArtifactSelectionViewModel>(new ContainerControlledLifetimeManager());
            this.Container.RegisterType<BreadcrumbViewModel, BreadcrumbViewModel>(new ContainerControlledLifetimeManager());
            this.Container.RegisterType<LogViewModel, LogViewModel>(new ContainerControlledLifetimeManager());
       
            // Register Views
            this.Container.RegisterType<object, ArtifactSelectionView>(
                "VistA.Imaging.Viewer.Views.MainView",
                new ContainerControlledLifetimeManager(),
                new InjectionConstructor(new ResolvedParameter<ArtifactSelectionViewModel>()));
            this.Container.RegisterType<object, BreadcrumbView>(
                "VistA.Imaging.Viewer.Views.BreadcrumbView",
                new ContainerControlledLifetimeManager(),
                new InjectionConstructor(new ResolvedParameter<BreadcrumbViewModel>()));
            this.Container.RegisterType<object, LogView>(
                "VistA.Imaging.Viewer.Views.LogView",
                new ContainerControlledLifetimeManager(),
                new InjectionConstructor(new ResolvedParameter<LogViewModel>()));

            // Register starting views with regions
            this.RegionManager.RegisterViewWithRegion("MainRegion", typeof(ArtifactSelectionView));
            this.RegionManager.RegisterViewWithRegion("HeaderRegion", typeof(BreadcrumbView));
        }
    }
}
