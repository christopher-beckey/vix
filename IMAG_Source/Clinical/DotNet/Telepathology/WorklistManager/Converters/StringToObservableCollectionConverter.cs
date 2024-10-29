// -----------------------------------------------------------------------
// <copyright file="StringToObservableCollectionConverter.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Mar 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Report Model
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

namespace VistA.Imaging.Telepathology.Worklist.Converters
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Windows.Data;
    using System.Collections.ObjectModel;
    using VistA.Imaging.Telepathology.Common.Model;
    using System.Text.RegularExpressions;
    using System.Globalization;


    [ValueConversion(typeof(string), typeof(ObservableCollection<StringWrapper>))]
    public class StringToObservableCollectionConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            string stringValue = (string)value;
            ObservableCollection<StringWrapper> bindedList = new ObservableCollection<StringWrapper>();
            if ((stringValue == null) || (stringValue == string.Empty))
                return bindedList;
            else
            {
                string[] values = Regex.Split(stringValue, "\r\n");
                foreach (string s in values)
                {
                    if (s != string.Empty)
                    {
                        bindedList.Add(new StringWrapper() { Value = s });
                    }
                }
                
                return bindedList;
            }
        }
 
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            ObservableCollection<StringWrapper> valueList = (ObservableCollection<StringWrapper>)value;
            string valueString = string.Empty;

            foreach (StringWrapper s in valueList)
            {
                if ((s.Value != null) || (s.Value != string.Empty))
                {
                    valueString += valueString + s.Value + "\r\n";
                }
            }

            return valueString;
        }
    }
}
