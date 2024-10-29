namespace VistA.Imaging.Telepathology.Worklist.Behaviors
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Windows.Interactivity;
    using System.Windows.Controls;
    using System.Collections.Specialized;
    using System.Windows;
    using System.Collections;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class ListViewMultiSelectBehavior : Behavior<ListView>
    {
        private ListView ListViewCtrl
        {
            get
            {
                return AssociatedObject as ListView;
            }
        }

        public INotifyCollectionChanged SelectedItems
        {
            get { return (INotifyCollectionChanged)GetValue(SelectedItemsProperty); }
            set { SetValue(SelectedItemsProperty, value); }
        }

        // Using a DependencyProperty as the backing store for SelectedItemsProperty.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty SelectedItemsProperty =
            DependencyProperty.Register("SelectedItems", typeof(INotifyCollectionChanged), typeof(ListViewMultiSelectBehavior), new PropertyMetadata(OnSelectedItemsPropertyChanged));


        private static void OnSelectedItemsPropertyChanged(DependencyObject target, DependencyPropertyChangedEventArgs args)
        {
            var collection = args.NewValue as INotifyCollectionChanged;
            if (collection != null)
            {
                collection.CollectionChanged += ((ListViewMultiSelectBehavior)target).ContextSelectedItems_CollectionChanged;
            }
        }

        protected override void OnAttached()
        {
            base.OnAttached();

            //ListViewCtrl.SelectedItems.CollectionChanged += GridSelectedItems_CollectionChanged;
            ListViewCtrl.SelectionChanged += GridSelectedItems_CollectionChanged;
        }

        void ContextSelectedItems_CollectionChanged(object sender, NotifyCollectionChangedEventArgs e)
        {
            UnsubscribeFromEvents();

            Transfer(SelectedItems as IList, ListViewCtrl.SelectedItems);

            SubscribeToEvents();
        }

        //void GridSelectedItems_CollectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e)
        void GridSelectedItems_CollectionChanged(object sender, SelectionChangedEventArgs e)
        {
            UnsubscribeFromEvents();

            Transfer(ListViewCtrl.SelectedItems, SelectedItems as IList);

            SubscribeToEvents();
        }

        private void SubscribeToEvents()
        {
            //ListViewCtrl.SelectedItems.CollectionChanged += GridSelectedItems_CollectionChanged;
            ListViewCtrl.SelectionChanged += GridSelectedItems_CollectionChanged;

            if (SelectedItems != null)
            {
                SelectedItems.CollectionChanged += ContextSelectedItems_CollectionChanged;
            }
        }

        private void UnsubscribeFromEvents()
        {
            //ListViewCtrl.SelectedItems.CollectionChanged -= GridSelectedItems_CollectionChanged;
            ListViewCtrl.SelectionChanged += GridSelectedItems_CollectionChanged;

            if (SelectedItems != null)
            {
                SelectedItems.CollectionChanged -= ContextSelectedItems_CollectionChanged;
            }
        }

        public static void Transfer(IList source, IList target)
        {
            if (source == null || target == null)
                return;

            target.Clear();

            foreach (var o in source)
            {
                target.Add(o);
            }
        }
    }
}
