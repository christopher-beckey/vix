using Hydra.IX.Common;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Client
{
    public class EventLogger : IDisposable
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        private EventLogRequest _EventLogRequest;

        private bool _EventEnded = false;

        public static bool IsEnabled { get; set;}

        static EventLogger()
        {
            IsEnabled = false;
        }

        public static EventLogger Create(string transactionUid, string context, EventLogContextType contextType)
        {
            return new EventLogger(transactionUid, context, contextType);
        }

        public EventLogger(string transactionUid, string context, EventLogContextType contextType)
        {
            if (IsEnabled)
            {
                _EventLogRequest = new EventLogRequest
                {
                    TransactionUid = transactionUid,
                    Context = context,
                    ContextType = contextType
                };
            }
        }

        public void BeginEvent(string message)
        {
            if (_EventLogRequest != null)
            {
                _EventLogRequest.StartTime = DateTime.UtcNow.ToString();
                _EventLogRequest.Message = message;
            }
        }

        public void EndEvent(string message = null, EventLogType messageType = EventLogType.Info)
        {
            if (_EventLogRequest != null)
            {
                _EventLogRequest.EndTime = DateTime.UtcNow.ToString();
                _EventLogRequest.MessageType = messageType;

                if (!string.IsNullOrEmpty(message))
                    _EventLogRequest.Message += (Environment.NewLine + message);
            }

            _EventEnded = true;
        }

        public void Dispose()
        {
            try
            {
                if (!_EventEnded)
                    EndEvent();

                if (_EventLogRequest != null)
                {
                    var hixConnection = HixConnectionFactory.Create();
                    hixConnection.CreateEventLogRecord(_EventLogRequest);
                }
            }
            catch (Exception ex)
            {
                _Logger.Info("EventLogger - Error storing event log.", "Exception", ex.ToString());
            }
        }
    }
}
