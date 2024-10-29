using Hydra.Log;
using Hydra.Web.Contracts;
using Microsoft.AspNet.SignalR;
using Nancy;
using Nancy.Extensions;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Threading.Tasks;

namespace Hydra.Web.Modules
{
    public class SessionModule : BaseViewerModule
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public SessionModule(IHydraParentContext ctx, IRootPathProvider pathProvider)
            : base("vix")
        {
            AddGet("/", _ => GetPage());

            AddPost("/session/{sessionId}/context", parameters => AddDisplayContext(ctx, parameters.sessionId));

            AddDelete("/session/{sessionId}/context", parameters => RemoveDisplayContext(ctx, parameters.sessionId));

            AddGet("/session/{sessionId}/context", parameters => GetDisplayContext(parameters.sessionId));

            AddGet("/session/{sessionId}/status", parameters => GetStatus(parameters.sessionId));

            AddPost("/viewer/session/{sessionId}/context", parameters => AddDisplayContext(ctx, parameters.sessionId));

            AddDelete("/viewer/session/{sessionId}/context", parameters => RemoveDisplayContext(ctx, parameters.sessionId));

            AddGet("/viewer/session/{sessionId}/context", parameters => GetDisplayContext(parameters.sessionId));

            AddGet("/viewer/session/{sessionId}/status", parameters => GetStatus(parameters.sessionId));

            //AddPost("/{sessionId}/patient", parameters => SetPatientContext(parameters.sessionId));
        }

        dynamic GetPage()
        {
            return View["session.cshtml"];
        }

        Response AddDisplayContext(IHydraParentContext ctx, string sessionId)
        {
            _Logger.Info("Adding display context to session.", "SessionId", sessionId, "Url", this.Request.Url.ToString());

            var viewerRequest = BindRequest<ViewerRequest>();
            if (viewerRequest == null)
                return BadRequest("Invalid viewer parameters.");

            ValidateRequest(ctx, viewerRequest);

            dynamic request = JsonConvert.DeserializeObject(Request.Body.AsString());
            var sessionHub = GlobalHost.ConnectionManager.GetHubContext<SessionHub>();
            var result = sessionHub.Clients.All.addDisplayContext(sessionId, request);

            return Ok();
        }

        Response RemoveDisplayContext(IHydraParentContext ctx, string sessionId)
        {
            try
            {
                _Logger.Info("Removing display context from session.", "SessionId", sessionId, "Url", this.Request.Url.ToString());

                var viewerRequest = BindRequest<ViewerRequest>();
                if (viewerRequest == null)
                    return BadRequest("Invalid viewer parameters.");

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Validating request");

                ValidateRequest(ctx, viewerRequest);

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Deserializing request body");

                string text = Request.Body.AsString();
                
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Request body deserialize.", "Body", text);

                dynamic request = JsonConvert.DeserializeObject(text);

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Getting hub context");

                var sessionHub = GlobalHost.ConnectionManager.GetHubContext<SessionHub>();

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Calling removeDisplayContext");

                var result = sessionHub.Clients.All.removeDisplayContext(sessionId, request);

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Calling removeDisplayContext...done");

                return Ok();
            }
            catch (Exception ex)
            {
                _Logger.Error("Error removing display context.", "Error", ex.ToString());
                throw;
            }
        }

        Response GetDisplayContext(string sessionId)
        {
            var sessionHub = GlobalHost.ConnectionManager.GetHubContext<SessionHub>();
            var result = sessionHub.Clients.All.getDisplayContext(sessionId);

            return result;
        }

        dynamic GetStatus(string sessionId)
        {
            _Logger.Info("Getting session status.", "SessionId", sessionId);

            return asyncGetStatus(sessionId).Result;
        }

        async Task<dynamic> asyncGetStatus(string sessionId)
        {
            dynamic sesionStatus = null;
            try
            {
                sesionStatus = await GetSessionIdleTime(sessionId);
                //if (sesionStatus.IdleTime == "invalid")
                //{
                //    throw new Exception();
                //}
                return FormatAsJson(sesionStatus);
            }
            catch (Exception)
            {
                return CreateResponse("Session not found.", HttpStatusCode.NotFound);
            }
        }

        private dynamic FormatAsJson(object response)
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

        public Task<object> GetSessionIdleTime(string sessionId)
        {
            TaskCompletionSource<object> tcs = new TaskCompletionSource<object>();
            string taskId = Guid.NewGuid().ToString();
            SessionHub.getResponseTasks[taskId] = tcs;

            var cts = new System.Threading.CancellationTokenSource(2000);
            cts.Token.Register(() => 
            { 
                tcs.TrySetCanceled();
            });

            try
            {
                cts.Token.ThrowIfCancellationRequested();
                var sessionHub = GlobalHost.ConnectionManager.GetHubContext<SessionHub>();
                sessionHub.Clients.All.getSessionIdleTime(taskId, sessionId);
            }
            catch (Exception ex)
            {
                tcs.TrySetException(ex);
                SessionHub.getResponseTasks.Remove(taskId);
            }

            if (tcs.Task.Exception != null)
            {
                throw tcs.Task.Exception;
            }

            return tcs.Task;
        }
    }
}
