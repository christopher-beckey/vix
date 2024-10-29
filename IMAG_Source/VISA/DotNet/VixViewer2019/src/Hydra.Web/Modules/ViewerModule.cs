using Hydra.Common; //VAI-707
using Hydra.Common.Entities;
using Hydra.Common.Exceptions;//VAI-707
using Hydra.Log;
using Hydra.Security; //VAI-707
using Hydra.VistA;
using Hydra.Web.Common;
using Hydra.Web.Contracts;
using Nancy;
using Nancy.Extensions;
using Nancy.ModelBinding;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Web; //VAI-707

namespace Hydra.Web.Modules
{
    /// <summary>
    /// Web App Pages
    /// </summary>
    public class ViewerModule : BaseViewerModule
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public ViewerModule(IHydraParentContext ctx, IRootPathProvider pathProvider) : base(HydraConfiguration.ViewerRoutePrefix)
        {
            AddGet("/", _ => GetViewer(ctx));

            AddGet("/login", parameters => GetLogin(ctx, parameters)); //VAI-707

            AddPost("/login", _ => PostLogin(ctx)); //VAI-707

            AddGet("/tools", _ => GetTools(ctx)); //VAI-707: These are all the VIX and VIX Viewer Tools on the tools page, not viewer page tools

            AddGet("/3D", _ => GetViewer3D(ctx));

            AddGet("/loader", _ => GetLoader(ctx));

            AddGet("/version", _ => GetVersion());

            AddGet("/VVSDoc", _ => View["VVSDoc.html"]);

            AddGet("/context", _ => GetDisplayContext(ctx));

            AddDelete("/context", _ => DeleteDisplayContext(ctx)); //This is the purge of a specific study from the dash page

            AddPost("/prepare", _ => PrepareForDisplay(ctx));

            AddGet("/releasehistory", _ => GetReleaseHistory(pathProvider));

            AddGet("/metadata", _ => GetMetadata(ctx));

            AddGet("/events", _ => GetEvents(ctx));

            // dictionary
            AddGet("/dict/{level}/{name}", parameters => GetDictionaryItem(ctx, parameters.level, parameters.name));
            AddDelete("/dict/{level}/{name}", parameters => DeleteDictionaryItem(ctx, parameters.level, parameters.name));
            AddPost("/dict/{level}/{name}", parameters => AddDictionaryItem(ctx, parameters.level, parameters.name));

            // export
            AddGet("/context/export", _ => ExportDisplayContext(ctx));

            // dicomdir
            AddGet("/context/dicomdir", _ => CreateDicomDir(ctx));

            AddGet("/images", _ => GetImage(ctx)); //also see ImageModule.cs

            AddGet("/user/details", _ => GetUserDetails(ctx));

            AddGet("/manage", _ => GetManage(ctx));

            AddGet("/print/reasons", _ => GetPrintReasons(ctx));

            AddGet("/extlinks", _ => GetExternalLinks(ctx));

            AddGet("/VIX_Viewer_User_Guide", _ => GetHelp(ctx)); //VAI-461

            //AddPost("/cache/purge", _ => PurgeCache(ctx)); //This is for *all* the cache and unused. See DeleteDisplayContext().

            AddGet("/status", _ => GetStatus(ctx));
        }


        //VAI-707: Get the user's login page.
        private dynamic GetLogin(IHydraParentContext ctx, dynamic parameters)
        {
            ViewerModel model = new ViewerModel();
            model.ReturnTo = HttpUtility.UrlDecode(parameters.returnTo); //if nothing to return to, we'll go to the VixTools page after successful login
            model.BaseUrl = $"{Request.Url.SiteBase}/vix"; //VAI-915
            model.BaseViewerUrl = string.IsNullOrWhiteSpace(Request.Url.SiteBase) ? "~" : Request.Url.SiteBase;
            model.BaseViewerUrl = model.BaseViewerUrl + Request.Url.Path; //Request.Url.Path starts with a slash

            Dictionary<string, object> requestParams = (Context.Request.Query as Nancy.DynamicDictionary).ToDictionary();
            if (requestParams != null)
            {
                _ = requestParams.TryGetValue("status", out object value);
                string status = (value == null) ? "" : value.ToString();
                if (!string.IsNullOrWhiteSpace(status))
                {
                    Context.Request.Query = null;
                    int statusCode = Convert.ToInt32(status);
                    if (statusCode != 0)
                        model.ErrorMsg = "An error occurred when trying to access that tool. Please try re-accessing it or use different credentials.";
                }
            }

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting login page.", "BaseViewerUrl", model.BaseViewerUrl, "ReturnTo", model.ReturnTo);

            return View["login.cshtml", model];
        }

