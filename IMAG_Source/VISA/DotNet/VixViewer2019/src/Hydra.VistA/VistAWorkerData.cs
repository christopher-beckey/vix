using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    [DataContract]
    public class VistAWorkerData
    {
        [DataMember]
        public string VixBaseUrl { get; set; }

        [DataMember]
        public VixFlavor VixFlavor { get; set; }

        [DataMember]
        public string ContextId { get; set; }

        [DataMember]
        public IEnumerable<Hydra.IX.Common.ImageRecord> ImageRecords { get; set; }

        [DataMember]
        public string SecurityToken { get; set; }

        [DataMember]
        public string TransactionUid { get; set; }
    }
}
