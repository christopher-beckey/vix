using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;

namespace VISAHealthMonitorCommon.wiki
{
    public class VixAdministratorsHelper
    {
        public static List<VixAdministrator> GetSiteAdministrators(WikiConfiguration wikiConfiguration, string siteNumber, int timeout)
        {
            List<VixAdministrator> result = new List<VixAdministrator>();
            string vixServersWikiPage = wikiConfiguration.WikiRootUrl +  "?page=VIXServers&skin=raw";

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(vixServersWikiPage);
            //request.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8";
            //request.Headers.Add("Accept-Encoding", "gzip,deflate");
            request.Timeout = timeout * 1000;
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            StreamReader reader = new StreamReader(IOUtilities.getStreamFromResponse(response));

            string line = reader.ReadLine();
            while (line != null)
            {
                if (line.StartsWith("|["))
                {
                    string [] pieces = line.Split('|');
                    if (pieces[3] == siteNumber)
                    {
                        if (pieces.Length > 5)
                        {
                            for (int i = 5; i < pieces.Length; i++)
                            {
                                string contact = pieces[i].Trim();
                                char [] delimiter = new char [] {'\\', '\\'};                                
                                string[] contactPieces = contact.Split(delimiter);
                                string name = "";

                                string phoneNumber = "";
                                string email = "";
                                if (contactPieces.Length > 0)
                                    name = contactPieces[0];

                                for (int j = 1; j < contactPieces.Length; j++)
                                {
                                    string val = contactPieces[j];
                                    if (!string.IsNullOrEmpty(val))
                                    {
                                        val = val.Trim();
                                        if (val.Contains("@"))
                                        {
                                            if (email == "")
                                                email = val;
                                            else
                                                email = email + "; " + val;
                                        }
                                        else
                                        {
                                            if (phoneNumber == "")
                                                phoneNumber = val;
                                            else
                                                phoneNumber = phoneNumber + "; " + val;
                                        }
                                    }
                                }
                                result.Add(new VixAdministrator(name, phoneNumber, email));
                            }
                        }
                    }
                }
                line = reader.ReadLine();
            }

            return result;
        }

    }
}
