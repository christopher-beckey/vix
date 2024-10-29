using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class VixRootPath
    {
        public const string ViewerApiRootPath = "vix/api";
        public const string ViewerRootPath = "vix/viewer";
        public const string ROIRootPath = "vix/roi";
        public const string SignalrRootPath = "signalr";

        public const string StudyQuery = "/studyquery";
        public const string StudyDetails = "/studydetails";
        public const string StudyReport = "/studyreport";
        public const string StudyCache = "/studycache";
        public const string Thumbnails = "/thumbnails";
        public const string ServePdf = "/servePdf"; //VAI-1284
        public const string Images = "/images";
        public const string Ping = "/ping";
        public const string Test = "/test";
        public const string Token = "/token";
        public const string Token2 = "/token2";
        public const string SecurityToken = "/securitytoken";
    }
}
