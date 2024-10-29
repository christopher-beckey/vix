// -----------------------------------------------------------------------
// <copyright file="OrganTissueToTreeConverter.cs" company="Department of Veterans Affairs">
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
    using System.Globalization;
    using System.Collections;
    using VistA.Imaging.Telepathology.Worklist.ViewModel;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class OrganTissueToTreeConverter : IMultiValueConverter
    {
        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            // get a list of group names
            string groups = parameter as string ?? string.Empty;
            List<string> groupNames = groups.Split(',').Select(g => g.Trim()).ToList();
            while (values.Length > groupNames.Count)
            {
                groupNames.Add(string.Empty);
            }

            // top level collection
            List<object> items = new List<object>();

            for (int i = 0; i < values.Length; i++)
            {
                IEnumerable childs = values[i] as IEnumerable ?? new List<object> { values[i] };

                string groupName = groupNames[i];
                if (groupName != string.Empty)
                {
                    // create group item and assign childs
                    TreeGroup groupItem = new TreeGroup { GroupName = groupName, Items = childs };
                    items.Add(groupItem);
                }
                else
                {
                    //if no folder name was specified, move the item directly to the root item
                    foreach (var child in childs) { items.Add(child); }
                }
            }

            return items;
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
        {
            throw new NotSupportedException("Cannot perform reverse-conversion");
        }
    }
}
