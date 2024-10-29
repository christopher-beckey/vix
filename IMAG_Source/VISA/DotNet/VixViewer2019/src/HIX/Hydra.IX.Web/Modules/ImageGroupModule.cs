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
    public class ImageGroupModule : HixModule
    {
        public ImageGroupModule(IHixRequestHandler handler) : base("groups")
        {
            if (HixConfiguration.RequiresAuthentication)
                this.RequiresAuthentication();

            AddGet("/{groupUid}", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.GetImageGroupRecord, this, parameters);
                });

            AddGet("/{groupUid}/status", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.GetImageGroupStatus, this, parameters);
                });

            AddPost("/", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.CreateImageGroupRecord, this, parameters);
                });

            AddGet("/{groupUid}/data", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.GetImageGroupData, this, parameters);
                });

            AddPut("/{groupUid}", parameters =>
            {
                return handler.ProcessRequest(HixRequest.UpdateImageGroupRecord, this, parameters);
            });

            AddDelete("/{groupUid}", parameters =>
            {
                return handler.ProcessRequest(HixRequest.DeleteImageGroupRecord, this, parameters);
            });

            AddPost("/dicomdir", parameters =>
            {
                return handler.ProcessRequest(HixRequest.CreateDicomDir, this, parameters);
            });
        }
    }
}
