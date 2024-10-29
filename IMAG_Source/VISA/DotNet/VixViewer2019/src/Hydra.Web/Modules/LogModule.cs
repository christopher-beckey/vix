using Hydra.Log;
using Hydra.Web.Contracts;
using Nancy;
using Nancy.ModelBinding;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System.Linq;

namespace Hydra.Web.Modules
{
    public class LogModule : BaseViewerModule
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public LogModule(IHydraParentContext ctx, IRootPathProvider pathProvider)
            : base(HydraConfiguration.ViewerRoutePrefix)
        {
            AddGet("/log/settings", _ => GetLogSettings(ctx));
            AddPost("/log/settings", _ => SetLogSettings(ctx));
            AddGet("/log/files", _ => GetLogFiles(ctx));
            AddGet("/log/events", _ => GetLogEvents(ctx));
            AddDelete("/log/files", _ => DeleteLogFiles(ctx));
        }
        private dynamic GetLogSettings(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("log/settings", ref ctx, out ViewerModel model, out Response response);
            if (authParts.SecureToken == null)
            {
                if (response != null)
                    return response;
                else
                    return View["login.cshtml", model];  //Need to get new security token. Return to this method when we have one.
            }
            if (!string.IsNullOrWhiteSpace(model.ErrorMsg))
                return BadRequest(model.ErrorMsg);

            var request = this.Bind<Hydra.IX.Common.LogSettingsRequest>();
            if (request == null)
                return BadRequest();

            if (string.IsNullOrEmpty(request.Application))
                return BadRequest("Application name is missing");

            // to ignore null values
            return this.Response.AsText(JsonConvert.SerializeObject(ctx.GetLogSettings(request.Application),
                                                                    Formatting.None,
                                                                    new Newtonsoft.Json.JsonSerializerSettings
                                                                    {
                                                                        NullValueHandling = NullValueHandling.Ignore,
                                                                        ContractResolver = new CamelCasePropertyNamesContractResolver()
                                                                    }),
                                                                    "application/json");
            //return this.Response.AsJson<Hydra.IX.Common.LogSettingsResponse>(ctx.GetLogSettings(request.Application));
        }

        private dynamic SetLogSettings(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("log/settings", ref ctx, out ViewerModel model, out Response response);
            if (authParts.SecureToken == null)
            {
                if (response != null)
                    return response;
                else
                    return View["login.cshtml", model];  //Need to get new security token. Return to this method when we have one.
            }
            if (!string.IsNullOrWhiteSpace(model.ErrorMsg))
                return BadRequest(model.ErrorMsg);

            var request = this.Bind<Hydra.IX.Common.LogSettingsRequest>();
            if (request == null)
                return BadRequest();

            if (string.IsNullOrEmpty(request.Application))
                return BadRequest("Application name is missing");

            ctx.SetLogSettings(request);

            return Ok();
        }

        private dynamic GetLogEvents(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("log/settings", ref ctx, out ViewerModel model, out Response response);
            if (authParts.SecureToken == null)
            {
                if (response != null)
                    return response;
                else
                    return View["login.cshtml", model];  //Need to get new security token. Return to this method when we have one.
            }
            if (!string.IsNullOrWhiteSpace(model.ErrorMsg))
                return BadRequest(model.ErrorMsg);

            var request = this.Bind<Hydra.IX.Common.LogSettingsRequest>();
            if (request == null)
                return BadRequest();

            if (string.IsNullOrEmpty(request.Application))
                return BadRequest("Application name is missing");

            return this.Response.AsJson<Hydra.IX.Common.LogSettingsResponse>(ctx.GetLogEvents(request.Application, request.LogFileName, request.PageSize, request.PageIndex));
        }

        private dynamic GetLogFiles(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("log/settings", ref ctx, out ViewerModel model, out Response response);
            if (authParts.SecureToken == null)
            {
                if (response != null)
                    return response;
                else
                    return View["login.cshtml", model];  //Need to get new security token. Return to this method when we have one.
            }
            if (!string.IsNullOrWhiteSpace(model.ErrorMsg))
                return BadRequest(model.ErrorMsg);

            var request = this.Bind<Hydra.IX.Common.LogSettingsRequest>();
            if (request == null)
                return BadRequest();

            if (string.IsNullOrEmpty(request.Application))
                return BadRequest("Application name is missing");

            if (!string.IsNullOrEmpty(request.LogFileName))
            {
                // get single log file contents
                response = null;

                ctx.GetLogFile(request.Application, request.LogFileName, (stream, statusCode, contentType, httpHeaders) =>
                {
                    if ((statusCode == (int)HttpStatusCode.OK) ||
                        (statusCode == (int)HttpStatusCode.PartialContent))
                    {
                        response = new Nancy.Response
                        {
                            Contents = data =>
                            {
                                stream.CopyTo(data);
                            },
                            ContentType = contentType,
                            StatusCode = (HttpStatusCode)statusCode
                        };

                        if (httpHeaders != null)
                        {
                            foreach (var item in httpHeaders)
                            {
                                response.WithHeader(item.Key, item.Value.First());
                            }
                        }
                    }
                    else
                    {
                        response = new Nancy.Response { StatusCode = (HttpStatusCode)statusCode };
                    }
                });

                return response;
            }
            else
            {
                // get log file list
                return this.Response.AsJson<Hydra.IX.Common.LogSettingsResponse>(ctx.GetLogFiles(request.Application));
            }
        }

        private dynamic DeleteLogFiles(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("log/settings", ref ctx, out ViewerModel model, out Response response);
            if (authParts.SecureToken == null)
            {
                if (response != null)
                    return response;
                else
                    return View["login.cshtml", model];  //Need to get new security token. Return to this method when we have one.
            }
            if (!string.IsNullOrWhiteSpace(model.ErrorMsg))
                return BadRequest(model.ErrorMsg);

            var request = this.Bind<Hydra.IX.Common.LogSettingsRequest>();
            if (request == null)
                return BadRequest();

            if (string.IsNullOrEmpty(request.Application))
                return BadRequest("Application name is missing");

            // Note: Delete all files if log file name is empty
            ctx.DeleteLogFiles(request.Application, request.LogFileName);

            return Ok();
        }
    }
}
