namespace Hydra.IX.Common
{
    public class EventLogItem
    {
        public int Id { get; set; }
        public string StartTime { get; set; }
        public string EndTime { get; set; }
        public int TimeSpan { get; set; }
        public string TransactionUid { get; set; }
        public int ContextType { get; set; }
        public string Context { get; set; }
        public int MessageType { get; set; }
        public string Message { get; set; }
    }
}