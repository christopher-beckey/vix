using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;
using System.Xml;
using System.Net;
using System.IO;

namespace VISAHealthMonitorCommon.monitorederror
{
    public class MonitoredErrorHelper
    {
        public static bool AddMonitoredError(VisaSource visaSource, string errorContains)
        {
            return UpdateMonitoredError(visaSource, errorContains, "add");
        }

        public static bool DeleteMonitoredError(VisaSource visaSource, string errorContains)
        {
            return UpdateMonitoredError(visaSource, errorContains, "delete");
        }

        private static bool UpdateMonitoredError(VisaSource visaSource, string errorContains, string method)
        {
            if (string.IsNullOrEmpty(errorContains))
            {
                throw new Exception("Cannot add/delete empty error");
            }
            string url = GetUrl(visaSource, method);
            string body = CreateBody(errorContains);
            XmlDocument xmlDoc = makeWebRequest(url, "POST", body, "application/xml");

            return ParseResult(xmlDoc);
        }

        private static bool ParseResult(XmlDocument xmlDoc)
        {
            XmlNode resultNode = xmlDoc.SelectSingleNode("/restBooleanReturnType/result");
            return bool.Parse(resultNode.InnerText);
        }

        private static string GetUrl(VisaSource visaSource, string method)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("http://");
            sb.Append(visaSource.VisaHost);
            sb.Append(":");
            sb.Append(visaSource.VisaPort);
            sb.Append("/VixServerHealthWebApp/restservices/monitorederror/");
            sb.Append(method);
            return sb.ToString();
        }

        private static string CreateBody(string errorContains)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("<restStringType>");
            sb.Append("<value>");
            sb.Append(errorContains);
            sb.Append("</value>");
            sb.Append("</restStringType>");
            return sb.ToString();
        }

        private static XmlDocument makeWebRequest(string url, string method, string body, string contentType)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Credentials = VISACredentials.GetVISANetworkCredentials();
            request.Timeout = 30 * 1000;
            request.Method = method;
            if (contentType != null)
                request.ContentType = contentType;

            if (body != null)
            {
                byte[] byteArray = Encoding.UTF8.GetBytes(body);
                Stream requestStream = request.GetRequestStream();
                requestStream.Write(byteArray, 0, byteArray.Length);
                requestStream.Close();
            }

            //DateTime startTime = DateTime.Now;
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.Load(IOUtilities.getStreamFromResponse(response));
            return xmlDoc;
        }


    }
}
