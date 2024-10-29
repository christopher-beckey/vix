using Hydra.Log; //VAI-397
using Hydra.VistA; //VAI-707
using Hydra.Web;
using Hydra.Web.Contracts;
using Nancy;
using Nancy.Bootstrapper;
using Nancy.Diagnostics;
using Nancy.Json;
using Nancy.Security; //VAI-707: Needed for UserIdentity
using Nancy.TinyIoc;
using System;
using System.Collections.Generic;
using System.Diagnostics; //VAI-397
using System.IO; //VAI-397
using System.Linq;
using System.Text;

namespace VIX.Viewer.Service
{
    public class CustomBootstrapper : DefaultNancyBootstrapper
    {
        //VAI-397: Added logging for HTTP requests and responses
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        //For some reason, it appears we receive duplicate requests and responses back-to-back when debugging in Visual Studio.
        //These variables enable us to only log one if we receive two.  This is just a band-aid, an alleviation, not a root cause fix.
        private static string _PrevRequest = ""; //stops us from processing same one twice
        private static string _PrevResponse = ""; //stops us from processing same one twice
        private static string _Request = ""; //stops us from processing same one twice
        private static string _Response = ""; //stops us from processing same one twice

        protected override void ApplicationStartup(TinyIoCContainer container, IPipelines pipelines)
        {
            _Logger.TraceOrDebugIfEnabled("CustomBootstrapper::ApplicationStartup");

            // Common Hydra configuration
            HydraConfiguration.ApiRoutePrefix = VixRootPath.ViewerApiRootPath;
            HydraConfiguration.ViewerRoutePrefix = VixRootPath.ViewerRootPath;
            HydraConfiguration.SignalrRoutePrefix = VixRootPath.SignalrRootPath;

            StaticConfiguration.EnableRequestTracing = true; //for NancyFX diagnostics (see below), but not working. DefaultDiagnostics maybe?
            StaticConfiguration.DisableErrorTraces = false;

            JsonSettings.MaxJsonLength = Int32.MaxValue;

            VixServiceUtil.Initialize(); //VAI-707

            pipelines.BeforeRequest += (ctx) =>
            {
                //VAI-707: Replace Basic Authentication with Custom Authenication and integrate Session
                string vixViewerSecurityToken = ctx.Request.Query["SecurityToken"];
                if (!string.IsNullOrWhiteSpace(vixViewerSecurityToken))
                {
                    IUserIdentity userIdentity = VixServiceUtil.GetAuthenticatedUser(vixViewerSecurityToken);
                    if (userIdentity != null)
                        ctx.CurrentUser = userIdentity;
                }
                PreRequest(ctx); //VAI-397
                return null; //no action is taken by this hook; process the request normally, by the matching route
            };
#if DEBUG_ONLY_FOR_RESEARCH
            //VAI-1336: ONLY RUN THIS FOR RESEARCH. IT EATS THE RESPONSE!
            //To run this:
            //1. TEMPORARILY change #if DEBUG_ONLY_FOR_RESEARCH to #if DEBUG
            //2. Do the same for the code lower in this module (see #region RESPONSE)
            //3. Do NOT expect the client to receive the response!
            //If Response had a clone, we would use it, but it doesn't.
            //
            //Example that I couldn't get working. Alternative to a clone somehow.
            //pipelines.AfterRequest.AddItemToEndOfPipeline(ctx =>
            //{
            //    //The following comments show how we could manipulate the response based on some value https://github.com/NancyFx/Nancy/issues/1556
            //    //var example = ctx.Items["sampleKey"] as string;
            //    //ctx.Response = new PostRequest(ctx, CallAMethodBasedOnExample, example);
            //    ctx.Response = new PostRequest(ctx); //VAI-397: Log the response if traced, and VAI-876: instantiate a new object for return to front-end
            //});
            //VAI-397: Show response when log level is Trace.
            pipelines.AfterRequest += (ctx) =>
            {
                PostRequest(ctx);
            };
#endif
        }

