using Hydra.Common; //VAI-707
using Nancy; //VAI-707
using Newtonsoft.Json;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace Hydra.VistA
{
    public class VistAQuery
    {
        public string PatientICN { get; set; }
        public string PatientDFN { get; set; }
        public string SecurityToken { get; set; } //This is VIX Viewer Security Token, not to be confused with BSE or VixJavaSecurity tokens, but we cannot change the name due to API syntax
        public string SiteNumber { get; set; }
        public string[] SiteNumbers { get; set; }
        public string AuthSiteNumber { get; set; }
        //public string VixRootUrl { get; set; }
        public string ContextId { get; set; }
        public string TransactionUid { get; set; }
        [JsonIgnore]
        public Dictionary<string, object> RequestParams { get; set; } //VAI-707: Encapsulate for refactoring
        [JsonIgnore]
        public string UserHostAddress { get; set; } //VAI-707
        [JsonIgnore]
        public VixHeaders VixHeaders { get; set; }
        [JsonIgnore]
        public string HostRootUrl { get; set; }
        [JsonIgnore]
        public string VixJavaSecurityToken { get; set; }
        public int VixTimeout { get; set; }
        public string UserId { get; set; }
        [JsonIgnore]
        public string ApiToken { get; set; }
        [JsonIgnore]
        public string AccessContext { get; set; }

        public VistAQuery()
        {
        }

        public VistAQuery(NancyContext ctx, Request req)
        {
            UserHostAddress = Util.GetHostAddressNoSuffix(req.UserHostAddress); //VAI-707: save user's IP address
            Dictionary<string, object> requestParams = (ctx.Request.Query as Nancy.DynamicDictionary).ToDictionary();
            Dictionary<string, IEnumerable<string>> requestHeaders = (ctx.Request.Headers != null) ? ctx.Request.Headers.ToDictionary(k => k.Key, v => v.Value) : null;
            RequestParams = requestParams != null ? new Dictionary<string, object>(requestParams) : null;
            VixHeaders = requestHeaders != null ? new VixHeaders(requestHeaders) : null;
            
            foreach (var item in requestParams)
            {
                if ((item.Value != null) && (item.Value is string))
                {
                    var prop = GetType().GetProperty(item.Key, BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.Instance);
                    if (prop != null)
                        prop.SetValue(this, item.Value);
                }
            }
        }

        public bool ShouldSerializeSecurityToken() { return false; }
        public bool ShouldSerializeVixRootUrl() { return false; }
        public bool ShouldSerializeVixTimeout() { return false; }
        public bool ShouldSerializeApiToken() { return false; }
    }
}
