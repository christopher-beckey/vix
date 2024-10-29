using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Commands
{
    public class ROISubmitQueryCommand
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static string Execute(ROISubmitQuery roiSubmitQuery)
        {
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Performing ROI submit query.", "ROISubmitQuery", roiSubmitQuery.ToJsonLog());

                VixServiceUtil.Authenticate(roiSubmitQuery);

                VixServiceUtil.SubmitROIRequest(roiSubmitQuery);

                return null;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error performing ROI status query.", "Exception", ex.ToString());
                throw;
            }
        }
    }
}
