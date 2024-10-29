using Hydra.Log;
using Nancy;

namespace Hydra.IX.Core.Modules
{
    public static class ModuleExtensions
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static Response BadRequest(this NancyModule module, string format, params object[] args)
        {
            string message = string.Format(format, args);
            _Logger.Error("Bad Request.", "Message", message, "Url", module.Request.Url.ToString());
            return CreateResponse(message, HttpStatusCode.BadRequest);
        }

        public static Response BadRequest(this NancyModule module)
        {
            _Logger.Error("Bad Request.", "Url", module.Request.Url.ToString());
            return HttpStatusCode.BadRequest;
        }

        public static Response Ok(this NancyModule module)
        {
            return HttpStatusCode.OK;
        }

        public static Response Ok<T>(this NancyModule module, T content)
        {
            return module.Response.AsJson<T>(content);
        }

        public static Response NotFound(this NancyModule module)
        {
            return HttpStatusCode.NotFound;
        }

        public static Response NoContent(this NancyModule module)
        {
            return HttpStatusCode.NoContent;
        }

        public static Response NotFound(this NancyModule module, string format, params object[] args)
        {
            string message = string.Format(format, args);
            _Logger.Error("Not found.", "Message", message, "Url", module.Request.Url.ToString());
            return CreateResponse(message, HttpStatusCode.NotFound);
        }

        public static Response Error(this NancyModule module, string format, params object[] args)
        {
            return CreateResponse(string.Format(format, args), HttpStatusCode.InternalServerError);
        }

        public static Response NotImplemented(this NancyModule module)
        {
            return HttpStatusCode.NotImplemented;
        }

        private static Response CreateResponse(string msg, HttpStatusCode statusCode)
        {
            Response resp = msg;
            resp.StatusCode = statusCode;

            return resp;
        }
    }
}