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
    public class DicomDirModule : HixModule
    {
        public DicomDirModule(IHixRequestHandler handler) : base("dicomdir")
        {
            if (HixConfiguration.RequiresAuthentication)
                this.RequiresAuthentication();

            AddGet("/{groupUid}", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.GetDicomDir, this, parameters);
                });

            AddGet("/{groupUid}/status", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.GetDicomDirStatus, this, parameters);
                });

            AddPost("/{groupUid}/", parameters =>
                {
                    return handler.ProcessRequest(HixRequest.CreateDicomDir, this, parameters);
                });
        }
    }
}
