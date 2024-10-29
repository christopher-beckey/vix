using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace VistA.Imaging.Telepathology.Common.Controls
{
    /// <summary>
    /// Interaction logic for LogView.xaml
    /// </summary>
    public partial class LogView : UserControl
    {
        private int searchIndex = -1;

        public LogView()
        {
            InitializeComponent();
        }

        private void ViewUserLog_Click(object sender, RoutedEventArgs e)
        {
            (DataContext as LogViewModel).ChangeLogType(false);
            this.txtLog.Background = Brushes.White;
        }

        private void ViewSystemLog_Click(object sender, RoutedEventArgs e)
        {
            (DataContext as LogViewModel).ChangeLogType(true);
            this.txtLog.Background = Brushes.LightGoldenrodYellow;
        }

        private void Find_Click(object sender, RoutedEventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtSearch.Text))
            {
                MessageBox.Show("Please enter some text.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            searchIndex = txtLog.Text.IndexOf(txtSearch.Text, StringComparison.OrdinalIgnoreCase);

            if (searchIndex < 0)
            {
                MessageBox.Show(txtSearch.Text + " could not be found.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                btnFindNext.IsEnabled = false;
                return;
            }

            txtLog.Focus();
            txtLog.Select(searchIndex, txtSearch.Text.Length);

            btnFindNext.IsEnabled = true;
        }

        private void FindNext_Click(object sender, RoutedEventArgs e)
        {
            if (searchIndex < 0)
            {
                MessageBox.Show("Please find the text first.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            searchIndex = txtLog.Text.IndexOf(txtSearch.Text, searchIndex + txtSearch.Text.Length, StringComparison.OrdinalIgnoreCase);

            if (searchIndex < 0)
            {
                searchIndex = txtLog.Text.IndexOf(txtSearch.Text, StringComparison.OrdinalIgnoreCase);
            }

            txtLog.Focus();
            txtLog.Select(searchIndex, txtSearch.Text.Length);
        }

        private void txtSearch_TextChanged(object sender, TextChangedEventArgs e)
        {
            searchIndex = -1;
            btnFindNext.IsEnabled = false;
        }
    }
}
