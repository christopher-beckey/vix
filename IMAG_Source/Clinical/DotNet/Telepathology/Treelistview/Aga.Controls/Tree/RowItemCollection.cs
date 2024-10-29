using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Data;
using System.ComponentModel;

namespace Aga.Controls.Tree
{
    public delegate int CompareDelegate(TreeNode x, TreeNode y, string sortColumn);

    public class RowItemCollection
    {
        internal class Comparer : IComparer<TreeNode>
        {
            private readonly CompareDelegate _delegate;
            private ListSortDirection sortDir { get; set; }
            private string sortColumn { get; set; }

            public Comparer(CompareDelegate compareDelegate, string sortColumn, ListSortDirection sortDir)
            {
                this._delegate = compareDelegate;
                this.sortDir = sortDir;
                this.sortColumn = sortColumn;
            }

            public int Compare(TreeNode o1, TreeNode o2)
            {
                if (o1.Parent == o2.Parent)
                {
                    return (sortDir == ListSortDirection.Ascending) ? _delegate(o1, o2, sortColumn) : -_delegate(o1, o2, sortColumn);
                }
                else if (o1 == o2.Parent)
                {
                    return -1;
                }
                else if (o2 == o1.Parent)
                {
                    return 1;
                }

                return 0;
            }
        } 

        public RowItemCollection()
        {
            ObservableRowItems = new ObservableCollectionAdv<TreeNode>();
        }

        ObservableCollectionAdv<TreeNode> _observableRowItems = null;
        public ObservableCollectionAdv<TreeNode> ObservableRowItems
        {
            get
            {
                return this._observableRowItems;
            }

            set
            {
                this._observableRowItems = value;
                _rowItemsSource = new CollectionViewSource();
                _rowItemsSource.Source = this._observableRowItems;
            }
        }

        CollectionViewSource _rowItemsSource;
        public ListCollectionView RowItemsView
        {
            get
            {
                return (ListCollectionView)_rowItemsSource.View;
            }
        }

        public void Sort(CompareDelegate compareDelegate, string sortColumn, ListSortDirection sortDir)
        {
            var comparision = new Comparer(compareDelegate, sortColumn, sortDir);

            List<TreeNode> sorted = _observableRowItems.OrderBy(x => x, comparision).ToList();

            for (int i = 0; i < sorted.Count(); i++)
                _observableRowItems.Move(_observableRowItems.IndexOf(sorted[i]), i);
        }

        //public void Sort(IComparer<TreeNode> comparer)
        //{
        //    for (int i = _observableRowItems.Count - 1; i >= 0; i--)
        //    {
        //        for (int j = 1; j <= i; j++)
        //        {
        //            TreeNode o1 = _observableRowItems[j - 1];
        //            TreeNode o2 = _observableRowItems[j];

        //            if (Sort(o2, o1, comparer) > 0)
        //            {
        //                _observableRowItems.Remove(o1);
        //                _observableRowItems.Insert(j, o1);
        //            }
        //        }
        //    }
        //}
    }
}
