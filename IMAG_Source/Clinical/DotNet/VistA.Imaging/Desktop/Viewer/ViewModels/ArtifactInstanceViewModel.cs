// -----------------------------------------------------------------------
// <copyright file="ArtifactInstanceViewModel.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Viewer.ViewModels
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Unity;
    using VistA.Imaging.Prism;
    using VistA.Imaging.Viewer.Models;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class ArtifactInstanceViewModel : ViewModel
    {
        #region Constructor(s)

        /// <summary>
        /// Initializes a new instance of the <see cref="ArtifactInstanceViewModel"/> class.
        /// </summary>
        public ArtifactInstanceViewModel()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ArtifactInstanceViewModel"/> class.
        /// </summary>
        /// <param name="regionManager">The region manager.</param>
        [InjectionConstructor]
        public ArtifactInstanceViewModel(IRegionManager regionManager)
            : base(regionManager)
        {
        }

        #endregion

        /// <summary>
        /// Gets or sets the artifact instance.
        /// </summary>
        public ArtifactInstance ArtifactInstance { get; set; }

        /// <summary>
        /// Gets or sets the bytes received.
        /// </summary>
        public int BytesReceived { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether the download is complete.
        /// </summary>
        public bool IsDownloadComplete { get; set; }
    }
}
