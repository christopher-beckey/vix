using System;
using System.Collections.Generic;
namespace Hydra.Log
{
    public interface ILogFactory
    {
        LogConfiguration Configuration { get; set; }
        ILogger GetLogger(string name, LoggerType loggerType);
        string LogLevel { get; set; }
        LogFileItem[] GetLogFiles();
        LogEventItem[] GetLogItems(string logFile, int pageSize, int pageIndex, out bool more);
        string GetLogFilePath(string logFileName);
        void DeleteLogFile(string logFileName);
        void DeleteAllLogFiles();
    }
}
