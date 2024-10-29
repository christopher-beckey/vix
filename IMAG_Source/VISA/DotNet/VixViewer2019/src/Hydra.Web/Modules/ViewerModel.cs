using Hydra.Web.Common;

namespace Hydra.Web.Modules
{
    public class ViewerModel
    {
        public string BaseUrl { get; set; } //VAI-915: root URL
        public string BaseApiUrl { get; set; }
        public string BaseViewerUrl { get; set; } // page (not necessarily the viewer page) URL
        public string BaseSignalrUrl { get; set; }
        public string TestData { get; set; }
        public string SecurityToken { get; set; }
        public UserDetails UserDetails { get; set; }
        public string AccessCode { get; set; } //VAI-707
        public string VerifyCode { get; set; } //VAI-707
        public string ReturnTo { get; set; } //VAI-707
        public string ErrorMsg { get; set; } //VAI-707
    }
}
