// -----------------------------------------------------------------------
// <copyright file="BreadcrumbViewModel.cs" company="Department of Veterans Affairs">
//     Copyright (c) Department of Veterans Affairs. All rights reserved.
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.Viewer.ViewModels
{
    using System.Collections.ObjectModel;
    using Microsoft.Practices.Prism.Regions;
    using VistA.Imaging.Models;
    using VistA.Imaging.Prism;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class BreadcrumbViewModel : ViewModel
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="BreadcrumbViewModel"/> class.
        /// </summary>
        public BreadcrumbViewModel()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="BreadcrumbViewModel"/> class.
        /// </summary>
        /// <param name="regionManager">The region manager.</param>
        public BreadcrumbViewModel(IRegionManager regionManager)
            : base(regionManager)
        {
            this.Trail = new ObservableCollection<Breadcrumb>();
        }

        /// <summary>
        /// Gets the breadcrumb trail.
        /// </summary>
        public ObservableCollection<Breadcrumb> Trail { get; private set; }

    }
}
