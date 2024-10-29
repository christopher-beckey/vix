using System;
using System.IO;
using log4net;


namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public static class SQLiteFacade
    {
        public static InfoDelegate InfoDelegate { get; set; }
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(SQLiteFacade).Name);
        }

        private static String Info(String infoMessage)
        {
            if (InfoDelegate != null)
            {
                InfoDelegate(infoMessage);
            }
            Logger().Info(infoMessage); // any info provided to the presentation layer will be logged.
            return infoMessage;
        }
        public static bool PurgeRenderDatabase()
        {
            bool isPurged = false;

            string renderDbPath = @"C:\Program Files\VistA\Imaging\VIX.Render.Service\Db";
            string renderDbFilePath = @"C:\Program Files\VistA\Imaging\VIX.Render.Service\Db\SQLiteDB.db";

            if (Directory.Exists(renderDbPath))
            {
                if (File.Exists(renderDbFilePath))
                {
                    try
                    {
                        File.Delete(renderDbFilePath);
                        isPurged = true;
                    }
                    catch (Exception ex)
                    {
                        Info("Failed to purge Image Render DB.  " + ex.ToString());
                    }
                }
                else
                {
                    isPurged = true;
                }
            }
            else
            {
                isPurged = true;
            }

            return isPurged;
        }
    }
}
