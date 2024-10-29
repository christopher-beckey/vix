namespace Hydra.IX.Common
{
    public static class HixConfiguration
    {
        public static string ApiRoutePrefix { get; set; }
        public static string ViewerRoutePrefix { get; set; }
        public static bool RequiresAuthentication { get; set; }

        static HixConfiguration()
        {
            ApiRoutePrefix = "hix";
            ViewerRoutePrefix = "static";
        }
    }
}