using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Input;
using System.Windows.Controls;

namespace VISAHealthMonitorCommon
{
    public class SelectedItemChangedBehavior
    {
        public static DependencyProperty SelectedItemChangedProperty =
            DependencyProperty.RegisterAttached("SelectedItemChanged",
            typeof(ICommand),
            typeof(SelectedItemChangedBehavior),
            new UIPropertyMetadata(SelectedItemChangedBehavior.SelectedItemChangedFired));

        public static void SetSelectedItemChanged(DependencyObject target, ICommand value)
        {
            target.SetValue(SelectedItemChangedBehavior.SelectedItemChangedProperty, value);
        }

        private static void SelectedItemChangedFired(DependencyObject target, DependencyPropertyChangedEventArgs e)
        {
            TreeView control = target as TreeView;
            if (control != null)
            {
                if ((e.NewValue != null) && (e.OldValue == null))
                {
                    control.SelectedItemChanged += SelectedItemChanged;
                }
                else if ((e.NewValue == null) && (e.OldValue != null))
                {
                    control.SelectedItemChanged -= SelectedItemChanged;
                }
            }
        }

        private static void SelectedItemChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
        {
            TreeView control = sender as TreeView;
            ICommand command = (ICommand)control.GetValue(SelectedItemChangedBehavior.SelectedItemChangedProperty);
            object[] arguments = new object[] { control.SelectedItem};
            command.Execute(arguments);
        }
    }

    public class MouseDoubleClickBehavior
    {
        public static DependencyProperty MouseDoubleClickProperty =
            DependencyProperty.RegisterAttached("MouseDoubleClick",
            typeof(ICommand),
            typeof(MouseDoubleClickBehavior),
            new UIPropertyMetadata(MouseDoubleClickBehavior.MouseDoubleClickFired));

        public static void SetMouseDoubleClick(DependencyObject target, ICommand value)
        {
            target.SetValue(MouseDoubleClickBehavior.MouseDoubleClickProperty, value);
        }

        private static void MouseDoubleClickFired(DependencyObject target, DependencyPropertyChangedEventArgs e)
        {
            Control control = target as Control;
            if (control != null)
            {
                if ((e.NewValue != null) && (e.OldValue == null))
                {
                    control.MouseDoubleClick += MouseDoubleClick;
                }
                else if ((e.NewValue == null) && (e.OldValue != null))
                {
                    control.MouseDoubleClick -= MouseDoubleClick;
                }
            }
        }

        private static void MouseDoubleClick(object sender, RoutedEventArgs e)
        {
            Control control = sender as Control;
            ICommand command = (ICommand)control.GetValue(MouseDoubleClickBehavior.MouseDoubleClickProperty);
            object[] arguments = new object[] { };
            command.Execute(arguments);
        }
    }
}