        //VAI-707: Login the user and get his security tokens.
        private dynamic PostLogin(IHydraParentContext ctx)
        {
            ctx.UserClientHostAddress = Util.GetHostAddressNoSuffix(RequestUserHostAddress); //VAI-707
            #region GetLoginParameters
            string content = "";
            using (StreamReader reader = new StreamReader(Request.Body))
            {
                content = reader.ReadToEnd();
                content = Util.Base64Decode(content);
            }
            if (string.IsNullOrWhiteSpace(content))
                return BadRequest("Missing login parameters.");

            //access|verify|returnURL
            string[] dataParts = content.Split('|');
            string accessCode = ((dataParts != null) && !string.IsNullOrEmpty(dataParts[0])) ? dataParts[0] : "";
            string verifyCode = ((dataParts != null) && !string.IsNullOrEmpty(dataParts[1])) ? dataParts[1] : "";
            string returnTo = ((dataParts != null) && !string.IsNullOrEmpty(dataParts[2])) ? dataParts[2] : "";
            #endregion GetLoginParameters
            //GetLoginParameters(Request.Body, out string accessCode, out string verifyCode, out string returnTo);
            if (string.IsNullOrWhiteSpace(accessCode) || string.IsNullOrWhiteSpace(verifyCode))
                return BadRequest("Missing login parameters.");

            //VAI-707: Authenticate the user. On error, return an error. On success, return the next view to display.
            UserIdentity userIdentity = VixServiceUtil.Authenticate(accessCode, verifyCode, Util.GetHostAddressNoSuffix(Request.UserHostAddress));
            string secureToken = VixServiceUtil.GetVixViewerSecurityToken(userIdentity);
            if (secureToken == null)
                return new Response { StatusCode = HttpStatusCode.InternalServerError}; //Authenticate() should have created the VIX Viewer Security Token

            //If we started from somewhere other than the login page, let's return there. Otherwise, go to the VIX Tools page.
            string nextView = returnTo;
            if (string.IsNullOrWhiteSpace(nextView))
                nextView = Request.Url.SiteBase + Request.Path.Replace("login", "tools");

            string delimiter = "?";
            if (nextView.Contains("?"))
                delimiter = "&";
            return new Response
            {
                Contents = GetStringContents(nextView + delimiter + "SecurityToken=" + secureToken),
                ContentType = "application/text",
                StatusCode = HttpStatusCode.OK
            };
        }

        //VAI-707: Get the login parameters from the View's post data (a stream)
        private void GetLoginParameters(Stream stm, out string accessCode, out string verifyCode, out string returnTo)
        {
            accessCode = "";
            verifyCode = "";
            returnTo = "";
            string content = "";
            using (var reader = new StreamReader(stm))
            {
                content = reader.ReadToEnd();
                content = Util.Base64Decode(content);
            }
            if (string.IsNullOrWhiteSpace(content))
                return;

            //access|verify|returnURL
            string[] dataParts = content.Split('|');
            accessCode = ((dataParts != null) && !string.IsNullOrEmpty(dataParts[0])) ? dataParts[0] : "";
            verifyCode = ((dataParts != null) && !string.IsNullOrEmpty(dataParts[1])) ? dataParts[1] : "";
            returnTo = ((dataParts != null) && !string.IsNullOrEmpty(dataParts[2])) ? dataParts[2] : "";
        }

        /// <summary>
        /// Converts a string content value to a response action.
        /// </summary>
        /// <param name="contents">The string containing the content.</param>
        /// <returns>A response action that writes the contents of the string to the response stream.</returns>
        /// <remarks>Changed to public for VAI-1284</remarks>
        public static Action<Stream> GetStringContents(string contents)
        {
            return stream =>
            {
                var writer = new StreamWriter(stream) { AutoFlush = true };
                writer.Write(contents);
            };
        }

