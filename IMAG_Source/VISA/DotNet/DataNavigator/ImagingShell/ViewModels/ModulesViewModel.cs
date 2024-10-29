//-----------------------------------------------------------------------
// <copyright file="ModulesViewModel.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace ImagingShell.ViewModels
{
    using System;
    using System.Linq;
    using ImagingClient.Infrastructure.ViewModels;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Prism.Modularity;
    using ImagingClient.Infrastructure.Prism;
    using System.Collections.Generic;
    using Microsoft.Practices.ServiceLocation;
    using ImagingClient.Infrastructure.Prism.Modularity;
    using ImagingClient.Infrastructure.Prism.Mvvm;
    using Microsoft.Practices.Unity;

    /// <summary>
    /// TODO: Provide summary section in the documentation header.
    /// </summary>
    public class ModulesViewModel : ViewModel
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ModulesViewModel"/> class.
        /// </summary>
        public ModulesViewModel()
        {

        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ModulesViewModel"/> class.
        /// </summary>
        /// <param name="regionManager">The region manager.</param>
        [InjectionConstructor]
        public ModulesViewModel(IRegionManager regionManager)
            : base(regionManager)
        {

        }
    }
}
