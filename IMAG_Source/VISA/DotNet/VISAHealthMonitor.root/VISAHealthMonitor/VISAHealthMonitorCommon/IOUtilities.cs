using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO.Compression;
using System.IO;
using System.Xml;
using VISACommon;

namespace VISAHealthMonitorCommon
{
    public class IOUtilities
    {
        public static Stream getStreamFromResponse(HttpWebResponse response)
        {
            Stream stream;
            switch (response.ContentEncoding.ToUpperInvariant())
            {
                case "GZIP":
                    stream = new GZipStream(response.GetResponseStream(), CompressionMode.Decompress);
                    break;
                case "DEFLATE":
                    stream = new DeflateStream(response.GetResponseStream(), CompressionMode.Decompress);
                    break;

                default:
                    stream = response.GetResponseStream();
                    //stream.ReadTimeout = readTimeOut;
                    break;
            }
            return stream;
        }

        public  static XmlDocument MakeXmlWebRequest(string url)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Credentials = VISACredentials.GetVISANetworkCredentials();
            request.Timeout = 30 * 1000;
            DateTime startTime = DateTime.Now;
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.Load(IOUtilities.getStreamFromResponse(response));
            return xmlDoc;
        }
    }
}
