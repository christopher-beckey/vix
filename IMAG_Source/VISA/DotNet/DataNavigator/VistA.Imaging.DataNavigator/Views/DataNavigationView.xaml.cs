//-----------------------------------------------------------------------
// <copyright file="DataNavigationView.xaml.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Views
{
    using System.ComponentModel;
    using System.Windows;
    using System.Windows.Controls;
    using System.Windows.Data;
    using ImagingClient.Infrastructure.Prism.Mvvm;
    using VistA.Imaging.DataNavigator.Model;
    using VistA.Imaging.DataNavigator.ViewModels;

    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class DataNavigationView : View<DataNavigationViewModel>
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="DataNavigationView"/> class.
        /// </summary>
        /// <param name="viewModel">The view model.</param>
        public DataNavigationView(DataNavigationViewModel viewModel)
            : base(viewModel)
        {
            InitializeComponent();
        }

        /// <summary>
        /// Handles the LostFocus event of the ComboBox control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.RoutedEventArgs"/> instance containing the event data.</param>
        private void ComboBox_LostFocus(object sender, RoutedEventArgs e)
        {
            if (ViewModel.CheckFileCommand.CanExecute())
            {
                ViewModel.CheckFileCommand.Execute();
            }
        }

        /// <summary>
        /// Handles the KeyUp event of the ComboBox control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.Input.KeyEventArgs"/> instance containing the event data.</param>
        private void ComboBox_KeyUp(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (e.Key == System.Windows.Input.Key.Enter)
            {
                if (ViewModel.CheckFileCommand.CanExecute())
                {
                    ViewModel.CheckFileCommand.Execute();
                }

                e.Handled = true;
            }
        }

        /// <summary>
        /// Handles the KeyUp event of the SearchTextBox control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.Input.KeyEventArgs"/> instance containing the event data.</param>
        private void SearchTextBox_KeyUp(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (e.Key == System.Windows.Input.Key.Enter)
            {
                SearchButton.Focus();
                if (ViewModel.SearchCommand.CanExecute())
                {
                    ViewModel.SearchCommand.Execute();
                }

                e.Handled = true;
            }
        }

        /// <summary>
        /// Handles the SelectedItemChanged event of the treeView control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.RoutedPropertyChangedEventArgs&lt;System.Object&gt;"/> instance containing the event data.</param>
        private void treeView_SelectedItemChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
        {
            ViewModel.SelectedNode = e.NewValue as TreeNodeViewModel;
            ScrollViewer sv = EntryItemsControl.Template.FindName("EntryItemsControlScrollViewer", EntryItemsControl) as ScrollViewer;
            if (sv != null)
            {
                sv.ScrollToBottom();
            }
        }
    }
}
