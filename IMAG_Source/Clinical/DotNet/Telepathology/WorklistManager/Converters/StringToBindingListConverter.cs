
namespace VistA.Imaging.Telepathology.Worklist.Converters
{
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Globalization;
    using System.Linq;
    using System.Text;
    using System.Text.RegularExpressions;
    using System.Windows.Data;
    using VistA.Imaging.Telepathology.Common.Model;

    [ValueConversion(typeof(string), typeof(BindingList<StringWrapper>))]
    public class StringToBindingListConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            string stringValue = (string)value;
            BindingList<StringWrapper> bindedList = new BindingList<StringWrapper>();
            if ((stringValue == null) || (stringValue == ""))
                return bindedList;
            else
            {
                string[] values = Regex.Split(stringValue, "\r\n");
                foreach (string s in values)
                    if (s != "")
                        bindedList.Add(new StringWrapper() { Value = s });
                return bindedList;
            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            BindingList<StringWrapper> valueList = (BindingList<StringWrapper>)value;
            string valueString = "";

            foreach (StringWrapper s in valueList)
                if ((s.Value != null) || (s.Value != ""))
                    valueString += valueString + s.Value + "\r\n";
            return valueString;
        }
    }
}
