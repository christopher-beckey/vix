using System.Diagnostics;
using System.Text;

namespace TransactionLog
{
    public class TransactionLogUrlHelper
    {
        public static void LaunchTransactionViewer(SiteTransactionLogEntry siteTransactionLogEntry)
        {
            StringBuilder url = new StringBuilder();
            url.Append("http://");
            url.Append(siteTransactionLogEntry.VASite.VisaHost);
            url.Append(":");
            url.Append(siteTransactionLogEntry.VASite.VisaPort);
            url.Append("/Vix/secure/VixLogViewTransaction.jsp?transactionId=");
            url.Append(siteTransactionLogEntry.TransactionLogEntry.TransactionId);

            Process proc = new Process();
            proc.StartInfo.FileName = url.ToString();
            proc.Start();
        }
    }
}
