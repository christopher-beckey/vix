using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Commands
{
    public class ROIQueryCommand
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static IEnumerable<ROIStatusItem> Execute(ROIQuery roiQuery)
        {
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Performing ROI status query.", "ROIQuery", roiQuery.ToJsonLog());

                VixServiceUtil.Authenticate(roiQuery);

                var list = VixServiceUtil.GetROIStatus(roiQuery);

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("ROI Items found.", "Count", (list != null) ? list.Count() : 0);

                return list;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error performing ROI status query.", "Exception", ex.ToString());
                throw;
            }
        }
    }
}
