using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Windows.Data;

namespace VISAHealthMonitorCommon
{
    delegate void SetSourceDelegate(object source);
    delegate void ClearSourceDelegate();

    public class ListViewSortedCollectionViewSource
    {
        public ListSortDirection ListSortDirection { get; set; }
        public CollectionViewSource Sources { get; set; }
        private string currentSortColumn = null;

        public ListViewSortedCollectionViewSource()
        {
            Sources = new CollectionViewSource();
            ListSortDirection = System.ComponentModel.ListSortDirection.Ascending;
        }

        public void ClearSource()
        {
            ClearSourceDelegate d = new ClearSourceDelegate(ClearSourceInternal);
            Sources.Dispatcher.Invoke(d, new object[] { });
        }

        private void ClearSourceInternal()
        {
            Sources.Source = null;
        }

        public void Sort(string sortColumn)
        {
            Sources.SortDescriptions.Clear();
            if (currentSortColumn != null)
            {
                // sorting on the same column so change direction
                if (currentSortColumn == sortColumn)
                {
                    if (ListSortDirection == System.ComponentModel.ListSortDirection.Ascending)
                        ListSortDirection = System.ComponentModel.ListSortDirection.Descending;
                    else
                        ListSortDirection = System.ComponentModel.ListSortDirection.Ascending;
                }
            }
            currentSortColumn = sortColumn;
            Sources.SortDescriptions.Add(new SortDescription(sortColumn, ListSortDirection));
        }

        public void SetSource(object source)
        {
            // this is necessary for threading, to invoke the method on the thread this object was created on
            SetSourceDelegate d = new SetSourceDelegate(SetSourceInternal);
            Sources.Dispatcher.Invoke(d, new object[] { source });
            //Sources.Source = source;
        }

        private void SetSourceInternal(object source)
        {
            Sources.Source = source;
        }
    }
}
