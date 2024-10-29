using Hydra.Common.Exceptions;
using Hydra.IX.Common;
using Nancy;
using Nancy.ModelBinding;
using Nancy.Security;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Web
{
    public class ImageModule : HixModule
    {
        public ImageModule(IHixRequestHandler handler) : base("images")
        {
            if (HixConfiguration.RequiresAuthentication)
                this.RequiresAuthentication();

            AddPost("/{imageUid}", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.StoreImage, this, parameters);
                });

            AddPost("/{imageUid}/process", parameters =>
            {
                return handler.ProcessRequest(HixRequest.ProcessImage, this, parameters);
            });

            AddPost("/{imageUid}/error", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.SetImageRecordError, this, parameters);
                });

            AddPost("/", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.CreateImageRecord, this, parameters);
                });

            AddGet("/{imageUid}/record", parameters =>
            {
                return handler.ProcessRequest(HixRequest.GetImageRecord, this, parameters);
            });

        }
    }
}