        //VAI-707: Get the tools page.
        private dynamic GetTools(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("tools", ref ctx, out ViewerModel loginModel, out Response response);
            //if secureToken is null, we either have an error (response) or just need to login, then return here (loginModel.ReturnTo) once logged in
            if (authParts.SecureToken == null)
            {
                if (response != null)
                    return response;
                return View["login.cshtml", loginModel];  //need to get security token
            }

            //the user is already authenticated with a secureToken
            try
            {
                List<SecurityUtil.VixTool> items = new List<SecurityUtil.VixTool>(SecurityUtil.VixToolList);
                if ((items == null) || (items.Count() == 0))
                    return "Sorry, there are no configured VIX Tools.";

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Getting tools page.", "Url", Request.Url.ToString());

                List<SecurityUtil.VixTool> filteredItems = items; //default to all
                //Secret (Easter egg) URL parameter: All. If exists, show all tools, that is, do not filter. Useful for debugging and when dashboard is enabled on a VIX.
                if (!IsParamInUrl("All")) //VAI-1329
                {
                    //Not showing all tools.
                    //VAI-1329: Check for Easter Egg URL parameter: SCIP.
                    //SCIP means to show internal-only tools. Remove internal tools if SCIP not specified.
                    if (!IsParamInUrl("SCIP"))
                    {
                        filteredItems.Remove(filteredItems.Find(x => x.IsInternal == true));
                    }
                    //if we are running on a CVIX
                    //then  only include CVIX tools
                    //else  only include VIX tools
                    filteredItems = SecurityUtil.IsCvix
                        ? filteredItems.Where(i => i.IsCvix).OrderBy(fi => fi.Name).ToList()
                        : filteredItems.Where(i => i.IsVix).OrderBy(fi => fi.Name).ToList();
                }
                List<VixToolModel> list = new List<VixToolModel>();
                int idx = 0;
                string bseToken = SessionManager.Instance.GetBseToken(authParts.SecureToken); //Example: XUSBSE1504-383116_9
                string javaToken = SessionManager.Instance.GetVixJavaToken(authParts.SecureToken); //Example: -DvDIIjtbNov3PRqBblt1U5n5n7UWJ22xGQooGLIAGcZkPsO5JWvc6skavdBUrAY-t2qh7oTq5ASmCpfA6d0QdbgEyNFl6XteGpNCFAyup9H2EL9kFoTHiIHHU7KnrrirA1W8kumdRF6i6LSOcGicfHupGnw9ixZGhXriUIWfllEk77Dcw==
                foreach (SecurityUtil.VixTool item in filteredItems)
                {
                    if (!string.IsNullOrWhiteSpace(item.Name) && item.Url.StartsWith("http"))
                    {
                        //we have a valid tool
                        VixToolModel toolItem = new VixToolModel
                        {
                            BaseUrl = authParts.BaseUrl, //VAI-915
                            BseToken = bseToken,
                            ToolId = "btn" + (++idx).ToString(),
                            SecurityHandoff = item.SecurityHandoff,
                            Title = item.Name,
                            ToolUrl = item.Url,
                            VixJavaSecurityToken = javaToken,
                            VixViewerSecurityToken = authParts.SecureToken
                        };
                        list.Add(toolItem);
                    }
                }
                ViewBag.Title = SecurityUtil.IsCvix ? "CVIX" : "VIX";
                ViewBag.BaseUrl = authParts.BaseUrl; //VAI-915
                if (IsParamInUrl("EE"))
                    ViewBag.EE = "All=1: Show all. SCIP=1: Include internal. lp=1: Return to login page if not authenticated. EasterE88=1: Dash can show.";
                return View["tools", list];
            }
            catch (Exception ex)
            {
                _Logger.Error("Error getting VIX Tools.", "Exception", ex.ToString());
                return "Sorry, there was a system error getting the VIX Tools";
            }
        }

        dynamic GetVersion()
        {
            dynamic versionInfo = new ExpandoObject();
            //VAI 300 - update for Viewer Version to no longer be from the assembly version
            versionInfo.version = Hydra.VistA.VixServiceUtil.GetVixVersion();

            return Newtonsoft.Json.JsonConvert.SerializeObject(versionInfo);
        }

