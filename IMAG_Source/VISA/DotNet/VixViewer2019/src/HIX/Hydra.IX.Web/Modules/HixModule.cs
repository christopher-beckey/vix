using Hydra.IX.Common;
using Nancy;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Web
{
    public class HixModule : NancyModule
    {
        private string moduleRoutePrefix;

        public HixModule() : base(HixConfiguration.ApiRoutePrefix)
        {
        }

        public HixModule(string routePrefix) : base(HixConfiguration.ApiRoutePrefix)
        {
            moduleRoutePrefix = routePrefix.TrimEnd('/');
        }

        public void AddGet(string path, Func<dynamic, dynamic> func)
        {
            Get[moduleRoutePrefix + "/" + path.TrimStart('/')] = func;
        }

        public void AddPost(string path, Func<dynamic, dynamic> func)
        {
            Post[moduleRoutePrefix + "/" + path.TrimStart('/')] = func;
        }

        public void AddPut(string path, Func<dynamic, dynamic> func)
        {
            Put[moduleRoutePrefix + "/" + path.TrimStart('/')] = func;
        }

        public void AddDelete(string path, Func<dynamic, dynamic> func)
        {
            Delete[moduleRoutePrefix + "/" + path.TrimStart('/')] = func;
        }
    }
}
