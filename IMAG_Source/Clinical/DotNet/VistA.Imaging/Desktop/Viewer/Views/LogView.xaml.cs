// -----------------------------------------------------------------------
// <copyright file="LogView.xaml.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 03/26/2012
//   Site Name:  Washington OI Field Office, Silver Spring, MD
//   Developer: vhaiswwillil
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
//         ;; is considered to   be a violation of US Federal Statutes.
//         ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.Viewer.Views
{
    using Microsoft.Practices.Unity;
    using VistA.Imaging.Viewer.ViewModels;
    using VistA.Imaging.Viewer.Views.Bases;

    /// <summary>
    /// Interaction logic for LogView.xaml
    /// </summary>
    public partial class LogView : LogViewBase
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="LogView"/> class.
        /// </summary>
        public LogView()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="LogView"/> class.
        /// </summary>
        /// <param name="viewModel">The view model.</param>
        [InjectionConstructor]
        public LogView(LogViewModel viewModel)
            : base(viewModel)
        {
            InitializeComponent();
        }
    }
}
