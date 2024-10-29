// -----------------------------------------------------------------------
// <copyright file="MultiBoolToVisibility.cs" company="Patriot Technologies">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Worklist.Converters
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Windows.Data;
    using System.Windows;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class MultiBoolToVisibilityConverter : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType,
          object parameter, System.Globalization.CultureInfo culture)
        {
            try
            {
                if ((values == null) || (values.Length != 2)) return Visibility.Hidden;

                bool param = bool.Parse(parameter as string);
                bool val = ((bool)values[0]) && ((bool)values[1]);

                return val == param ? Visibility.Visible : Visibility.Hidden;
            }
            catch (Exception)
            {
                return Visibility.Hidden;
            }
        }

        public object[] ConvertBack(object values, Type[] targetType,
          object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotImplementedException();
        }
    }
}
