using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;

namespace Hydra.VistA
{
    public class VixTextParser
    {
        public static string Parse(string text)
        {
            XDocument doc = XDocument.Parse(text);
            return doc.XPathSelectElement(@"/restStringType/value").Value;
        }

        public static string ParseVersion(string text)
        {
            var doc = new HtmlAgilityPack.HtmlDocument();
            doc.LoadHtml(text);

            var node = doc.DocumentNode.SelectSingleNode("//b");
            return node.InnerText;
        }
    }
}
