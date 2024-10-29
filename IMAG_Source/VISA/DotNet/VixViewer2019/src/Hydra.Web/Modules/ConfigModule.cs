using Hydra.Entities;
using Hydra.Log;
using Hydra.Web.Contracts;
using Nancy;
using Nancy.ModelBinding;

namespace Hydra.Web.Modules
{
    public class ConfigModule : BaseModule
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public ConfigModule(IHydraParentContext ctx, IRootPathProvider pathProvider) : base("config", HydraConfiguration.ApiRoutePrefix)
        {
            AddGet("/", _ => GetConfig());
        }

        Response GetConfig()
        {
            var request = this.Bind<ConfigRequest>();
            if ((request == null) || !request.IsValid)
                return BadRequest();

            switch (request.Parameter.ToLower())
            {
                case "textoverlay":
                    var testOverlay = new TextOverlay()
                    {
                        bottomleft = new string[] { "ImageNumber", "WCWW", "Accession_Number", "Content_Date_Time", "Scale"}
                    };
                    return Ok<TextOverlay>(testOverlay);
            }

            return BadRequest();
        }
    }
}
