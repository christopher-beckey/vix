// -----------------------------------------------------------------------
// <copyright file="StringToBoolConverter.cs" company="Patriot Technologies">
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
    using System.ComponentModel;
    using System.Globalization;

    [ValueConversion(typeof(string), typeof(bool))]
    public class StringToBoolConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            string stringValue = (string)value;

            if ((stringValue.ToLower() == "yes") || (stringValue.ToLower() == "true"))
                return true;
            return false;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            bool boolValue = (bool)value;

            if (boolValue)
                return "YES";
            
            return "NO";
        }
    }
}
