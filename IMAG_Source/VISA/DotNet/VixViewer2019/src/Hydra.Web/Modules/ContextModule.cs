using Hydra.Log;
using Hydra.Security;
using Hydra.VistA;
using Hydra.Web.Contracts;
using Nancy;
using Nancy.Extensions;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Hydra.Web.Modules
{
    public class ContextModule : BaseModule
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public ContextModule(IHydraParentContext ctx) : base("context", HydraConfiguration.ApiRoutePrefix)
        {
            AddGet("/getUrlResponse", _ => GetRedirectedUrlResponse(ctx)); //VAI-760

            AddGet("/pstate", _ => GetPStates(ctx));
            AddPost("/pstate", _ => AddPState(ctx));
            AddDelete("/pstate", _ => DeletePState(ctx));

            AddGet("/metadata", _ => GetMetadata(ctx));
            AddGet("/metadata/thumbnail", _ => GetMetadataThumbnail(ctx));
            AddDelete("/metadata/image", _ => DeleteImageMetadata(ctx));
            AddGet("/metadata/image/imageinfo", _ => GetMetadataImageInfo(ctx));
            AddPost("/metadata/image/sensitive", _ => SensitiveImageMetadata(ctx));
            AddGet("/metadata/image/reasons", _ => GetImageDeleteReasons(ctx));
            AddGet("/metadata/image/editOptions/{indexes}", parameters => GetImageEditOptions(ctx, parameters.indexes));
            AddPost("/metadata/image/edit", _ => SaveEditedImage(ctx));
        }

        /// <summary>
        /// Get the response from another URL if it is valid/safe. (VAI-760)
        /// </summary>
        /// <param name="ctx">The HydraParentContext</param>
        /// <returns>The reponse from the given URL (in the HTTP request header).</returns>
        /// <remarks>Internal API. Originally written for VAI-760.</remarks>
        private dynamic GetRedirectedUrlResponse(IHydraParentContext ctx)
        {
            string validUrl = "";
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Getting redirected URL response.", "Url", Request.Url.Path); //VAI-1336
                Dictionary<string, IEnumerable<string>> requestHeaders = Context.Request.Headers?.ToDictionary(k => k.Key.ToLower(), v => v.Value);
                if (requestHeaders == null)
                    return BadRequest("Invalid parameters.");
                string possibleUrl = requestHeaders["url"].FirstOrDefault();
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Testing possible URL.", "Url", possibleUrl);
                validUrl = SecurityUtil.GetValidUrl(possibleUrl);
                if (string.IsNullOrWhiteSpace(validUrl))
                {
                    _Logger.Error("URL Test FAILED! Possible Hacker call #2.", "Requested Bad URL", possibleUrl);
                    return BadRequest("Invalid parameters.");
                }
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Pass. Calling URL and returning its response.");
            return Response.AsRedirect(validUrl);
        }

        // get all pstates for a context
        Response GetPStates(IHydraParentContext ctx)
        {          
            try
            {
                var vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
                var pstates = ctx.GetPresentationStates(vistaQuery);

                if ((pstates == null) || (pstates.Count() == 0))
                    return NoContent();

                return Ok<List<Hydra.Common.Entities.StudyPresentationState>>(pstates);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        Response AddPState(IHydraParentContext ctx)
        {
            var vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
            var pstate = JsonConvert.DeserializeObject<Hydra.Common.Entities.StudyPresentationState>(this.Request.Body.AsString());
            ctx.AddPresentationState(vistaQuery, pstate);

            return Ok();
        }

        Response DeletePState(IHydraParentContext ctx)
        {
            var vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
            var pstate = JsonConvert.DeserializeObject<Hydra.Common.Entities.StudyPresentationState>(this.Request.Body.AsString());
            ctx.DeletePresentationState(vistaQuery, pstate);

            return Ok();
        }

        Response GetMetadata(IHydraParentContext ctx)
        {
            try
            {
                var vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
                var metadata = ctx.GetDisplayContextMetadata(vistaQuery);

                if (metadata == null)
                    return NoContent();

                return Ok<Hydra.Web.Common.DisplayContextMetadata>(metadata);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        Response DeleteImageMetadata(IHydraParentContext ctx)
        {
            try
            {
                var vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
                var request = JsonConvert.DeserializeObject<Hydra.Web.Common.ImageDeleteRequest>(this.Request.Body.AsString());
                var response = ctx.DeleteImageMetadata(vistaQuery, request);

                return Ok<Hydra.Web.Common.ImageDeleteResponse[]>(response);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        private dynamic GetMetadataThumbnail(IHydraParentContext ctx)
        {
            Response response = null;
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Getting metadata thumbnail.", "Url", Request.Url.Path); //VAI-1336

                ImageQuery imageQuery = QueryUtil.Create<ImageQuery>(Context); //VAI-707: Encapsulate/Refactor
                ctx.GetImage(imageQuery, (stream, statusCode, contentType, httpHeaders) =>
                {
                    if ((statusCode == (int)HttpStatusCode.OK) ||
                        (statusCode == (int)HttpStatusCode.PartialContent))
                    {
                        response = this.Response.AsJson<Hydra.Entities.Thumbnail>(new Hydra.Entities.Thumbnail((stream as System.IO.MemoryStream).ToArray()));
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

        Response GetMetadataImageInfo(IHydraParentContext ctx)
        {
            try
            {
                var metadata = ctx.GetMetadataImageInfo(Context);

                return CreateResponse(metadata, HttpStatusCode.OK);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        Response SensitiveImageMetadata(IHydraParentContext ctx)
        {
            try
            {
                var vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
                var request = JsonConvert.DeserializeObject<Hydra.Web.Common.SensitiveImageRequest>(this.Request.Body.AsString());
                ctx.SensitiveImageMetadata(vistaQuery, request);

                return Ok();
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        Response GetImageDeleteReasons(IHydraParentContext ctx)
        {
            try
            {
                var vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
                var reasons = ctx.GetImageDeleteReasons(vistaQuery);

                if (reasons == null)
                {
                    reasons = new List<string>();
                }

                return this.Response.AsJson<List<string>>(reasons);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        Response GetImageEditOptions(IHydraParentContext ctx, string indexes)
        {
            try
            {
                var vistaQuery = new VistAQuery(Context, Request); //VAI-707: Encapsulate/Refactor
                var editOptions = ctx.GetImageEditOptions(vistaQuery, indexes);

                return this.Response.AsJson<object>(editOptions as object);
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }

        Response SaveEditedImage(IHydraParentContext ctx)
        {
            try
            {
                //TODO: VIX call

                return Ok();
            }
            catch (Exception ex)
            {
                return Error(ex.ToString());
            }
        }
    }
}
