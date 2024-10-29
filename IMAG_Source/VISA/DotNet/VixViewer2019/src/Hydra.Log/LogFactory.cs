using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Hydra.Log
{
    internal class LogFactory : Hydra.Log.ILogFactory
    {
        private Dictionary<NLog.Logger, ILogger> _LoggerCache = new Dictionary<NLog.Logger, ILogger>();
        private object _SyncLock = new object();
        private LogConfiguration _LogConfiguration = new LogConfiguration();
        private NLog.Config.LoggingRule _LoggingRule = null;
        private NLog.Targets.FileTarget _StartupTarget = null;
        private NLog.Targets.FileTarget _ClassTarget = null;
        private NLog.Targets.FileTarget _AccessTarget = null;
        private NLog.Targets.FileTarget _PurgeTarget = null;
        private Regex _regex = new Regex(@"^\[(?'datetime'[^\]]*)\] \[(?'level'[^\]]*)\] \[(?'logger'[^\]]*)\] \[(?'message'[^\]]*)\] (?'parameters'[^$]*)");

        public LogFactory()
        {
            UpdateNLog();
        }

        public ILogger GetLogger(string name, LoggerType loggerType)
        {
            lock (_SyncLock)
            {
                string loggerName = null;
                
                switch (loggerType)
                {
                    case LoggerType.Class: loggerName = name; break;
                    case LoggerType.Purge: loggerName = "PURGE_" + name; break;
                    case LoggerType.Startup: loggerName = "STARTUP_" + name; break;
                    case LoggerType.Access: loggerName = "ACCESS_" + name; break;
                }

                ILogger logger = null;
                var key = NLog.LogManager.GetLogger(loggerName);
                if (!_LoggerCache.TryGetValue(key, out logger))
                {
                    logger = new Logger(key, name, loggerType);
                    _LoggerCache[key] = logger;
                }

                return logger;
            }
        }

        public LogConfiguration Configuration
        {
            get
            {
                return _LogConfiguration;
            }

            set
            {
                if (value == null)
                    throw new ArgumentNullException("LogConfiguration cannot be null");

                _LogConfiguration = value;

                UpdateNLog();
            }
        }

        private void UpdateNLog()
        {
            // clear logger cache
            lock (_SyncLock)
            {
                _LoggerCache.Clear();

                var nLogConfiguration = new NLog.Config.LoggingConfiguration();

                // startup target
                _StartupTarget = new NLog.Targets.FileTarget
                {
                    FileName = _LogConfiguration.StartupFile,
                    ConcurrentWrites = true,
                    Layout = _LogConfiguration.StartupLogLayout,
                    DeleteOldFileOnStartup = true
                };
                nLogConfiguration.AddTarget("startuplogfile", _StartupTarget);

                var rule = new NLog.Config.LoggingRule("STARTUP_*", NLog.LogLevel.Trace, _StartupTarget);
                rule.Final = true;
                nLogConfiguration.LoggingRules.Add(rule);

                // purge target
                _PurgeTarget = new NLog.Targets.FileTarget
                {
                    FileName = _LogConfiguration.PurgeFile,
                    ConcurrentWrites = true,
                    Layout = _LogConfiguration.PurgeLogLayout,
                    DeleteOldFileOnStartup = true
                };

                SetArchivalProperties(_PurgeTarget, _LogConfiguration.PurgeFile);

                nLogConfiguration.AddTarget("purgelogfile", _PurgeTarget);

                rule = new NLog.Config.LoggingRule("PURGE_*", NLog.LogLevel.Trace, _PurgeTarget);
                rule.Final = true;
                nLogConfiguration.LoggingRules.Add(rule);

                // access target
                _AccessTarget = new NLog.Targets.FileTarget
                {
                    FileName = _LogConfiguration.AccessFile,
                    ConcurrentWrites = true,
                    Layout = _LogConfiguration.AccessLogLayout,
                    DeleteOldFileOnStartup = true
                };

                SetArchivalProperties(_AccessTarget, _LogConfiguration.AccessFile);

                nLogConfiguration.AddTarget("accesslogfile", _AccessTarget);

                rule = new NLog.Config.LoggingRule("ACCESS_*", NLog.LogLevel.Trace, _AccessTarget);
                rule.Final = true;
                nLogConfiguration.LoggingRules.Add(rule);

                // default target
                _ClassTarget = new NLog.Targets.FileTarget
                {
                    FileName = _LogConfiguration.LogFile,
                    ConcurrentWrites = true,
                    Layout = _LogConfiguration.LogLayout
                };

                SetArchivalProperties(_ClassTarget, _LogConfiguration.LogFile);

                nLogConfiguration.AddTarget("logfile", _ClassTarget);

                _LoggingRule = new NLog.Config.LoggingRule("*", NLog.LogLevel.FromString(_LogConfiguration.LogLevel), _ClassTarget);
                nLogConfiguration.LoggingRules.Add(_LoggingRule);

                NLog.LogManager.Configuration = nLogConfiguration;

                if (_LogConfiguration.TimeStampType == TimeStampType.Local)
                    NLog.Time.TimeSource.Current = new NLog.Time.FastLocalTimeSource();
                else if (_LogConfiguration.TimeStampType == TimeStampType.UTC)
                    NLog.Time.TimeSource.Current = new NLog.Time.FastUtcTimeSource();
            }
        }

        private void SetArchivalProperties(NLog.Targets.FileTarget fileTarget, string logFileName)
        {
            string fileName = Path.GetFileName(logFileName);
            int index = fileName.LastIndexOf('.');
            if (index < 0)
                throw new ArgumentOutOfRangeException("Invalid log file format.");
            fileName = Path.Combine(Path.GetDirectoryName(logFileName), "Archive", fileName.Insert(index, "_{#}."));

            fileTarget.ArchiveFileName = fileName;
            fileTarget.ArchiveAboveSize = _LogConfiguration.LogFileMaxSizeMB * 1000000;
            fileTarget.ArchiveOldFileOnStartup = true;
            fileTarget.MaxArchiveFiles = _LogConfiguration.LogFileMaxArchiveFiles;
            fileTarget.ArchiveEvery = NLog.Targets.FileArchivePeriod.Hour;
            fileTarget.ArchiveNumbering = NLog.Targets.ArchiveNumberingMode.Rolling;
        }

        public string LogLevel 
        { 
            set
            {
                lock (_SyncLock)
                {
                    if (_LoggingRule != null)
                    {
                        _LogConfiguration.LogLevel = value;
                        _LoggingRule.EnableLoggingForLevel(NLog.LogLevel.FromString(value));

                        NLog.LogManager.ReconfigExistingLoggers();
                    }
                }
            }

            get
            {
                lock (_SyncLock)
                {
                    return (_LogConfiguration != null) ? _LogConfiguration.LogLevel : null;
                }
            }
        }

        private string GetLogFolder()
        {
            lock (_SyncLock)
            {
                if (_ClassTarget == null)
                    return null;

                var logEvent = new NLog.LogEventInfo { TimeStamp = DateTime.UtcNow };
                return System.IO.Path.GetDirectoryName(_ClassTarget.FileName.Render(logEvent));
            }
        }

        public LogFileItem[] GetLogFiles()
        {
            var logFolder = GetLogFolder();
            DirectoryInfo directoryInfo = new DirectoryInfo(logFolder);
            var result = directoryInfo.GetFiles("*.log", SearchOption.AllDirectories)
                                      .OrderByDescending(t => t.LastWriteTime)
                                      .Select(x => new LogFileItem 
                                                       {
                                                           FileName = GetRelativePath(x.FullName, logFolder), 
                                                           TimeStamp = x.LastWriteTime.ToShortTimeString() 
                                                       }).ToList();

            return result.ToArray();
        }

        public string GetLogFilePath(string logFileName)
        {
            return Path.Combine(GetLogFolder(), logFileName);
        }

        public LogEventItem[] GetLogItems(string logFile, int pageSize, int pageIndex, out bool more)
        {
            more = false;

            string filePath = Path.Combine(GetLogFolder(), logFile);
            if (!File.Exists(filePath))
                throw new ArgumentException("File does not exist");

            var logItems = new List<LogEventItem>();

            if (pageSize > 0)
            {
                var lines = ReadLines(filePath);
                int count = lines.Count();
                int skipLines = pageIndex * pageSize;

                if (count >= skipLines)
                {
                    int take = Math.Min(count - skipLines, pageSize);
                    int start = Math.Max(count - pageSize - skipLines, 0);
                    more = start != 0;
                    var pageLines = lines.Skip(start).Take(take).Reverse();
                    foreach (var line in pageLines)
                    {
                        Match match = _regex.Match(line);
                        logItems.Add(new LogEventItem
                        {
                            TimeStamp = match.Groups["datetime"].Value,
                            Level = match.Groups["level"].Value,
                            Logger = match.Groups["logger"].Value,
                            Message = match.Groups["message"].Value,
                            Parameters = match.Groups["parameters"].Value
                        });
                    }
                }
            }
            else
            {
                // fetch all lines
                var file = new System.IO.StreamReader(filePath);
                string line = null;
                while ((line = file.ReadLine()) != null)
                {
                    Match match = _regex.Match(line);
                    logItems.Add(new LogEventItem
                        {
                            TimeStamp = match.Groups["datetime"].Value,
                            Level = match.Groups["level"].Value,
                            Logger = match.Groups["logger"].Value,
                            Message = match.Groups["message"].Value,
                            Parameters = match.Groups["parameters"].Value
                        });
                }
            }

            return logItems.ToArray();
        }

        private IEnumerable<string> ReadLines(string path)
        {
            using (var fs = new FileStream(path, FileMode.Open, FileAccess.Read, FileShare.ReadWrite, 0x1000, FileOptions.SequentialScan))
            using (var sr = new StreamReader(fs, Encoding.UTF8))
            {
                string line;
                while ((line = sr.ReadLine()) != null)
                {
                    yield return line;
                }
            }
        }

        public void DeleteLogFile(string logFileName)
        {
            try
            {
                string filePath = GetLogFilePath(logFileName);
                if (File.Exists(filePath))
                    File.Delete(filePath);
            }
            catch (Exception)
            {
            }
        }

        public void DeleteAllLogFiles()
        {
            var folder = GetLogFolder();
            var logFiles = GetLogFiles();
            foreach (var logFile in logFiles)
            {
                string filePath = Path.Combine(folder, logFile.FileName);
                try
                {
                    if (File.Exists(filePath))
                        File.Delete(filePath);
                }
                catch (Exception)
                {
                }
            }
        }

        public static string GetRelativePath(string fullPath, string basePath)
        {
            // Require trailing backslash for path
            if (!basePath.EndsWith("\\"))
                basePath += "\\";

            Uri baseUri = new Uri(basePath);
            Uri fullUri = new Uri(fullPath);

            Uri relativeUri = baseUri.MakeRelativeUri(fullUri);

            // Uri's use forward slashes so convert back to backward slashes
            return relativeUri.ToString().Replace("/", "\\");
        }
    }
}