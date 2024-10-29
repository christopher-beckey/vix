using Hydra.IX.Common;
using Nancy;
using Nancy.Json;
using Nancy.ModelBinding;
using Nancy.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Web
{
    public class DisplayContextModule : HixModule
    {
        public DisplayContextModule(IHixRequestHandler handler) : base("dispctx")
        {
            if (HixConfiguration.RequiresAuthentication)
                this.RequiresAuthentication();

            AddGet("/", parameters =>
            {
                return handler.ProcessRequest(HixRequest.SearchDisplayContextRecords, this, parameters);
            });

            AddGet("/{contextId}", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.GetDisplayContextRecord, this, parameters);
                });

            AddPost("/", parameters =>
            {
                return handler.ProcessRequest(HixRequest.CreateDisplayContextRecord, this, parameters);
            });

            AddDelete("/{contextId}", parameters =>
            {
                return handler.ProcessRequest(HixRequest.DeleteDisplayContextRecord, this, parameters);
            });

            //VAI-307
            AddPost("/pdffile", parameters =>
            {
                return handler.ProcessRequest(HixRequest.GetPdfFile, this, parameters);
            });

            AddPost("/pstate", parameters =>
            {
                return handler.ProcessRequest(HixRequest.CreatePRFile, this, parameters);
            });
        }
    }
}
