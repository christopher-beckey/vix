using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Commands
{
    public class GetStudyDetailsCommand
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static StudyDetails Execute(StudyDetailsQuery studyDetailsQuery)
        {
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Getting study details", "StudyDetailsQuery", studyDetailsQuery.ToJsonLog());

                VixServiceUtil.Authenticate(studyDetailsQuery);

                var studyDetails = VixServiceUtil.GetStudyDetails(studyDetailsQuery);
                if (studyDetails != null)
                {
                    // check for sentitive images
                    if (studyDetails.Studies != null)
                    {
                        // study is sensitive, if any series is sensitive
                        Array.ForEach<StudyItemDetails>(studyDetails.Studies, x =>
                            {
                                if (!x.IsSensitive && (x.Series != null))
                                    x.IsSensitive = Array.Exists<SeriesItemDetails>(x.Series, s => s.IsSensitive);
                            });

                        // whole study group is sensitive, if any sub-study is sensitive
                        studyDetails.IsSensitive = Array.Exists<StudyItemDetails>(studyDetails.Studies, x => x.IsSensitive);
                    }

                    VixServiceUtil.FormatUrl(studyDetailsQuery, studyDetails);
                }

                return studyDetails;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting study details.", "Exception", ex.ToString());
                throw;
            }
        }
    }
}
