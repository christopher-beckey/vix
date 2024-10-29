using System;
using System.IO;

namespace VIX.Viewer.Service
{
    public static class Globals
    {
        //VAI-780: For Debug config, assume local dev machine (bin). For Release config, assume deployed machine (program files).
#pragma warning disable IDE0051 //variable not used
#pragma warning disable CS0414 //variable not used
        private static readonly string defaultDebugConfigFilePath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Vix.Viewer.config");
        private static readonly string defaultReleaseConfigFilePath = @"C:\Program Files\VistA\Imaging\Vix.Config\Vix.Viewer.config";
#pragma warning restore CS0414
#pragma warning restore IDE0051

#if DEBUG
        public static string ConfigFilePath = defaultDebugConfigFilePath;
#else
        public static string ConfigFilePath = defaultReleaseConfigFilePath;
#endif
        public static void OverideConfigFilePath(string filePath)
        {
            ConfigFilePath = filePath;
        }
    }
}
