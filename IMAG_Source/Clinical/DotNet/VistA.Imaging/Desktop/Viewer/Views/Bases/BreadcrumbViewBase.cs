// <copyright file="BreadcrumbViewBase.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 03/21/2012
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
namespace VistA.Imaging.Viewer.Views.Bases
{
    using VistA.Imaging.Prism.Views;
    using VistA.Imaging.Viewer.ViewModels;

    /// <summary>
    /// Base class for BreadCrumbView
    /// </summary>
    public class BreadcrumbViewBase : UserControlView<BreadcrumbViewModel>
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="BreadcrumbViewBase"/> class.
        /// </summary>
        public BreadcrumbViewBase()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="BreadcrumbViewBase"/> class.
        /// </summary>
        /// <param name="viewModel">The view model.</param>
        public BreadcrumbViewBase(BreadcrumbViewModel viewModel)
            : base(viewModel)
        {
        }
    }
}
