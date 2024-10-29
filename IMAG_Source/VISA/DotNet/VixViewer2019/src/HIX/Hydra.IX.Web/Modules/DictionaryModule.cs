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
    public class DictionaryModule : HixModule
    {
        public DictionaryModule(IHixRequestHandler handler) : base("dict")
        {
            if (HixConfiguration.RequiresAuthentication)
                this.RequiresAuthentication();

            AddGet("/{name}", parameters =>
            {
                return handler.ProcessRequest(HixRequest.GetDictionaryRecord, this, parameters);
            });

            AddGet("/{name}/search", parameters =>
            {
                return handler.ProcessRequest(HixRequest.SearchDictionaryRecords, this, parameters);
            });

            AddPost("/{name}", parameters =>
            {
                return handler.ProcessRequest(HixRequest.AddDictionaryRecord, this, parameters);
            });

            AddDelete("/{name}", parameters =>
            {
                return handler.ProcessRequest(HixRequest.DeleteDictionaryRecord, this, parameters);
            });
        }
    }
}
