using Hydra.Common; //VAI-707
using Hydra.Common.Exceptions; //VAI-707
using Hydra.Security; //VAI-707
using Hydra.VistA; //VAI-707
using Hydra.Web.Contracts;
using Nancy;
using Nancy.Security; //VAI-707: For IUserIdentity
using System;
using System.Linq;
using System.Collections.Generic;
using System.Reflection;

namespace Hydra.Web.Modules
{
    public class BaseModule : NancyModule
    {
        private readonly string moduleRoutePrefix;

        //VAI-707
        protected class AuthenticationParts
        {
            public string BaseApiUrl;
            public string BaseUrl;
            public string BaseSignalrUrl;
            public string BseToken;
            public string SecureToken; //VIX Viewer Security Token
            public string ReturnToUrl;
            public bool returnToLoginPage; //VAI-707
        }

        //VAI-707
        protected string RequestUserHostAddress
        {
            get
            {
                try
                {
                    if (Request != null)
                    {
                        if (Request.UserHostAddress != null)
                            return Request.UserHostAddress;
                    }
                }
                catch
                {
                    return "";
                }
                return "";
            }
        }

        public BaseModule()
        {
        }

        public BaseModule(string modulePath) : base(modulePath)
        {
        }

        public BaseModule(string routePrefix, string modulePath) : base(modulePath)
        {
            moduleRoutePrefix = routePrefix.TrimEnd('/');
        }

        public void AddGet(string path, Func<dynamic, dynamic> func)
        {
            Get[moduleRoutePrefix + "/" + path.TrimStart('/')] = func;
        }

        public void AddPost(string path, Func<dynamic, dynamic> func)
        {
            Post[moduleRoutePrefix + "/" + path.TrimStart('/')] = func;
        }

        public void AddPut(string path, Func<dynamic, dynamic> func)
        {
            Put[moduleRoutePrefix + "/" + path.TrimStart('/')] = func;
        }

        public void AddDelete(string path, Func<dynamic, dynamic> func)
        {
            Delete[moduleRoutePrefix + "/" + path.TrimStart('/')] = func;
        }

        protected Response Ok()
        {
            return HttpStatusCode.OK;
        }

        protected Response Ok<T>(T content)
        {
            return Response.AsJson<T>(content);
        }

        protected Response NotFound()
        {
            return HttpStatusCode.NotFound;
        }

        protected Response NoContent()
        {
            return HttpStatusCode.NoContent;
        }

        protected Response NotImplemented()
        {
            return HttpStatusCode.NotImplemented;
        }

        protected Response Forbidden()
        {
            return HttpStatusCode.Forbidden;
        }

        protected Response BadRequest()
        {
            return HttpStatusCode.BadRequest;
        }

        protected Response Error(string msg = "")
        {
            return CreateResponse(msg, HttpStatusCode.InternalServerError);
        }

        protected Response BadRequest(string format, params object[] args)
        {
            return CreateResponse(string.Format(format, args), HttpStatusCode.BadRequest);
        }

        protected Response CreateResponse(string msg, HttpStatusCode statusCode)
        {
            Response resp = msg;
            resp.StatusCode = statusCode;

            return resp;
        }

        protected string RootUrl
        {
            get
            {
                return string.IsNullOrEmpty(Request.Url.BasePath) ? Request.Url.SiteBase : Request.Url.BasePath;
            }
        }

        protected T BindRequest<T>() where T : new()
        {
            var requestParams = (Context.Request.Query as DynamicDictionary).ToDictionary();

            T queryObject = new T();
            Type type = queryObject.GetType();

            foreach (KeyValuePair<string, object> item in requestParams)
            {
                if ((item.Value != null) && (item.Value is string))
                {
                    PropertyInfo prop = type.GetProperty(item.Key, BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.Instance);
                    if (prop != null)
                        prop.SetValue(queryObject, item.Value);
                }
            }

            return queryObject;
        }

        //VAI-1329
        protected bool IsParamInUrl(string paramName)
        {
            bool result = false;
            Dictionary<string, object> requestParams = (Request.Query as DynamicDictionary).ToDictionary();
            if ((requestParams != null) && (requestParams.Count > 0))
            {
                foreach (KeyValuePair<string, object> kvp in requestParams)
                {
                    if (kvp.Key == paramName)
                    {
                        result = true;
                        break;
                    }
                }
            }
            return result;
        }

        //VAI-707: Added securityToken parameter in case request.SecurityToken is null
        public void ValidateRequestAndSession(IHydraParentContext ctx, ViewerRequest request, string securityToken = "")
        {
            Dictionary<string, IEnumerable<string>> requestHeaders = Context.Request.Headers?.ToDictionary(k => k.Key, v => v.Value);
            string secureToken = request.SecurityToken ?? securityToken;
            ctx.ValidateSession(secureToken, requestHeaders, Request.UserHostAddress);
        }

