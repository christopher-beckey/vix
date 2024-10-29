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
using VistA.Imaging.Telepathology.Worklist.ViewModel;
using VistA.Imaging.Telepathology.Common.Model;

namespace VistA.Imaging.Telepathology.Worklist.Views
{
    /// <summary>
    /// Interaction logic for CaseOrganTissueView.xaml
    /// </summary>
    public partial class ReportCodingView : UserControl
    {
        private TreeViewItem selectedItem = null;

        public ReportCodingView()
        {
            InitializeComponent();
        }

        private void TreeView_SelectedItemChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
        {
            if (snomedTree.SelectedItem == null)
            {
                ((ReportCodingViewModel)this.DataContext).SnomedTreeSelectedItem = null;
                ((ReportCodingViewModel)this.DataContext).SnomedTreeSelectedItemParent = null;
                return;
            }

            string type = string.Empty;
            
            if (!(snomedTree.SelectedItem is TreeGroup))
            {
                type = string.Empty;
                //((ReportCodingViewModel)this.DataContext).CanAddSnomedItem = false;
            }
            else
            {
                if ((snomedTree.SelectedItem as TreeGroup).GroupName == "Morphologies")
                {
                    type = "Morphology";
                }
                else if ((snomedTree.SelectedItem as TreeGroup).GroupName == "Etiologies")
                {
                    type = "Etiology";
                }
                else if ((snomedTree.SelectedItem as TreeGroup).GroupName == "Functions")
                {
                    type = "Function";
                }
                else if ((snomedTree.SelectedItem as TreeGroup).GroupName == "Procedures")
                {
                    type = "Procedure";
                }
                else if ((snomedTree.SelectedItem as TreeGroup).GroupName == "Diseases")
                {
                    type = "Disease";
                }

                //((ReportCodingViewModel)this.DataContext).CanAddSnomedItem = true;
            }

            // update view model
            ((ReportCodingViewModel)this.DataContext).SelectedItemType = type;
            ((ReportCodingViewModel)this.DataContext).SnomedTreeSelectedItem = snomedTree.SelectedItem;
            ((ReportCodingViewModel)this.DataContext).SnomedSearchText = string.Empty;
            ((ReportCodingViewModel)this.DataContext).SearchItems.Clear();
            ((ReportCodingViewModel)this.DataContext).SelectedSearchItem = null;
        }

        private void TreeView_Selected(object sender, RoutedEventArgs e)
        {
            // get the parent of the selected item
            selectedItem = e.OriginalSource as TreeViewItem;
            if (selectedItem != null)
            {
                if (selectedItem.DataContext is TreeGroup)
                {
                    ItemsControl parent = ItemsControl.ItemsControlFromItemContainer(selectedItem);
                    if (parent != null)
                    {
                        ((ReportCodingViewModel)this.DataContext).SnomedTreeSelectedItemParent = (parent as TreeViewItem).DataContext;
                        //MessageBox.Show(((CaseOrganTissueViewModel)this.DataContext).SnomedTreeSelectedItemParent.ToString());
                    }
                }
            }
        }

        private void ClearSelection_Click(object sender, RoutedEventArgs e)
        {
            if (snomedTree.SelectedItem != null)
            {
                selectedItem.IsSelected = false;
            }

            // enable user to add organ tissue
            ((ReportCodingViewModel)this.DataContext).SelectedItemType = "Organ/Tissue";
            ((ReportCodingViewModel)this.DataContext).SnomedSearchText = string.Empty;
            ((ReportCodingViewModel)this.DataContext).SearchItems.Clear();
            ((ReportCodingViewModel)this.DataContext).SelectedSearchItem = null;
            //((ReportCodingViewModel)this.DataContext).CanAddSnomedItem = true;
        }
    }
}
