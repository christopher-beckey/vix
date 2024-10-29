// -----------------------------------------------------------------------
// <copyright file="HealthSummaryPreferences.cs" company="Patriot Technologies">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Worklist.Preferences
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
using VistA.Imaging.Telepathology.Common.Model;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class HealthSummaryPreferences
    {
        public HealthSummaryTypeList SelectedHealthSummaryTypeList { get; set; }

        public string DefaultHealthSummaryTypeID { get; set;}

        public HealthSummaryPreferences()
        {
            this.SelectedHealthSummaryTypeList = new HealthSummaryTypeList();
        }

        public HealthSummaryType GetDefaultHealthSummaryType()
        {
            return this.SelectedHealthSummaryTypeList.Items.Where(x => (x.ID == this.DefaultHealthSummaryTypeID)).FirstOrDefault();
        }
    }
}
