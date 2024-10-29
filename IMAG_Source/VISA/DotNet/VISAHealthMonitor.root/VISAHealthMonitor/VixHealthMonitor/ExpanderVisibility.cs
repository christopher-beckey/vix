using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;

namespace VixHealthMonitor
{
    public class ExpanderVisibility
    {
        public Visibility Visibility { get; set; }
        public bool Expanded { get; set; }

        public ExpanderVisibility(bool visible)
        {
            this.Expanded = visible;
            this.Visibility = (visible == true ? Visibility.Visible :  Visibility.Collapsed);
        }
    }
}
