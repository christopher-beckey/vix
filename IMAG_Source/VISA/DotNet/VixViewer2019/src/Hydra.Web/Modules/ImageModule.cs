using Hydra.Log;
using Hydra.Web.Contracts;
using Nancy;
using Nancy.ModelBinding;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Hydra.Web.Modules
{
    public class ImageModule : BaseModule
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public ImageModule(IHydraParentContext ctx) : base("images", HydraConfiguration.ApiRoutePrefix)
        {
            AddGet("/", _ => GetImages(ctx));
        }

        Response GetImages(IHydraParentContext ctx)
        {
            Hydra.IX.Common.ImagePartRequest request = this.Bind<Hydra.IX.Common.ImagePartRequest>();
            if (request == null)
                return BadRequest();
            
            Response response = null;

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Getting image.", "Url", Request.Url.Path); //VAI-1336

            //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
            Dictionary<string, IEnumerable<string>> requestHeaders = Context.Request.Headers?.ToDictionary(k => k.Key.ToLower(), v => v.Value);
            if (requestHeaders == null)
                return BadRequest();
            if (string.IsNullOrEmpty(request.CacheLocator) && requestHeaders.ContainsKey("cachelocator"))
            {
                request.CacheLocator = requestHeaders["cachelocator"].FirstOrDefault();
            }

            ctx.GetImagePart(request, (stream, statusCode, contentType, httpHeaders) =>
                {
                    if ((statusCode == (int) HttpStatusCode.OK) ||
                        (statusCode == (int) HttpStatusCode.PartialContent))
                    {
                        response = new Nancy.Response
                        {
                            Contents = data =>
                            {
                                try
                                {
                                    stream.CopyTo(data);
                                }
                                catch (Exception e)
                                {
                                    //no-op: Gracefully handle (swallow) when client abandons the connection
                                }
                            },
                            ContentType = contentType,
                            StatusCode = (HttpStatusCode) statusCode
                        };

                        if (httpHeaders != null)
                        {
                            foreach (var item in httpHeaders)
                            {
                                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                                if (item.Key.ToLower() != "transfer-encoding")
                                    response.WithHeader(item.Key.ToLower(), item.Value.First());
                            }
                        }
                    }
                    else
                    {
                        response = new Nancy.Response { StatusCode = (HttpStatusCode) statusCode };
                    }
                });
#if DEBUG_ONLY_FOR_RESEARCH
            //VAI-1336: ONLY RUN THIS FOR RESEARCH. IT EATS THE RESPONSE!
            //To run this, TEMPORARILY change #if DEBUG_ONLY_FOR_RESEARCH to #if DEBUG, but do NOT
            //expect the images to display! If Response had a clone, we would use it, but it doesn't.
            if (_Logger.IsDebugEnabled)
            {
                byte[] buffer;
                using (var memoryStream = new MemoryStream())
                {
                    response.Contents.Invoke(memoryStream);
                    buffer = memoryStream.ToArray();
                }
                var contentLength = (response.Headers.ContainsKey("Content-Length")) ? Convert.ToInt64(response.Headers["Content-Length"]) : buffer.Length;
                var utf8Buffer = System.Text.Encoding.UTF8.GetString(buffer);
                var maxBufferLen = utf8Buffer.Length >= 30 ? 30 : utf8Buffer.Length;
                var first30Contents = utf8Buffer.Substring(0, maxBufferLen);
                var pos1stAmp = Context.Request.Url.ToString().IndexOf('&');
                var maxUrlLen = 0;
                if (pos1stAmp >= 0)
                {
                    var pos2ndAmp = Context.Request.Url.ToString().IndexOf('&', pos1stAmp + 1);
                    if (pos2ndAmp >= 0)
                        maxUrlLen = pos2ndAmp;
                }
                var firstPartUrl = Context.Request.Url.ToString().Substring(0, maxUrlLen);
                _Logger.Debug("Returning image.", "StatusCode", response.StatusCode, $"1st {maxBufferLen} bytes of Contents", first30Contents, "Contents length", contentLength, "start of Url", firstPartUrl);
            }
#endif
            return response;
        }
    }
}
