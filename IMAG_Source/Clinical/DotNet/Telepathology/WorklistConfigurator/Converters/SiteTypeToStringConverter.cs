using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Data;
using VistA.Imaging.Telepathology.Common.Model;
using System.Globalization;

namespace VistA.Imaging.Telepathology.Configurator.Converters
{
    [ValueConversion(typeof(ReadingSiteType), typeof(string))]
    public class SiteTypeToStringConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            ReadingSiteType typeValue = (ReadingSiteType)value;

            string result = "";
            switch (typeValue)
            {
                case ReadingSiteType.interpretation:
                    result = "Interpretation";
                    break;
                case ReadingSiteType.consultation:
                    result = "Consultation";
                    break;
                case ReadingSiteType.both:
                    result = "Both";
                    break;
                default:
                    result = "Both";
                    break;
                   
            }
            return result;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            string stringValue = (string)value;

            ReadingSiteType result = ReadingSiteType.consultation;
            if (stringValue == "Interpretation")
                result = ReadingSiteType.interpretation;
            else if (stringValue == "Consultation")
                result = ReadingSiteType.consultation;
            else
                result = ReadingSiteType.both;

            return result;
        }
    }
}
