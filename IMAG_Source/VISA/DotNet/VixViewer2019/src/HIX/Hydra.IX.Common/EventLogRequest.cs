namespace Hydra.IX.Common
{
    public class EventLogRequest
    {
        public EventLogRequest()
        {
        }

        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public string TransactionUid { get; set; }
        public EventLogContextType ContextType { get; set; }
        public string Context { get; set; }
        public EventLogType MessageType { get; set; }
        public string Message { get; set; }
    }
}