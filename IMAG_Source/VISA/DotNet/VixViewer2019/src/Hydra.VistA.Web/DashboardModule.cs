using Hydra.Log;
using Hydra.Web;
using Hydra.Web.Contracts;
using Hydra.Web.Modules;
using Nancy;
using Nancy.ModelBinding;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Hydra.VistA.Web
{
    public class DashboardModule : VistAModule
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public DashboardModule(IHydraParentContext ctx, IRootPathProvider pathProvider)
            : base(HydraConfiguration.ViewerRoutePrefix)
        {
            AddGet("dash/", _ => GetDefault(ctx));

            AddGet("dash/testdata/{testdata}", parameters => GetTestData(pathProvider, parameters.testdata));

            AddGet("dash/status", _ => GetStatus(ctx));
        }

        private dynamic GetDefault(IHydraParentContext ctx)
        {
            if (!PolicyUtil.IsPolicyEnabled("Viewer.EnableDashboard"))
            {
                bool isDashEnabled = false;
                if (IsParamInUrl("EasterE88")) //VAI-1329
                  isDashEnabled = true;
                if (!isDashEnabled)
                    return "Dashboard not enabled";
            }
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("dash", ref ctx, out ViewerModel model, out Response response);
            if (authParts.SecureToken == null)
            {
                if (response != null)
                    return response;
                else
                    return View["login.cshtml", model];  //Need to get new security token. Return to this method when we have one.
            }
            if (!string.IsNullOrWhiteSpace(model.ErrorMsg))
                return BadRequest(model.ErrorMsg);

            //the user is already authenticated with a secureToken

            model.BaseViewerUrl = authParts.ReturnToUrl; //VAI-915: this is the page to display; a little confusing because it's misnamed

            ViewerRequest request = this.Bind<ViewerRequest>();
            request.SecurityToken = authParts.SecureToken;
            ValidateRequest(ctx, request); //throws an exception if invalid
            string testData = ((request != null) && !string.IsNullOrEmpty(request.TestData)) ? request.TestData : "Default";
            model.TestData = testData;

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Displaying dash page.", "Url", Request.Url.Path); //VAI-1336

            return View["dash.cshtml", model];
        }

        Response GetTestData(IRootPathProvider pathProvider, string testData)
        {
            string rootPath = pathProvider.GetRootPath();

            string filePath = Path.Combine(rootPath, "TestData", testData + ".json");
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Locating test data file.", "FilePath", filePath);
            if (!File.Exists(filePath))
                return NotFound();

            string text = File.ReadAllText(filePath);

            return this.Response.AsText(text, "application/json");
        }

        Response GetStatus(IHydraParentContext ctx)
        {
            return Ok();
        }
    }
}
