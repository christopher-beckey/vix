using System.Configuration;
using System.IO;

namespace MockService.Common
{
    public class Globals
    {
        public static string siteNumber = "660";
        public static string icn = "icn(1008861107V475740)";
        public static string subFolder = "26732Mock";
        public static string imageSourceFolder = ConfigurationManager.AppSettings["InputFolderLocation"];
        public static string responseXmlFolder = ConfigurationManager.AppSettings["XmlFolderLocation"];
        public static string imageUploadFolder = Path.Combine(responseXmlFolder, @"ImagesToImport\");
        public static string rootViewerURL = ConfigurationManager.AppSettings["RootViewerUrl"];

        /// <summary>
        /// The default C/VIX image cache folder property
        /// </summary>
        public static string defaultImageCacheFolder
        {
            get
            {
                return $@"C:\VixCache\va-image-region\{siteNumber}\{icn}\{subFolder}\";
            }
        }

        /// <summary>
        /// Get a C/VIX image cache folder
        /// </summary>
        /// <param name="site"></param>
        /// <param name="icn"></param>
        /// <param name="subFolder"></param>
        /// <returns>The full path to the folder</returns>
        public static string GetImageCacheFolder(string site, string icn, string subFolder)
        {
            return $@"C:\VixCache\va-image-region\{siteNumber}\{icn}\{subFolder}\";
        }
    }
}