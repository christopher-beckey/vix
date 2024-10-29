using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;

namespace Hydra.VistA.Parsers
{
    public class ROIParser
    {
        public static IEnumerable<ROIStatusItem> Parse(string text)
        {
            if (string.IsNullOrEmpty(text))
                return null;

            XDocument doc = XDocument.Parse(text);
            var items = doc.XPathSelectElements(@"//roiRequestType");
            if (items == null)
                return null;

            var list = new List<ROIStatusItem>();

            foreach (var item in items)
            {
                var roiStatusItem = new ROIStatusItem
                {
                    ErrorMessage = item.XPathGetText(@"errorMessage"),
                    Id = item.XPathGetText(@"guid"),
                    LastUpdated = item.XPathGetText(@"lastUpdateDate"),
                    PatientId = item.XPathGetText(@"patientId"),
                    PatientName = item.XPathGetText(@"patientName"),
                    SLast4 = item.XPathGetText(@"patientSsn"),
                    Status = item.XPathGetText(@"status"),
                    ResultUri = item.XPathGetText(@"resultUri"),
                    ExportQueue = item.XPathGetText(@"exportQueue")
                };

                var studyIds = item.XPathSelectElements(@"studyIds");
                if (studyIds != null)
                {
                    var studyIdList = new List<string>();
                    foreach (var studyId in studyIds)
                        studyIdList.Add(studyId.Value);

                    roiStatusItem.StudyIds = studyIdList.ToArray();
                }

                list.Add(roiStatusItem);
            }

            return list;
        }
    }
}
