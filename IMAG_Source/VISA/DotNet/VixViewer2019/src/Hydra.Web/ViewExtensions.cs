using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Nancy.ViewEngines.Razor;
using System.Reflection;
using Owin;

namespace Hydra.Web
{
    public static class ViewExtensions
    {
        private static string _ViewVersion = null;

        static ViewExtensions()
        {
            _ViewVersion = Assembly.GetExecutingAssembly().GetName().Version.ToString();
        }

        public static IHtmlString HydraScript<T>(this HtmlHelpers<T> htmlHelpers, string contentPath)
        {
            contentPath = string.Format("{0}?v={1}", contentPath, _ViewVersion);
            return new NonEncodedHtmlString(string.Format("<script type='text/javascript' src='{0}'></script>", contentPath));
        }

        public static IHtmlString HydraCss<T>(this HtmlHelpers<T> htmlHelpers, string contentPath)
        {
            contentPath = string.Format("{0}?v={1}", contentPath, _ViewVersion);
            return new NonEncodedHtmlString(string.Format("<link rel='stylesheet' type='text/css' href='{0}' />", contentPath));
        }
    }
}
