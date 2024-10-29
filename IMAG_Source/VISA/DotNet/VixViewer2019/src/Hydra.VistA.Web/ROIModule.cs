using Hydra.Common.Exceptions;
using Hydra.Log;
using Hydra.VistA.Commands;
using Hydra.Web;
using Hydra.Web.Contracts;
using Hydra.Web.Modules;
using Nancy;
using Nancy.Extensions;
using Nancy.ModelBinding;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hydra.VistA.Web
{
    public class ROIModule : VistAModule
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public ROIModule(IHydraParentContext ctx) : base(VixRootPath.ROIRootPath)
        {
            AddGet("/", _ => GetPage(ctx));

            AddGet("/status", _ => GetROIStatus());

            AddGet("/status/exportqueue", _ => GetROIDicomRouting(ctx));

            AddGet("/disclosure/{patientId}/{guid}", parameters => DownloadDisclosure(ctx, parameters.patientId, parameters.guid));

            AddGet("/submit", _ => GetROISubmitPage(ctx));

            AddPost("/submit", _ => SubmitROIRequest());

            AddGet("/submit/prompts", _ => GetROISubmitPrompts(ctx));
        }

        private dynamic GetPage(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("ROI", ref ctx, out ViewerModel model, out Response response);
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

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting ROI page.", "Url", this.Request.Url.ToString());

            return View["ROI.cshtml", model];
        }

        private dynamic GetROIStatus()
        {
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Received ROI status request.", "Request", this.Request.Body.AsString());

                var request = this.BindRequest<ROIQuery>();
                if ((request == null) || !request.IsValid())
                    throw new BadRequestException("Invalid ROI query request.");

                var response = ROIQueryCommand.Execute(request);

                return FormatAsJson(response);
            }
            catch (Exception ex)
            {
                return CreateResponse(ex);
            }
        }

        private dynamic GetROIDicomRouting(IHydraParentContext ctx)
        {
            try
            {
                var request = this.Bind<ViewerRequest>();
                if ((request == null) || !request.IsValid)
                    return BadRequest("Invalid ROI parameters.");

                ValidateRequestAndSession(ctx, request); //throws an exception if invalid

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                var cdBurners = ctx.GetCDBurners(vistaQuery);
                return Ok(cdBurners);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        private dynamic GetROISubmitPage(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("submit", ref ctx, out ViewerModel model, out Response response);
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

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting ROI submission page.", "Url", this.Request.Url.ToString());

            return View["ROISubmission.cshtml", model];
        }

        private dynamic SubmitROIRequest()
        {
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Received ROI submit request.", "Request", this.Request.Body.AsString());

                var request = this.BindRequest<ROISubmitQuery>();
                if ((request == null) || !request.IsValid())
                    throw new BadRequestException("Invalid ROI query request.");

                var response = ROISubmitQueryCommand.Execute(request);

                return FormatAsJson(response);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        private dynamic GetROISubmitPrompts(IHydraParentContext ctx)
        {
            try
            {
                var request = this.Bind<ViewerRequest>();
                if ((request == null) || !request.IsValid)
                    return BadRequest("Invalid ROI parameters.");

                ValidateRequestAndSession(ctx, request); //throws an exception if invalid

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                var printReasons = ctx.GetPrintReasons(vistaQuery);
                if (printReasons == null)
                {
                    printReasons = new List<string>();
                }

                var cdBurners = ctx.GetCDBurners(vistaQuery);

                ROISubmitPrompts prompts = new ROISubmitPrompts()
                {
                    Printers = new List<string>() {},
                    Writers = cdBurners,
                    DownloadReasons = printReasons,
                    Agreement = @"All uses pose potential violations of patient privacy. <br/><br/> It is absolutely required that all users with download capability personally inspect each downloaded image. <br/><br/> For technical reasons, related to the image capture process, some of the images contain patient identification data which must be manually removed. <br/><br/> Each image downloaded is tracked and audited by the Imaging System. <br/><br/> The images are not to be distributed outside the VA, or used for any other purposes than listed on the next page. <br/><br/> The downloading user is specifically responsible for protection of these images."
                };

                return FormatAsJson(prompts);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        private dynamic DownloadDisclosure(IHydraParentContext ctx, string patientId, string guid)
        {
            Response response = null;
            try
            {
                var request = this.Bind<ViewerRequest>();
                if ((request == null) || !request.IsValid)
                    return BadRequest("Invalid ROI parameters.");

                ValidateRequestAndSession(ctx, request); //throws an exception if invalid

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                ctx.DownloadDisclosure(vistaQuery, patientId, guid, (stream, statusCode, contentType, httpHeaders) =>
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
    }
}
