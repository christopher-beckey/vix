// -----------------------------------------------------------------------
// <copyright file="LaunchViewModel.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.ViewModels
{
    using ImagingClient.Infrastructure;
    using ImagingClient.Infrastructure.Prism.Mvvm;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Unity;
    using System.Diagnostics.Contracts;
    using System;

    /// <summary>
    /// This class contains properties to which the LaunchView binds.
    /// </summary>
    public class LaunchViewModel : ViewModel
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="LaunchViewModel"/> class.
        /// </summary>
        public LaunchViewModel()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="LaunchViewModel"/> class.
        /// </summary>
        /// <param name="regionManager">The IRegionManager.</param>
        [InjectionConstructor]
        public LaunchViewModel(IRegionManager regionManager)
            : base(regionManager)
        {
            Contract.Requires<ArgumentNullException>(regionManager != null);
            this.LaunchCommand = new DelegateCommand(() => this.Launch());
        }

        #region Commands

        /// <summary>
        /// Gets the launch command.
        /// </summary>
        public DelegateCommand LaunchCommand { get; private set; }

        #endregion

        /// <summary>
        /// Launches this instance.
        /// </summary>
        private void Launch()
        {
            this.RegionManager.RequestNavigate(RegionNames.MainRegion, "DataNavigator.DataNavigationView");
        }
    }
}