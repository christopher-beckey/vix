using Hydra.IX.Common;
using Nancy;
using Nancy.ModelBinding;
using Nancy.Security;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Web
{
    public class AdminModule : HixModule
    {
        public class AdminModel
        {
            public string BaseApiUrl { get; set; }
            public string BaseViewerUrl { get; set; }
        }

        public AdminModule(IHixRequestHandler handler) : base("admin")
        {
            AddGet("/", parameters =>
                {
                    AdminModel model = new AdminModel();
                    //model.BaseApiUrl = string.IsNullOrEmpty(HydraConfiguration.BaseApiUrl) ?
                    //    (string.IsNullOrEmpty(this.Request.Url.BasePath) ? this.Request.Url.SiteBase.TrimEnd('/') : this.Request.Url.BasePath) + "/" + HydraConfiguration.ApiRoutePrefix + "/" : HydraConfiguration.BaseApiUrl.TrimEnd('/'); //VAI-915
                    //model.BaseViewerUrl = (string.IsNullOrEmpty(this.Request.Url.BasePath) ? this.Request.Url.SiteBase.TrimEnd('/') : this.Request.Url.BasePath) + "/" + HydraConfiguration.ViewerRoutePrefix.TrimEnd('/'); //VAI-915

                    return View["viewer.cshtml", model];
                });
        }
    }
}
