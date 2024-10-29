using System.Configuration;

namespace Hydra.Log
{
    public class LogConfigurationSection : ConfigurationSection
    {
        [ConfigurationProperty("LogFilePrefix", DefaultValue = Constants.DEFAULT_LOGPREFIX)]
        public string LogFilePrefix
        {
            get { return (string)base["LogFilePrefix"]; }
        }

        [ConfigurationProperty("LogFileSuffix", DefaultValue = Constants.DEFAULT_LOGSUFFIX)]
        public string LogFileSuffix
        {
            get { return (string)base["LogFileSuffix"]; }
        }

        [ConfigurationProperty("LogFileIncludeDate", DefaultValue = Constants.DEFAULT_LOGINCLUDEDATE)]
        public bool LogFileIncludeDate
        {
            get { return (bool)base["LogFileIncludeDate"]; }
        }

        [ConfigurationProperty("LogFolder", DefaultValue = Constants.DEFAULT_LOGFOLDER)]
        public string LogFolder
        {
            get { return (string)base["LogFolder"]; }
        }

        [ConfigurationProperty("QueueLimit", DefaultValue = Constants.DEFAULT_QUEUELIMIT)]
        public string QueueLimit
        {
            get { return (string)base["QueueLimit"]; }
        }

        [ConfigurationProperty("LogLevel", DefaultValue = Constants.DEFAULT_LOGLEVEL)]
        public string LogLevel
        {
            get { return (string)base["LogLevel"]; }
        }

        [ConfigurationProperty("LogSingleLine", DefaultValue = Constants.DEFAULT_LOGSINGLELINE)]
        public bool LogSingleLine
        {
            get { return (bool)base["LogSingleLine"]; }
        }

        [ConfigurationProperty("TimeStamp", DefaultValue = Constants.DEFAULT_TIMESTAMPTYPE)]
        public TimeStampType TimeStamp
        {
            get { return (TimeStampType)base["TimeStamp"]; }
        }

        [ConfigurationProperty("MaxSizeMB", DefaultValue = Constants.DEFAULT_ARCHIVEABOVESIZEMB)]
        public long MaxSizeMB
        {
            get { return (long)base["MaxSizeMB"]; }
        }

        [ConfigurationProperty("MaxArchiveFiles", DefaultValue = Constants.DEFAULT_MAXARCHIVEFILES)]
        public int MaxArchiveFiles
        {
            get { return (int)base["MaxArchiveFiles"]; }
        }
    }
}