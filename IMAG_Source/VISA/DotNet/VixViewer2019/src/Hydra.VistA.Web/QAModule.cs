using Hydra.Log;
using Hydra.Web;
using Hydra.Web.Contracts;
using Hydra.Web.Modules;
using Nancy;
using Nancy.Extensions;
using Nancy.ModelBinding;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Dynamic;

namespace Hydra.VistA.Web
{
    public class QAModule : VistAModule
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public QAModule(IHydraParentContext ctx, IRootPathProvider pathProvider)
            : base(HydraConfiguration.ViewerRoutePrefix)
        {
            if (PolicyUtil.IsPolicyEnabled("Viewer.EnableQA", true))
            {
                AddGet("qa/", _ => GetDefault(ctx));

                AddGet("qareport/", _ => GetQAReport(ctx));

                AddGet("qa/search/params", _ => GetSearchparams(ctx));

                AddGet("qa/search/captureusers/{fromDate}/{throughDate}", parameters => GetCaptureUsers(ctx, parameters.fromDate, parameters.throughDate));

                AddGet("qa/search/imagefilters/{userId}", parameters => GetImageFilters(ctx, parameters.userId));

                AddGet("qa/search/imagefilterdetails/{filterIEN}", parameters => GetImageFilterDetails(ctx, parameters.filterIEN));

                AddGet("qa/reports/{flags}/{fromDate}/{throughDate}", parameters => GetQAReviewReportStat(ctx, parameters.flags, parameters.fromDate, parameters.throughDate));

                AddGet("qa/reports/{userId}", parameters => GetQAReviewReports(ctx, parameters.userId));

                AddPost("qa/review/imageproperties", _ => SetImageProperties(ctx));

                AddGet("qa/review/imageproperties/{imageIEN}", parameters => GetImageProperties(ctx, parameters.imageIEN));

                AddPost("qa/search/{siteId}", parameters => SearchStudy(ctx, parameters.siteId));
            }
        }

        private dynamic GetDefault(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("qa", ref ctx, out ViewerModel model, out Response response);
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
                _Logger.Debug("Getting qa page.", "Url", this.Request.Url.ToString());

            return View["qa.cshtml", model];
        }

        private dynamic GetQAReport(IHydraParentContext ctx)
        {
            //VAI-707: Custom authentication and better session management
            AuthenticationParts authParts = AuthenticateMe("qareport", ref ctx, out ViewerModel model, out Response response);
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
                _Logger.Debug("Getting qa report page.", "Url", this.Request.Url.ToString());

            return View["qareport.cshtml", model];
        }

        private dynamic GetSearchparams(IHydraParentContext ctx)
        {
            var testData = new QATestData
            {
                SearchParams = new List<SearchParam>()
            };

            testData.SearchParams.Add(new SearchParam
            {
                DateRange = "1 Day",
                CapturedBy = "Physician",
                Status = "Waiting",
                Percentage = "10",
                MaxNumber = "100",
                FilterBy = "Status"
            });

            testData.SearchParams.Add(new SearchParam
            {
                DateRange = "1 Week",
                CapturedBy = "Technician",
                Status = "Assigned",
                Percentage = "50",
                MaxNumber = "200",
                FilterBy = "Percentage"
            });

            testData.SearchParams.Add(new SearchParam
            {
                DateRange = "1 Month",
                CapturedBy = "Radiologist",
                Status = "Locked",
                Percentage = "80",
                MaxNumber = "500",
                FilterBy = "DateRange"
            });

            return Ok<QATestData>(testData);
        }

