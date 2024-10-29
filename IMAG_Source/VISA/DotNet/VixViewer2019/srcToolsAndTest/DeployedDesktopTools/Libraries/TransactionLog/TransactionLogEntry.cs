using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace TransactionLog
{
    public delegate void LogMsgDelegate(string msg);

    public class TransactionLogEntry
    {
        private Dictionary<string, string> values = new Dictionary<string, string>();
        public readonly int maxOkTimeOnVix = 1000 * 60 * 15; // 15 minutes
        private readonly string siteNumber;

        public TransactionLogEntry(string siteNumber)
        {
            this.siteNumber = siteNumber;
            ChildEntries = new List<TransactionLogEntry>();
        }

        public string SiteNumber => siteNumber;

        public Dictionary<string, string> Values => values;

        public List<TransactionLogEntry> ChildEntries { get; set; }

        public string TransactionId { get; set; }
        public DateTime Date { get; set; }
        public long TimeOnVix { get; set; }
        public string PatientIcn { get; set; }
        public string QueryType { get; set; }
        public bool Asynchronous { get; set; }
        public int ItemsReturned { get; set; }
        public int DataSourceItemsReceived { get; set; }
        public long FacadeBytesReturned { get; set; }
        public long DataSourceBytesReceived { get; set; }
        public string Quality { get; set; }
        public string CommandClassName { get; set; }
        public string OriginatingAddress { get; set; }
        public string User { get; set; }
        public string Urn { get; set; }
        public bool ItemInCache { get; set; }
        public string ExceptionClassName { get; set; }
        public string ErrorMessage { get; set; }
        public string DataSource { get; set; }
        public string DataSourceMethod { get; set; }
        public string DataSourceVersion { get; set; }
        public string DataSourceResponseServer { get; set; }
        public string ResponseCode { get; set; }
        public string QueryFilter { get; set; }
        public string VixSoftwareVersion { get; set; }
        public string VistaLoginMethod { get; set; }
        public long FacadeBytesReceived { get; set; }
        public long DataSourceBytesReturned { get; set; }
        public string MachineName { get; set; }
        public string RequestingSite { get; set; }
        public string RespondingSite { get; set; }
        public long TimeToFirstByte { get; set; }
        public string FacadeImageFormatSent { get; set; }
        public string FacadeImageQualitySent { get; set; }
        public string DataSourceImageFormatReceived { get; set; }
        public string DataSourceImageQualityReceived { get; set; }
        public string ClientVersion { get; set; }
        public string RealmSiteNumber { get; set; }
        public string Modality { get; set; }
        public string PurposeOfUse { get; set; }
        public string CommandId { get; set; }
        public string ParentCommandId { get; set; }
        public string DebugInformation { get; set; }

        public bool IsLongVixTransaction()
        {
            if (TimeOnVix >= maxOkTimeOnVix)
                return true;
            return false;
        }

        public bool IsError()
        {
            if (ErrorMessage.Length > 0)
                return true;
            if (ExceptionClassName.Length > 0)
                return true;
            if ((ResponseCode.Length > 0) && (ResponseCode != "200"))
                return true;
            if (IsLongVixTransaction())
                return true;
            return false;
        }

        public bool IsChild()
        {
            // if parent command ID is null then it is a parent, otherwise it is a child
            return !string.IsNullOrEmpty(ParentCommandId);
        }

        private static char stringDelimiter = '\t';

        public static TransactionLogEntry parseTSVLine(string siteNumber, string headerLine, string line)
        {
            return parseTSVLine(siteNumber, headerLine, line, null);
        }

        public static TransactionLogEntry parseTSVLine(string siteNumber, string headerLine, string line, LogMsgDelegate OnLogMsgEvent)
        {
            string[] headerPieces = headerLine.Split(stringDelimiter);
            string[] entryPieces = line.Split(stringDelimiter);
            if (headerPieces.Length > entryPieces.Length)
                return null;
            TransactionLogEntry logEntry = new TransactionLogEntry(siteNumber);
            try
            {
                for (int i = 0; i < headerPieces.Length; i++)
                {
                    SetLogEntryField(logEntry, headerPieces[i], extractQuotes(entryPieces[i]));
                }
            }
            catch (Exception ex)
            {
                //throw new Exception("Error parsing line '" + line + "', " + ex.Message);
                if (OnLogMsgEvent != null)
                {
                    OnLogMsgEvent("Error parsing line '" + line + "', " + ex.Message);
                    return null;
                }
                else
                    throw new Exception("Error parsing line '" + line + "', " + ex.Message);
                
            }
            return logEntry;
        }

        private static void SetLogEntryField(TransactionLogEntry logEntry, string headerName, string value)
        {
            logEntry.values.Add(headerName, value);
            switch (headerName)
            {
                case "Date and Time":
                    logEntry.Date = parseDateTime(value);
                    break;
                case "Time on ViX (msec)":
                    logEntry.TimeOnVix = parseInt(value);
                    break;
                case "Patient ICN":
                    logEntry.PatientIcn = value;
                    break;
                case "Query Type":
                    logEntry.QueryType = value;
                    break;
                case "Items (Size) Returned":
                    if (!string.IsNullOrEmpty(value))
                    {
                        logEntry.ItemsReturned = parseInt(value);
                    }
                    break;
                case "Quality":
                    logEntry.Quality = value;
                    break;
                case "Originating IP Address":
                    logEntry.OriginatingAddress = value;
                    break;
                case "User":
                    logEntry.User = value;
                    break;
                case "Transaction Number":
                    logEntry.TransactionId = value;
                    break;
                case "URN":
                    logEntry.Urn = value;
                    break;
                case "Item in cache?":
                    logEntry.ItemInCache = parseBool(value);
                    break;
                case "Error Message":
                    logEntry.ErrorMessage = value;
                    break;
                //case "Bytes Transferred":
                //case "Bytes Returned":
                //    logEntry.BytesTransfered = parseInt(value);
                //    break;
                case "Datasource Protocol":
                    logEntry.DataSource = value;
                    break;
                case "Response Code":
                    logEntry.ResponseCode = value;
                    break;
                case "Exception Class Name":
                    logEntry.ExceptionClassName = value;
                    break;
                case "Modality":
                    logEntry.Modality = value;
                    break;
                case "Command Class Name":
                    logEntry.CommandClassName = value;
                    break;
                case "Responding Site":
                    logEntry.RespondingSite = value;
                    break;
                case "Machine Name":
                    logEntry.MachineName = value;
                    break;
                case "Requesting Site":
                    logEntry.RequestingSite = value;
                    break;
                case "Purpose of Use":
                    logEntry.PurposeOfUse = value;
                    break;
                case "Realm Site Number":
                    logEntry.RealmSiteNumber = value;
                    break;
                case "Time To First Byte":
                    if (!string.IsNullOrEmpty(value))
                    {
                        logEntry.TimeToFirstByte = int.Parse(value);
                    }
                    break;
                case "Vix Software Version":
                    logEntry.VixSoftwareVersion = value;
                    break;
                case "Data Source Items Received":
                    if (!string.IsNullOrEmpty(value))
                    {
                        logEntry.DataSourceItemsReceived = parseInt(value);
                    }
                    break;
                case "Asynchronous?":
                    if (!string.IsNullOrEmpty(value))
                    {
                        logEntry.Asynchronous = bool.Parse(value);
                    }
                    break;
                case "Query Filter":
                    logEntry.QueryFilter = value;
                    break;
                case "Facade Bytes Returned":
                    if (!string.IsNullOrEmpty(value))
                    {
                        logEntry.FacadeBytesReturned = parseLong(value);
                    }
                    break;
                case "Facade Bytes Received":
                    if (!string.IsNullOrEmpty(value))
                    {
                        logEntry.FacadeBytesReceived = parseLong(value);
                    }
                    break;
                case "DataSource Bytes Returned":
                    if (!string.IsNullOrEmpty(value))
                    {
                        logEntry.DataSourceBytesReturned = parseLong(value);
                    }
                    break;
                case "DataSource Bytes Received":
                    if (!string.IsNullOrEmpty(value))
                    {
                        logEntry.DataSourceBytesReceived = parseLong(value);
                    }
                    break;
                case "Client Version":
                    logEntry.ClientVersion = value;
                    break;
                case "Data Source Method":
                    logEntry.DataSourceMethod = value;
                    break;
                case "Data Source Version":
                    logEntry.DataSourceVersion = value;
                    break;
                case "Debug Information":
                    logEntry.DebugInformation = value;
                    break;
                case "Data Source Response Server":
                    logEntry.DataSourceResponseServer = value;
                    break;
                case "Command ID":
                    logEntry.CommandId = value;
                    break;
                case "Parent Command ID":
                    logEntry.ParentCommandId = value;
                    break;
                case "Facade Image Format Sent":
                    logEntry.FacadeImageFormatSent = value;
                    break;
                case "Facade Image Quality Sent":
                    logEntry.FacadeImageQualitySent = value;
                    break;
                case "Data Source Image Format Received":
                    logEntry.DataSourceImageFormatReceived = value;
                    break;
                case "Data Source Image Quality Received":
                    logEntry.DataSourceImageQualityReceived = value;
                    break;
                case "Remote Login Method": // old value before P104T5
                case "VistA Login Method": // new value for P104T5
                    logEntry.VistaLoginMethod = value;
                    break;
            }
        }

        private static DateTime parseDateTime(string value)
        {
            try
            {
                return DateTime.Parse(value);
            }
            catch (Exception ex)
            {
                throw new Exception("Error parsing date '" + value + "', " + ex.Message);
            }
        }

        private static int parseInt(string value)
        {
            int result = -1;
            if ((value == null) || (value.Length <= 0))
                return result;
            if (int.TryParse(value, out result))
                return result;
            return -1;
        }

        private static long parseLong(string value)
        {
            long result = -1;
            if ((value == null) || (value.Length <= 0))
                return result;
            if (long.TryParse(value, out result))
                return result;
            return -1;
        }

        private static bool parseBool(string value)
        {
            if ((value == null) || (value.Length <= 0))
                return false;
            bool result = false;
            if (bool.TryParse(value, out result))
                return result;
            return false;
        }

        private static string extractQuotes(string value)
        {
            if ((value == null) || (value.Length <= 0))
                return value;
            if (value.StartsWith("\""))
            {
                value = value.Substring(1);
            }
            if (value.EndsWith("\""))
            {
                value = value.Substring(0, value.Length - 1);
            }
            return value;
        }

        /// <summary>
        /// Get the specified property from the parent or any child transaction entry
        /// </summary>
        /// <param name="propertyName">The name of the property of the TransactionLogEntry class</param>
        /// <param name="excludeEmptyOrZeroValue">If true, then an empty string or zero value in the parent will not be returned</param>
        /// <returns></returns>
        public object GetPropertyFromParentOrChild(string propertyName, bool excludeEmptyOrZeroValue)
        {
            PropertyInfo property = typeof(TransactionLogEntry).GetProperty(propertyName);
            if (property != null)
            {
                object value = property.GetValue(this, null);
                if (value != null)
                {
                    if (excludeEmptyOrZeroValue)
                    {
                        string strVal = value.ToString();
                        if (strVal.Length > 0 && strVal != "0")
                            return value;
                    }
                    else
                    {
                        return value;
                    }
                }
                foreach (TransactionLogEntry childEntry in ChildEntries)
                {
                    value = childEntry.GetPropertyFromParentOrChild(propertyName, excludeEmptyOrZeroValue);
                    if (value != null)
                    {
                        if (excludeEmptyOrZeroValue)
                        {
                            string strVal = value.ToString();
                            if (strVal.Length > 0 && strVal != "0")
                                return value;
                        }
                        else
                        {
                            return value;
                        }
                    }
                }
            }
            return null;
        }

        public override string ToString()
        {
            StringBuilder sb = new StringBuilder();
            PropertyInfo[] properties = this.GetType().GetProperties();
            foreach (PropertyInfo property in properties)
            {
                if (property.CanRead)
                {
                    if (property.Name != "Values" && property.Name != "ChildEntries")
                    {
                        sb.AppendLine(property.Name + ": " + property.GetValue(this, null));
                    }
                }
            }
            return sb.ToString();
        }

        public class TransactionLogEntrySorter : Comparer<TransactionLogEntry>
        {
            public override int Compare(TransactionLogEntry x, TransactionLogEntry y)
            {
                int val = x.Date.CompareTo(y.Date);
                if (val != 0)
                    return val;
                return x.SiteNumber.CompareTo(y.SiteNumber);
            }
        }
    }
}
