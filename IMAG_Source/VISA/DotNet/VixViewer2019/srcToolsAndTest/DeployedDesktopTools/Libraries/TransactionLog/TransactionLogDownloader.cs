using DesktopCommon;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;

namespace TransactionLog
{
    public class TransactionLogDownloader
    {
        public static List<TransactionLogEntry> DownloadTransactions(string server, DateTime startDate, DateTime endDate, string transactionId)
        {
            return DownloadTransactions(server, startDate, endDate, transactionId);
        }

        public static void DownloadLog(VaSite site, DateTime startDate, DateTime endDate)
        {
            string vixUrl = GetSiteVixUrl(site);
            if (vixUrl == null)
                return;
            DateTime curDate = startDate;
            vixUrl = "http://" + vixUrl;
            string logD = $@"{Utils.LogDir}\{site.SiteNumber}";
            if (!Directory.Exists(logD))
            {
                Directory.CreateDirectory(logD);
            }

            while (!Utils.IsDateAfter(curDate, endDate))
            {
                string filename = Utils.GetLogFilename(site.SiteNumber, curDate);
                DownloadLogFile(vixUrl, curDate, filename);
                curDate = curDate.AddDays(1);
            }
        }

        /// <summary>
        /// This method searches for the transaction for a specific date and will work on any version of the VIX.
        /// </summary>
        /// <param name="server"></param>
        /// <param name="port"></param>
        /// <param name="siteNumber"></param>
        /// <param name="transactionId"></param>
        /// <param name="date"></param>
        /// <returns></returns>
        public static List<TransactionLogEntry> GetTransaction(string server, int port, string siteNumber, string transactionId, DateTime fromDate, DateTime toDate)
        {
            //string rawTransactionId = transactionId;

            if (transactionId.StartsWith("{"))
            {
                transactionId = "\\" + transactionId;
            }
            if (transactionId.EndsWith("}"))
            {
                transactionId = transactionId.Substring(0, transactionId.Length - 1) + "\\}";
            }

            StringBuilder url = new StringBuilder();
            url.Append("http://");
            url.Append(server);
            url.Append(":");
            url.Append(port);
            url.Append("/Vix/secure/ExcelTransactionLog");
            url.Append("?fromDate=");
            url.Append($"{fromDate.ToString(Utils.DateFormat)} 00:00");
            url.Append("&toDate=");
            url.Append($"{toDate.ToString(Utils.DateFormat)} 23:59");
            url.Append("&transactionId=");
            url.Append(transactionId);

            // JMW 11/29/2012 - the transactionIdOnly property works correctly however it does not work if you escape the transaction ID.  The ID provided must be the real ID and not include the \{ and \} as done above
            // for now just exclude the transactionIdOnly parameter since it works fine without it (just not quite as efficient).  When we are sure all sites are 124 and 119 then it can be added back in
            //url.Append("&transactionIdOnly=true"); // specify only this transaction (new for P124 and 119)

            // JMW 3/25/2013
            // this doesn't really add anything since the transactionIdOnly=true works for P124/P119 the problem is if you provide an escaped value it won't work.

            // JMW 3/25/2013 - Added rawTransactionId property to P119T6, this should contain the unescaped value and can be used with transactionIdOnly, will only work with VIX/CVIX at least P119T6
            //url.Append("&transactionIdOnly=true"); // specify only this transaction (fixed in 119T6)
            // specify the raw transaction ID value with no escaping (added in 119T6)
            //url.Append("&rawTransactionId=");
            //url.Append(rawTransactionId);

            string delim = Utils.Delimiter == "Tab" ? "tab-separated-values" : "csv";
            url.Append($"&format=text%2F{delim}");
            url.Append($"&securityToken={Utils.VixJavaSecurityToken}");
            WebRequest webRequest = WebRequest.Create(url.ToString());
            webRequest.Credentials = new NetworkCredential(Utils.AccessCodeDecrypted, Utils.VerifyCodeDecrypted);
            WebResponse response = webRequest.GetResponse();
            Stream transactionLogStream = transactionLogStream = response.GetResponseStream();

            return TransactionLogParser.ParseLogStream(transactionLogStream, siteNumber);
        }

        /// <summary>
        /// Parse entries from a download log file  in the format the VIX Log Collector does it
        /// </summary>
        /// <param name="siteNumber"></param>
        /// <param name="date"></param>
        /// <returns>A lst of TransactionLogEntry items</returns>
        public static List<TransactionLogEntry> GetLogEntriesFromDirectory(string siteNumber, DateTime date)
        {
            string filename = Utils.GetLogFilename(siteNumber, date);
            if (File.Exists(filename))
            {
                FileStream stream = new FileStream(filename, FileMode.Open);
                return TransactionLogParser.ParseLogStream(stream, siteNumber);
            }
            return null;
        }

        private static void DownloadLogFile(string vixBaseUrl, DateTime date, string outputFilename)
        {
            if (File.Exists(outputFilename))
                return;
            WebClient client = new WebClient();
            client.Credentials = new NetworkCredential(Utils.AccessCodeDecrypted, Utils.VerifyCodeDecrypted);
            string dateString = date.ToString(Utils.DateFormat);
            string delim = Utils.Delimiter == "Tab" ? "tab-separated-values" : "csv";
            string sec = $"securityToken={Utils.VixJavaSecurityToken}";
            string url = $"{vixBaseUrl}/Vix/secure/ExcelTransactionLog?startIndex=&endIndex=&format=text%2F{delim}&fromDate={dateString} 00:00&toDate={dateString} 23:59&imageQuality=unselected&user=&modality=&datasourceProtocol=unselected&errorMessage=&transactionId=&imageUrn=&forwardIteration=False&resultsPerPage=100&{sec}";
            client.DownloadFile(url, outputFilename);
        }

        private static string GetSiteVixUrl(VaSite site)
        {
            return $"{site.VisaHost}:{site.VisaPort}";
            /*
            switch (siteNumber)
            {
                case "756":  // el paso
                    return "elp-imgvix.el-paso.med.va.gov:8080";
            }
            return null;
             */ 
        }
    }
}
