using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;

namespace Hydra.VistA.Parsers
{
    public class TreatingFacilitiesParser
    {
        public static IEnumerable<VixSite> Parse(string text)
        {
            if (string.IsNullOrEmpty(text))
                return null;

            XDocument doc = XDocument.Parse(text);
            var items = doc.XPathSelectElements(@"//treatingFacility");
            if (items == null)
                return null;

            var list = new List<VixSite>();
            foreach (var item in items)
            {
                list.Add(new VixSite
                {
                    SiteNumber = item.XPathGetText(@"institutionIEN"),
                    SiteName = item.XPathGetText(@"institutionName"),
                });
            }

            return list;
        }
    }
}
