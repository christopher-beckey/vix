using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;

namespace Hydra.VistA.Parsers
{
    public static class UserPreferenceParser
    {
        public static string Parse(string text)
        {
            if (string.IsNullOrEmpty(text))
                return null;

            XDocument doc = XDocument.Parse(text);
            var values = doc.XPathSelectElements(@"//value");
            if (values == null)
                return null;

            // unescape xml and join multiple values (if any)
            return string.Join("", values.Select(a => Regex.Replace(System.Web.HttpUtility.HtmlDecode(a.Value), "[\r\n]+", "")));
        }
    }
}
