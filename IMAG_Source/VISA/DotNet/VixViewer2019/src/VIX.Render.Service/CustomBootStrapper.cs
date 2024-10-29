using Hydra.IX.Common;
using Hydra.IX.Core;
using Hydra.IX.Core.Modules;
using Hydra.IX.Web;
using Hydra.IX.Web.Modules;
using Hydra.Log; //VAI-397
using Newtonsoft.Json; //VAI-397
using Nancy;
using Nancy.Bootstrapper;
using Nancy.TinyIoc;
using System;
using System.Collections.Generic;
using System.Diagnostics; //VAI-397
using System.IO; //VAI-397
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web; //VAI-397

namespace VIX.Render.Service
{
    public class CustomBootStrapper : DefaultNancyBootstrapper
    {
        //VAI-397: Added logging for HTTP requests and responses
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        //For some reason, it appears we receive duplicate requests and responses back-to-back.  Not sure if that is actually happening.
        //These variables enable us to only log one if we receive two.  This is just a band-aid, an alleviation, not a root cause fix.
        private static string _PrevRequest = ""; //stops us from processing same one twice
        private static string _PrevResponse = ""; //stops us from processing same one twice
        private static string _Request = ""; //stops us from processing same one twice
        private static string _Response = ""; //stops us from processing same one twice

        protected override void ApplicationStartup(TinyIoCContainer container, IPipelines pipelines)
        {
            base.ApplicationStartup(container, pipelines);

            //VAI-397: Trap Pre-Request and Post-Request if the log level is Trace
            if (_Logger.IsTraceEnabled)
            {
                pipelines.BeforeRequest += (ctx) =>
                {
                    PreRequest(ctx);
                    return null; //no action is taken by this hook; process the request normally, by the matching route
                };

                //VAI-397 IS NOT YET WORKING! KEEP THIS COMMENTED OUT UNTIL WE GET TRACE WORKING.
                //pipelines.AfterRequest += (ctx) =>
                //{
                //    PostRequest(ctx); //VAI-397
                //};
            }

            HixBootstrapper.Start(container, pipelines);
        }

        protected override void ConfigureConventions(Nancy.Conventions.NancyConventions nancyConventions)
        {
            base.ConfigureConventions(nancyConventions);

            HixBootstrapper.ConfigureConventions(nancyConventions);
        }

        protected override void ConfigureApplicationContainer(TinyIoCContainer container)
        {
            base.ConfigureApplicationContainer(container);

            HixBootstrapper.RegisterHandler(container, new DefaultHixRequestHandler());
        }

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

                _Request = string.Format("Method = {0}, URL = {1}, Headers.Count = {2}, Headers = {3}, Items.Count = {4}, Items = {5}, Body = {6}",
                    ctx.Request.Method, ctx.Request.Url, ctx.Request.Headers.Count(), headers, ctx.Items.Count, items, content);

                //NancyFX has a defect that it receives duplicate requests during debugging, so we have to ignore those
                if (_Request == _PrevRequest)
                {
                    return;
                }
                _PrevRequest = _Request;

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

        //private static List<string> ParseKeysResponse(IDictionary<string, string> dict)
        //{
        //    List<string> ls = new List<string>();
        //    foreach (var keyValuePair in dict)
        //    {
        //        ls.Add(keyValuePair.Key + " = " + keyValuePair.Value);
        //    }
        //    return ls;
        //}

        //VAI-397: Log our response to the request if Trace log level is set
        //^^^NOT YET WORKING! THIS METHOD EATS THE RESPONSE (NOT RETURNED TO CLIENT).
        //KEEP THIS COMMENTED OUT UNTIL WE GET TRACE WORKING.
        //private void PostRequest(NancyContext ctx)
        //{
        //    if (!_Logger.IsTraceEnabled)
        //        return;
        //    try
        //    {
        //        string headers = "";
        //        List<string> ls = ParseKeysResponse(ctx.Response.Headers);
        //        ls.ForEach(s => headers = headers + " [" + s + "]");

        //        string items = "";
        //        foreach (var key in ctx.Items.Keys)
        //            items = items + " [" + key + "=" + ctx.Items[key] + "]";

        //        string prettyJson = string.Format("{0}", JsonConvert.SerializeObject(ctx.Response, new JsonSerializerSettings()
        //        {
        //            PreserveReferencesHandling = PreserveReferencesHandling.Objects,
        //            Formatting = Formatting.Indented
        //        }));
        //        _Response = string.Format("Duration = REPLACE, StatusCode = {0}, Headers.Count = {1}, Headers={2}, Items.Count = {3}, Items={4}, ContentType = {5}, Contents = {6}",
        //            ctx.Response.StatusCode, ctx.Response.Headers.Count(), headers, ctx.Items.Count, items, ctx.Response.ContentType, prettyJson);

        //        //NancyFX has a defect that it receives duplicate requests during debugging, so we have to ignore their responses
        //        if (_Response == _PrevResponse)
        //        {
        //            return;
        //        }
        //        _PrevResponse = _Response;

        //        string msString = "unknown";
        //        if (ctx.Items.ContainsKey("VIXSvcDebugRequestTimer"))
        //        {
        //            Stopwatch timer = (Stopwatch)ctx.Items["VIXSvcDebugRequestTimer"];
        //            timer.Stop();
        //            msString = TimeSpan.FromMilliseconds(timer.ElapsedMilliseconds).ToString(@"mm\:ss\.fff");
        //        }
        //        if (_Logger.IsTraceEnabled)
        //            _Logger.Trace("Sending Response.", "Response parts", _Response.Replace("REPLACE", msString));
        //    }
        //    catch (Exception ex)
        //    {
        //        _Logger.Error("Error recording PostRequest.", "Exception", ex.ToString());
        //    }
        //}
    }
}
