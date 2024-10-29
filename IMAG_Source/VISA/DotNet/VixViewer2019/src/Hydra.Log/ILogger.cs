using System;
namespace Hydra.Log
{
    public interface ILogger
    {
        void Debug(string message, params object[] args);
        void Error(string message, params object[] args);
        void Fatal(string message, params object[] args);
        void Info(string message, params object[] args);
        bool IsDebugEnabled { get; }
        bool IsErrorEnabled { get; }
        bool IsFatalEnabled { get; }
        bool IsInfoEnabled { get; }
        bool IsTraceEnabled { get; }
        bool IsWarnEnabled { get; }
        LoggerType LoggerType { get; }
        string Name { get; }
        void Trace(string message, params object[] args);
        void TraceVariable(params object[] args); //VAI-373
        void TraceOrDebugIfEnabled(string message, params object[] args); //VAI-707
        void Warn(string message, params object[] args);
        ILogEventInfo WithError(string message, params object[] args);
        ILogEventInfo WithFatal(string message, params object[] args);
        ILogEventInfo WithInfo(string message, params object[] args);
        ILogEventInfo WithTrace(string message, params object[] args);
        ILogEventInfo WithWarn(string message, params object[] args);
        ILogEventInfo WithDebug(string message, params object[] args);
    }
}
