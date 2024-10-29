//-----------------------------------------------------------------------
// <copyright file="BreadcrumbView.xaml.cs" company="Department of Veterans Affairs">
//     Copyright (c) Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.Viewer.Views
{
    using Microsoft.Practices.ServiceLocation;
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
        public BreadcrumbView(BreadcrumbViewModel viewModel)
            : base(viewModel)
        {
            InitializeComponent();
        }

        /// <summary>
        /// Handles the Click event of the logButton control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.RoutedEventArgs"/> instance containing the event data.</param>
        private void LogButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            LogView logView = ServiceLocator.Current.GetInstance<LogView>();
            logView.LayoutRoot.IsOpen = true;
        }
    }
}
