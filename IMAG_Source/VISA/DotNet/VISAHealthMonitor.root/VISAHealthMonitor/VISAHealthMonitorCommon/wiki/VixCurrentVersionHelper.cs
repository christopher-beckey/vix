using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net;
using System.IO;
using System.Runtime.CompilerServices;

namespace VISAHealthMonitorCommon.wiki
{
    public class VixCurrentVersionHelper
    {

        private static string currentVersion = null;
        private static DateTime? cachedDate = null;

        /// <summary>
        /// This method caches the current version and will use that cached version if it is available and has not expired (value from yesterday).
        /// </summary>
        /// <param name="wikiConfiguration"></param>
        /// <param name="timeout"></param>
        /// <returns></returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static string GetCachedCurrentReleasedVersion(WikiConfiguration wikiConfiguration, int timeout)
        {
            if (currentVersion == null || IsExpired())
            {
                currentVersion = GetCurrentReleasedVixVersion(wikiConfiguration, timeout);
                cachedDate = DateTime.Now;
            }
            return currentVersion;
        }

        private static bool IsExpired()
        {
            if (cachedDate.HasValue)
            {
                DateTime dt = cachedDate.Value;
                bool isYesterday = DateTime.Today - dt.Date == TimeSpan.FromDays(1);
                return isYesterday;
            }
            return true;
        }

        /// <summary>
        /// Always gets the currently released version from the VIX Wiki page
        /// </summary>
        /// <param name="wikiConfiguration"></param>
        /// <param name="timeout"></param>
        /// <returns></returns>
        public static string GetCurrentReleasedVixVersion(WikiConfiguration wikiConfiguration, int timeout)
        {
            string vixCurrentVersionWikiPage = wikiConfiguration.WikiRootUrl + "?page=CurrentVIXVersion&&skin=raw";
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(vixCurrentVersionWikiPage);
            request.Timeout = timeout * 1000;
            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            StreamReader reader = new StreamReader(IOUtilities.getStreamFromResponse(response));

            string line = reader.ReadLine();
            return line;
        }
    }
}