        protected override void ConfigureConventions(Nancy.Conventions.NancyConventions nancyConventions)
        {
            base.ConfigureConventions(nancyConventions);

            //HydraConfiguration.ConfigureViewer(nancyConventions, "viewer");
            string viewerPath = "viewer";

            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("vix/bootstrap", viewerPath + "/bootstrap"));
            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("vix/images", viewerPath + "/images"));
            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("vix/js", viewerPath + "/js"));
            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("vix/style", viewerPath + "/style"));
            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("vix/files", viewerPath + "/files")); //VAI-307

            nancyConventions.ViewLocationConventions.Add((viewName, model, context) => { return string.Concat(viewerPath + "/", viewName); });

            // navigator [TEST]
            //nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("Navigator/wwwroot", "Navigator/wwwroot"));
        }

        protected override void ConfigureApplicationContainer(TinyIoCContainer container)
        {
            base.ConfigureApplicationContainer(container);

            container.Register<IHydraParentContext, VistAHydraParentContext>().AsSingleton();
        }

        //for NancyFX diagnostics: http://localhost:7343/_Nancy
        protected override DiagnosticsConfiguration DiagnosticsConfiguration
        {
            get { return new DiagnosticsConfiguration { Password = @"hydra" }; }
        }
        //I think this is for NancyFX version 2
        //public override void Configure(INancyEnvironment environment)
        //{
        //    var debug = true
        //    environment.Diagnostics(debug, "mypassword", "/api/v1/_MyCustomDashboardRoute");
        //    base.Configure(environment);
        //}

        //VAI-397: Log the incoming request if Trace log level is set
        private void PreRequest(NancyContext ctx)
        {
            if (!_Logger.IsTraceEnabled)
                return;
            try
            {
                string headers = "";
                List<string> ls = ParseKeysRequest(ctx.Request.Headers);
                ls.ForEach(s => headers = headers + " [" + s + "]");

                Stopwatch timer = Stopwatch.StartNew();
                if (ctx.Items.ContainsKey("VIXSvcDebugRequestTimer"))
                    timer.Restart();
                else
                    ctx.Items.Add("VIXSvcDebugRequestTimer", timer);
                string items = "";
                foreach (var key in ctx.Items.Keys)
                    items = items + " [" + key + "=" + ctx.Items[key] + "]";

                string content = "";
                using (var reader = new StreamReader(ctx.Request.Body))
                {
                    content = reader.ReadToEnd();
                    reader.BaseStream.Position = 0;
                    content = System.Web.HttpUtility.UrlDecode(content);
                }
                if (!string.IsNullOrWhiteSpace(content) && (content[0] == 0x0))
                    content = "";

                _Request = $"Method = {ctx.Request.Method}, URL = {ctx.Request.Url}, Headers.Count = {ctx.Request.Headers.Count()}, Headers = {headers}, Items.Count = {ctx.Items.Count}, Items = {items}, Body = {content}";

                //NancyFX has a defect that it receives duplicate requests during debugging, so we have to ignore those
                if (_Request == _PrevRequest)
                {
                    return;
                }
                _PrevRequest = _Request;

                //VAI-397: TODO - Need to verify this works or use NancyFX Diagnostics
                ctx.Trace.TraceLog.WriteLog(s => s.AppendLine($"Received Request: {_Request}"));
                _Logger.Trace("Received Request.", "Request parts", _Request);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error recording PreRequest.", "Exception", ex.ToString());
            }
        }

        private static List<string> ParseKeysRequest(IEnumerable<KeyValuePair<string, IEnumerable<string>>> dict)
        {
            List<string> ls = new List<string>();
            foreach (var keyValuePair in dict)
            {
                ls.Add(keyValuePair.Key + " = " + keyValuePair.Value.FirstOrDefault());
            }
            return ls;
        }
        #region RESPONSE
