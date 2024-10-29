using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Hydra.VistA
{
    static class UrlFormatter
    {
        public static string FormatViewerUrl(string viewerRootUrl,
                                             string contextId, 
                                             string siteNumber, 
                                             string patientICN, 
                                             string securityToken,
                                             string vixRootUrl,
                                             string authSiteNumber)
        {
            return string.Format("{0}?ContextId={1}&SiteNumber={2}&PatientICN={3}{4}",
                                 viewerRootUrl,
                                 HttpUtility.UrlEncode(contextId),
                                 siteNumber,
                                 patientICN, 
                                 string.IsNullOrEmpty(securityToken) ? "" : string.Format("&SecurityToken={0}", HttpUtility.UrlEncode(securityToken)),
                                 string.IsNullOrEmpty(vixRootUrl) ? "" : string.Format("&VixRootUrl={0}", vixRootUrl),
                                 string.IsNullOrEmpty(authSiteNumber) ? "" : string.Format("&AuthSiteNumber={0}", authSiteNumber));
        }

        public static string FormatViewerUrl(string viewerRootUrl, VistAQuery vistaQuery)
        {
            return FormatViewerUrl(viewerRootUrl,
                                   vistaQuery.ContextId,
                                   vistaQuery.SiteNumber,
                                   vistaQuery.PatientICN,
                                   vistaQuery.SecurityToken,
                                   vistaQuery.VixRootUrl,
                                   vistaQuery.AuthSiteNumber);
        }

        public static void PrepareRequest(VistAQuery vistaQuery)
        {
            if (!string.IsNullOrEmpty(vistaQuery.SecurityToken))
                vistaQuery.SecurityToken = HttpUtility.HtmlDecode(vistaQuery.SecurityToken);

            if (!string.IsNullOrEmpty(vistaQuery.ContextId))
                vistaQuery.ContextId = HttpUtility.HtmlDecode(vistaQuery.ContextId);
        }


        public static string FormatDetailsUrl(StudyQuery studyQuery, StudyItem studyItem, VixServiceUrls urls)
        {
            if (!urls.ContainsKey(VixServiceType.Viewer))
                return null;

            return FormatDetailsUrl(urls[VixServiceType.Viewer],
                                    VixRootPath.StudyDetails,
                                    studyItem.ContextId,
                                    string.IsNullOrEmpty(studyItem.SiteNumber) ? studyQuery.SiteNumber : studyItem.SiteNumber,
                                    string.IsNullOrEmpty(studyItem.PatientICN) ? studyQuery.PatientICN : studyItem.PatientICN,
                                    studyQuery.ExcludeToken ? null : studyQuery.SecurityToken,
                                    urls.ContainsKey(VixServiceType.Local) ? urls[VixServiceType.Local] : null);
        }

        public static string FormatDetailsUrl(string viewerRootUrl, 
                                              string detailsRootPath, 
                                              string contextId, 
                                              string siteNumber, 
                                              string patientICN, 
                                              string securityToken, 
                                              string vixRootUrl)
        {
            return string.Format("{0}{1}?ContextId={2}&SiteNumber={3}&PatientICN={4}{5}{6}",
                                 viewerRootUrl.TrimEnd('/'),
                                 (detailsRootPath != null)? @"/" + detailsRootPath.Trim('/') : "",
                                 HttpUtility.UrlEncode(contextId),
                                 siteNumber,
                                 patientICN,
                                 string.IsNullOrEmpty(securityToken) ? "" : string.Format("&SecurityToken={0}", HttpUtility.UrlEncode(securityToken)),
                                 string.IsNullOrEmpty(vixRootUrl) ? "" : string.Format("&VixRootUrl={0}", HttpUtility.UrlEncode(vixRootUrl)));
        }

        public static string FormatThumbnailUrl(string viewerRootUrl,
                                                string thumbnailsRootPath,
                                                string thumbnailImageUri,
                                                string siteNumber,
                                                string patientICN,
                                                string securityToken, 
                                                string vixRootUrl)
        {
            return string.Format("{0}{1}?ContextId={2}&SiteNumber={3}&PatientICN={4}{5}{6}",
                                 viewerRootUrl.TrimEnd('/'),
                                 (thumbnailsRootPath != null) ? @"/" + thumbnailsRootPath.Trim('/') : "",
                                 Base64Encode(thumbnailImageUri),
                                 siteNumber,
                                 patientICN,
                                 string.IsNullOrEmpty(securityToken) ? "" : string.Format("&SecurityToken={0}", HttpUtility.UrlEncode(securityToken)),
                                 string.IsNullOrEmpty(vixRootUrl) ? "" : string.Format("&VixRootUrl={0}", HttpUtility.UrlEncode(vixRootUrl)));
        }

        public static string Base64Encode(string plainText)
        {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            return System.Convert.ToBase64String(plainTextBytes);
        }

        public static string Base64Decode(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }
    }
}
