using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class EventLogRecord
    {
        public int Id { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public string TransactionUid { get; set; }
        public int ContextType { get; set; }
        public string Context { get; set; }
        public int MessageType { get; set; }
        public string Message { get; set; }
    }
}
