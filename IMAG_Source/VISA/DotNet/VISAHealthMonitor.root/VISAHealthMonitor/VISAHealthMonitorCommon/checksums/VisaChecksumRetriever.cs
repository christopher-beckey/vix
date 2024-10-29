using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAChecksums;
using VISACommon;
using System.Xml;

namespace VISAHealthMonitorCommon.checksums
{
    public class VisaChecksumRetriever
    {
        public static List<FileDetails> DownloadChecksums(VisaSource visaSource, LibraryType libraryType)
        {
            List<FileDetails> result = new List<FileDetails>();

            string url = GetUrl(visaSource, libraryType);

            XmlDocument xmlDoc = IOUtilities.MakeXmlWebRequest(url);

            XmlNodeList propertyNodes = xmlDoc.SelectNodes("/VisaConfiguration/Property");
            foreach (XmlNode propertyNode in propertyNodes)
            {
                string name = propertyNode.Attributes["name"].Value;
                long size = long.Parse(propertyNode.Attributes["size"].Value);
                string checksum = null;
                if (propertyNode.Attributes["checksum"] != null)
                {
                    checksum = propertyNode.Attributes["checksum"].Value;
                }
                result.Add(new FileDetails(name, checksum, size));
            }
            
            return result;
        }

        /// <summary>
        /// http://server:port/VixServerHealthWebApp/secure/VisaConfigurationServlet?checksum=true
        /// </summary>
        /// <param name="visaSource"></param>
        /// <param name="method"></param>
        /// <returns></returns>
        private static string GetUrl(VisaSource visaSource, LibraryType libraryType)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("http://");
            sb.Append(visaSource.VisaHost);
            sb.Append(":");
            sb.Append(visaSource.VisaPort);
            sb.Append("/VixServerHealthWebApp/secure/VisaConfigurationServlet?checksum=true&configurationType=" + libraryType);
            return sb.ToString();
        }
    }
}
