using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISAHealthMonitorCommon.formattedvalues;

namespace VixHealthMonitorCommon
{
    public class GlobalRequestProcessor
    {
        public string Name { get; set; }

        public FormattedBytes BytesReceived { get; set; }
        public FormattedBytes BytesSent { get; set; }
        public FormattedTime ProcessingTime { get; set; }
        public FormattedNumber RequestCount { get; set; }
        public FormattedBytes TotalBytes { get; set; }

        public GlobalRequestProcessor(string name)
        {
            this.Name = name;
            BytesReceived = FormattedBytes.UnknownFormattedBytes;
            BytesSent = FormattedBytes.UnknownFormattedBytes;
            ProcessingTime = FormattedTime.UnknownFormattedTime;
            RequestCount = FormattedNumber.UnknownFormattedNumber;
            TotalBytes = FormattedBytes.UnknownFormattedBytes;
        }

        public GlobalRequestProcessor(string name, long bytesReceived, 
            long bytesSent, long processingTime, long requestCount)
        {
            Name = name;
            BytesReceived = new FormattedBytes(bytesReceived);
            BytesSent = new FormattedBytes(bytesSent);
            ProcessingTime = new FormattedTime(processingTime, true);
            RequestCount = new FormattedNumber(requestCount);
            TotalBytes = new FormattedBytes(bytesReceived + bytesSent);
        }

        public void UpdateTotalBytes()
        {
            TotalBytes = new FormattedBytes(BytesReceived.Bytes + BytesSent.Bytes);
        }
    }
}
