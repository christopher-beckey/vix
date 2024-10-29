// -----------------------------------------------------------------------
// <copyright file="WindowState.cs" company="Patriot Technologies">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Worklist.Preferences
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Windows;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class WindowSettings
    {
        public double Left { get; set; }

        public double Top { get; set; }

        public double Width { get; set; }

        public double Height { get; set; }

        public bool IsMaximized { get; set; }

        public string Label { get; set; }

        public void Save(Window window)
        {
            if (window.WindowState == WindowState.Maximized)
            {
                this.Left = window.RestoreBounds.Left;
                this.Top = window.RestoreBounds.Top;
                this.Width = window.RestoreBounds.Width;
                this.Height = window.RestoreBounds.Height;
                this.IsMaximized = true;
            }
            else
            {
                this.Left = window.Left;
                this.Top = window.Top;
                this.Width = window.Width;
                this.Height = window.Height;
                this.IsMaximized = false;
            }
        }

        public void Restore(Window window)
        {
            window.Left = this.Left;
            window.Top = this.Top;
            window.Width = this.Width;
            window.Height = this.Height;

            if (this.IsMaximized)
            {
                window.WindowState = WindowState.Maximized;
            }
        }
    }
}
