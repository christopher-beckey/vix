namespace Hydra.Log
{
    internal static class Constants
    {
        public const string DEFAULT_LAYOUT = "[${longdate}${date:format= K}] [${uppercase:${level}}] [${logger}] [${message}]";
        public const string DEFAULT_STARTUPLAYOUT = "[${longdate}${date:format= K}] [${uppercase:${level}}] [${event-properties:item=LOGGERNAME}] [${message}]";
        public const string DEFAULT_PURGELAYOUT = "[${longdate}${date:format= K}] [${uppercase:${level}}] [${event-properties:item=LOGGERNAME}] [${message}]";
        public const string DEFAULT_ACCESSLAYOUT = "[${longdate}${date:format= K}] [${message}]";
        public const string DEFAULT_QUEUELIMIT = "5000";
        public const string DEFAULT_LOGFOLDER = "Log";
        public const string DEFAULT_LOGPREFIX = "LogFile";
        public const string DEFAULT_LOGSUFFIX = null;
        public const bool DEFAULT_LOGINCLUDEDATE = false;
        public const string DEFAULT_LOGLEVEL = "Trace";
        public const bool DEFAULT_LOGSINGLELINE = true;
        public const TimeStampType DEFAULT_TIMESTAMPTYPE = TimeStampType.Local;
        public const long DEFAULT_ARCHIVEABOVESIZEMB = 50;
        public const string DEFAULT_ARCHIVEFOLDER = "Archive";
        public const int DEFAULT_MAXARCHIVEFILES = 10;
    }
}