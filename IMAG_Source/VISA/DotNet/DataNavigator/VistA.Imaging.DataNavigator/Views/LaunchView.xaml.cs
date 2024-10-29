//-----------------------------------------------------------------------
// <copyright file="LaunchView.xaml.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Views
{
    using ImagingClient.Infrastructure.Prism.Mvvm;
    using VistA.Imaging.DataNavigator.ViewModels;

    /// <summary>
    /// Interaction logic for LaunchView.xaml
    /// </summary>
    public partial class LaunchView : View<LaunchViewModel>
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="LaunchView"/> class.
        /// </summary>
        /// <param name="viewModel">The view model.</param>
        public LaunchView(LaunchViewModel viewModel)
            : base(viewModel)
        {
            InitializeComponent();
        }
    }
}
