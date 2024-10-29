using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;
using VixHealthMonitorCommon.model;

namespace VixHealthMonitorDailyStatus
{
    public class VixCounts : VixCountsModel
    {
        public List<VisaSource> Sites {get;private set;}

        public VixCounts(List<VaSite> sites)
        {
            Sites = new List<VisaSource>();
            foreach (VaSite site in sites)
            {
                Sites.Add(site);
            }
            LoadVixSites(null);
        }


        public override List<VisaSource> GetVisaSources()
        {
            return Sites;
        }
    }
}
