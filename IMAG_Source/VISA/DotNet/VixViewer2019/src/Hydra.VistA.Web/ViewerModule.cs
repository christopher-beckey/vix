using Hydra.Common; //VAI-707
using Hydra.Common.Exceptions;
using Hydra.Log;
using Hydra.Security; //VAI-707
using Hydra.VistA.Commands;
using Hydra.Web;
using Hydra.Web.Contracts;
using Nancy;
using Nancy.Extensions;
using Nancy.Helpers;
using Nancy.ModelBinding;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Text;

using HWM = Hydra.Web.Modules; //VAI-1284

namespace Hydra.VistA.Web
{
    /// <summary>
    /// Web API
    /// </summary>
    public class ViewerModule : VistAModule
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        private enum SessionRequest
        {
            AddDisplayContext,
            RemoveDisplayContext,
            GetDisplayContextStatus
        };

        public ViewerModule(IHydraParentContext ctx) : base(HydraConfiguration.ViewerRoutePrefix)
        {
            AddPost(VixRootPath.StudyQuery, _ => GetStudyListQueryResponse());

            AddGet(VixRootPath.StudyDetails, _ => GetStudyDetails());

            AddGet(VixRootPath.StudyReport, _ => GetStudyReport());

            AddPost(VixRootPath.StudyCache, _ => CacheStudy(ctx));

            AddGet(VixRootPath.Thumbnails, _ => GetThumbnailImageQueryResponse(ctx));

            AddGet(VixRootPath.ServePdf, _ => GetServedPdfUrl(ctx)); //VAI-1284

            AddGet(VixRootPath.Images, _ => GetImageResponse(ctx));

            AddGet(VixRootPath.Ping, _ => GetPingResponse());

            AddGet(VixRootPath.Token, _ => GetToken());
            AddGet(VixRootPath.Token2, _ => GetToken2());

            AddGet(VixRootPath.SecurityToken, _ => GetSecurityToken());

            AddGet("/site/{siteId}/session/{sessionId}/status", parameters => HandleSessionRequest(SessionRequest.GetDisplayContextStatus, parameters.siteId, parameters.sessionId));

            AddPost("/site/{siteId}/session/{sessionId}/context", parameters => HandleSessionRequest(SessionRequest.AddDisplayContext, parameters.siteId, parameters.sessionId));

            AddDelete("/site/{siteId}/session/{sessionId}/context", parameters => HandleSessionRequest(SessionRequest.RemoveDisplayContext, parameters.siteId, parameters.sessionId));

            AddGet("/site/{siteId}/esignature/{eSignature}/verify", parameters => VerifyESignature(parameters.siteId, parameters.eSignature));

            AddGet("/site/{siteId}/logexport", parameters => LogImageExport(parameters.siteId));
        }

        private string ViewerRootUrl
        {
            get
            {
                return RootUrl + "/" + HydraConfiguration.ViewerRoutePrefix;
            }
        }

        private new dynamic FormatAsJson(object response)
        {
            return this.Response.AsText(JsonConvert.SerializeObject(response, 
                                                                    Formatting.Indented, 
                                                                    new JsonSerializerSettings 
                                                                    { 
                                                                        NullValueHandling = NullValueHandling.Ignore,
                                                                        ContractResolver = new CamelCasePropertyNamesContractResolver()
                                                                    }), 
                                                                    "application/json");
        }

        private dynamic GetPingResponse()
        {
            return Ok();
        }

