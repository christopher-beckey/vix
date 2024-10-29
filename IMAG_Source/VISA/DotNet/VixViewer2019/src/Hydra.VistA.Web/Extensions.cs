using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Web
{
    static class Extensions
    {
        public static bool IsValid(this StudyQuery studyQuery)
        {
            if ((string.IsNullOrEmpty(studyQuery.PatientICN) && 
                    string.IsNullOrEmpty(studyQuery.PatientDFN)) || 
                (string.IsNullOrEmpty(studyQuery.SiteNumber) &&
                    ((studyQuery.SiteNumbers == null) || (studyQuery.SiteNumbers.Length == 0))))
            {
                if ((studyQuery.Studies == null) && (string.IsNullOrEmpty(studyQuery.ApiToken)))
                    return false;

                if (string.IsNullOrEmpty(studyQuery.PatientICN) && string.IsNullOrEmpty(studyQuery.PatientDFN))
                {
                    if (studyQuery.Studies.FirstOrDefault(x => (string.IsNullOrEmpty(x.PatientICN) && string.IsNullOrEmpty(x.PatientDFN))) != null)
                        return false; //there is atleast one study item whose patientICN is not valid
                }
                else if (string.IsNullOrEmpty(studyQuery.SiteNumber))
                {
                    if (string.IsNullOrEmpty(studyQuery.ApiToken) && (studyQuery.Studies.FirstOrDefault(x => string.IsNullOrEmpty(x.SiteNumber)) != null))
                        return false; //there is atleast one study item whose site number is not valid
                }
            }

            return true;
        }

        public static bool IsValid(this ROIQuery studyQuery)
        {
            return true;
        }

        public static bool IsValid(this ROISubmitQuery studyQuery)
        {
            return true;
        }
    }
}
