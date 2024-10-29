using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Runtime.CompilerServices;

namespace Hydra.Log
{
    public static class LogManager
    {
        private static readonly ILogFactory _LogFactory = new LogFactory();

        private static string GetClassFullName()
        {
            string className;
            Type declaringType;
            int framesToSkip = 2;

            do
            {
#if SILVERLIGHT
                StackFrame frame = new StackTrace().GetFrame(framesToSkip);
#else
                StackFrame frame = new StackFrame(framesToSkip, false);
#endif
                MethodBase method = frame.GetMethod();
                declaringType = method.DeclaringType;
                if (declaringType == null)
                {
                    className = method.Name;
                    break;
                }

                framesToSkip++;
                className = declaringType.FullName;
            } while (className.StartsWith("System.", StringComparison.Ordinal));

            return className;
        }

        [CLSCompliant(false)]
        [MethodImpl(MethodImplOptions.NoInlining)]
        public static ILogger GetCurrentClassLogger()
        {
            return _LogFactory.GetLogger(GetClassFullName(), LoggerType.Class);
        }

        [CLSCompliant(false)]
        [MethodImpl(MethodImplOptions.NoInlining)]
        public static ILogger GetStartupLogger()
        {
            return _LogFactory.GetLogger(GetClassFullName(), LoggerType.Startup);
        }

        [CLSCompliant(false)]
        [MethodImpl(MethodImplOptions.NoInlining)]
        public static ILogger GetAccessLogger()
        {
            return _LogFactory.GetLogger(GetClassFullName(), LoggerType.Access);
        }

        [CLSCompliant(false)]
        [MethodImpl(MethodImplOptions.NoInlining)]
        public static ILogger GetPurgeLogger()
        {
            return _LogFactory.GetLogger(GetClassFullName(), LoggerType.Purge);
        }

        public static LogConfiguration Configuration
        {
            get
            {
                return _LogFactory.Configuration;
            }

            set
            {
                _LogFactory.Configuration = value;
            }
        }

        public static string LogLevel
        {
            get
            {
                return _LogFactory.LogLevel;
            }

            set
            {
                _LogFactory.LogLevel = value;
            }
        }

        public static LogFileItem[] GetLogFiles()
        {
             return _LogFactory.GetLogFiles();
        }

        public static LogEventItem[] GetLogItems(string logFile, int pageSize, int pageIndex, out bool more)
        {
            return _LogFactory.GetLogItems(logFile, pageSize, pageIndex, out more);
        }

        public static string GetLogFilePath(string logFile)
        {
            return _LogFactory.GetLogFilePath(logFile);
        }

        public static void DeleteLogFiles(string logFileName)
        {
            if (!string.IsNullOrEmpty(logFileName))
                _LogFactory.DeleteLogFile(logFileName);
            else
                _LogFactory.DeleteAllLogFiles();
        }
     }
}