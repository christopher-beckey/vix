using Hydra.Web.Contracts;
using System.Linq;

namespace Hydra.Web.Modules
{
    public class BaseViewerModule : BaseModule
    {
        public BaseViewerModule()
        {
        }

        public BaseViewerModule(string modulePath) : base(modulePath)
        {
        }

        public BaseViewerModule(string routePrefix, string modulePath)
            : base(routePrefix, modulePath)
        {
        }

        public void ValidateRequest(IHydraParentContext ctx, ViewerRequest request)
        {
            var requestHeaders = (Context.Request.Headers != null) ? Context.Request.Headers.ToDictionary(k => k.Key, v => v.Value) : null;
            ctx.ValidateSession(request.SecurityToken, requestHeaders, Request.UserHostAddress);
        }
    }
}
