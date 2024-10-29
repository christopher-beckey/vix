using System.Configuration;
using System.Web.Mvc;

namespace MockService.Controllers
{
    public class HomeController : Controller
    {
        private string rootViewerURL = ConfigurationManager.AppSettings["rootViewerURL"];
        public ActionResult Index()
        {
            @ViewBag.RootViewerURL = rootViewerURL;
            return View();
        }

        public ActionResult Info()
        {
            @ViewBag.RootViewerURL = rootViewerURL;
            return View();
        }

        public ActionResult Contact()
        {
          return View();
        }
    }
}