        //VAI-707
        protected AuthenticationParts AuthenticateMe(string pageName, ref IHydraParentContext ctx, out ViewerModel loginModel, out Response response)
        {
            //VAI-915: Ensure all Urls do NOT end in a slash
            string TrimEndingSlashIfNotNullOrWhiteSpace(string aUrl)
            {
                return string.IsNullOrWhiteSpace(aUrl) ? "" : aUrl.TrimEnd('/');
            }
            ctx.UserClientHostAddress = TrimEndingSlashIfNotNullOrWhiteSpace(Util.GetHostAddressNoSuffix(RequestUserHostAddress));
            string cBaseApiUrl = TrimEndingSlashIfNotNullOrWhiteSpace(HydraConfiguration.BaseApiUrl);
            string rUrlBasePath = TrimEndingSlashIfNotNullOrWhiteSpace(Request.Url.BasePath);
            string rUrlSiteBase = TrimEndingSlashIfNotNullOrWhiteSpace(Request.Url.SiteBase);
            AuthenticationParts ap = new AuthenticationParts
            {
                BaseApiUrl = string.IsNullOrWhiteSpace(cBaseApiUrl) ? (string.IsNullOrWhiteSpace(rUrlBasePath) ? rUrlSiteBase : rUrlBasePath) + "/" + HydraConfiguration.ApiRoutePrefix.TrimEnd('/') : cBaseApiUrl,
                BaseUrl = (string.IsNullOrWhiteSpace(rUrlBasePath) ? rUrlSiteBase : rUrlBasePath) + "/" + HydraConfiguration.ViewerRoutePrefix.TrimEnd('/').Replace("/viewer", ""),
                BaseSignalrUrl = (string.IsNullOrWhiteSpace(rUrlBasePath) ? rUrlSiteBase : rUrlBasePath) + "/" + HydraConfiguration.SignalrRoutePrefix.TrimEnd('/'),
                ReturnToUrl = (string.IsNullOrWhiteSpace(rUrlBasePath) ? rUrlSiteBase : rUrlBasePath) + Request.Url.Path.TrimEnd('/')
            };
            ap.SecureToken = CheckAuthenticated(ap, out loginModel, out response); //If response != null, we have a problem so just return

            //If the security token is null, we either have an error (response or ErrorMsg) or just need to login. Return to the caller (loginModel.ReturnTo) once logged in.
            if ((response == null) && (ap.SecureToken == null))
            {
                ap.returnToLoginPage = false; //VAI-707
                Dictionary<string, object> requestParams = (Request.Query as DynamicDictionary).ToDictionary();
                if ((requestParams != null) && (requestParams.Count > 0))
                {
                    string delimiter = "?";
                    foreach (KeyValuePair<string, object> kvp in requestParams)
                    {
                        if (kvp.Key == "SecurityToken")
                            continue; //ignore this, because we need a new one
                        if (kvp.Key == "lp")
                        {
                            ap.returnToLoginPage = true;
                            continue;
                        }
                        loginModel.ReturnTo = loginModel.ReturnTo + delimiter + kvp.Key + "=" + kvp.Value;
                        delimiter = "&";
                    }
                }
                if ((pageName == "dash") || (pageName == "tools"))
                    ap.returnToLoginPage = true;
                if (!ap.returnToLoginPage)
                {
                    string errorMsg = loginModel.ErrorMsg ?? "";
                    throw new BadRequestException(errorMsg.Replace(" Please login again.", "")); //return to external caller instead of login page
                }
            }
            return ap;
        }

        /// <summary>
        /// Check to see if the user is authenticated
        /// </summary>
        /// <param name="ap">Authentication parts</param>
        /// <param name="model">The model for the View</param>
        /// <param name="response">The response to send to the View</param>
        /// <returns>If successful, the VIX Viewer Security Token as string. If failure, return null with either model or response*.</returns>
        /// <remarks>*Where model is urlToShow (display View) and urlToReturnTo (where to go after displayed View is successful).
        /// Originally created for VAI-707.</remarks>
        private string CheckAuthenticated(AuthenticationParts ap, out ViewerModel model, out Response response)
        {
            model = null;
            response = null;
            if ((Context.CurrentUser != null) && (((UserIdentity)Context.CurrentUser).HttpStatusCode != HttpStatusCode.OK))
            {
                response = CreateResponse(((UserIdentity)Context.CurrentUser).Message, ((UserIdentity)Context.CurrentUser).HttpStatusCode);
                return null; //we have a current user (authenticated), but there's a problem
            }
            HttpStatusCode statusCode = HttpStatusCode.OK;
            string secureToken = "";
            IUserIdentity userIdentity = null;
            if (SecurityToken.TryParse(Context.Request.Query.SecurityToken, out SecurityToken securityToken))
            {
                secureToken = securityToken.ToString();
                if (securityToken.IsExpired)
                {
                    secureToken = "";
                    statusCode = HttpStatusCode.Gone;
                }
                else
                {
                    if (!string.IsNullOrWhiteSpace(secureToken))
                        userIdentity = VixServiceUtil.GetAuthenticatedUser(secureToken);
                    if (userIdentity == null)
                    {
                        //This often happens when someone has pasted a valid VIX Viewer Security Token from another session, so let's add the session
                        SecurityUtil.CreateUserSession(secureToken, securityToken.UserId, Request.UserHostAddress);
                        userIdentity = VixServiceUtil.GetAuthenticatedUser(secureToken);
                    }
                }
            }

            if (string.IsNullOrWhiteSpace(secureToken) || (userIdentity == null))
            {
                model = new ViewerModel
                {
                    BaseUrl = ap.BaseUrl, //VAI-915
                    BaseApiUrl = ap.BaseApiUrl, //VAI-915
                    BaseViewerUrl = ap.BaseUrl + "/viewer/login", //VAI-915: use the BaseViewerUrl field for the login URL
                    ErrorMsg = (statusCode == HttpStatusCode.Gone) ? "The session expired. Please login again." : "",
                    ReturnTo = ap.ReturnToUrl //URL to return to after login
                };
                return null; //we need to get the secureToken using the login View
            }
            else
            {
                model = new ViewerModel
                {
                    SecurityToken = secureToken,
                    BaseUrl = ap.BaseUrl,  //VAI-915
                    BaseApiUrl = ap.BaseApiUrl,
                    BaseViewerUrl = ap.BaseUrl,
                    BaseSignalrUrl = ap.BaseSignalrUrl
                };
            }
            return secureToken;
        }
    }
}
