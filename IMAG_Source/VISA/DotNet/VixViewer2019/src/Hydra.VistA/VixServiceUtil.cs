using Hydra.Common;//VAI-707
using Hydra.Common.Exceptions;
using Hydra.Security; //VAI-707: Introduced use of SecurityUtil in many places in this class
using Hydra.Log;
using Hydra.VistA.Parsers;
using Nancy.Security;
using System;
using System.Collections.Generic;
using System.Configuration; //VAI-707
using System.IO;
using System.Linq;

namespace Hydra.VistA
{
    public static class VixServiceUtil
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private static bool _IsInitialized;
        private static int SecurityTokenTimeout { get; set; }
        private static List<SecurityUtil.ClientAuthentication> _ClientAuthenticationList = new List<SecurityUtil.ClientAuthentication>();
        private static List<SecurityUtil.VixTool> _VixToolList = new List<SecurityUtil.VixTool>();
        private static SecurityTokenTimeoutType SecurityTokenTimeoutType { get; set; }

        // policy settings
        private static bool _UseCPRSImageIndicator = true;
        private static int _CPRSImageIndicatorIndex = 13;
        private static bool _EnablePromiscuousMode = false;

        // vix request settings
        private static TimeSpan _ImageRequestTimeout = TimeSpan.FromMinutes(5);
        private static int _ImageRequestRetryCount = 3;
        private static TimeSpan _MetadataRequestTimeout = TimeSpan.FromMinutes(5);

        public static bool CanAccessVixCache { get; private set; }
        public static string SecureToken { get; private set; }
        public static List<SecurityUtil.ClientAuthentication> ClientAuthenticationSettings { get; private set; }
        public static VixService SiteServiceVix { get; set; }
        public static VixService LocalVix { get; private set; }
        public static VixService ViewerVix { get; set; }

        static VixServiceUtil()
        {
            Initialize();
        }

        public static void Initialize()
        {
            if (_IsInitialized)
                return;
            _IsInitialized = true;

            Globals.Config.VixUtilPassword = CryptoUtil.DecryptAES(VistAConfigurationSection.Instance.UtilPwd);

            #region SetServiceTypes
            for (int i = 0; i < VistAConfigurationSection.Instance.VixServices.Count; i++)
            {
                var vixService = VistAConfigurationSection.Instance.VixServices[i];

                var userName = vixService.UserName;
                var password = vixService.Password;

                // decrypt username
                if (string.IsNullOrEmpty(userName))
                {
                    var secureElement = vixService.SecureElements["UserName"];
                    if (secureElement != null)
                        userName = secureElement.Value;
                }

                // decrypt password
                if (string.IsNullOrEmpty(password))
                {
                    var secureElement = vixService.SecureElements["Password"];
                    if (secureElement != null)
                        password = secureElement.Value;
                }

                switch (vixService.ServiceType)
                {
                    case VixServiceType.Local:
                        LocalVix = new VixService
                        {
                            RootUrl = vixService.RootUrl,
                            UserName = userName,
                            Password = password,
                            Flavor = vixService.Flavor
                        };

                        // access VIX Java cache before VIX Render cache if the VIX Java code is running on the same machine
                        // THIS MAKES NO SENSE! TODO: VAI-293: If the VIX Render Cache is up-to-date with no errors, we should use it first
                        CanAccessVixCache = (LocalVix.RootUrl.IndexOf("localhost", StringComparison.OrdinalIgnoreCase) >= 0);
                        if (CanAccessVixCache)
                            CanAccessVixCache = PolicyUtil.IsPolicyEnabled("VIX.EnableCacheAccess", true);

                        break;

                    case VixServiceType.SiteService:
                        SiteServiceVix = new VixService
                        {
                            RootUrl = vixService.RootUrl
                        };
                        break;

                    case VixServiceType.Viewer:
                        ViewerVix = new VixService
                        {
                            SiteServiceProtocol = vixService.SiteServiceProtocol,
                            SecureSiteServiceProtocol = vixService.SecureSiteServiceProtocol,
                            RootUrl = vixService.RootUrl,
                            PublicHostName = vixService.PublicHostName,
                            TrustedClientRootUrl = vixService.TrustedClientRootUrl
                        };
                        break;
                }
            }
            #endregion SetServiceTypes

            #region ClientAuthenticationSettings
            if (VistAConfigurationSection.Instance.ClientAuthenticationSettings != null)
            {
                for (int i = 0; i < VistAConfigurationSection.Instance.ClientAuthenticationSettings.Count; i++)
                {
                    var item = VistAConfigurationSection.Instance.ClientAuthenticationSettings[i];

                    var clientAuthentication = new SecurityUtil.ClientAuthentication
                    {
                        CertificateThumbprints = item.CertificateThumbprints.Split(';').Where(x => !string.IsNullOrEmpty(x)).ToList(),
                        StoreLocation = item.StoreLocation,
                        StoreName = item.StoreName,
                        IncludeVixSecurityToken = item.IncludeVixSecurityToken
                    };

                    var secureElement = item.SecureElements["UserName"];
                    if (secureElement != null)
                        clientAuthentication.Username = secureElement.Value;

                    secureElement = item.SecureElements["Password"];
                    if (secureElement != null)
                        clientAuthentication.Password = secureElement.Value;

                    _ClientAuthenticationList.Add(clientAuthentication);
                }
                SecurityUtil.ClientAuthenticationList = _ClientAuthenticationList;
            }
            #endregion ClientAuthenticationSettings

            #region VixToolSettings
            if ((VistAConfigurationSection.Instance.VixToolSettings != null) && (VistAConfigurationSection.Instance.VixToolSettings.Count > 0))
            {
                string[] parts;
                string myFqdn = Util.GetFqdn();
                foreach (string key in VistAConfigurationSection.Instance.VixToolSettings.AllKeys)
                {
                    NameValueConfigurationElement configElement = VistAConfigurationSection.Instance.VixToolSettings[key];
                    parts = configElement.Name.Split('|');
                    string toolName = parts[0];
                    string securityHandoff = parts[1];
                    string toolUrl = parts[2].Replace("REPLACE-FQDN-RUNTIME", myFqdn);
                    if (string.IsNullOrWhiteSpace(toolName))
                        toolName = "Unspecified";
                    if ((securityHandoff != "None") && (securityHandoff != "BSE") && (securityHandoff != "VJ") && (securityHandoff != "VV"))
                        securityHandoff = "None";
                    bool hasCVIX = configElement.Value.Contains("CVIX");
                    bool hasVIX = configElement.Value.Replace("CVIX", "").Contains("VIX");
                    bool hasSCIP = configElement.Value.Contains("SCIP"); //VAI-1329

                    SecurityUtil.VixTool vixTool = new SecurityUtil.VixTool
                    {
                        Name = toolName,
                        SecurityHandoff = securityHandoff,
                        Url = toolUrl,
                        IsCvix = hasCVIX,
                        IsVix = hasVIX,
                        IsInternal = hasSCIP //VAI-1329
                    };
                    _VixToolList.Add(vixTool);
                }
                SecurityUtil.VixToolList = _VixToolList;
            }
            #endregion VixToolSettings

            SecurityUtil.IsCvix = PolicyUtil.IsPolicyEnabled("Viewer.EnableDashboard"); //Can also check in the VIX Java config files, but this is good enough for now
            SecurityUtil.BypassCertificateDateCheck = PolicyUtil.IsPolicyEnabled("Security.BypassCertificateDateCheck");

            SecurityTokenTimeout = VistAConfigurationSection.Instance.SecurityTokenTimeout;
            SecurityTokenTimeoutType = VistAConfigurationSection.Instance.SecurityTokenTimeoutType;

            _UseCPRSImageIndicator = PolicyUtil.IsPolicyEnabled("CPRS.ContextId.UseImageIndicator", _UseCPRSImageIndicator);
            _CPRSImageIndicatorIndex = PolicyUtil.GetPolicySettingsInt("CPRS.ContextId.ImageIndicatorIndex", _CPRSImageIndicatorIndex);
            _CPRSImageIndicatorIndex = Math.Max(_CPRSImageIndicatorIndex, 0);
            _EnablePromiscuousMode = PolicyUtil.IsPolicyEnabled("Security.EnablePromiscuousMode", _EnablePromiscuousMode);

            _ImageRequestTimeout = PolicyUtil.GetPolicySettingsTimeSpan("Vix.ImageRequestTimeout", _ImageRequestTimeout);
            _ImageRequestRetryCount = Math.Max(PolicyUtil.GetPolicySettingsInt("Vix.ImageRequestRetryCount", _ImageRequestRetryCount), 1);
            _MetadataRequestTimeout = PolicyUtil.GetPolicySettingsTimeSpan("Vix.MetadataRequestTimeout", _MetadataRequestTimeout);
        }