        dynamic GetViewer(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("viewer", ref ctx, out ViewerModel model, out Response response);
            //if secureToken is null, we either have an error (response) or just need to login, then return here (loginModel.ReturnTo) once logged in
            if (authParts.SecureToken == null)
            {
                if (response != null)
                    return response;
                Dictionary<string, object> requestParams = (Request.Query as DynamicDictionary).ToDictionary();
                if (requestParams != null)
                {
                    string delimiter = "?";
                    foreach (KeyValuePair<string, object> kvp in requestParams)
                    {
                        if (kvp.Key == "SecurityToken")
                            continue; //we do not want this token, because we need a new one
                        model.ReturnTo = model.ReturnTo + delimiter + kvp.Key + "=" + kvp.Value;
                        delimiter = "&";
                    }
                }
                model.ReturnTo = model.ReturnTo.Replace("viewer?", "viewer/loader?");
                return View["login.cshtml", model];  //need to get new security token
            }

            //the user is already authenticated with a secureToken

            model.BaseViewerUrl = authParts.ReturnToUrl; //VAI-915

            var request = this.Bind<ViewerRequest>();
            if ((request == null) || !request.IsValid)
                return BadRequest("Invalid viewer parameters.");

            ValidateRequestAndSession(ctx, request, authParts.SecureToken);

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting viewer page.", "Url", Request.Url.ToString());

            return View["viewer.cshtml", model];
        }

        dynamic GetViewer3D(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("3Dviewer", ref ctx, out ViewerModel model, out Response response);
            //if secureToken is null, we either have an error (response) or just need to login, then return here (loginModel.ReturnTo) once logged in
            if (authParts.SecureToken == null)
            {
                if (response != null)
                    return response;
                return View["login.cshtml", model];  //need to get security token
            }

            //the user is already authenticated with a secureToken

            model.BaseViewerUrl = authParts.ReturnToUrl; //VAI-915

            var request = this.Bind<ViewerRequest>();
            if ((request == null) || !request.IsValid)
                return BadRequest("Invalid viewer parameters.");

            ValidateRequestAndSession(ctx, request, authParts.SecureToken);

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting viewer page.",  "Url", Request.Url.ToString());

            return View["3DViewer.cshtml", model];
        }

        dynamic GetLoader(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("viewer", ref ctx, out ViewerModel model, out Response response);
            //if secureToken is null, we either have an error (response) or just need to login, then return here (loginModel.ReturnTo) once logged in
            if (authParts.SecureToken == null)
            {
                if ((model != null) && !string.IsNullOrWhiteSpace(model.ErrorMsg) && !authParts.returnToLoginPage)
                    throw new BadRequestException("Invalid session."); //Need to do this because an external system is calling us, and it has its own login mechanism
                if (response != null)
                    return response;
                return View["login.cshtml", model];  //need to get security token
            }

            //the user is already authenticated with a secureToken

            model.BaseViewerUrl = authParts.ReturnToUrl; //VAI-915

            var request = this.Bind<ViewerRequest>();
            if ((request == null) || !request.IsValid)
                return BadRequest("Invalid loader parameters.");

            ValidateRequestAndSession(ctx, request, authParts.SecureToken);

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting loader page.", "Url", Request.Url.ToString());

            return View["loader.cshtml", model];
        }

        dynamic GetManage(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("manage", ref ctx, out ViewerModel model, out Response response);
            //if secureToken is null, we either have an error (response) or just need to login, then return here (loginModel.ReturnTo) once logged in
            if (authParts.SecureToken == null)
            {
                if (response != null)
                    return response;
                return View["login.cshtml", model];  //need to get security token
            }

            //the user is already authenticated with a secureToken

            model.BaseViewerUrl = authParts.ReturnToUrl; //VAI-915

            var request = this.Bind<ViewerRequest>();
            if ((request == null) || !request.IsValid)
                return BadRequest("Invalid manage parameters.");

            ValidateRequestAndSession(ctx, request, authParts.SecureToken);

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting manage page.", "Url", Request.Url.ToString());

            return View["manage.cshtml", model];
        }

        public Response GetDisplayContext(IHydraParentContext ctx)
        {
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting display context...");

            var codeClock = Hydra.Common.CodeClock.Start();

            VistAQuery vistaQuery = new VistAQuery(Context, Request);
            var displayContext = ctx.GetDisplayContext(vistaQuery);

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Got display context.", "Duration", codeClock.ElapsedMilliseconds);
            
            if (displayContext == null)
                return NotFound();

            return Ok<DisplayContextDetails>(displayContext);
        }