        private dynamic GetCaptureUsers(IHydraParentContext ctx, string fromDate, string throughDate)
        {
            try
            {
                var request = this.Bind<ViewerRequest>();
                if ((request == null) || !request.IsValid)
                    return BadRequest("Invalid capture users parameters.");

                ValidateRequestAndSession(ctx, request); //throws an exception if invalid

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                var captureUsers = ctx.GetCaptureUsers(vistaQuery, fromDate, throughDate);

                return this.Response.AsText(captureUsers.ToString(), "text/plain");
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        private dynamic GetImageFilters(IHydraParentContext ctx, string userId)
        {
            try
            {
                var request = this.Bind<ViewerRequest>();
                if ((request == null) || !request.IsValid)
                    return BadRequest("Invalid image filters parameters.");

                ValidateRequestAndSession(ctx, request); //throws an exception if invalid

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                var imageFilters = ctx.GetImageFilters(vistaQuery, userId);

                return this.Response.AsText(imageFilters.ToString(), "text/plain");
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        private dynamic GetImageFilterDetails(IHydraParentContext ctx, string filterIEN)
        {
            try
            {
                var request = this.Bind<ViewerRequest>();
                if ((request == null) || !request.IsValid)
                    return BadRequest("Invalid image filter details parameters.");

                ValidateRequestAndSession(ctx, request); //throws an exception if invalid

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                var imageFilterDetails = ctx.GetImageFilterDetails(vistaQuery, filterIEN);

                return this.Response.AsText(imageFilterDetails.ToString(), "text/plain");
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        private dynamic SetImageProperties(IHydraParentContext ctx)
        {
            try
            {
                var request = this.Bind<ViewerRequest>();
                if ((request == null) || !request.IsValid)
                    return BadRequest("Invalid image property parameters.");

                ValidateRequestAndSession(ctx, request); //throws an exception if invalid

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                var imgArgs = JsonConvert.DeserializeObject<ExpandoObject>(this.Request.Body.AsString(), new ExpandoObjectConverter());
                var response = ctx.SetImageProperties(vistaQuery, imgArgs);

                return this.Response.AsText(response.ToString(), "text/plain");
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        private dynamic GetImageProperties(IHydraParentContext ctx, string imageIEN)
        {
            try
            {
                var request = this.Bind<ViewerRequest>();
                if ((request == null) || !request.IsValid)
                    return BadRequest("Invalid image property parameters.");

                ValidateRequestAndSession(ctx, request); //throws an exception if invalid

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                var response = ctx.GetImageProperties(vistaQuery, imageIEN);

                return this.Response.AsText(response.ToString(), "text/plain");
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        private dynamic SearchStudy(IHydraParentContext ctx, string siteId)
        {
            try
            {
                var request = this.Bind<ViewerRequest>();
                if ((request == null) || !request.IsValid)
                    return BadRequest("Invalid image property parameters.");

                ValidateRequestAndSession(ctx, request); //throws an exception if invalid

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                var studyFilter = this.Request.Body.AsString();
                var response = ctx.SearchStudy(vistaQuery, siteId, studyFilter);

                return this.Response.AsText(response as string, "text/plain");
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        private dynamic GetQAReviewReportStat(IHydraParentContext ctx, string flags, string fromDate, string throughDate)
        {
            try
            {
                var request = this.Bind<ViewerRequest>();
                if ((request == null) || !request.IsValid)
                    return BadRequest("Invalid view report parameters.");

                ValidateRequestAndSession(ctx, request); //throws an exception if invalid

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                var qaReport = ctx.GetQAReviewReportStat(vistaQuery, flags, fromDate, throughDate);

                return this.Response.AsText(qaReport.ToString(), "text/plain");
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        private dynamic GetQAReviewReports(IHydraParentContext ctx, string userId)
        {
            try
            {
                var request = this.Bind<ViewerRequest>();
                if ((request == null) || !request.IsValid)
                    return BadRequest("Invalid user report parameters.");

                ValidateRequestAndSession(ctx, request); //throws an exception if invalid

                VistAQuery vistaQuery = new VistAQuery(Context, Request); //VAI-707
                var userQAReports = ctx.GetQAReviewReports(vistaQuery, userId);

                return this.Response.AsText(userQAReports.ToString(), "text/plain");
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }
    }
}
