using Hydra.Common; //VAI-707
using Hydra.Common.Exceptions;
using Hydra.Web;
using Hydra.Web.Contracts;
using Hydra.Web.Modules;
using Nancy;
using Nancy.Extensions;
using Nancy.ModelBinding;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Linq;


namespace Hydra.VistA.Web
{
    public abstract class VistAModule : BaseModule
    {
        public VistAModule(string modulePath) : base(modulePath)
        {
        }

        private string ViewerRootUrl
        {
            get
            {
                return RootUrl + "/" + HydraConfiguration.ViewerRoutePrefix;
            }
        }

        internal dynamic FormatAsJson(object response)
        {
            return this.Response.AsText(JsonConvert.SerializeObject(response, 
                                                                    Formatting.None, 
                                                                    new JsonSerializerSettings 
                                                                    { 
                                                                        NullValueHandling = NullValueHandling.Ignore,
                                                                        ContractResolver = new CamelCasePropertyNamesContractResolver()
                                                                    }), 
                                                                    "application/json");
        }

        internal Response CreateResponse(Exception ex)
        {
            if (ex is TokenExpiredException)
                return TokenExpiredException.HttpStatusCode;

            if (ex is VixTimeoutException)
                return VixTimeoutException.HttpStatusCode;

            if (ex is BadRequestException)
                return BadRequest(ex.Message);

            if (ex is HydraWebException)
                return CreateResponse(ex.Message, (Nancy.HttpStatusCode)(ex as HydraWebException).HttpStatusCode);

            if (ex is System.Net.WebException)
            {
                var webex = ex as System.Net.WebException;
                if ((webex.Response != null) && (webex.Response is System.Net.HttpWebResponse))
                    return CreateResponse(ex.Message, (Nancy.HttpStatusCode)(webex.Response as System.Net.HttpWebResponse).StatusCode);
            }

            return Error(ex.ToString());
        }

        internal TModel BindRequest<TModel>(bool bodyOnly = false)
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
                    if ((this.Request.Query as Nancy.DynamicDictionary).TryGetValue("VixSecurityToken", out vixSecurityToken))
                    {
                        if (vixSecurityToken.HasValue)
                            vistaQuery.VixJavaSecurityToken = (vixSecurityToken.Value as string);
                    }
                }

            }

            return request;
        }

        internal void ValidateRequest(IHydraParentContext ctx, ViewerRequest request)
        {
            var requestHeaders = (Context.Request.Headers != null) ? Context.Request.Headers.ToDictionary(k => k.Key, v => v.Value) : null;
            ctx.ValidateSession(request.SecurityToken, requestHeaders, Util.GetHostAddressNoSuffix(Request.UserHostAddress));
        }
    }
}