        Response GetUserDetails(IHydraParentContext ctx)
        {
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting user details...");

            VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707;
            UserDetails userDetails = ctx.GetUserDetails(vistaQuery);
            if (userDetails == null)
                return NotFound();

            return Ok<UserDetails>(userDetails);
        }

        Response DeleteDisplayContext(IHydraParentContext ctx)
        {
            VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
            ctx.DeleteDisplayContext(vistaQuery);

            // todo: delete display group associate with the display context.

            return Ok();
        }

        Response GetReleaseHistory(IRootPathProvider pathProvider)
        {
            string rootPath = pathProvider.GetRootPath();
            _Logger.Info("Reading release history", "RootPath", rootPath);

            return Response.AsJson<List<ReleaseHistoryItem>>(ReleaseHistory.Build(rootPath));
        }

        Response PrepareForDisplay(IHydraParentContext ctx)
        {
            try
            {
                var codeClock = Hydra.Common.CodeClock.Start();

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Preparing for display #1.", "Duration", codeClock.ElapsedMilliseconds);

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                ctx.PrepareForDisplay(vistaQuery); //Purge the study if the image count is different from before

                //VAI-373 - Log more info about the incoming HTTP request (Context) to help us troubleshoot problems at run-time
                if (_Logger.IsTraceEnabled)
                {
                    int paramsCount = 0;
                    Dictionary<string, object> requestParams = (Context.Request.Query as DynamicDictionary).ToDictionary();
                    if (requestParams != null)
                        paramsCount = requestParams.Count();
                    _Logger.TraceVariable("VM-PrepareForDisplay-requestParams.Count().", paramsCount);
                    NancyContext ctx2 = Context;
                    string headers = "";
                    List<string> ls = ParseKeysRequest(ctx2.Request.Headers);
                    ls.ForEach(s => headers = headers + " [" + s + "]");
                    string items = "";
                    foreach (var key in ctx2.Items.Keys)
                        items = items + " [" + key + "=" + ctx2.Items[key] + "]";
                    string content = Nancy.Extensions.RequestStreamExtensions.AsString(ctx2.Request.Body);
                    string requestParts = $"URL = {ctx2.Request.Url.Path}, Method = {ctx2.Request.Method}, Headers.Count = {ctx2.Request.Headers.Count()}, Headers = {headers}, Items.Count = {ctx2.Items.Count}, Items = {items}, Body Length = {content.Length}, Body = {content}"; //VAI-1336
                    _Logger.Trace("Tracing request.", "Request parts", requestParts);
                }

                return Ok();
            }
            catch (Exception ex)
            {
                _Logger.Error("Error preparing for display #1.", "Exception", ex.ToString());
                throw;
            }
        }

        private List<string> ParseKeysRequest(IEnumerable<KeyValuePair<string, IEnumerable<string>>> dict)
        {
            List<string> ls = new List<string>();
            foreach (var keyValuePair in dict)
            {
                ls.Add(keyValuePair.Key + " = " + keyValuePair.Value.FirstOrDefault());
            }
            return ls;
        }