#if DEBUG_ONLY_FOR_RESEARCH
        //VAI-1336: ONLY RUN THIS FOR RESEARCH. IT EATS THE RESPONSE!
        //To run this, TEMPORARILY change #if DEBUG_ONLY_FOR_RESEARCH to #if DEBUG, but do NOT
        //expect the response in the client! If Response had a clone, we would use it, but it doesn't.

        private static List<string> ParseKeysResponse(IDictionary<string, string> dict)
        {
            List<string> ls = new List<string>();
            foreach (var keyValuePair in dict)
            {
                ls.Add(keyValuePair.Key + " = " + keyValuePair.Value);
            }
            return ls;
        }

        //Example if we want to modify the response
        private interface IResponseProcessor
        {
            string GetText(string text, string example = "dummy");
        }
        
        private class ResponseProcessor : IResponseProcessor
        {
            public string GetText(string text, string example = "dummy")
            {
                if (example != "dummy")
                {
                    return text.Replace("NotDummy", "exampleToReplaceTextThatIsntDummy");
                }
        
                return text;
            }
        }
        
        //VAI-397: Log our response to the request if Trace log level is set
        private void PostRequest(NancyContext ctx)
        {
            if (!_Logger.IsTraceEnabled)
                return;
            try
            {
                string headers = "";
                List<string> ls = ParseKeysResponse(ctx.Response.Headers);
                ls.ForEach(s => headers = headers + " [" + s + "]");

                string items = "";
                foreach (var key in ctx.Items.Keys)
                    items = items + " [" + key + "=" + ctx.Items[key] + "]";

                NancyResponseForLog nancyResponseForLog = new NancyResponseForLog(ctx.Response);
                string contents = nancyResponseForLog.TextResponse;
                if (!string.IsNullOrWhiteSpace(contents) && (contents[0] == 0x0))
                    contents = "";

                _Response = $"Duration = REPLACE, StatusCode = {ctx.Response.StatusCode}, Headers.Count = {ctx.Response.Headers.Count()}, Headers={headers}, Items.Count = {ctx.Items.Count}, Items={items}, ContentType = {ctx.Response.ContentType}, Contents = {contents}";

                //NancyFX has a defect that it receives duplicate requests during debugging, so we have to ignore their responses
                if (_Response == _PrevResponse)
                {
                    return;
                }
                _PrevResponse = _Response;

                string msString = "unknown";
                if (ctx.Items.ContainsKey("VIXSvcDebugRequestTimer"))
                {
                    Stopwatch timer = (Stopwatch)ctx.Items["VIXSvcDebugRequestTimer"];
                    timer.Stop();
                    msString = TimeSpan.FromMilliseconds(timer.ElapsedMilliseconds).ToString(@"mm\:ss\.fff");
                }
                if (_Logger.IsTraceEnabled)
                    _Logger.Trace("Sending Response.", "Response parts", _Response.Replace("REPLACE", msString));
            }
            catch (Exception ex)
            {
                _Logger.Error("Error recording PostRequest.", "Exception", ex.ToString());
            }
        }

        private class NancyResponseForLog : Response
        {
            public string TextResponse { get; private set; }

            public NancyResponseForLog(Response sourceResponse)
            {
                this.ContentType = sourceResponse.ContentType;
                this.Headers = sourceResponse.Headers;
                this.StatusCode = sourceResponse.StatusCode;
                this.ReasonPhrase = sourceResponse.ReasonPhrase;

                using (var memoryStream = new MemoryStream())
                {
                    sourceResponse.Contents.Invoke(memoryStream);
                    this.TextResponse = Encoding.UTF8.GetString(memoryStream.ToArray());
                }

                //var output = Encoding.UTF8.GetBytes(this.textResponse);
                //this.Contents = stream => stream.Write(output, 0, output.Length);
            }
        }
#endif
        #endregion RESPONSE
    }
}
