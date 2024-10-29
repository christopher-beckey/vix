using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web
{
    public class HydraConfiguration
    {
        public static string ApiRoutePrefix { get; set; }
        public static string ViewerRoutePrefix { get; set; }
        public static string SignalrRoutePrefix { get; set; }
        public static string BaseApiUrl { get; set; }

        public static void ConfigureViewer(Nancy.Conventions.NancyConventions nancyConventions, string viewerPath)
        {
            viewerPath = viewerPath.TrimEnd('/');

            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("hydra/bootstrap", viewerPath + "/bootstrap"));
            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("hydra/images", viewerPath + "/images"));
            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("hydra/js", viewerPath + "/js"));
            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("hydra/style", viewerPath + "/style"));

            nancyConventions.ViewLocationConventions.Add((viewName, model, context) => { return string.Concat(viewerPath + "/", viewName); });
        }
    }
}