        Response GetMetadata(IHydraParentContext ctx)
        {
            try
            {
                var codeClock = Hydra.Common.CodeClock.Start();
                MetadataQuery metadataQuery = QueryUtil.Create<MetadataQuery>(Context); //VAI-707: Encapsulate/Refactor
                var metadata = ctx.GetMetadata(metadataQuery);

                if(_Logger.IsDebugEnabled)
                    _Logger.Debug("Getting metadata.", "Duration", codeClock.ElapsedMilliseconds);

                return CreateResponse(metadata, HttpStatusCode.OK);
            }
            catch (Exception ex)
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Error getting metadata.");
                return Error(ex.ToString());
            }
        }

        dynamic GetEvents(IHydraParentContext ctx)
        {
            try
            {
                var requestParams = (Context.Request.Query as Nancy.DynamicDictionary).ToDictionary();
                var events = ctx.GetEvents(requestParams);

                ViewBag.BaseUrl = (Request.Url.SiteBase + Request.Url.Path).Replace("/viewer/events", ""); // Request.Url.BasePath is empty //VAI-915
                return View["EventLogView.cshtml", events.ToList()];
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        dynamic GetDictionaryItem(IHydraParentContext ctx, string level, string name)
        {
            try
            {
                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
                string text = ctx.GetDictionaryItem(level, name, vistaQuery);

                return Response.AsText(text);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        dynamic DeleteDictionaryItem(IHydraParentContext ctx, string level, string name)
        {
            try
            {
                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
                ctx.DeleteDictionaryItem(level, name, vistaQuery);

                return Ok();
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        dynamic AddDictionaryItem(IHydraParentContext ctx, string level, string name)
        {
            try
            {
                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
                string value = Request.Body.AsString();
                ctx.AddDictionaryItem(level, name, value, vistaQuery);

                return Ok();
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        Response ExportDisplayContext(IHydraParentContext ctx)
        {
            Response response = null;
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Exporting display context", "Url", Request.Url.Path); //VAI-1336
            try
            {
                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707: Refactor
                ctx.ExportDisplayContext(vistaQuery, (stream, statusCode, contentType, httpHeaders) =>
                {
                    if ((statusCode == (int)HttpStatusCode.OK) ||
                        (statusCode == (int)HttpStatusCode.PartialContent))
                    {
                        response = new Nancy.Response
                        {
                            Contents = data =>
                            {
                                stream.CopyTo(data);
                                stream.Dispose();
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
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
            return response;
        }

        Response CreateDicomDir(IHydraParentContext ctx)
        {
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Creating DicomDir for display context", "Url", Request.Url.Path); //VAI-1336

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
                var dicomDirManifest = ctx.CreateDicomDirManifest(vistaQuery);

                return Ok<DicomDirManifest>(dicomDirManifest);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        Response GetImage(IHydraParentContext ctx)
        {
            Response response = null;
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting original image", "Url", Request.Url.Path); //VAI-1336
            try
            {
                ImageQuery imageQuery = QueryUtil.Create<ImageQuery>(Context); //VAI-707: Encapsulate/Refactor
                ctx.GetImage(imageQuery, (stream, statusCode, contentType, httpHeaders) =>
                {
                    if ((statusCode == (int)HttpStatusCode.OK) ||
                        (statusCode == (int)HttpStatusCode.PartialContent))
                    {
                        response = new Nancy.Response
                        {
                            Contents = data =>
                            {
                                stream.CopyTo(data);
                                stream.Dispose();
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
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
            return response;
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

            return Response.AsText(text, "application/json");
        }

        Response GetPrintReasons(IHydraParentContext ctx)
        {
            try
            {
                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
                var reasons = ctx.GetPrintReasons(vistaQuery);

                if (reasons == null)
                {
                    reasons = new List<string>();
                }

                return Response.AsJson<List<string>>(reasons);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        Response GetExternalLinks(IHydraParentContext ctx)
        {
            var requestParams = (Context.Request.Query as Nancy.DynamicDictionary).ToDictionary();
            var links = ctx.GetExternalLinks(requestParams);
            var list = new List<ExternalLink>();
            if (links != null)
                list.AddRange(links);

            return Ok<ExternalLink[]>(links);
        }

        Response GetHelp(IHydraParentContext ctx)
        {
            if (!File.Exists(ctx.HelpFilePath))
                return NotFound();

            return Response.AsFile(ctx.HelpFilePath, "application/pdf");
        }
        //
        //Response PurgeCache(IHydraParentContext ctx)
        //{
        //    try
        //    {
        //        VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
        //        ctx.PurgeCache(vistaQuery);
        //
        //        return Ok();
        //    }
        //    catch (Exception ex)
        //    {
        //        _Logger.Error("Error purging cache", "Exception", ex.ToString());
        //
        //        return Error(ex.ToString());
        //    }
        //}

        Response GetStatus(IHydraParentContext ctx)
        {
            try
            {
                var status = ctx.GetServiceStatus();

                //status["RENDER.SERVERURL"] = "http://localhost:9901";
                //status["RENDER.DataSource"] = "MACHINENAME\\DBNAME";
                //status["RENDER.IMAGESTOREPATH"] = "C:\\VIXRenderCache";
                //status["RENDER.PURGETIMES"] = "16:50;16:55;16:59";

                //status["VIEWER.LOCALVIX"] = "http://localhost:8080";
                //status["VIEWER.ROOTURL"] = "http://+:9911";
                //status["VIEWER.TrustedClientRootUrl"] = "http://+:9922";

                return Response.AsJson<IDictionary<string, string>>(status);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }
    }
}
