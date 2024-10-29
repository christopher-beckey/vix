using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Hydra.VistA
{
    class SiteServiceUtil
    {
        internal class ServiceProtocol
        {
            public string ProtocolName { get; set; }
            public bool IsSecure { get; set; }
        }

        internal static ServiceProtocol[] _ViewerServiceProtocols = new ServiceProtocol[]
        {
            new ServiceProtocol { ProtocolName = "VVS"},
            new ServiceProtocol { ProtocolName = "VVSS", IsSecure = true}
        };

        internal static string GetViewerUrl(string siteServiceUrl, string siteNumber)
        {
            return GetRootUrl(siteServiceUrl, siteNumber, _ViewerServiceProtocols);
        }

        internal static string GetSiteVixUrl(string siteServiceUrl, string siteNumber)
        {
            return GetRootUrl(siteServiceUrl, siteNumber, new ServiceProtocol[] { new ServiceProtocol { ProtocolName = "VIX"} });
        }

        internal static string GetRootUrl(string siteServiceUrl, string siteNumber, ServiceProtocol[] serviceProtocols)
        {
            var vixClient = new VixClient(siteServiceUrl);
            string siteServiceConfig = vixClient.QuerySiteService(siteNumber);
            if (string.IsNullOrEmpty(siteServiceConfig))
                return null;

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(siteServiceConfig);

            for (int i = 0; i < serviceProtocols.Length; i++)
            {
                XmlNode node = doc.SelectSingleNode(string.Format(@"/site/connections/connection[protocol='{0}']", serviceProtocols[i].ProtocolName));
                if (node != null)
                {
                    return string.Format("{0}://{1}:{2}",
                                            serviceProtocols[i].IsSecure ? "https" : "http",
                                            node["server"].InnerText,
                                            int.Parse(node["port"].InnerText));
                }
            };

            return null;
        }

        internal static void GetServiceStatus(string siteServiceUrl, IEnumerable<StudyItemGroup> studyItemGroups)
        {
            var siteNumbers = studyItemGroups.Select(x => x.SiteNumber).ToList();
            var vixClient = new VixClient(siteServiceUrl);
            string siteServiceConfig = vixClient.QuerySiteService(siteNumbers);
            if (string.IsNullOrEmpty(siteServiceConfig))
                return;

            XmlDocument doc = new XmlDocument();
            doc.LoadXml(siteServiceConfig);

            foreach (var studyItemGroup in studyItemGroups)
            {
                var siteNode = doc.SelectSingleNode(string.Format(@"sites/site[siteNumber = '{0}']", studyItemGroup.SiteNumber));
                if (siteNode != null)
                {
                    var node = siteNode.SelectSingleNode(@"connections/connection[protocol = 'VIX']") ?? siteNode.SelectSingleNode(@"//connection[protocol = 'VIXS']");
                    if (node != null)
                    {
                        studyItemGroup.IsServerAvailable = true;

                        studyItemGroup.IsBulkStudyQuerySupported =
                            (siteNode.SelectSingleNode(string.Format(@"connections/connection[protocol = '{0}']", _ViewerServiceProtocols[0].ProtocolName)) != null) ||
                            (siteNode.SelectSingleNode(string.Format(@"connections/connection[protocol = '{0}']", _ViewerServiceProtocols[1].ProtocolName)) != null);
                    }
                }
            }

        }
    }
}
