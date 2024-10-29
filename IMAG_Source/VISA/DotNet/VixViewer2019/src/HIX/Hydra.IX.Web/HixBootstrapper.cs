using Hydra.IX.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Web
{
    public class HixBootstrapper
    {
        public static void Start(Nancy.TinyIoc.TinyIoCContainer container, Nancy.Bootstrapper.IPipelines pipelines)
        {
        }

        public static void ConfigureConventions(Nancy.Conventions.NancyConventions nancyConventions)
        {
            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("hix/bootstrap", HixConfiguration.ViewerRoutePrefix + "/bootstrap"));
            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("hix/images", HixConfiguration.ViewerRoutePrefix + "/images"));
            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("hix/js", HixConfiguration.ViewerRoutePrefix + "/js"));
            nancyConventions.StaticContentsConventions.Add(Nancy.Conventions.StaticContentConventionBuilder.AddDirectory("hix/style", HixConfiguration.ViewerRoutePrefix + "/style"));

            //nancyConventions.ViewLocationConventions.Add((viewName, model, context) => { return string.Concat(HixConfiguration.ViewerRoutePrefix + "/", viewName); });
        }

        public static void RegisterHandler(Nancy.TinyIoc.TinyIoCContainer container, IHixRequestHandler instance)
        {
            container.Register<IHixRequestHandler>(instance);
        }
    }

}
