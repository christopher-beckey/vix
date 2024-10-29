//-----------------------------------------------------------------------
// <copyright file="BreadcrumbView.xaml.cs" company="Department of Veterans Affairs">
//     Copyright (c) Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.Viewer.Views
{
    using Microsoft.Practices.Unity;
    using VistA.Imaging.Viewer.ViewModels;
    using VistA.Imaging.Viewer.Views.Bases;

    /// <summary>
    /// Interaction logic for BreadcrumbView.xaml
    /// </summary>
    public partial class BreadcrumbView : BreadcrumbViewBase
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="BreadcrumbView"/> class.
        /// </summary>
        public BreadcrumbView()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="BreadcrumbView"/> class.
        /// </summary>
        /// <param name="viewModel">The view model.</param>
        [InjectionConstructor]
        public BreadcrumbView(BreadcrumbViewModel viewModel)
            : base(viewModel)
        {
            InitializeComponent();
        }
    }
}
