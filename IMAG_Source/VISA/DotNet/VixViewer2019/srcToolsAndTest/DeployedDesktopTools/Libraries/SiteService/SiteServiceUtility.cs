using DesktopCommon;
using System;
using System.Net;
using System.Text;

namespace SiteService
{
    public class SiteServiceUtility
    {
        public static bool RefreshSiteService(VisaSource visaSource)
        {
            StringBuilder url = new StringBuilder();
            url.Append("http://");
            url.Append(visaSource.VisaHost);
            url.Append(":");
            url.Append(visaSource.VisaPort);
            url.Append("/Vix/secure/RefreshSiteServiceServlet");

            HttpWebRequest request = (HttpWebRequest)HttpWebRequest.Create(url.ToString());
            request.Method = "POST";
            request.AllowAutoRedirect = false;
            ServicePointManager.Expect100Continue = false;
            request.Credentials = new NetworkCredential(Utils.AccessCodeDecrypted, Utils.VerifyCodeDecrypted);
            ////TODO string credentials = Convert.ToBase64String(ASCIIEncoding.ASCII.GetBytes(VISACredentials.VISAUsername + ":" + VISACredentials.VISAPassword));
            //request.Headers.Add("Authorization", "Basic " + null); //TODO credentials);
            ////byte[] byteArray = Encoding.UTF8.GetBytes(createRetrieveRequest(homeCommunityId, repositoryId,
            //    //documentUniqueId, url));
            HttpWebResponse response = null;
            try
            {
                response = (HttpWebResponse)request.GetResponse();
            }
            catch (WebException webEx)
            {
                //LogMsg("WebException, " + webEx.Message, true);
                // got something other than a 200 status code but we still want to parse the response
                // i think if an XCA error code comes back, the status code will still be a 200
                // so if not 200, then throw exception
                if (webEx.Status != WebExceptionStatus.Success)
                    throw webEx;

                response = (HttpWebResponse)webEx.Response;
            }
            if (response == null)
                throw new Exception("Null response from server");

            if (response.StatusCode == HttpStatusCode.Found)
            {
                return true;
            }
            return false;
        }
    }
}
