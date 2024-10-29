//-----------------------------------------------------------------------
// <copyright file="ArtifactSelectionView.xaml.cs" company="Department of Veterans Affairs">
//     Copyright (c) Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.Viewer.Views
{
    using Microsoft.Practices.Unity;
    using VistA.Imaging.Viewer.ViewModels;
    using VistA.Imaging.Viewer.Views.Bases;
    using System.Windows;
    using VistA.Imaging.Viewer.Models;
    using System;

    /// <summary>
    /// The main view
    /// </summary>
    public partial class ArtifactSelectionView : ArtifactSelectionViewBase
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ArtifactSelectionView"/> class.
        /// </summary>
        public ArtifactSelectionView()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ArtifactSelectionView"/> class.
        /// </summary>
        /// <param name="viewModel">The view model.</param>
        public ArtifactSelectionView(ArtifactSelectionViewModel viewModel)
            : base(viewModel)
        {
            InitializeComponent();
        }

        private void ArtifactSet_SelectedItemChanged(object sender, System.Windows.RoutedPropertyChangedEventArgs<object> e)
        {
            if (abstractSelectionTreeView.SelectedItem == null)
            {
                ArtifactThumbnailsViewer.Visibility = Visibility.Collapsed;
                SelectArtifactTextBoxBorder.Visibility = Visibility.Visible;
            }
            else
            {
                ArtifactThumbnailsViewer.Visibility = Visibility.Visible;
                SelectArtifactTextBoxBorder.Visibility = Visibility.Collapsed;
                //figure out a way to handle the situation where no artifacts exist. 
                this.ViewModel.UpdateThumbnailViewer((ArtifactSet)abstractSelectionTreeView.SelectedItem);
            }      
        }
    }
}
