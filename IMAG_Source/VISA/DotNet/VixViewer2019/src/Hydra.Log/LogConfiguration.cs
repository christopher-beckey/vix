using System.Configuration;
using System.IO;
using System.Reflection;

namespace Hydra.Log
{
    public class LogConfiguration
    {
        private string _QueueLimit = Constants.DEFAULT_QUEUELIMIT;
        private string _LogLevel = Constants.DEFAULT_LOGLEVEL;
        private string _LogLayout = Constants.DEFAULT_LAYOUT;
        private string _StartupLogLayout = Constants.DEFAULT_STARTUPLAYOUT;
        private string _AccessLogLayout = Constants.DEFAULT_ACCESSLAYOUT;
        private string _PurgeLogLayout = Constants.DEFAULT_PURGELAYOUT;
        private string _LogFolder = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), Constants.DEFAULT_LOGFOLDER);
        private string _LogFilePrefix = Constants.DEFAULT_LOGPREFIX;
        private string _LogFileSuffix = Constants.DEFAULT_LOGSUFFIX;
        private bool _LogFileIncludeDate = Constants.DEFAULT_LOGINCLUDEDATE;
        private bool _LogSingleLine = Constants.DEFAULT_LOGSINGLELINE;
        private TimeStampType _TimeStampType = Constants.DEFAULT_TIMESTAMPTYPE;
        private long _LogFileMaxSizeMB = Constants.DEFAULT_ARCHIVEABOVESIZEMB;
        private int _LogFileMaxArchiveFiles = Constants.DEFAULT_MAXARCHIVEFILES;

        public LogConfiguration(string configFilePath, string sectionName = "Log")
        {
            var config = ConfigurationManager.OpenMappedExeConfiguration(new ExeConfigurationFileMap { ExeConfigFilename = configFilePath },
                                                                (ConfigurationUserLevel.None));
            var configurationSection = config.GetSection(sectionName);
            if ((configurationSection == null) || !(configurationSection is LogConfigurationSection))
            {
                // create a default configuration section
                configurationSection = new LogConfigurationSection();
            }

            var logConfigurationSection = configurationSection as LogConfigurationSection;
            if (logConfigurationSection == null)
                return;

            // format log file
            if (Path.IsPathRooted(logConfigurationSection.LogFolder))
                this.LogFolder = logConfigurationSection.LogFolder;
            else
                // relative folder
                this.LogFolder = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), logConfigurationSection.LogFolder);

            this.QueueLimit = logConfigurationSection.QueueLimit;
            this.LogLevel = logConfigurationSection.LogLevel;
            this.LogSingleLine = logConfigurationSection.LogSingleLine;
            this.LogFilePrefix = logConfigurationSection.LogFilePrefix;
            this.LogFileSuffix = logConfigurationSection.LogFileSuffix;
            this.LogFileIncludeDate = logConfigurationSection.LogFileIncludeDate;
            this.TimeStampType = logConfigurationSection.TimeStamp;
            this.LogFileMaxSizeMB = logConfigurationSection.MaxSizeMB;
            this.LogFileMaxArchiveFiles = logConfigurationSection.MaxArchiveFiles;
        }

        public LogConfiguration()
        {
        }

        public string LogFile
        {
            get
            {
                string filename = string.Format("{0}-{1}{2}", 
                                                this.LogFilePrefix, 
                                                LogFileIncludeDate? "${{shortdate}}-" : "",
                                                this.LogFileSuffix).Trim('-');
                return Path.ChangeExtension(Path.Combine(this.LogFolder, filename), "log");
            }
        }

        public string StartupFile
        {
            get
            {
                string filename = string.Format("{0}-Startup-{1}", this.LogFilePrefix, this.LogFileSuffix).Trim('-');
                return Path.ChangeExtension(Path.Combine(this.LogFolder, filename), "log");
            }
        }

        public string PurgeFile
        {
            get
            {
                string filename = string.Format("{0}-Purge-{1}{2}",
                                                this.LogFilePrefix,
                                                LogFileIncludeDate ? "${{shortdate}}-" : "",
                                                this.LogFileSuffix).Trim('-');
                return Path.ChangeExtension(Path.Combine(this.LogFolder, filename), "log");
            }
        }

        public string AccessFile
        {
            get
            {
                string filename = string.Format("{0}-Access-{1}", this.LogFilePrefix, this.LogFileSuffix).Trim('-');
                return Path.ChangeExtension(Path.Combine(this.LogFolder, filename), "log");
            }
        }

        public string LogLayout
        {
            get
            {
                if (_LogSingleLine)
                    return _LogLayout + " ${replace:inner=${event-properties:item=DETAILS}:searchFor=\\r\\n|\\n:replaceWith=->:regex=true}";
                else
                    return _LogLayout + " ${event-properties:item=DETAILS}";
            }
        }

        public string StartupLogLayout
        {
            get
            {
                if (_LogSingleLine)
                    return _StartupLogLayout + " ${replace:inner=${event-properties:item=DETAILS}:searchFor=\\r\\n|\\n:replaceWith=->:regex=true}";
                else
                    return _StartupLogLayout + " ${event-properties:item=DETAILS}";
            }
        }

        public string PurgeLogLayout
        {
            get
            {
                if (_LogSingleLine)
                    return _PurgeLogLayout + " ${replace:inner=${event-properties:item=DETAILS}:searchFor=\\r\\n|\\n:replaceWith=->:regex=true}";
                else
                    return _PurgeLogLayout + " ${event-properties:item=DETAILS}";
            }
        }

        public string AccessLogLayout
        {
            get
            {
                if (_LogSingleLine)
                    return _AccessLogLayout + " ${replace:inner=${event-properties:item=DETAILS}:searchFor=\\r\\n|\\n:replaceWith=->:regex=true}";
                else
                    return _AccessLogLayout + " ${event-properties:item=DETAILS}";
            }
        }

        public string QueueLimit
        {
            get { return _QueueLimit; }
            set { _QueueLimit = value; }
        }

        public string LogLevel
        {
            get { return _LogLevel; }
            set { _LogLevel = value; }
        }

        public string LogFilePrefix
        {
            get { return _LogFilePrefix; }
            set { _LogFilePrefix = value; }
        }

        public string LogFileSuffix
        {
            get { return _LogFileSuffix; }
            set { _LogFileSuffix = value; }
        }

        public bool LogFileIncludeDate
        {
            get { return _LogFileIncludeDate; }
            set { _LogFileIncludeDate = value; }
        }

        public string LogFolder
        {
            get { return _LogFolder; }
            set { _LogFolder = value; }
        }

        public bool LogSingleLine
        {
            get { return _LogSingleLine; }
            set { _LogSingleLine = value; }
        }

        public TimeStampType TimeStampType
        {
            get { return _TimeStampType; }
            set { _TimeStampType = value; }
        }

        public long LogFileMaxSizeMB
        {
            get { return _LogFileMaxSizeMB; }
            set { _LogFileMaxSizeMB = value; }
        }

        public int LogFileMaxArchiveFiles
        {
            get { return _LogFileMaxArchiveFiles; }
            set { _LogFileMaxArchiveFiles = value; }
        }
    }
}