        /// <summary>
        /// Get the VIX Viewer Security Token (VVST) string, and update its expiry.
        /// </summary>
        /// <param name="appName">Application Name</param>
        /// <param name="userId">User Identifier</param>
        /// <param name="userName">User Name</param>
        /// <param name="userPassword">User Password</param>
        /// <returns>The token.</returns>
        public static string GetUpdatedSecurityTokenString(string appName, string userId, string userName, string userPassword)
        {
            string vixJavaSecurityToken = GetVixJavaSecurityToken(appName, userName, userPassword);
            return SecurityToken.GenerateVixViewerSecurityToken(userId, vixJavaSecurityToken, GetTimeoutTimeSpan());
        }

        /// <summary>
        /// Get the VIX Viewer Security Token (VVST) object by first getting the VIX Java Security Token (VJST), then update the VVST's expiration.
        /// </summary>
        /// <param name="appName">Application Name</param>
        /// <param name="userId">User Identifier</param>
        /// <param name="userName">User Name</param>
        /// <param name="userPassword">User Password</param>
        /// <returns>The VVST.</returns>
        public static ViewerToken GetUpdatedSecurityTokenObject(string appName, string userId, string userName, string userPassword)
        {
            string vixJavaSecurityToken = GetVixJavaSecurityToken(appName, userName, userPassword);
            string vixViewerSecurityToken = SecurityToken.GenerateVixViewerSecurityToken(userId, vixJavaSecurityToken, GetTimeoutTimeSpan());
            return new ViewerToken() { VixViewerSecurityToken = vixViewerSecurityToken, VixJavaSecurityToken = vixJavaSecurityToken };
        }

        private static IVixClient CreateClient(VixService vixService)
        {
            return new VixClient(vixService.RootUrl,
                                 vixService.UserName,
                                 vixService.Password,
                                 vixService.Flavor);
        }

        public static StudyItem[] GetPatientStudies(string patientICN, string patientDFN, string siteNumber, string vixJavaSecurityToken, string imageFilter)
        {
            var vixClient = CreateClient(LocalVix);

            if (string.IsNullOrEmpty(imageFilter))
                imageFilter = "PAT,ENC";

            bool isDash = false;
            if (imageFilter.ToUpper().Contains("DODNONDICOM"))
            {
                imageFilter = Util.SplitRemoveJoin(imageFilter, "DODnonDICOM", ",");
                isDash = true;
            }

            string text = vixClient.GetPatientStudies(patientICN, patientDFN, siteNumber, vixJavaSecurityToken, imageFilter, isDash, null);
            if (string.IsNullOrEmpty(text))
            {
                //VAI-707
                //throw new Exception("Failed to retrieve patient studies");
                _Logger.Error("Failed to retrieve patient studies.");
                return null;
            }

            var studies = StudyMetadataParser.ParsePatientStudyQueryReponse(text, patientICN, patientDFN);

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("PatientStudiesQuery complete", "PatientId", patientICN, "SiteNumber", siteNumber, "StudyCount", (studies != null) ? studies.Count() : 0);

            return studies;
        }

