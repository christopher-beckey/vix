//-----------------------------------------------------------------------
// <copyright file="DataNavigationView.xaml.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Views
{
    using System.ComponentModel;
    using System.Windows.Controls;
    using System.Windows.Data;
    using ImagingClient.Infrastructure.Prism.Mvvm;
    using VistA.Imaging.DataNavigator.Model;
    using VistA.Imaging.DataNavigator.ViewModels;

    /// <summary>
    /// Interaction logic for FilemanEntryView.xaml
    /// </summary>
    public partial class FilemanEntryView : View<HierarchicalEntryViewModel>
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanEntryView"/> class.
        /// </summary>
        public FilemanEntryView()
        {
            InitializeComponent();
        }

        /// <summary>
        /// Handles the Sorting event of the EntryGrid control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.Controls.DataGridSortingEventArgs"/> instance containing the event data.</param>
        private void EntryGrid_Sorting(object sender, DataGridSortingEventArgs e)
        {
            DataGridColumn column = e.Column;

            if (!e.Column.Header.Equals("#"))
            {
                e.Handled = false;
                return;
            }

            // prevent the built-in sort from sorting
            e.Handled = true;

            // set the sort order on the column
            column.SortDirection = (column.SortDirection != ListSortDirection.Ascending)
                ? ListSortDirection.Ascending : ListSortDirection.Descending;

            // use a ListCollectionView to do the sort.
            ListCollectionView lcv = (ListCollectionView)CollectionViewSource.GetDefaultView((sender as DataGrid).ItemsSource);

            // apply the sort
            lcv.CustomSort = new FilemanFieldValueComparer(column.SortDirection);
        }
    }
}
