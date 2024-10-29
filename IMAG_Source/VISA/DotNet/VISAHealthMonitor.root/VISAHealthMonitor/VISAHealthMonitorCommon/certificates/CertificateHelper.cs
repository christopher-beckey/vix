using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;
using System.Net;
using System.Runtime.CompilerServices;
using System.Security.Cryptography.X509Certificates;
using System.Net.Sockets;
using System.Net.Security;
using System.Security.Authentication;

namespace VISAHealthMonitorCommon.certificates
{
    public class CertificateHelper
    {
        /*
        private static bool Initialized = false;

        [MethodImpl(MethodImplOptions.Synchronized)]
        private static void Initialize()
        {
            if (!Initialized)
            {
                ServicePointManager.ServerCertificateValidationCallback = ReceiveCertificateHandler;
                ServicePointManager.MaxServicePointIdleTime = 0;
                Initialized = true;
            }
        }
        */


        public static string GetCertificateExpirationDate(VisaSource visaSource)
        {
            
            CertificateReceiver receiver = new CertificateReceiver();
            try
            {
                //Initialize();
                ServicePointManager.ServerCertificateValidationCallback += receiver.ReceiveCertificateHandler;
                ServicePointManager.MaxServicePointIdleTime = 0;
                StringBuilder url = new StringBuilder();
                url.Append("https://");
                url.Append(visaSource.VisaHost); // default to port 443
                //url.Append(":8443");

                WebClient client = new WebClient();
                client.DownloadData(url.ToString());
                return receiver.ExpirationDate;
                //return null;
            }
            finally
            {
                ServicePointManager.ServerCertificateValidationCallback -= receiver.ReceiveCertificateHandler;    
            }

            /*
            Uri u = new Uri("https://" + visaSource.VisaHost);
            ServicePoint sp = ServicePointManager.FindServicePoint(u);

            string groupName = Guid.NewGuid().ToString();
            HttpWebRequest req = HttpWebRequest.Create(u) as HttpWebRequest;
            
            req.ConnectionGroupName = groupName;

            using (WebResponse resp = req.GetResponse())
            {
                // Ignore response, and close the response.
            }
            sp.CloseConnectionGroup(groupName);

            return sp.Certificate.GetExpirationDateString();
            */
        }

        /*
        public static X509Certificate2 DownloadSslCertificate(string strDNSEntry)
        {

            X509Certificate2 cert = null;
            using (TcpClient client = new TcpClient())
            {
                //ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3;           
                client.Connect(strDNSEntry, 8443);

                SslStream ssl = new SslStream(client.GetStream(), false, new RemoteCertificateValidationCallback(ValidateServerCertificate), null);
                try
                {
                    ssl.AuthenticateAsClient(strDNSEntry);
                    cert = new X509Certificate2(ssl.RemoteCertificate);
                    return cert;
                }
                finally
                {
                    ssl.Close();
                    client.Close();
                }
            }
        }

        public static bool ValidateServerCertificate(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) 
        { 
            if (sslPolicyErrors == SslPolicyErrors.None) 
                return true;
            return false;
        }*/

        public static bool ReceiveCertificateHandler(object sender, System.Security.Cryptography.X509Certificates.X509Certificate certificate,
            System.Security.Cryptography.X509Certificates.X509Chain chain, System.Net.Security.SslPolicyErrors sslPolicyErrors)
        {
            //this.EffectiveDate = certificate.GetEffectiveDateString();
            string expirationDate = certificate.GetExpirationDateString();
            return true;
        }
    }

    public class CertificateReceiver
    {
        public string EffectiveDate { get; private set; }
        public string ExpirationDate { get; private set; }
        
        private static int count = 0;
        public CertificateReceiver()
        {
            
        }

        public bool ReceiveCertificateHandler(object sender, System.Security.Cryptography.X509Certificates.X509Certificate certificate,
            System.Security.Cryptography.X509Certificates.X509Chain chain, System.Net.Security.SslPolicyErrors sslPolicyErrors)
        {
            this.EffectiveDate = certificate.GetEffectiveDateString();
            this.ExpirationDate = certificate.GetExpirationDateString();
            return true;
        }
    }
}