        private dynamic GetStudyListQueryResponse()
        {
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Received study query request.", "Request", this.Request.Body.AsString());
                var request = this.BindRequest<StudyQuery>(true);
                if ((request == null) || !request.IsValid())
                    throw new BadRequestException("Invalid study query request.");

                //VAI-703 TODO:Call AuthenticateMe which sets UserHostAddress (see BaseModule)
                //and if fails, show login page
                //but if succeeds, model.BaseViewerUrl = authParts.ReturnToUrl;
                request.UserHostAddress = Util.GetHostAddressNoSuffix(Request.UserHostAddress);
                StudyQueryCommand.Execute(request);

                return FormatAsJson(request);
            }
            catch (Exception ex)
            {
                return CreateResponse(ex);
            }
        }

        private dynamic GetStudyDetails()
        {
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Received study details request.", "Request", this.Request.Body.AsString());
                var request = this.BindRequest<StudyDetailsQuery>();
                if ((request == null) || !request.IsValid)
                    throw new BadRequestException("Invalid study details request.");

                //VAI-703 TODO:Call AuthenticateMe which sets UserHostAddress (see BaseModule)
                //and if fails, show login page
                //but if succeeds, model.BaseViewerUrl = authParts.ReturnToUrl;
                request.UserHostAddress = Util.GetHostAddressNoSuffix(Request.UserHostAddress); //VAI-
                var studyDetails = GetStudyDetailsCommand.Execute(request);

                return FormatAsJson(studyDetails);
            }
            catch (Exception ex)
            {
                return CreateResponse(ex);
            }
        }

        private dynamic GetStudyReport()
        {
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Received study report request.", "Request", this.Request.Body.AsString());
                var request = this.BindRequest<StudyReportQuery>();
                if ((request == null) || !request.IsValid)
                    throw new BadRequestException("Invalid study report request.");

                //VAI-703 TODO:Call AuthenticateMe which sets UserHostAddress (see BaseModule)
                //and if fails, show login page
                //but if succeeds, model.BaseViewerUrl = authParts.ReturnToUrl;
                request.UserHostAddress = Util.GetHostAddressNoSuffix(Request.UserHostAddress);
                var studyDetails = GetStudyReportCommand.Execute(request);

                return this.Response.AsText(studyDetails, "text/plain");
            }
            catch (Exception ex)
            {
                return CreateResponse(ex);
            }
        }

        //VAI-707: Get the ImageUid from the URL parameters
        private string GetImageUid()
        {
            Dictionary<string, object> requestParams = (Request.Query as DynamicDictionary).ToDictionary();
            if (requestParams == null)
                return null;

            foreach (KeyValuePair<string, object> kvp in requestParams)
            {
                if (kvp.Key == "ImageUid")
                    return kvp.Value.ToString();
            }
            return null;
        }

        private dynamic GetThumbnailImageQueryResponse(IHydraParentContext ctx)
        {
            try
            {
                var request = this.Bind<ImageQuery>();
                if ((request == null) || !request.IsValid)
                    throw new BadRequestException("Invalid thumbnail image query request.");

                //VAI-707
                if (string.IsNullOrWhiteSpace(request.ImageURN))
                    request.ImageURN = ctx.GetImageUrn(GetImageUid());

                //VAI-703 TODO:Call AuthenticateMe which sets UserHostAddress (see BaseModule)
                //and if fails, show login page
                //but if succeeds, model.BaseViewerUrl = authParts.ReturnToUrl;
                request.UserHostAddress = Util.GetHostAddressNoSuffix(Request.UserHostAddress);
                return new Response
                {
                    Contents = stream =>
                    {
                        GetImageCommand.Execute(request, stream);
                    },
                    ContentType = "image/jpeg",
                    StatusCode = HttpStatusCode.OK
                };
            }
            catch (Exception ex)
            {
                return CreateResponse(ex);
            }
        }

        //VAI-1284
        private dynamic GetServedPdfUrl(IHydraParentContext ctx)
        {
            Response response;
            AuthenticationParts authParts;
            VistAQuery vistaQuery;
            try
            {
                vistaQuery = new VistAQuery(Context, Request);
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Getting servePdf URL.", "ContextId", vistaQuery.ContextId);

                _ = ctx.GetDisplayContext(vistaQuery); //create PDF if it doesn't exist
                authParts = AuthenticateMe("n/a", ref ctx, out HWM.ViewerModel loginModel, out response);
            }
            catch (Exception ex)
            {
                return new Response
                {
                    Contents = HWM.ViewerModule.GetStringContents("Invalid request."),
                    ContentType = "application/text",
                    StatusCode = HttpStatusCode.InternalServerError
                };
            }

            if ((authParts == null) || (authParts.SecureToken == null))
            {
                string responseText = response == null ? "Invalid request." : response.Contents.ToString();
                return new Response
                {
                    Contents = HWM.ViewerModule.GetStringContents(responseText),
                    ContentType = "application/text",
                    StatusCode = HttpStatusCode.InternalServerError
                };
            }

            UrlItem urlItem = new UrlItem
            {
                URL = GetServePdfUrl(vistaQuery.ContextId, out string errorReason)
            };
            if (!string.IsNullOrWhiteSpace(errorReason))
            {
                return new Response
                {
                    Contents = HWM.ViewerModule.GetStringContents(errorReason),
                    ContentType = "application/text",
                    StatusCode = HttpStatusCode.InternalServerError
                };
            }

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Received servePdf URL.", "ContextId", vistaQuery.ContextId);

            return FormatAsJson(urlItem);
        }

        //VAI-1284
        private string GetServePdfUrl(string contextID, out string errorReason)
        {
            errorReason = "";
            string result = "";
            string pdfFile = VixServiceUtil.GetPdfFileUrl(contextID);
            if (pdfFile.Length == 0)
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Requested PDF document is zero length.");
                errorReason = "Requested PDF document could not be created.";
                return result;
            }

            if (System.IO.File.Exists(pdfFile))
            {
                result = Request.Url.SiteBase + "/vix/files/" + pdfFile.Substring(pdfFile.IndexOf("pdffile")).Replace('\\', '/');
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("PDF document exists.", "pdfFile", pdfFile);
            }
            else
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Requested PDF document does not exist.", "pdfFile", pdfFile);
                errorReason = "Requested PDF document does not exist.";
            }
            return result;
        }


        private dynamic GetImageResponse(IHydraParentContext ctx)
        {
            try
            {
                var request = this.BindRequest<ImageQuery>();
                if (request == null)
                    throw new BadRequestException("Invalid image query request.");

                //VAI-707
                if (string.IsNullOrWhiteSpace(request.ImageURN))
                    request.ImageURN = ctx.GetImageUrn(GetImageUid());

                //VAI-703 TODO:Call AuthenticateMe which sets UserHostAddress (see BaseModule)
                //and if fails, show login page
                //but if succeeds, model.BaseViewerUrl = authParts.ReturnToUrl;
                request.UserHostAddress = Util.GetHostAddressNoSuffix(Request.UserHostAddress);
                return new Response
                {
                    Contents = stream =>
                    {
                        GetImageCommand.Execute(request, stream);
                    },
                    ContentType = "application/octet-stream",
                    StatusCode = HttpStatusCode.OK
                };
            }
            catch (Exception ex)
            {
                return CreateResponse(ex);
            }
        }

        private new TModel BindRequest<TModel>(bool bodyOnly = false)
        {
            TModel request = bodyOnly? this.Bind<TModel>(new BindingConfig { BodyOnly = true }) : this.Bind<TModel>();
            if ((request != null) && (request is VistAQuery))
            {
                var vistaQuery = (request as VistAQuery);
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                vistaQuery.VixHeaders = new VixHeaders(Request.Headers.ToDictionary(k => k.Key.ToLower(), v => v.Value));
                vistaQuery.HostRootUrl = this.ViewerRootUrl;

                if (string.IsNullOrEmpty(vistaQuery.AuthSiteNumber) &&
                    (vistaQuery.VixHeaders.Contains(VixHeaderName.SiteNumber)))
                    vistaQuery.AuthSiteNumber = vistaQuery.VixHeaders.GetValue(VixHeaderName.SiteNumber);

                if (string.IsNullOrEmpty(vistaQuery.VixJavaSecurityToken) && (this.Request.Query != null))
                {
                    dynamic vixSecurityToken;
                    if ((this.Request.Query as Nancy.DynamicDictionary).TryGetValue("VixJavaSecurityToken", out vixSecurityToken))
                    {
                        if (vixSecurityToken.HasValue)
                            vistaQuery.VixJavaSecurityToken = (vixSecurityToken.Value as string);
                    }
                }

                if (string.IsNullOrEmpty(vistaQuery.ApiToken) && (vistaQuery.VixHeaders.Contains(VixHeaderName.ApiToken)))
                    vistaQuery.ApiToken = vistaQuery.VixHeaders.GetValue(VixHeaderName.ApiToken);
            }

            return request;
        }

        private dynamic HandleSessionRequest(SessionRequest sessionRequest, string siteId, string sessionId)
        {
            try
            {
                var request = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
                if (request == null)
                    throw new BadRequestException("Invalid session request.");
                if (string.IsNullOrEmpty(request.SecurityToken))
                    throw new BadRequestException("Invalid session request. Security token not present.");

                // get viewer service associated with the site
                string rootUrl = VixServiceUtil.GetViewerUrl(siteId, this.Request.Url.SiteBase);

                _Logger.Info("Handling site session request.", "SiteId", siteId, "SessionId", sessionId, "Request", sessionRequest.ToString());

                // generate new security token. simply change the guid
                VixServiceUtil.RenewToken(request);

                // forward request to the viewer service
                using (var client = new HttpClient())
                {
                    string sessionUrl = string.Format("{0}/{1}/session/{2}", rootUrl, HydraConfiguration.ViewerRoutePrefix, sessionId);

                    if ((sessionRequest == SessionRequest.AddDisplayContext) ||
                        (sessionRequest == SessionRequest.RemoveDisplayContext))
                    {
                        // get body
                        StringContent content = null;
                        string text = null;
                        if (Request.Body != null)
                        {
                            using (var reader = new StreamReader(Request.Body))
                            {
                                text = reader.ReadToEnd();
                            }
                            content = new StringContent(text, Encoding.UTF8, "application/json");
                        }

                        sessionUrl += string.Format("/context?SiteNumber={0}&PatientICN={1}&AuthSiteNumber={2}&SecurityToken={3}",
                                                    request.SiteNumber, request.PatientICN, request.AuthSiteNumber, HttpUtility.UrlEncode(request.SecurityToken));

                        _Logger.Info("Forwarding session request", "Url", sessionUrl, "Body", text);

                        HttpRequestMessage httpRequest = new HttpRequestMessage((sessionRequest == SessionRequest.AddDisplayContext)? HttpMethod.Post : HttpMethod.Delete,
                                                                                sessionUrl);
                        if (content != null)
                            httpRequest.Content = content;

                        HttpResponseMessage httpResponse = client.SendAsync(httpRequest).Result;
                        if (!httpResponse.IsSuccessStatusCode)
                        {
                            throw new Exception(httpResponse.ToString());
                        }

                        return new Response
                        {
                            StatusCode = (Nancy.HttpStatusCode)httpResponse.StatusCode
                        };
                    }
                    else
                    {
                        sessionUrl += "/status";

                        _Logger.Info("Forwarding session request.", "Url", sessionUrl);

                        HttpResponseMessage httpResponse = client.GetAsync(sessionUrl).Result;
                        if (!httpResponse.IsSuccessStatusCode)
                        {
                            throw new Exception(httpResponse.ToString());
                        }

                        return new Response
                        {
                            Contents = stream =>
                            {
                                httpResponse.Content.ReadAsStreamAsync().Result.CopyTo(stream);
                            },
                            ContentType = "application/json",
                            StatusCode = (Nancy.HttpStatusCode)httpResponse.StatusCode
                        };
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error handling site session request.", "Exception", ex.ToString());

                return CreateResponse(ex);
            }
        }

        private dynamic VerifyESignature(string siteId, string eSignature)
        {
            try
            {
                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                if (vistaQuery == null)
                    throw new BadRequestException("Invalid session request.");
                if (string.IsNullOrEmpty(vistaQuery.SecurityToken))
                    throw new BadRequestException("Invalid session request. Security token not present.");

                return VerifyESignatureCommand.Execute(siteId, eSignature, vistaQuery) ? Ok() : BadRequest(); 
            }
            catch (Exception ex)
            {
                _Logger.Error("Error verifying electronic signature.", "Exception", ex.ToString());
                return CreateResponse(ex);
            }
        }

        private dynamic LogImageExport(string siteId)
        {
            try
            {
                ImageQuery imageQuery = QueryUtil.Create<ImageQuery>(Context); //VAI-707
                if (imageQuery == null)
                    throw new BadRequestException("Invalid log image export request.");
                if (string.IsNullOrEmpty(imageQuery.SecurityToken))
                    throw new BadRequestException("Invalid log image export. Security token not present.");

                return LogImageExportCommand.Execute(siteId, imageQuery) ? Ok() : BadRequest();
            }
            catch (Exception ex)
            {
                _Logger.Error("Error verifying electronic signature.", "Exception", ex.ToString());
                return CreateResponse(ex);
            }
        }

        private dynamic GetToken()
        {
            try
            {
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading, this.Request.Headers["FOO"] is case-insensitive
                var userId = this.Request.Headers["userId"].FirstOrDefault();
                if (string.IsNullOrEmpty(userId))
                    throw new BadRequestException("UserId not specified");

                var clientAuthentication = SecurityUtil.ValidateCertificate(this.Request.ClientCertificate);
                string apiToken = VixServiceUtil.GetUpdatedSecurityTokenString(null, userId, clientAuthentication.Username, clientAuthentication.Password); //VAI-707

                return this.Response.AsText(apiToken, "text/plain");
            }
            catch (Exception ex)
            {
                _Logger.Error("Error generating token.", "Exception", ex.ToString());

                if (ex is BadRequestException)
                    throw;

                return CreateResponse(ex);
            }
        }

        private dynamic GetToken2()
        {
            try
            {
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading, and this.Request.Headers["FOO"] is case-insensitive
                var userId = this.Request.Headers["userId"].FirstOrDefault();
                if (string.IsNullOrEmpty(userId))
                    throw new BadRequestException("UserId not specified");

                var appName = this.Request.Headers["appName"].FirstOrDefault();
                if (string.IsNullOrEmpty(appName))
                    throw new BadRequestException("App name not specified");

                var clientAuthentication = SecurityUtil.ValidateCertificate(this.Request.ClientCertificate);
                ViewerToken token = VixServiceUtil.GetUpdatedSecurityTokenObject(appName, userId, clientAuthentication.Username, clientAuthentication.Password); //VAI-707

                //VAI-839: Json serialization response uses the variable names as labels. Do not want to change the labels.
                ApiResponseViewerToken apiTokenResponse = new ApiResponseViewerToken
                {
                    token = token.VixViewerSecurityToken,
                    vixToken = token.VixJavaSecurityToken
                };
                return this.Response.AsJson<ApiResponseViewerToken>(apiTokenResponse);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error generating token.", "Exception", ex.ToString());

                if (ex is BadRequestException)
                    throw;

                return CreateResponse(ex);
            }
        }

        private dynamic GetSecurityToken()
        {
            try
            {
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading, and this.Request.Headers["FOO"] is case-insensitive
                var accessCode = this.Request.Headers["accessCode"].FirstOrDefault();
                if (string.IsNullOrEmpty(accessCode))
                    throw new BadRequestException("accessCode not specified");

                var verifyCode = this.Request.Headers["verifyCode"].FirstOrDefault();
                if (string.IsNullOrEmpty(verifyCode))
                    throw new BadRequestException("verifyCode not specified");

                string securityToken = VixServiceUtil.GetUpdatedSecurityTokenString(null, "", accessCode, verifyCode); //VAI-707

                return this.Response.AsText(securityToken, "text/plain");
            }
            catch (Exception ex)
            {
                _Logger.Error("Error generating token.", "Exception", ex.ToString());

                if (ex is BadRequestException)
                    throw;

                return CreateResponse(ex);
            }
        }

        private dynamic CacheStudy(IHydraParentContext ctx)
        {
            try
            {
                string requestBody = this.Request.Body.AsString();

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Received study cache request.", "Request", requestBody);

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                ctx.CacheDisplayContext(vistaQuery, requestBody);

                return Ok();
            }
            catch (Exception ex)
            {
                return CreateResponse(ex);
            }
        }
    }
}