        public static void GetStudyImageStatus(StudyItem studyItem, string vixJavaSecurityToken)
        {
            try
            {
                //studyItem.SiteNumber = string.IsNullOrEmpty(studyItem.SiteNumber) ? studyQuery.SiteNumber : studyItem.SiteNumber;
                //studyItem.PatientICN = string.IsNullOrEmpty(studyItem.PatientICN) ? studyQuery.PatientICN : studyItem.PatientICN;
                //studyItem.PatientDFN = string.IsNullOrEmpty(studyItem.PatientDFN) ? studyQuery.PatientDFN : studyItem.PatientDFN;

                // if enable, simply check the image indicator piece in the context id
                if (_UseCPRSImageIndicator)
                {
                    string[] tokens = studyItem.ContextId.Split('^');
                    if ((tokens != null) &&
                        (tokens.Length >= _CPRSImageIndicatorIndex) &&
                        (tokens[_CPRSImageIndicatorIndex - 1] == "0"))
                    {
                        studyItem.ImageCount = 0;
                        studyItem.StatusCode = VixStatusCode.OK;
                        studyItem.Status = "No images detected.";

                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("ContextId ignored after examining CPRS identifier", "ContextId", studyItem.ContextId);

                        return;
                    }
                }

                var vixClient = CreateClient(LocalVix);
                string studyMetadata = vixClient.GetStudyMetadata(null, studyItem.ContextId, vixJavaSecurityToken, studyItem.PatientDFN, studyItem.PatientICN, studyItem.SiteNumber);

                StudyMetadataParser.FillBasic(studyMetadata, studyItem);

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Getting study metadata complete.", "ImageCount", studyItem.ImageCount);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting study metadata.", "Exception", ex.ToString());

                if (ex is VixTimeoutException)
                {
                    studyItem.StatusCode = VixStatusCode.GatewayTimeout;
                    studyItem.Status = "Vix request has timed out.";
                }
                else
                {
                    studyItem.StatusCode = VixStatusCode.Error;
                    studyItem.Status = ex.ToString();
                }
            }
        }

        public static void GetPatientStudiesImageStatus(StudyItemGroup studyItemGroup, string vixJavaSecurityToken)
        {
            // Note all studyItems belong to the same site and patient

            try
            {
                string patientICN = null, patientDFN = null, siteNumber = null;
                List<StudyItem> studies = null;

                foreach (var studyItem in studyItemGroup.Studies)
                {
                    // check if server is available. (Site service vix must be enabled)
                    if (studyItemGroup.IsServerAvailable == false)
                    {
                        studyItem.ImageCount = 0;
                        studyItem.StatusCode = VixStatusCode.ServiceUnavailable;
                        studyItem.Status = "Vix service unavailable.";
                        continue;
                    }

                    // if enable, simply check the image indicator piece in the context id
                    if (_UseCPRSImageIndicator)
                    {
                        string[] tokens = studyItem.ContextId.Split('^');
                        if ((tokens != null) &&
                            (tokens.Length >= _CPRSImageIndicatorIndex) &&
                            (tokens[_CPRSImageIndicatorIndex - 1] == "0"))
                        {
                            studyItem.ImageCount = 0;
                            studyItem.StatusCode = VixStatusCode.OK;
                            studyItem.Status = "No images detected.";
                            continue;
                        }
                    }

                    if (studies == null)
                    {
                        studies = new List<StudyItem>();
                        patientICN = studyItem.PatientICN;
                        patientDFN = studyItem.PatientDFN;
                        siteNumber = studyItem.SiteNumber;
                    }

                    studies.Add(studyItem);
                }

                if (studies != null)
                {
                    var vixClient = CreateClient(LocalVix);

                    if (studyItemGroup.IsBulkStudyQuerySupported == true)
                    {
                        // bulk study query supported
                        List<string> contextIds = studies.Select(x => x.ContextId).ToList();
                        string response = vixClient.GetStudiesMetadata(null, contextIds, vixJavaSecurityToken, patientDFN, patientICN, siteNumber, _MetadataRequestTimeout);
                        StudyMetadataParser.FillBasic(response, studyItemGroup.Studies);
                    }
                    else
                    {
                        // bulk query not supported or site service vix is not enabled
                        int requestThreadCount = (int)Math.Min(VistAConfigurationSection.Instance.QueryThreadPoolSize, studies.Count);

                        // update status for the selected studies
                        Hydra.IX.Common.BackgroundWorker<StudyItem>.Execute((studyItem, workerId, workerIndex, token) =>
                                                                            {
                                                                                if (_Logger.IsDebugEnabled)
                                                                                    _Logger.Debug(@"Getting image status for context", "WorkerIndex", workerIndex, "ThreadCount", requestThreadCount, "WorkerId", workerId, "ContextId", studyItem.ContextId);

                                                                                VixServiceUtil.GetStudyImageStatus(studyItem, vixJavaSecurityToken);
                                                                            },
                                                                            studies,
                                                                            requestThreadCount,
                                                                            true);
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Info("Error getting image status.", "Exception", ex.ToString());

                int statusCode = (ex is VixTimeoutException) ?
                    (int)System.Net.HttpStatusCode.GatewayTimeout : 500;
                var status = ex.Message;

                foreach (var studyItem in studyItemGroup.Studies)
                {
                    studyItem.StatusCode = statusCode.ToString();
                    studyItem.Status = status;
                }

                throw;
            }
        }

        public static StudyDetails GetStudyDetails(StudyDetailsQuery studyDetailsQuery)
        {
            string studyMetadata = GetStudyMetadata(studyDetailsQuery);
            if (string.IsNullOrEmpty(studyMetadata))
                throw new BadRequestException("No study metadata found for ContextId {0}", studyDetailsQuery.ContextId);

            var studyDetails = StudyMetadataParser.GetStudyDetails(studyMetadata, studyDetailsQuery.ContextId, studyDetailsQuery.IncludeImageDetails);

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("StudyDetails request complete", "ImageCount", (studyDetails != null) ? studyDetails.TotalImageCount : 0);

            return studyDetails;
        }

        public static string GetStudyReport(StudyReportQuery studyReportQuery)
        {
            var vixClient = CreateClient(LocalVix);

            string studyMetadata = vixClient.GetStudyReport(null, studyReportQuery.ContextId, studyReportQuery.VixJavaSecurityToken, studyReportQuery.PatientDFN, studyReportQuery.PatientICN, studyReportQuery.SiteNumber);

            return (!string.IsNullOrEmpty(studyMetadata)) ? VixTextParser.Parse(studyMetadata) : null;
        }

        public static List<DisplayObjectGroup> GetDisplayObjectGroups(VistAQuery vistaQuery, out int imageCount)
        {
            imageCount = 0;

            string studyMetadata = GetStudyMetadata(vistaQuery);
            if (string.IsNullOrEmpty(studyMetadata))
                throw new BadRequestException("No study metadata found for ContextId {0}", vistaQuery.ContextId);

            var displayObjectCollection = DisplayObjectParser.Parse(studyMetadata);

            if (displayObjectCollection != null)
                foreach (var displayObject in displayObjectCollection)
                    imageCount += displayObject.Items.Count;

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("DisplayObjectCollection created.", "ImageCount", imageCount);

            return displayObjectCollection;
        }

        public static List<DisplayObjectGroup> GetDisplayObjectGroups(string contextId, string patientICN, string patientDFN, string siteNumber, string vixJavaSecurityToken)
        {
            string studyMetadata = GetStudyMetadata(contextId, patientICN, patientDFN, siteNumber, vixJavaSecurityToken);
            if (string.IsNullOrEmpty(studyMetadata))
                throw new BadRequestException("No study metadata found for ContextId {0}", contextId);

            var displayObjectCollection = DisplayObjectParser.Parse(studyMetadata);

            return displayObjectCollection;
        }

        private static string GetStudyMetadata(VistAQuery vistaQuery)
        {
            return GetStudyMetadata(vistaQuery.ContextId, vistaQuery.PatientICN, vistaQuery.PatientDFN, vistaQuery.SiteNumber, vistaQuery.VixJavaSecurityToken, vistaQuery.VixTimeout);
        }

        private static string GetStudyMetadata(string contextId, string patientICN, string patientDFN, string siteNumber, string vixJavaSecurityToken, int vixTimeout = 0)
        {
            var vixClient = CreateClient(LocalVix);

            string studyMetadata = vixClient.GetStudyMetadata(null, contextId, vixJavaSecurityToken, patientDFN, patientICN, siteNumber);

            return studyMetadata;
        }

        public static string GetVixViewerSecurityToken(IUserIdentity userIdentity)
        {
            if (userIdentity.Claims == null)
                return null;
            //Commented out until we use key|value
            //string key = "SecurityToken|";
            //foreach (string s in userIdentity.Claims)
            //{
            //    if (s.StartsWith(key))
            //        return s.Substring(key.Length);
            //}
            //return "";
            return userIdentity.Claims.FirstOrDefault();
        }

        // get the encrypted VIX Java security token (that contains the VistA BSE token) using the configured local VIX Java server
        public static string GetVixJavaSecurityToken(string appName, string username, string password)
        {
            var vixServer = LocalVix;
            var vixClient = new VixClient(vixServer.RootUrl, username, password, vixServer.Flavor);
            VixHeaders vixHeaders = null;
            if (!string.IsNullOrEmpty(appName))
            {
                var dict = new Dictionary<string, IEnumerable<string>>();
                dict["xxx-appname"] = new List<string>() { appName };
                vixHeaders = new VixHeaders(dict);
            }

            return vixClient.GetVixJavaSecurityToken(vixHeaders);
        }

        // get security token from VIX Java service that uses VistA authentication based on access and verify codes 
        private static string GetVixJavaSecurityToken(string accessCode, string verifyCode)
        {
            var vixClient = new VixClient(LocalVix.RootUrl,
                                          accessCode,
                                          verifyCode,
                                          LocalVix.Flavor);

            return vixClient.GetVixJavaSecurityToken(null);
        }

        public static void GetImage(ImageQuery imageQuery, Stream outputStream)
        {
            try
            {
                if (imageQuery.IsSensitive)
                {
                    Resources.magsensitive.Save(outputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                }
                else
                {
                    var vixClient = CreateClient(LocalVix);
                    string imageUrn = null;

                    if (!string.IsNullOrEmpty(imageQuery.ContextId))
                        imageUrn = Util.Base64Decode(imageQuery.ContextId);
                    else
                    {
                        imageUrn = "";

                        if (!string.IsNullOrEmpty(imageQuery.ImageURN))
                            imageUrn += "imageURN=" + imageQuery.ImageURN;

                        if (!string.IsNullOrEmpty(imageQuery.ImageQuality))
                            imageUrn += "&imageQuality=" + imageQuery.ImageQuality;

                        if (!string.IsNullOrEmpty(imageQuery.ContentType))
                            imageUrn += "&contentType=" + imageQuery.ContentType;

                        if (!string.IsNullOrEmpty(imageQuery.ContentTypeWithSubType))
                            imageUrn += "&contentTypeWithSubType=" + imageQuery.ContentTypeWithSubType;

                        imageUrn = imageUrn.TrimStart('&');
                    }

                    vixClient.GetImage(imageUrn, imageQuery.VixJavaSecurityToken, null, outputStream, _ImageRequestTimeout, _ImageRequestRetryCount);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static Stream GetImage(string imageUrn, string securityToken, string transactionUid)
        {
            var vixClient = new VixClient(LocalVix.RootUrl, LocalVix.Flavor);
            var memoryStream = new MemoryStream();

            vixClient.GetImage(imageUrn, securityToken, transactionUid, memoryStream, _ImageRequestTimeout, _ImageRequestRetryCount);
            memoryStream.Seek(0, SeekOrigin.Begin);

            return memoryStream;
        }

        public static string GetImageCacheLocation(string imageUrn, string securityToken, string transactionUid)
        {
            var vixClient = new VixClient(LocalVix.RootUrl, LocalVix.Flavor);
            return vixClient.GetImageCacheLocation(imageUrn, securityToken, transactionUid, _ImageRequestTimeout, _ImageRequestRetryCount);
        }

        private static TimeSpan GetTimeoutTimeSpan()
        {
            if (SecurityTokenTimeoutType == SecurityTokenTimeoutType.UntilMidnight)
            {
                return DateTime.Today.ToUniversalTime().AddDays(1).Subtract(DateTime.UtcNow);
            }
            else
            {
                if (VistAConfigurationSection.Instance.SecurityTokenTimeout <= 0)
                    return TimeSpan.FromMinutes(30);
                else
                    return TimeSpan.FromMinutes(VistAConfigurationSection.Instance.SecurityTokenTimeout);
            }
        }

        public static void Authenticate(VistAQuery vistaQuery)
        {
            if (string.IsNullOrEmpty(vistaQuery.SecurityToken) ||
                (_EnablePromiscuousMode && (vistaQuery.VixHeaders != null) && (vistaQuery.VixHeaders.IsValid)))
            {
                if (string.IsNullOrEmpty(vistaQuery.VixJavaSecurityToken) || _EnablePromiscuousMode)
                {
                    if (string.IsNullOrEmpty(vistaQuery.ApiToken))
                    {
                        var vixClient = CreateClient(LocalVix);
                        vistaQuery.VixJavaSecurityToken = vixClient.GetVixJavaSecurityToken(vistaQuery.VixHeaders);

                        if (vistaQuery.VixHeaders.Contains(VixHeaderName.DUZ))
                            vistaQuery.UserId = vistaQuery.VixHeaders.GetValue(VixHeaderName.DUZ);
                    }
                    else
                    {
                        // authenticate using api token
                        SecurityToken apiToken;
                        if (!SecurityToken.TryParse(vistaQuery.ApiToken, out apiToken))
                            throw new BadRequestException("Api token is not valid");

                        if (apiToken.IsExpired)
                        {
                            // this is useful when using postman. You can open urls sent by others if you pass your security header
                            throw new TokenExpiredException();
                        }
                        vistaQuery.VixJavaSecurityToken = apiToken.Data;
                        vistaQuery.AccessContext = apiToken.UserId;
                        // no user context for now
                        vistaQuery.UserId = "";
                    }
                }
                else
                {
                    // todo: get user id from VixSecurity token ************* WHY WASN'T THIS DONE? DO WE NEED IT?????????????????????
                }

                vistaQuery.SecurityToken = SecurityToken.GenerateVixViewerSecurityToken(vistaQuery.UserId, vistaQuery.VixJavaSecurityToken, GetTimeoutTimeSpan());
                SecurityUtil.CreateUserSession(vistaQuery.SecurityToken, vistaQuery.UserId, vistaQuery.UserHostAddress);
            }
            else
            {
                SecurityToken securityToken;
                if (!SecurityToken.TryParse(vistaQuery.SecurityToken, out securityToken))
                    throw new BadRequestException("Security token is invalid");

                if (!securityToken.IsExpired)
                {
                    vistaQuery.VixJavaSecurityToken = securityToken.Data;
                    vistaQuery.UserId = securityToken.UserId;
                }
                else
                {
                    // this is useful when using postman. You can open urls send by others if you pass your 
                    // security header

                    throw new TokenExpiredException();
                }
            }
        }

        public static void RenewToken(VistAQuery vistaQuery)
        {
            // make sure token is valid
            Authenticate(vistaQuery);

            // generate new token with new tokenId and expiration time
            string previousToken = vistaQuery.SecurityToken;
            vistaQuery.SecurityToken = SecurityToken.GenerateVixViewerSecurityToken(vistaQuery.UserId, vistaQuery.VixJavaSecurityToken, GetTimeoutTimeSpan());
            _ = SecurityToken.TryParse(vistaQuery.SecurityToken, out SecurityToken securityToken);
            SessionManager.Instance.ReplaceSecurityToken(previousToken, securityToken);
        }

        public static VixUrlFormatter CreateUrlFormatter(VistAQuery vistaQuery)
        {
            string rootUrl = null;

            if (ViewerVix != null)
            {
                // get viewer associated with the logged in site
                if ((SiteServiceVix != null) && (!string.IsNullOrEmpty(vistaQuery.AuthSiteNumber)))
                    rootUrl = SiteServiceUtil.GetViewerUrl(SiteServiceVix.RootUrl, vistaQuery.AuthSiteNumber);

                if (PolicyUtil.IsPolicyEnabled("Viewer.RedirectUrlsToSelf"))
                    rootUrl = null; // point all urls to itself

                if (string.IsNullOrEmpty(rootUrl))
                {
                    rootUrl = vistaQuery.HostRootUrl; // contains viewer root path

                    if (!string.IsNullOrEmpty(ViewerVix.PublicHostName))
                    {
                        // replace with public hostname
                        var uribuilder = new UriBuilder(rootUrl);
                        uribuilder.Host = ViewerVix.PublicHostName;
                        rootUrl = uribuilder.Uri.ToString();
                    }
                }
                else
                {
                    rootUrl = rootUrl.TrimEnd(new[] { '/', '\\' }) + @"/" + VixRootPath.ViewerRootPath;
                }
            }

            return new VixUrlFormatter(vistaQuery, rootUrl);
        }

        internal static void FormatUrl(StudyDetailsQuery studyDetailsQuery, StudyDetails studyDetails)
        {
            var urlFormatter = CreateUrlFormatter(studyDetailsQuery);
            urlFormatter.FormatUrl(studyDetails);
        }

        public static string GetImagingData(MetadataQuery metadataQuery)
        {
            var vixClient = CreateClient(LocalVix);

            string devFields = string.Empty;
            string globalNodes = string.Empty;

            try
            {
                devFields = vixClient.GetDevFields(metadataQuery.ImageUrn, metadataQuery.VixJavaSecurityToken, null);
            }
            catch (Exception)
            {
                devFields = "Error getting Dev Fields. Please see log for details";
            }

            try
            {
                globalNodes = vixClient.GetGlobalNodes(metadataQuery.ImageUrn, metadataQuery.VixJavaSecurityToken);
            }
            catch (Exception)
            {
                devFields = "Error getting Global Nodes. Please see log for details";
            }

            return string.Format("{0}\r\n\r\n{1}", devFields, globalNodes);
        }

        internal static void CheckServerStatus(IEnumerable<StudyItemGroup> studyItemGroups)
        {
            // reset server availability status
            foreach (var studyItemGroup in studyItemGroups)
            {
                studyItemGroup.IsServerAvailable = null;
                studyItemGroup.IsBulkStudyQuerySupported = null;
            }

            if (SiteServiceVix != null)
            {
                SiteServiceUtil.GetServiceStatus(SiteServiceVix.RootUrl, studyItemGroups);
            }
        }

        public static Hydra.Common.Entities.StudyPresentationState[] GetPresentationStateRecords(VistAQuery vistaQuery,
                                                                                                 Func<Dictionary<string, string>> fetchExternalIdMap)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            string text = null;
            var psList = new List<Hydra.Common.Entities.StudyPresentationState>();

            try
            {
                // get viewer annotations
                text = vixClient.GetPStateRecords(vistaQuery.ContextId, vistaQuery.VixJavaSecurityToken, true, true);
                if (!string.IsNullOrEmpty(text))
                {
                    var items = PStateParser.Parse(text);
                    if (items != null)
                        psList.AddRange(items);
                }
            }
            catch (Exception) { }

            try
            {
                // get VRad and Clinical annotations and convert to viewer format
                text = vixClient.GetOtherPStateInformation(vistaQuery.ContextId, vistaQuery.VixJavaSecurityToken);
                if (!string.IsNullOrEmpty(text))
                {
                    if (PStateParser.HasOtherAnnotations(text))
                    {
                        // create a map from image IEN to image Uid
                        // Note: VRad and ClinDisp use image IEN to indentify an image. 
                        Dictionary<string, string> externalIdMap = (fetchExternalIdMap != null) ? fetchExternalIdMap() : null;

                        PStateParser.ParseOther(vistaQuery.ContextId, text, psList, externalIdMap, vistaQuery.UserId);
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error parsing other PS data.", "Exception", ex.ToString());
            }


            if (psList.Count == 0)
                return null;

            // set description using user duz and timestamp
            var idMap = new Dictionary<string, string>();
            foreach (var item in psList)
            {
                if (!idMap.ContainsKey(item.UserId))
                {
                    try
                    {
                        // get user initials  or full name or user id
                        text = vixClient.GetUserDetails(item.UserId, vistaQuery.AuthSiteNumber, vistaQuery.VixJavaSecurityToken);
                        var userDetails = new Hydra.Web.Common.UserDetails()
                        {
                            Id = item.UserId
                        };

                        StudyMetadataParser.ParseUserDetails(text, userDetails);
                        idMap[item.UserId] = !string.IsNullOrEmpty(userDetails.Initials) ?
                            userDetails.Initials :
                            !string.IsNullOrEmpty(userDetails.Name) ?
                                userDetails.Name :
                                userDetails.Id;
                    }
                    catch (Exception)
                    {
                        // failed to fetch user details. use user id
                        idMap[item.UserId] = item.UserId;
                    }
                }

                if (item.IsExternal)
                {
                    var appendTimeStamp = String.IsNullOrEmpty(item.DateTime) ? "--/--/----" : item.DateTime;
                    item.Description = string.Format("{0} - {1} {2}", idMap[item.UserId], item.Source, appendTimeStamp);
                }
                else
                {
                    item.Description = string.Format("{0} - {1}", idMap[item.UserId], item.DateTime);
                }

                if (string.IsNullOrEmpty(item.Tooltip) && vistaQuery.SiteNumber != null)
                {
                    item.Tooltip = "Site: " + vistaQuery.SiteNumber;
                    item.Tooltip += "\nService: ";
                }
            }

            return psList.ToArray();
        }

        public static void AddUpdatePresentationStateRecord(VistAQuery vistaQuery, Hydra.Common.Entities.StudyPresentationState presentationState, string pstateFilePath)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);
            vixClient.AddPStateRecord(vistaQuery.ContextId,
                                      presentationState.Id,
                                      presentationState.Description,
                                      "VIX VIEWER SERVICE",
                                      presentationState.Data,
                                      vistaQuery.VixJavaSecurityToken, pstateFilePath);
        }

        public static void DeletePresentationStateRecord(VistAQuery vistaQuery, Hydra.Common.Entities.StudyPresentationState presentationState)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);
            vixClient.DeletePStateRecord(vistaQuery.ContextId,
                                         presentationState.Id,
                                         vistaQuery.VixJavaSecurityToken);
        }

        public static Hydra.Web.Common.DisplayContextMetadata GetDisplayContextMetadata(VistAQuery vistaQuery)
        {
            string studyMetadata = GetStudyMetadata(vistaQuery);
            if (string.IsNullOrEmpty(studyMetadata))
                throw new BadRequestException("No study metadata found for ContextId {0}", vistaQuery.ContextId);

            var metadata = new Hydra.Web.Common.DisplayContextMetadata();
            StudyMetadataParser.ParseDisplayContextMetadata(studyMetadata, metadata);

            if (!string.IsNullOrEmpty(vistaQuery.SiteNumber) &&
                !string.IsNullOrEmpty(vistaQuery.AuthSiteNumber) &&
                (string.Compare(vistaQuery.AuthSiteNumber, vistaQuery.SiteNumber, true) == 0))
            {
                // site number and auth site numbar match. the user is allowed to delete or edit images 
                var userDetails = GetUserDetails(vistaQuery);
                if (userDetails != null)
                {
                    metadata.CanDelete = userDetails.CanDelete;
                    metadata.CanEdit = userDetails.CanEdit;
                    metadata.CanPrint = userDetails.CanPrint;
                }
            }

            return metadata;
        }

        public static Hydra.Web.Common.UserDetails GetUserDetails(VistAQuery vistaQuery)
        {
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Get user details based on vistaQuery.");

            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);
            string text = vixClient.GetUserDetails(vistaQuery.UserId, vistaQuery.AuthSiteNumber, vistaQuery.VixJavaSecurityToken, vistaQuery.VixHeaders);

            if (_Logger.IsTraceEnabled)
                _Logger.Trace("Get user details based on vistaQuery complete.", "text", text);

            // for now simply return the user id embedded in the security token
            var userDetails = new Hydra.Web.Common.UserDetails
            {
                Id = vistaQuery.UserId
            };

            StudyMetadataParser.ParseUserDetails(text, userDetails);

            return userDetails;
        }

        public static Hydra.Web.Common.UserDetails GetUserDetails(string vixViewerSecurityToken)
        {
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Get user details based on vixViewerSecurityToken.");

            var vixClient = CreateClient(LocalVix);
            string text = vixClient.GetUserDetails(null, null, vixViewerSecurityToken, null);

            if (_Logger.IsTraceEnabled)
                _Logger.Trace("Get user details based on vixViewerSecurityToken complete.", "text", text);

            // for now simply return the user id embedded in the security token
            var userDetails = new Hydra.Web.Common.UserDetails
            {
            };

            StudyMetadataParser.ParseUserDetails(text, userDetails);

            return userDetails;
        }


        public static Hydra.Web.Common.ImageDeleteResponse[] DeleteImageMetadata(VistAQuery vistaQuery, Hydra.Web.Common.ImageDeleteRequest request)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            string response = vixClient.DeleteImages(request.ImageIds.ToArray(), request.Reason, vistaQuery.SiteNumber, vistaQuery.VixJavaSecurityToken, vistaQuery.VixHeaders);

            return StudyMetadataParser.ParseImageDeleteResponse(response);
        }

        public static Hydra.Common.FileType DetectFileType(string imageUrn)
        {
            if (!string.IsNullOrEmpty(imageUrn))
            {
                imageUrn = imageUrn.ToLower();

                if (imageUrn.Contains("application/dicom"))
                    return Hydra.Common.FileType.Dicom;

                if (imageUrn.Contains("application/pdf"))
                    return Hydra.Common.FileType.Document_Pdf;

                if (imageUrn.Contains("video/x-msvideo"))
                    return Hydra.Common.FileType.Video_Avi;

                if (imageUrn.Contains("audio/x-wav"))
                    return Hydra.Common.FileType.Audio_Wav;

                if (imageUrn.Contains("application/msword"))
                    return Hydra.Common.FileType.Document_Word;

                if (imageUrn.Contains("text/xml"))
                    return Hydra.Common.FileType.Document_CDA;

                if (imageUrn.Contains("text/rtf"))
                    return Hydra.Common.FileType.RTF;

                if (imageUrn.Contains("text/plain"))
                    return Hydra.Common.FileType.TXT;

                if (imageUrn.Contains("image/jpeg") ||
                    imageUrn.Contains("image/tiff") ||
                    imageUrn.Contains("image/bmp"))
                    return Hydra.Common.FileType.Image;
            }

            return Hydra.Common.FileType.Unknown;
        }

        public static string GetViewerUrl(string siteNumber, string alternateUrl)
        {
            string url = null;

            // get viewer associated with the site
            if (SiteServiceVix != null)
                url = SiteServiceUtil.GetViewerUrl(SiteServiceVix.RootUrl, siteNumber);

            return (string.IsNullOrEmpty(url)) ? alternateUrl : url;
        }

        public static void SensitiveImageMetadata(VistAQuery vistaQuery, Hydra.Web.Common.SensitiveImageRequest request)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            vixClient.SensitiveImages(request.ImageIds.ToArray(), request.IsSensitive, vistaQuery.SiteNumber, vistaQuery.VixJavaSecurityToken, vistaQuery.VixHeaders);
        }

        private static VixService GetSiteVixService(string siteNumber)
        {
            var vixServer = LocalVix;

            if (!string.IsNullOrEmpty(siteNumber) && (SiteServiceVix != null))
            {
                var siteVixUrl = SiteServiceUtil.GetSiteVixUrl(SiteServiceVix.RootUrl, siteNumber);
                if (siteVixUrl != null)
                {
                    vixServer = new VixService
                    {
                        RootUrl = siteVixUrl,
                        Flavor = LocalVix.Flavor // use local site vix flavor
                    };
                }
            }

            return vixServer;
        }

        public static List<string> GetImageDeleteReasons(VistAQuery vistaQuery)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            return vixClient.GetImageDeleteReasons(vistaQuery.VixJavaSecurityToken);
        }

        public static bool VerifyElectronicSignature(string siteNumber, string eSignature, string vixViewerSecurityToken)
        {
            var vixServer = GetSiteVixService(siteNumber);
            var vixClient = CreateClient(vixServer);

            var text = vixClient.VerifyElectronicSignature(eSignature, siteNumber, vixViewerSecurityToken);
            if (string.IsNullOrEmpty(text))
                return false;

            // response is an xml string. simple search for 'true', instead of parsing as xml.
            return (text.ToLower().Contains("true"));
        }

        public static bool LogImageExport(string siteNumber, string imageUrn, string reason, string vixViewerSecurityToken)
        {
            var vixServer = GetSiteVixService(siteNumber);
            var vixClient = CreateClient(vixServer);

            var text = vixClient.LogImageExport(siteNumber, imageUrn, reason, vixViewerSecurityToken, null);
            if (string.IsNullOrEmpty(text))
                return false;

            // response is an xml string. simple search for 'true', instead of parsing as xml.
            return (text.ToLower().Contains("true"));
        }

        public static void StorePreference(VistAQuery vistaQuery, string level, string name, string value)
        {
            var vixServer = GetSiteVixService(vistaQuery.AuthSiteNumber);
            var vixClient = CreateClient(vixServer);

            vixClient.StorePreference(name, value, vistaQuery.UserId, IsSystemLevel(level), vistaQuery.VixJavaSecurityToken);
        }

        public static void DeletePreference(VistAQuery vistaQuery, string level, string name)
        {
            var vixServer = GetSiteVixService(vistaQuery.AuthSiteNumber);
            var vixClient = CreateClient(vixServer);
        }

        private static bool IsSystemLevel(string level)
        {
            return string.Compare(level, "SYS", true) == 0;
        }

        public static string RetrievePreference(VistAQuery vistaQuery, string level, string name)
        {
            var vixServer = GetSiteVixService(vistaQuery.AuthSiteNumber);
            var vixClient = CreateClient(vixServer);

            string value = vixClient.RetrievePreference(name, vistaQuery.UserId, IsSystemLevel(level), vistaQuery.VixJavaSecurityToken);

            return UserPreferenceParser.Parse(value);
        }

        public static List<string> GetPrintReasons(VistAQuery vistaQuery)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            return vixClient.GetPrintReasons(vistaQuery.VixJavaSecurityToken);
        }

        public static Hydra.Entities.Patient GetPatientInformation(VistAQuery vistaQuery)
        {
            try
            {
                var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
                var vixClient = CreateClient(vixServer);

                string text = vixClient.GetPatientInformation(vistaQuery.PatientICN, vistaQuery.PatientDFN, vistaQuery.SiteNumber, vistaQuery.VixJavaSecurityToken, null);

                return PatientInformationParser.Parse(text);
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static IEnumerable<ROIStatusItem> GetROIStatus(ROIQuery roiQuery)
        {
            try
            {
                var vixServer = GetSiteVixService(roiQuery.SiteNumber);
                var vixClient = CreateClient(vixServer);

                string text = vixClient.GetROIStatus(roiQuery.PatientICN, roiQuery.PatientDFN, roiQuery.SiteNumber, roiQuery.VixJavaSecurityToken, null);

                return ROIParser.Parse(text);
            }
            catch (Exception)
            {
                return null;
            }

        }

        public static IEnumerable<VixSite> GetTreatingFacilities(VistAQuery vistaQuery)
        {
            try
            {
                var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
                var vixClient = CreateClient(vixServer);

                string text = vixClient.GetTreatingFacilities(vistaQuery.PatientICN, vistaQuery.PatientDFN, vistaQuery.SiteNumber, vistaQuery.VixJavaSecurityToken, null);

                return TreatingFacilitiesParser.Parse(text);
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static string GetVixVersion()
        {
            try
            {
                var vixClient = CreateClient(LocalVix);

                string text = vixClient.GetVixVersion();
                return VixTextParser.ParseVersion(text);
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static string GetCDBurners(VistAQuery vistaQuery)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            return vixClient.GetCDBurners(vistaQuery.VixJavaSecurityToken);
        }

        public static string SubmitROIRequest(ROISubmitQuery roiSubmitQuery)
        {
            var vixServer = GetSiteVixService(roiSubmitQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            return vixClient.SubmitROIRequest(roiSubmitQuery.PatientICN, roiSubmitQuery.SiteNumber, roiSubmitQuery.Studies.Select(p => p.GroupIEN).ToList(), roiSubmitQuery.Target, roiSubmitQuery.VixJavaSecurityToken);
        }

        public static string GetCaptureUsers(VistAQuery vistaQuery, string fromDate, string throughDate)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            return vixClient.GetCaptureUsers(vistaQuery.VixJavaSecurityToken, fromDate, throughDate);
        }

        public static string GetImageFilters(VistAQuery vistaQuery, string userId)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            return vixClient.GetImageFilters(vistaQuery.VixJavaSecurityToken, userId);
        }

        public static string GetImageFilterDetails(VistAQuery vistaQuery, string filterIEN)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            return vixClient.GetImageFilterDetails(vistaQuery.VixJavaSecurityToken, filterIEN);
        }

        public static string SetImageProperties(VistAQuery vistaQuery, dynamic imgArgs)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            return vixClient.SetImageProperties(vistaQuery.VixJavaSecurityToken, imgArgs);
        }

        public static string GetImageProperties(VistAQuery vistaQuery, string imageIEN)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            return vixClient.GetImageProperties(vistaQuery.VixJavaSecurityToken, imageIEN);
        }

        public static string SearchStudy(VistAQuery vistaQuery, string siteId, string studyFilter)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            return vixClient.SearchStudy(vistaQuery.VixJavaSecurityToken, siteId, studyFilter);
        }

        public static string GetQAReviewReportStat(VistAQuery vistaQuery, string flags, string fromDate, string throughDate)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            return vixClient.GetQAReviewReportStat(vistaQuery.VixJavaSecurityToken, flags, fromDate, throughDate);
        }

        public static string GetQAReviewReports(VistAQuery vistaQuery, string userId)
        {
            var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
            var vixClient = CreateClient(vixServer);

            return vixClient.GetQAReviewReports(vistaQuery.VixJavaSecurityToken, userId);
        }

        public static void DownloadDisclosure(VistAQuery vistaQuery, string patientId, string guid, Stream outputStream)
        {
            try
            {
                var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
                var vixClient = CreateClient(vixServer);

                vixClient.DownloadDisclosure(vistaQuery.VixJavaSecurityToken, patientId, guid, outputStream);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static dynamic GetImageEditOptions(VistAQuery vistaQuery, string indexes)
        {
            try
            {
                var vixServer = GetSiteVixService(vistaQuery.SiteNumber);
                var vixClient = CreateClient(vixServer);

                return vixClient.GetImageEditOptions(vistaQuery.VixJavaSecurityToken, indexes);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Get the PDF URL, if any, for a Context ID
        /// </summary>
        /// <param name="contextId"></param>
        /// <returns>the URL if one was found</returns>
        /// <remarks>Created for VAI-1284</remarks>
        public static string GetPdfFileUrl(string contextId)
        {
            var hixConnection = Hydra.IX.Client.HixConnectionFactory.Create();
            return hixConnection.RequestServePdfUrl(contextId);
        }

        /// <summary>
        /// Get the authenticated user (if any).
        /// </summary>
        /// <param name="securityToken">The VIX Viewer Security Token</param>
        /// <returns>The user if he is*, false if he isn't.</returns>
        /// <remarks>*TODO - This is a known defect discovered in P254. It does not work with load balancers (CVIX). Pending Management decision.</remarks>
        public static IUserIdentity GetAuthenticatedUser(string securityToken)
        {
            if (string.IsNullOrWhiteSpace(securityToken))
                return null;

            //P254 used this (which did not always work):
            //  userIdentity = (UserIdentity)cache[$"{userName}:{password}"];
            //  ObjectCache cache = MemoryCache.Default;
            //  return (IUserIdentity)cache[securityToken];
            //P269 uses the security token for the key that we get when we login the user. See Authenticate(). VAI-707.
            return SessionManager.Instance.GetUserIdentity(securityToken);
        }

        /// <summary>
        /// Authenticate the user and add currentUser to Session Cache.
        /// </summary>
        /// <param name="userName">userName credential</param>
        /// <param name="password">password credential</param>
        /// <param name="clientIpAddress">The client's IP address (which is not the actual one since X-Forwarded-For header is not being used by Ops)</param>
        /// <returns></returns>
        /// <remarks>VAI-707: moved here from UserValidator.Validate() and modified. Split into IsAuthenticated.</remarks>
        public static UserIdentity Authenticate(string userName, string password, string clientIpAddress)
        {
            _Logger.TraceOrDebugIfEnabled("Authenticate with credentials.", userName, CryptoUtil.EncryptAES(password));

            //Call VIX Java server to authenticate the user in VistA. If successful, create our user and store in the session cache.
            UserIdentity currentUser = new UserIdentity
            {
                HttpStatusCode = Nancy.HttpStatusCode.OK,
                UserName = userName
            };

            try
            {
                string vixJavaSecurityToken;
                Web.Common.UserDetails userDetails = null;
                vixJavaSecurityToken = GetVixJavaSecurityToken(userName, password);
                if (string.IsNullOrEmpty(vixJavaSecurityToken))
                    throw new Exception("Error fetching VIX Java security token.");
                _Logger.TraceOrDebugIfEnabled("VistA authenticated.", "VIX Java Security Token", vixJavaSecurityToken);
                userDetails = GetUserDetails(vixJavaSecurityToken);
                if (userDetails != null)
                {
                    //VAI-884: If we have the user details get the security token
                    string userDetailsId = string.IsNullOrEmpty(userDetails.Id) ? userName : userDetails.Id;
                    string vixViewerSecurityToken = SecurityToken.GenerateVixViewerSecurityToken(userDetailsId, vixJavaSecurityToken, GetTimeoutTimeSpan());
                    SessionManager.Instance.AddUserSession(vixViewerSecurityToken, userDetailsId, currentUser, clientIpAddress);
                }
            }
            catch (Exception ex)
            {
                currentUser.HttpStatusCode = Nancy.HttpStatusCode.Unauthorized;
                currentUser.Message = ex.Message;
            }

            return currentUser;
        }

        //VAI-707: Asked Ops to add this, but they won't, which means two people running on the dev/test server will collide if ip is a key
        //VAI-707: ***TODO: Leave commented out until Ops abides.***
        #region OpsAbide
        //public static string GetIpAddress()
        //{
        //    var request = HttpContext.Current.Request;
        //    // Look for a proxy address first
        //    var ip = request.ServerVariables["HTTP_X_FORWARDED_FOR"];

        //    // If there is no proxy, get the standard remote address
        //    if (string.IsNullOrWhiteSpace(ip)
        //        || string.Equals(ip, "unknown", StringComparison.OrdinalIgnoreCase))
        //        ip = request.ServerVariables["REMOTE_ADDR"];
        //    else
        //    {
        //        //extract first IP
        //        var index = ip.IndexOf(',');
        //        if (index > 0)
        //            ip = ip.Substring(0, index);

        //        //remove port
        //        index = ip.IndexOf(':');
        //        if (index > 0)
        //            ip = ip.Substring(0, index);
        //    }

        //    return ip;
        //}
        #endregion OpsAbide
    }
}
