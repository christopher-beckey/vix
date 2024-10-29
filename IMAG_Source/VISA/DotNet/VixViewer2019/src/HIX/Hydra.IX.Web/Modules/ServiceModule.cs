using Hydra.IX.Common;
using Nancy;
using Nancy.ModelBinding;
using Nancy.Security;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Web
{
    public class ServiceModule : HixModule
    {
        public ServiceModule(IHixRequestHandler handler) : base("service")
        {
            AddGet("/", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.Default, this, parameters);
                });

            AddGet("/status", parameters =>
            {
                return handler.ProcessRequest(HixRequest.GetStatus, this, parameters);
            });
            AddGet("/pdffile/{imageUid}&{baseDirectory}", parameters => //VAI-307
            {
                return handler.ProcessRequest(HixRequest.GetPdfFile, this, parameters);
            });
            AddGet("/servepdfurl/{contextID}&{baseDirectory}", parameters => //VAI-1284
            {
                return handler.ProcessRequest(HixRequest.GetServePdf, this, parameters);
            });
            AddGet("/log/settings", parameters =>
            {
                return handler.ProcessRequest(HixRequest.GetLogSettings, this, parameters);
            });

            AddPost("/log/settings", parameters =>
            {
                return handler.ProcessRequest(HixRequest.SetLogSettings, this, parameters);
            });

            AddGet("/log/files", parameters =>
            {
                return handler.ProcessRequest(HixRequest.GetLogFile, this, parameters);
            });

            AddDelete("/log/files", parameters =>
            {
                return handler.ProcessRequest(HixRequest.DeleteLogFiles, this, parameters);
            });

            AddGet("/log/events", parameters =>
            {
                return handler.ProcessRequest(HixRequest.GetLogEvents, this, parameters);
            });
        }

        private Response GetReleaseHistory(IRootPathProvider pathProvider)
        {
            string content = pathProvider.GetRootPath();
            return this.Response.AsText(content);
        }
    }
}
