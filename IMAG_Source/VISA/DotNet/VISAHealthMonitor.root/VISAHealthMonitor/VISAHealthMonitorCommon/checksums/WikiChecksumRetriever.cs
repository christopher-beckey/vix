using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon.wiki;
using System.Net;
using VISAChecksums;

namespace VISAHealthMonitorCommon.checksums
{
    public class WikiChecksumRetriever
    {
        
        public static ChecksumGroup GetChecksums(WikiConfiguration wikiConfiguration, string version, LibraryType libraryType, VisaType visaType, OsArchitecture osArchitecture)
        {
            string url = wikiConfiguration.WikiRootUrl.Replace("Wiki.jsp", "attach/Checksums/" + version + "_" + libraryType + "_" + visaType + "_" + osArchitecture + ".xml");

            WebClient client = new WebClient();
            string xml = client.DownloadString(url);

            return ChecksumGroup.FromXml(xml);

        }
    }
}
