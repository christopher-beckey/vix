using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using NLog.Fluent;
using System;
using System.Diagnostics;

namespace Hydra.Log
{
    public class Logger : ILogger
    {
        private NLog.Logger _Logger = null;

        public Logger(NLog.Logger logger, string name, LoggerType loggerType)
        {
            _Logger = logger;
            LoggerType = loggerType;
            Name = name;
        }

        public string Name { get; private set; }
        public LoggerType LoggerType { get; private set; }

        internal void LogEvent(NLog.LogLevel level, string message, string[] tags, params object[] args)
        {
            try
            {
                string jsonText = null;

                if (((args != null) && (args.Length > 0)) || ((tags != null) && (tags.Length > 0)))
                {
                    // args count should be even if passed.
                    if ((args != null) && ((args.Length % 2) != 0))
                        throw new ArgumentException("Invalid valid number of arguments");

                    using (JTokenWriter writer = new JTokenWriter())
                    {
                        writer.WriteStartObject();

                        //writer.WritePropertyName("message");
                        //writer.WriteValue(message);

                        if ((args != null) && (args.Length > 0))
                        {
                            if ((args.Length % 2) != 0)
                                throw new ArgumentException("Invalid valid number of arguments");

                            //writer.WritePropertyName("fields");
                            // writer.WriteStartObject();
                            for (int i = 0; i < args.Length; i += 2)
                            {
                                writer.WritePropertyName(args[i] as string);

                                if (args[i + 1] is DataFieldArray)
                                {
                                    var field = args[i + 1] as DataFieldArray;

                                    writer.WriteStartArray();
                                    foreach (var item in field.Values)
                                    {
                                        writer.WriteStartObject();
                                        for (int j = 0; j < field.Names.Length; j++)
                                        {
                                            writer.WritePropertyName(field.Names[j]);
                                            writer.WriteValue(item[j]);
                                        }
                                        writer.WriteEndObject();
                                    }
                                    writer.WriteEndArray();
                                }
                                else
                                    writer.WriteValue(args[i + 1]);
                            }
                            //writer.WriteEndObject();
                        }

                        if (tags != null)
                        {
                            writer.WritePropertyName("tags");
                            writer.WriteStartArray();
                            for (int i = 0; i < tags.Length; i++)
                            {
                                writer.WriteValue(tags[i]);
                            }
                            writer.WriteEndArray();
                        }

                        writer.WriteEndObject();

                        jsonText = writer.Token.ToString(Formatting.None);
                    }
                }

                if (string.IsNullOrEmpty(jsonText))
                {
                    if ((LoggerType == Log.LoggerType.Startup) ||
                        (LoggerType == Log.LoggerType.Purge))
                        _Logger.Log(level).Message(message).Property("LOGGERNAME", Name).Write();
                    else
                        _Logger.Log(level, message);
                }
                else
                {
                    if ((LoggerType == Log.LoggerType.Startup) ||
                        (LoggerType == Log.LoggerType.Purge))
                        _Logger.Log(level).Message(message).Property("DETAILS", jsonText).Property("LOGGERNAME", Name).Write();
                    else
                        _Logger.Log(level).Message(message).Property("DETAILS", jsonText).Write();
                }
            }
            catch (Exception ex)
            {
                //VAI-1336
                //DO NOT CALL THIS! Error("Error in LogEvent.", "Message", message, "Exception", ex.ToString());
                //When we tried to log the above error and we had an exception in this or that call, we wound up in an
                //invisible death spiral without knowing why, and the Viewer stopped displaying images for no apparent reason.
                //TODO: Event log? Email? Direct file append to the log file?
                Console.WriteLine($"*****EXCEPTION WE CANNOT LOG! message: {message}, {ex.ToString()}");
#if DEBUG
                if (!Debugger.IsAttached)
                    Debugger.Launch();
                Debugger.Break();
#endif
            }
        }

        public bool IsDebugEnabled
        {
            get { return _Logger.IsDebugEnabled; }
        }

        public bool IsErrorEnabled
        {
            get { return _Logger.IsErrorEnabled; }
        }

        public bool IsFatalEnabled
        {
            get { return _Logger.IsFatalEnabled; }
        }

        public bool IsInfoEnabled
        {
            get { return _Logger.IsInfoEnabled; }
        }

        public bool IsTraceEnabled
        {
            get { return _Logger.IsTraceEnabled; }
        }

        public bool IsWarnEnabled
        {
            get { return _Logger.IsWarnEnabled; }
        }

        public void Info(string message, params object[] args)
        {
            LogEvent(NLog.LogLevel.Info, message, null, args);
        }

        public void Error(string message, params object[] args)
        {
            LogEvent(NLog.LogLevel.Error, message, null, args);
        }

        public void Trace(string message, params object[] args)
        {
            LogEvent(NLog.LogLevel.Trace, message, null, args);
        }

        /// <summary>
        /// Output variable(s) when Trace log level is enabled
        /// </summary>
        /// <param name="args">arguments must be in pairs, such as: "myVariable", myVariable</param>
        /// <remarks>Added for VAI-373, and useful for any logging</remarks>
        public void TraceVariable(params object[] args)
        {
            if (IsTraceEnabled)
                LogEvent(NLog.LogLevel.Trace, "Variable setting.", null, args);
        }

        /// <summary>
        /// Output log if Trace or Debug is enabled
        /// </summary>
        /// <param name="message">The main message</param>
        /// <param name="args">The paired arguments to the message</param>
        public void TraceOrDebugIfEnabled(string message, params object[] args)
        {
            if (IsTraceEnabled)
                LogEvent(NLog.LogLevel.Trace, message, null, args);
            else
            {
                if (IsDebugEnabled)
                    LogEvent(NLog.LogLevel.Debug, message, null, args);
            }
        }

        public void Warn(string message, params object[] args)
        {
            LogEvent(NLog.LogLevel.Warn, message, null, args);
        }

        public void Fatal(string message, params object[] args)
        {
            LogEvent(NLog.LogLevel.Fatal, message, null, args);
        }

        public void Debug(string message, params object[] args)
        {
            LogEvent(NLog.LogLevel.Debug, message, null, args);
        }

        public ILogEventInfo WithInfo(string message, params object[] args)
        {
            return new LogEventInfo(this, NLog.LogLevel.Info, message, args);
        }

        public ILogEventInfo WithError(string message, params object[] args)
        {
            return new LogEventInfo(this, NLog.LogLevel.Error, message, args);
        }

        public ILogEventInfo WithTrace(string message, params object[] args)
        {
            return new LogEventInfo(this, NLog.LogLevel.Trace, message, args);
        }

        public ILogEventInfo WithWarn(string message, params object[] args)
        {
            return new LogEventInfo(this, NLog.LogLevel.Warn, message, args);
        }

        public ILogEventInfo WithFatal(string message, params object[] args)
        {
            return new LogEventInfo(this, NLog.LogLevel.Fatal, message, args);
        }
        public ILogEventInfo WithDebug(string message, params object[] args)
        {
            return new LogEventInfo(this, NLog.LogLevel.Debug, message, args);
        }
    }
}