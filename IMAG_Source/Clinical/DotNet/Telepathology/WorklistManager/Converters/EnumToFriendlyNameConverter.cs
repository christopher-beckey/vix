/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 1/9/2012
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Paul Pentapaty
 * Description: 
 * 
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *       
 * 
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Data;
using System.Globalization;
using System.Reflection;
using System.ComponentModel;

namespace VistA.Imaging.Telepathology.Worklist.Converters
{
    [ValueConversion(typeof(object), typeof(String))]
    public class EnumToFriendlyNameConverter : IValueConverter
    {
        #region IValueConverter implementation

        /// <summary>
        /// Convert value for binding from source object
        /// </summary>
        public object Convert(object value, Type targetType,
                object parameter, CultureInfo culture)
        {
            // To get around the stupid WPF designer bug
            if (value != null)
            {
                FieldInfo fi = value.GetType().GetField(value.ToString());

                // To get around the stupid WPF designer bug
                if (fi != null)
                {
                    var attributes = (DescriptionAttribute[]) fi.GetCustomAttributes(typeof(DescriptionAttribute), false);
                                                        
                    return ((attributes.Length > 0) && (!String.IsNullOrEmpty(attributes[0].Description))) ?
                                attributes[0].Description : value.ToString();
                }
            }

            return string.Empty;
        }

        /// <summary>
        /// ConvertBack value from binding back to source object
        /// </summary>
        public object ConvertBack(object value, Type targetType,
            object parameter, CultureInfo culture)
        {
            throw new Exception("Cannot convert back");
        }
        #endregion
    }
}
