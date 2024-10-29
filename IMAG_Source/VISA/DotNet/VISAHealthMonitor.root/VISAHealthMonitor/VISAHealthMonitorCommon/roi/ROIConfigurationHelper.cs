using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;
using System.Xml;
using System.Net;
using VISAHealthMonitorCommon.formattedvalues;
using System.IO;

namespace VISAHealthMonitorCommon.roi
{
    public class ROIConfigurationHelper
    {

        public static ROIConfiguration UpdateROIConfiguration(ROIConfiguration roiConfiguration, VisaSource visaSource)
        {
            StringBuilder body = new StringBuilder();
            body.AppendLine("<roiConfigurationType>");
            body.Append("<expireCompletedItemsAfterDays>");
            body.Append(roiConfiguration.ExpireCompletedItemsAfterDays.Number);
            body.AppendLine("</expireCompletedItemsAfterDays>");

            body.Append("<expireCompletedItemsEnabled>");
            body.Append(roiConfiguration.ExpireCompletedItemsEnabled.ToString().ToLower());
            body.AppendLine("</expireCompletedItemsEnabled>");

            body.Append("<periodicROIProcessingEnabled>");
            body.Append(roiConfiguration.PeriodicProcessingEnabled.ToString().ToLower());
            body.AppendLine("</periodicROIProcessingEnabled>");

            body.Append("<processWorkItemImmediately>");
            body.Append(roiConfiguration.ProcessWorkItemsImmediately.ToString().ToLower());
            body.AppendLine("</processWorkItemImmediately>");

            body.Append("<processingWorkItemWaitTime>");
            body.Append(roiConfiguration.ProcessingWorkItemWaitTime.Number);
            body.AppendLine("</processingWorkItemWaitTime>");

            body.AppendLine("</roiConfigurationType>");

            XmlDocument xmlDoc = makeWebRequest(GetUrl(visaSource), "POST", body.ToString(), "application/xml");

            return ParseRoiConfigurationResponse(xmlDoc);
        }


        public static ROIConfiguration GetROIConfiguration(VisaSource visaSource)
        {
            XmlDocument xmlDoc = makeWebRequest(GetUrl(visaSource));

            return ParseRoiConfigurationResponse(xmlDoc);
        }

        private static ROIConfiguration ParseRoiConfigurationResponse(XmlDocument xmlDoc)
        {
            XmlNode configurationNode = xmlDoc.SelectSingleNode("/roiConfigurationType");

            FormattedNumber expireCompletedItemsAfterDays = FormattedNumber.UnknownFormattedNumber;
            bool expireCompletedItemsEnabled = false;
            bool periodicROIProcessingEnabled = false;
            bool processWorkItemImmediately = false;
            FormattedNumber processingWorkItemWaitTime = FormattedNumber.UnknownFormattedNumber;

            XmlNode expireCompletedItemsAfterDaysNode = configurationNode.SelectSingleNode("expireCompletedItemsAfterDays");
            if (expireCompletedItemsAfterDaysNode != null)
                expireCompletedItemsAfterDays = new FormattedNumber(long.Parse(expireCompletedItemsAfterDaysNode.InnerText));

            XmlNode expireCompletedItemsEnabledNode = configurationNode.SelectSingleNode("expireCompletedItemsEnabled");
            if (expireCompletedItemsEnabledNode != null)
                expireCompletedItemsEnabled = bool.Parse(expireCompletedItemsEnabledNode.InnerText);

            XmlNode periodicROIProcessingEnabledNode = configurationNode.SelectSingleNode("periodicROIProcessingEnabled");
            if (periodicROIProcessingEnabledNode != null)
                periodicROIProcessingEnabled = bool.Parse(periodicROIProcessingEnabledNode.InnerText);

            XmlNode processWorkItemImmediatelyNode = configurationNode.SelectSingleNode("processWorkItemImmediately");
            if (processWorkItemImmediatelyNode != null)
                processWorkItemImmediately = bool.Parse(processWorkItemImmediatelyNode.InnerText);

            XmlNode processingWorkItemWaitTimeNode = configurationNode.SelectSingleNode("processingWorkItemWaitTime");
            if (processingWorkItemWaitTimeNode != null)
                processingWorkItemWaitTime = new FormattedNumber(long.Parse(processingWorkItemWaitTimeNode.InnerText));

            return new ROIConfiguration(expireCompletedItemsAfterDays, expireCompletedItemsEnabled,
                periodicROIProcessingEnabled, processWorkItemImmediately, processingWorkItemWaitTime);
        }

        private static XmlDocument makeWebRequest(string url)
        {
            return makeWebRequest(url, "GET", null, null);
        }

        private static XmlDocument makeWebRequest(string url, string method, string body, string contentType)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            request.Credentials = VISACredentials.GetVISANetworkCredentials();
            request.Timeout = 30 * 1000;
            request.Method = method;
            if(contentType != null)
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

        private static string GetUrl(VisaSource visaSource)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("http://");
            sb.Append(visaSource.VisaHost);
            sb.Append(":");
            sb.Append(visaSource.VisaPort);
            sb.Append("/ROIWebApp/restservices/configuration");
            return sb.ToString();
        }

    }
}
