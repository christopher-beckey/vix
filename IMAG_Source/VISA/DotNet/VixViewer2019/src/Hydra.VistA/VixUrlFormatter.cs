using Hydra.Log; //added for VAI-373 and can be used for any logging
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Hydra.VistA
{
    public class VixUrlFormatter
    {
        public string ViewerRootUrl { get; private set; }
        public VistAQuery VistAQuery { get; private set; }

        public const string SensitiveImage = "Sensitive";
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private string _TrailingText;

        public VixUrlFormatter(VistAQuery vistaQuery, string overrideViewerRootUrl = null)
        {
            VistAQuery = vistaQuery;
            ViewerRootUrl = (!string.IsNullOrEmpty(overrideViewerRootUrl) ? overrideViewerRootUrl : vistaQuery.HostRootUrl).TrimEnd('/');

            if (!string.IsNullOrEmpty(vistaQuery.SecurityToken))
                _TrailingText = string.Format("&SecurityToken={0}", HttpUtility.UrlEncode(vistaQuery.SecurityToken));

            if (!string.IsNullOrEmpty(vistaQuery.AuthSiteNumber))
                _TrailingText += string.Format("&AuthSiteNumber={0}", vistaQuery.AuthSiteNumber);

            // flags
            var flags = new List<string>();
            if (PolicyUtil.IsPolicyEnabled("Viewer.EnablePresentationState"))
                flags.Add("PSTATE");
            if (PolicyUtil.IsPolicyEnabled("Viewer.EnableESignatureVerification"))
                flags.Add("ESIGNATURE");

            if (flags.Count > 0)
                _TrailingText += string.Format("&Flags={0}", string.Join("^", flags.ToArray()));
        }

        public void FormatUrl(StudyItem studyItem)
        {
            //VAI-373 - Declare variables here to check if they are null, and initialize them. Then, log and use them below instead of studyItem properties.
            string contextId = studyItem.ContextId!= null ? HttpUtility.UrlEncode(studyItem.ContextId) : "";
            string patientICN = studyItem.PatientICN != null ? studyItem.PatientICN : "";
            string patientDFN = studyItem.PatientDFN != null ? studyItem.PatientDFN : "";
            string sensitiveImage = SensitiveImage != null ? Common.Util.Base64Encode(SensitiveImage) : "";
            string siteNumber = studyItem.SiteNumber != null ? studyItem.SiteNumber : "";
            string studyId = studyItem.StudyId != null ? HttpUtility.UrlEncode(studyItem.StudyId) : "";
            string studyItemDescLowerCase = string.IsNullOrEmpty(studyItem.StudyDescription) ? string.Empty : studyItem.StudyDescription.ToLower().Trim(); //VAI-1345
            string thumbnailUri = studyItem.ThumbnailUri != null ? Common.Util.Base64Encode(studyItem.ThumbnailUri) : "";
            _Logger.TraceVariable("contextId", contextId);
            _Logger.TraceVariable("patientICN", patientICN);
            _Logger.TraceVariable("patientDFN", patientDFN);
            _Logger.TraceVariable("sensitiveImage", sensitiveImage);
            _Logger.TraceVariable("siteNumber", siteNumber);
            _Logger.TraceVariable("studyId", studyId);
            _Logger.TraceVariable("studyItemDescLowerCase", studyItemDescLowerCase);
            _Logger.TraceVariable("thumbnailUri", thumbnailUri);

            //VAI-373: Add PatientICN= or PatientDFN= prefixes so Nancy modules can identify the properties when executing "request as VistAQuery"
            string patientQueryString;
            if (string.IsNullOrEmpty(patientDFN))
                patientQueryString = string.Format("SiteNumber={0}&PatientICN={1}", siteNumber, patientICN);
            else
                patientQueryString = string.Format("SiteNumber={0}&PatientDFN={1}", siteNumber, patientDFN);
 
            string queryString = string.Format("ContextId={0}&{1}", contextId, patientQueryString);
 
            string reportQueryString = string.Format("ContextId={0}&{1}", studyId, patientQueryString);

            int idx = queryString.IndexOf("&");
            _Logger.TraceVariable("idx", idx);
            if (queryString.Contains("vastudy") &&
                (idx > 0) &&
                (studyItemDescLowerCase.EndsWith(": confirmed") || studyItemDescLowerCase.EndsWith(": unconfirmed")))
            {
                //Remote MUSE
                string museUrl = SiteServiceUtil.GetViewerUrl(VixServiceUtil.SiteServiceVix.RootUrl, siteNumber);
                string museQuery = queryString.Substring(0, idx) + "-0" + queryString.Substring(idx);
                museQuery = museQuery.Replace("vastudy", "musestudy");
                studyItem.ViewerUrl = string.Format("{0}{1}?{2}{3}{4}",
                                                museUrl,
                                                "/" + VixRootPath.ViewerRootPath + "/loader",
                                                museQuery,
                                                _TrailingText,
                                                studyItem.IsSensitive ? "&IsSensitive=True" : "");

                studyItem.ManageUrl = string.Format("{0}{1}?{2}{3}",
                                                museUrl,
                                                "/" + VixRootPath.ViewerRootPath + "/manage",
                                                 museQuery,
                                                _TrailingText);

                studyItem.DetailsUrl = string.Format("{0}{1}?{2}{3}",
                                                 museUrl,
                                                 "/" + VixRootPath.ViewerRootPath + VixRootPath.StudyDetails,
                                                 museQuery,
                                                 _TrailingText);

                int idx2 = reportQueryString.IndexOf("&");
                _Logger.TraceVariable("idx2", idx2);
                string musereportQuery = reportQueryString.Substring(0, idx2) + "-0" + reportQueryString.Substring(idx2);
                musereportQuery = musereportQuery.Replace("vastudy", "musestudy");

                studyItem.ReportUrl = string.Format("{0}{1}?{2}{3}",
                                                museUrl,
                                                "/" + VixRootPath.ViewerRootPath + VixRootPath.StudyReport,
                                                musereportQuery,
                                                _TrailingText);

                if (!string.IsNullOrEmpty(thumbnailUri))
                {
                    studyItem.ThumbnailUrl = string.Format("{0}{1}?ContextId={2}{3}{4}",
                                                   museUrl,
                                                    "/" + VixRootPath.ViewerRootPath + VixRootPath.Thumbnails,
                                                    studyItem.IsSensitive ? sensitiveImage : thumbnailUri,
                                                    _TrailingText,
                                                    studyItem.IsSensitive ? "&IsSensitive=True" : "");
                }
            }
            else
            {
                //Not Remote MUSE:  Either local MUSE or non-MUSE
                studyItem.ViewerUrl = string.Format("{0}{1}?{2}{3}{4}",
                                                    !string.IsNullOrEmpty(ViewerRootUrl) ? ViewerRootUrl : VistAQuery.HostRootUrl,
                                                    "/loader",
                                                    queryString,
                                                    _TrailingText,
                                                    studyItem.IsSensitive ? "&IsSensitive=True" : "");

                studyItem.ManageUrl = string.Format("{0}{1}?{2}{3}",
                                                    !string.IsNullOrEmpty(ViewerRootUrl) ? ViewerRootUrl : VistAQuery.HostRootUrl,
                                                    "/manage",
                                                    queryString,
                                                    _TrailingText);

                studyItem.DetailsUrl = string.Format("{0}{1}?{2}{3}",
                                                     VistAQuery.HostRootUrl,
                                                     VixRootPath.StudyDetails,
                                                     queryString,
                                                     _TrailingText);

                studyItem.ReportUrl = string.Format("{0}{1}?{2}{3}",
                                                    VistAQuery.HostRootUrl,
                                                    VixRootPath.StudyReport,
                                                    reportQueryString,
                                                    _TrailingText);

                if (!string.IsNullOrEmpty(thumbnailUri))
                {
                    studyItem.ThumbnailUrl = string.Format("{0}{1}?ContextId={2}{3}{4}",
                                                   VistAQuery.HostRootUrl,
                                                    VixRootPath.Thumbnails,
                                                    studyItem.IsSensitive ? sensitiveImage : thumbnailUri,
                                                    _TrailingText,
                                                    studyItem.IsSensitive ? "&IsSensitive=True" : "");
                }
            }           
        }

        internal void FormatUrl(StudyDetails studyDetails)
        {
            string patientQueryString = string.IsNullOrEmpty(VistAQuery.PatientDFN) ? 
                                        string.Format("PatientICN={0}", VistAQuery.PatientICN) : 
                                        string.Format("PatientDFN={0}", VistAQuery.PatientDFN);

            string queryString = string.Format("ContextId={0}&SiteNumber={1}&{2}",
                                                HttpUtility.UrlEncode(VistAQuery.ContextId),
                                                VistAQuery.SiteNumber,
                                                patientQueryString);

            studyDetails.ViewerUrl = string.Format("{0}{1}?{2}{3}{4}",
                                                !string.IsNullOrEmpty(ViewerRootUrl) ?
                                                    ViewerRootUrl : VistAQuery.HostRootUrl,
                                                "/loader",
                                                queryString,
                                                _TrailingText,
                                                studyDetails.IsSensitive ? "&IsSensitive=True" : "");

            studyDetails.ExportUrl = string.Format("{0}{1}?{2}{3}",
                                                !string.IsNullOrEmpty(ViewerRootUrl) ?
                                                    ViewerRootUrl : VistAQuery.HostRootUrl,
                                                "/export",
                                                queryString,
                                                _TrailingText);

            if (studyDetails.Studies != null)
            {
                foreach (var studyItemDetails in studyDetails.Studies)
                {
                    string reportQueryString = string.Format("ContextId={0}&SiteNumber={1}&{2}",
                                                        HttpUtility.UrlEncode(studyItemDetails.StudyId),
                                                        VistAQuery.SiteNumber,
                                                        patientQueryString);

                    studyItemDetails.ReportUrl = string.Format("{0}{1}?{2}{3}",
                                                        !string.IsNullOrEmpty(ViewerRootUrl) ?
                                                            ViewerRootUrl : VistAQuery.HostRootUrl,
                                                        "/studyreport",
                                                        reportQueryString,
                                                        _TrailingText);

                    if (studyItemDetails.Series != null)
                    {
                        foreach (var seriesItemDetails in studyItemDetails.Series)
                        {
                            seriesItemDetails.ViewerUrl = studyDetails.ViewerUrl;
                            string shownUri = seriesItemDetails.IsSensitive ? Common.Util.Base64Encode(SensitiveImage) : Common.Util.Base64Encode(seriesItemDetails.ImageUri);
                            string sensitiveFlag = seriesItemDetails.IsSensitive ? "&IsSensitive=True" : "";
                            seriesItemDetails.ThumbnailUrl = $"{VistAQuery.HostRootUrl}{VixRootPath.Thumbnails}?ContextId={shownUri}&SiteNumber={VistAQuery.SiteNumber}&{patientQueryString}{_TrailingText}{sensitiveFlag}";
                        
                            if (seriesItemDetails.Images != null)// VAI-1284 
                            {
                                foreach (var image in seriesItemDetails.Images)
                                {
                                    string imageType = image.ImageType.ToLower();
                                    //If there is one of these imageTypes we can add the pdfUrl to studydetails
                                    //Note: This also requires the &IncludeImageDetails=true option
                                    if ((imageType.Contains("pdf") || imageType.Contains("rtf") || imageType.Contains("doc") || imageType.Contains("txt") || imageType.Contains("word document") || imageType.Contains("ascii")) && !imageType.Contains("htm"))
                                    {
                                        string urlForPdf = studyDetails.ViewerUrl.Replace("loader", "servePdf");
                                        seriesItemDetails.pdfUrl = KeepWantedPdfUrlParams(urlForPdf);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        private string KeepWantedPdfUrlParams(string givenUrl) //VAI-1284
        {
            Uri unparsedUrl = new Uri(givenUrl);
            string newUrl = unparsedUrl.GetLeftPart(UriPartial.Path);
            var queryParams = HttpUtility.ParseQueryString(unparsedUrl.Query);
            var dict = QueryUtil.ToDictionary(queryParams);
            string delimiter = "?";
            foreach (var param in dict)
            {
                if ((param.Key == "AuthSiteNumber") || (param.Key == "ContextId") || (param.Key == "PatientICN") || (param.Key == "SecurityToken") || (param.Key == "SiteNumber"))
                    newUrl = $"{newUrl}{delimiter}{param.Key}={param.Value}";
                delimiter = "&";
            }
            return newUrl;
        }
    }
}
