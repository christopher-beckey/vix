//-----------------------------------------------------------------------
// <copyright file="UnityModule.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace ImagingClient.Infrastructure.Prism.Modularity
{
    using System;
    using System.Configuration;
    using System.IO;
    using System.Linq;
    using Microsoft.Practices.Prism.Modularity;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Unity;
    using Microsoft.Practices.Unity.Configuration;
    using Microsoft.Practices.ServiceLocation;
    using System.Diagnostics.Contracts;
    using ImagingClient.Infrastructure.Configuration;

    /// <summary>
    /// TODO: Provide summary section in the documentation header.
    /// </summary>
    public abstract class UnityModule : IModule
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="UnityModule"/> class.
        /// </summary>
        public UnityModule(IUnityContainer container, IRegionManager regionManager)
        {
            Contract.Requires<ArgumentNullException>(container != null);
            Contract.Requires<ArgumentNullException>(regionManager != null);
            this.Container = container;
            this.RegionManager = regionManager;
            this.ModuleName = this.GetType().Assembly.GetName().Name;
        }

        #region Public Properties

        /// <summary>
        /// Gets the name of the module
        /// </summary>
        public virtual string ModuleName { get; protected set; }

        /// <summary>
        /// Gets or sets the configuration for the module
        /// </summary>
        public virtual Configuration Configuration { get; protected set; }

        #endregion

        #region Protected Properties

        /// <summary>
        /// Gets or sets the main unity container for the application
        /// </summary>
        protected virtual IUnityContainer Container { get; set; }

        /// <summary>
        /// Gets or sets the region manager.
        /// </summary>
        public IRegionManager RegionManager { get; set; }

        #endregion

        /// <summary>
        /// Initializes the module
        /// </summary>
        public virtual void Initialize()
        {
            this.Container.RegisterInstance(this.GetType(), this);
            this.Configuration = AssemblyConfigurationManager.GetConfiguration(this.GetType());
            if (this.Configuration != null)
            {
                UnityConfigurationSection unitySection = (UnityConfigurationSection)this.Configuration.GetSection("unity");
                if (unitySection != null)
                {
                    this.Container.LoadConfiguration(unitySection);
                }
            }
        }
    }
}
