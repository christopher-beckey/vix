using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Commands
{
    public class GetStudyReportCommand
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static string Execute(StudyReportQuery studyReportQuery)
        {
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Getting study report", "StudyReportQuery", studyReportQuery.ToJsonLog());

                VixServiceUtil.Authenticate(studyReportQuery);

                return VixServiceUtil.GetStudyReport(studyReportQuery);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting study report.", "Exception", ex.ToString());
                throw;
            }
        }
    }
}
