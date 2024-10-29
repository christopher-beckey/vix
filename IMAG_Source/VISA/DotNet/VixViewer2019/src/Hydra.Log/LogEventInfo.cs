using System.Collections.Generic;

namespace Hydra.Log
{
    public class LogEventInfo : ILogEventInfo
    {
        private Logger _Logger = null;
        private NLog.LogLevel _LogLevel = null;
        private string _Message = null;
        private object[] _Args = null;
        private List<string> _Tags = null;

        internal LogEventInfo(Logger logger, NLog.LogLevel logLevel, string message, object[] args)
        {
            _Logger = logger;
            _LogLevel = logLevel;
            _Message = message;
            _Args = args;
        }

        public LogEventInfo AddTag(string tag)
        {
            if (_Tags == null)
                _Tags = new List<string>();

            _Tags.Add(tag);

            return this;
        }

        public LogEventInfo AddTags(string[] tags)
        {
            if (_Tags == null)
                _Tags = new List<string>();

            _Tags.AddRange(tags);

            return this;
        }

        public LogEventInfo AddFields(params object[] args)
        {
            if ((args != null) && (args.Length > 0))
            {
                var newArgs = new object[((_Args != null) ? _Args.Length : 0) + args.Length];
                if (_Args != null)
                    _Args.CopyTo(newArgs, 0);

                args.CopyTo(newArgs, (_Args != null) ? _Args.Length : 0);
                _Args = newArgs;
            }

            return this;
        }

        public void Log()
        {
            _Logger.LogEvent(_LogLevel, _Message, (_Tags != null) ? _Tags.ToArray() : null, _Args);
        }
    }
}