// -----------------------------------------------------------------------
// <copyright file="BoolToStringConverter.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: April 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Convert boolean value to string
//        ;; +--------------------------------------------------------------------+
//        ;; Property of the US Government.
//        ;; No permission to copy or redistribute this software is given.
//        ;; Use of unreleased versions of this software requires the user
//        ;;  to execute a written test agreement with the VistA Imaging
//        ;;  Development Office of the Department of Veterans Affairs,
//        ;;  telephone (301) 734-0100.
//        ;;
//        ;; The Food and Drug Administration classifies this software as
//        ;; a Class II medical device.  As such, it may not be changed
//        ;; in any way.  Modifications to this software may result in an
//        ;; adulterated medical device under 21CFR820, the use of which
//        ;; is considered to be a violation of US Federal Statutes.
//        ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Configurator.Converters
{
    using System;
    using System.Windows.Data;
    using System.Globalization;

    /// <summary>
    /// Convert boolean value to string
    /// </summary>
    [ValueConversion(typeof(bool), typeof(string))]
    public class BoolToStringConverter : IValueConverter
    {
        /// <summary>
        /// Converts from bool to string
        /// </summary>
        /// <param name="value">bool value</param>
        /// <param name="targetType">target type</param>
        /// <param name="parameter">converting parameter</param>
        /// <param name="culture">converting culture</param>
        /// <returns>string represents the bool value</returns>
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            bool boolValue = System.Convert.ToBoolean(value);

            if (boolValue)
                return "Yes";
            else
                return "No";
        }

        /// <summary>
        /// Converts from string to bool
        /// </summary>
        /// <param name="value">string value</param>
        /// <param name="targetType">target type</param>
        /// <param name="parameter">converting parameter</param>
        /// <param name="culture">converting cuture</param>
        /// <returns>bool value from the string</returns>
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            string stringValue = (string)value;

            if ((stringValue == "Yes") || (stringValue == "True"))
                return true;
            else
                return false;
        }
    }
}
