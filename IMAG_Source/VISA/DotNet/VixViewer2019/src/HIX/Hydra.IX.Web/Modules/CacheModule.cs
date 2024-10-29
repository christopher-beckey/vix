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
    public class CacheModule : HixModule
    {
        public CacheModule(IHixRequestHandler handler) : base("cache")
        {
            if (HixConfiguration.RequiresAuthentication)
                this.RequiresAuthentication();

            AddGet("/{imageUid}/part", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.GetImagePart, this, parameters);
                });

            AddPost("/purge", parameters =>

            {
                return handler.ProcessRequest(HixRequest.PurgeCache, this, parameters);
            });

            AddGet("/purge", parameters =>
            {
                return handler.ProcessRequest(HixRequest.PurgeCache, this, parameters);
            });
            
            AddGet("/status", parameters =>
            {
                return handler.ProcessRequest(HixRequest.GetCacheStatus, this, parameters);
            });
            AddGet("/pdffile{imageUid}&{baseDirectory}", parameters => //VAI-307
            {
                return handler.ProcessRequest(HixRequest.GetPdfFile, this, parameters);
            });
        }
    }
}
