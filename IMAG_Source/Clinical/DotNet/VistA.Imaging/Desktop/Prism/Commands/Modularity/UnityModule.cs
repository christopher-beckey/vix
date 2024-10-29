//-----------------------------------------------------------------------
// <copyright file="UnityModule.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.Prism.Modularity
{
    using Microsoft.Practices.Prism.Modularity;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Unity;

    /// <summary>
    /// TODO: Provide summary section in the documentation header.
    /// </summary>
    public abstract class UnityModule : IModule
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="UnityModule"/> class.
        /// </summary>
        /// <param name="container">The application's container.</param>
        /// <param name="regionManager">The application's region manager.</param>
        public UnityModule(IUnityContainer container, IRegionManager regionManager)
        {
            this.Container = container;
            this.RegionManager = regionManager;
            this.Name = this.GetType().Assembly.FullName;
        }

        #region Public Properties

        /// <summary>
        /// Gets or sets the name of the module
        /// </summary>
        public virtual string Name { get; protected set; }

        #endregion

        #region Protected Properties

        /// <summary>
        /// Gets or sets the main unity container for the application
        /// </summary>
        protected virtual IUnityContainer Container { get; set; }

        /// <summary>
        /// Gets or sets the region manager.
        /// </summary>
        protected IRegionManager RegionManager { get; set; }

        #endregion

        /// <summary>
        /// Initializes the module
        /// </summary>
        public virtual void Initialize()
        {
            this.Container.RegisterInstance(this.GetType(), this);
        }
    }
}
