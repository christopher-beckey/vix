using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Net;
using VISACommon;
using System.Xml;
using System.IO.Compression;
using System.Threading;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using System.ComponentModel;
using VISAHealthMonitorCommon.formattedvalues;

namespace VISAHealthMonitorCommon
{
    public delegate void UpdateVisaHealthCompletedDelegate(VisaSource visaSource, VisaHealth visaHealth);
    //public delegate void UpdateVisaHealthStatusChangedDelegate(VisaSource visaSource, VixHealthLoadStatus loadStatus);

    public class VisaHealth : INotifyPropertyChanged
    {
        private static int defaultTimeoutMs = 45 * 1000;

        public VisaSource VisaSource { get; private set; }
        //private string mstrLastUpdateTime;
        //private Dictionary<string, string> mServerProperties =
        //    new Dictionary<string, string>(new VixServerHealthKeyComparator());
        public VixHealthLoadStatus LoadStatus {get;set;}
        //public Dictionary<string, string> ServerProperties { get { return mServerProperties; } }
        public Dictionary<string, string> ServerProperties { get; private set; }

        public string ErrorMessage { get; private set; }

        public FormattedDate LastUpdateTime {get; private set;}

        /// <summary>
        /// The amount of time it took to load the health information
        /// </summary>
        public FormattedTime HealthLoadTime { get; private set; }

        public string VisaVersion {get;private set;}
        public string Hostname {get;private set;}
        public FormattedTime JVMUptimeLong { get; private set; }
        public FormattedTime JVMUptimeShort { get; private set; }
        public FormattedDate JVMStartupTimeLong { get; private set; }

        /// <summary>
        /// The number of times the health from this source is requested
        /// </summary>
        public FormattedNumber HealthRequestCount { get; private set; }
        /// <summary>
        /// The number of times a successful (not error) response is returned (regardless of the health of the data)
        /// </summary>
        public FormattedNumber HealthSuccessResponseCount { get; private set; }

        public string OperatingSystemArchitecture { get; private set; }

        /// <summary>
        /// External values are values held by VisaHealth but not populated by VisaHealth. They are populated elsewhere but used in multiple places
        /// </summary>
        public Dictionary<string, string> ExternalValues { get; private set; }

        public event UpdateVisaHealthCompletedDelegate OnUpdateVisaHealthCompletedEvent = null;

        public VisaHealth(VisaSource visaSource)
        {
            this.VisaSource = visaSource;
            LoadStatus = VixHealthLoadStatus.unknown;
            HealthLoadTime = FormattedTime.UnknownFormattedTime;
            LastUpdateTime = FormattedDate.UnknownFormattedDate;
            ServerProperties = new Dictionary<string, string>(new VixServerHealthKeyComparator());
            HealthRequestCount = new FormattedNumber(0);
            HealthSuccessResponseCount = new FormattedNumber(0);
            Hostname = VisaSource.VisaHost;
            ExternalValues = new Dictionary<string, string>();
        }

        public void UpdateAsync(UpdateVisaHealthCompletedDelegate OnAsyncUpdateVisaHealthCompletedEvent,
            VisaHealthOption[] visaHealthOptions, int timeout)
        {
            Thread t = new Thread(UpdateInternal);
            t.Start(new UpdateHealthParameters(OnAsyncUpdateVisaHealthCompletedEvent, 
                visaHealthOptions, timeout));
        }

        private void UpdateInternal(object healthParameters)
        {
            UpdateHealthParameters updateHealthParameters = (UpdateHealthParameters)healthParameters;
            UpdateVisaHealthCompletedDelegate asyncUpdateVisaHealthCompletedEvent = updateHealthParameters.asyncUpdateVisaHealthCompletedEvent;
            Update(updateHealthParameters.visaHealthOptions, updateHealthParameters.Timeout);
            if (asyncUpdateVisaHealthCompletedEvent != null)
            {
                asyncUpdateVisaHealthCompletedEvent(this.VisaSource, this);
            }
        }

        public bool Update(VisaHealthOption [] visaHealthOptions, int timeout)
        {
            LoadStatus = VixHealthLoadStatus.loading;
            NotifyUpdatedVisaHealth();
            HealthLoadTime = FormattedTime.UnknownFormattedTime;
            ErrorMessage = null;
            XmlDocument xmlDoc = null;
            try
            {
                Messenger.Default.Send<StatusMessage>(new StatusMessage("Retrieving health from '" + this.VisaSource.DisplayName + "'"));
                ExternalValues.Clear(); // clear all externally set values so they can be reset
                string url = getServerHealthUrl(visaHealthOptions);

                HealthRequestCount = new FormattedNumber(HealthRequestCount.Number + 1);
                ServerProperties.Clear();
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                //request.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8";
                //request.Headers.Add("Accept-Encoding", "gzip,deflate");
                request.Timeout = timeout * 1000;
                DateTime startTime = DateTime.Now;
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                DateTime endTime = DateTime.Now;
                TimeSpan ts = endTime.Subtract(startTime);
                
                HealthLoadTime = new FormattedTime((long)ts.TotalMilliseconds, true);// new FormattedNumber((long)ts.TotalMilliseconds);
                xmlDoc = new XmlDocument();
                xmlDoc.Load(IOUtilities.getStreamFromResponse(response));


                XmlNodeList propertiesNodes = xmlDoc.SelectNodes("VixServerHealth/Property");
                foreach (XmlNode propertyNode in propertiesNodes)
                {
                    string name = propertyNode.Attributes["name"].Value;
                    string value = propertyNode.Attributes["value"].Value;

                    ServerProperties.Add(name, value);
                }
                LoadStatus = VixHealthLoadStatus.loaded;
                UpdateCommonProperties();
                NotifyUpdatedVisaHealth();

                // JMW 10/18/2012 - convert to universal time because the FormattedDate assumes all values passed in are UTC
                LastUpdateTime = new FormattedDate(DateTime.Now.ToUniversalTime().Ticks, false);
                HealthSuccessResponseCount = new FormattedNumber(HealthSuccessResponseCount.Number + 1);
                return true;
            }
            catch (Exception ex)
            {
                ErrorMessage = ex.Message;
                // don't reset the last update time so we can know when it was last successfully done
                //LastUpdateTime = FormattedDate.UnknownFormattedDate;
                //LogMsg("Error getting health for site '" + mSite + "'", true, ex.StackTrace);
                LoadStatus = VixHealthLoadStatus.unknown;
                UpdateCommonProperties(); // this will clear values
                NotifyUpdatedVisaHealth();

                if (ErrorMessage.StartsWith("Data at the root level", StringComparison.CurrentCultureIgnoreCase))
                {
                    LogErrorStackTrace(ex, xmlDoc);
                }
                return false;
            }
        }

        private void LogErrorStackTrace(Exception ex, XmlDocument xmlDoc)
        {
            try
            {
                string errorDirectory = System.AppDomain.CurrentDomain.BaseDirectory + @"\errors";
                if (!Directory.Exists(errorDirectory))
                {
                    Directory.CreateDirectory(errorDirectory);
                }
                string errorFilename = errorDirectory + "\\" + VisaSource.Name + "_" + Guid.NewGuid().ToString();
                StreamWriter writer = new StreamWriter(errorFilename);
                writer.WriteLine(DateTime.Now.ToString());
                writer.WriteLine(ex.Message);
                writer.WriteLine(ex.StackTrace);
                if(xmlDoc != null)
                    writer.WriteLine(xmlDoc.InnerXml);
                writer.Flush();
                writer.Close();
            }
            catch (Exception) { }
        }

        private void UpdateCommonProperties()
        {
            if (ServerProperties.ContainsKey("VixVersion"))
            {
                VisaVersion = ServerProperties["VixVersion"];
            }
            else
            {
                VisaVersion = "";
            }

            if (ServerProperties.ContainsKey("VixHostname"))
            {
                Hostname = ServerProperties["VixHostname"];
            }
            else
            {
                //Hostname = "";
                Hostname = VisaSource.VisaHost;
            }

            if (ServerProperties.ContainsKey("VixJVMUptime"))
            {
                string startTimeString = ServerProperties["VixJVMUptime"];
                long ticks = long.Parse(startTimeString);

                JVMUptimeShort = new FormattedTime(ticks, false);
                JVMUptimeLong = new FormattedTime(ticks, true);
            }
            else
            {
                JVMUptimeLong = FormattedTime.UnknownFormattedTime;
                JVMUptimeShort = FormattedTime.UnknownFormattedTime;
            }

            if (ServerProperties.ContainsKey("VixJVMStartTime"))
            {
                string startTimeString = ServerProperties["VixJVMStartTime"];
                long ticks = long.Parse(startTimeString);

                JVMStartupTimeLong = FormattedDate.createFromJavaTime(ticks, true);
            }
            else
            {
                JVMStartupTimeLong = FormattedDate.UnknownFormattedDate;
            }

            string osArchitecture = GetPropertyValue("OSArchitecture");
            if (osArchitecture == null)
                OperatingSystemArchitecture = "";
            else
                OperatingSystemArchitecture = osArchitecture;

        }

        private void NotifyUpdatedVisaHealth()
        {
            if (OnUpdateVisaHealthCompletedEvent != null)
            {
                OnUpdateVisaHealthCompletedEvent(this.VisaSource, this);
            }
            Messenger.Default.Send<VisaHealthUpdatedMessage>(new VisaHealthUpdatedMessage(this.VisaSource, this));            
            /*
            if (VisaHealthStatusChangedEvent != null)
            {
                VisaHealthStatusChangedEvent(this.visaSource, this.LoadStatus);
            }*/
        }

        /*
        private Stream getStreamFromResponse(HttpWebResponse response)
        {
            Stream stream;
            switch (response.ContentEncoding.ToUpperInvariant())
            {
                case "GZIP":
                    stream = new GZipStream(response.GetResponseStream(), CompressionMode.Decompress);
                    break;
                case "DEFLATE":
                    stream = new DeflateStream(response.GetResponseStream(), CompressionMode.Decompress);
                    break;

                default:
                    stream = response.GetResponseStream();
                    //stream.ReadTimeout = readTimeOut;
                    break;
            }
            return stream;
        }*/

        private string getServerHealthUrl(VisaHealthOption[] visaHealthOptions)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("http://");
            sb.Append(VisaSource.VisaHost);
            sb.Append(":");
            sb.Append(VisaSource.VisaPort.ToString());
            sb.Append("/VixServerHealthWebApp/VixServerHealthServlet");

            string prefix = "?";
            if (visaHealthOptions != null)
            {
                foreach (VisaHealthOption visaHealthOption in visaHealthOptions)
                {
                    sb.Append(prefix);
                    sb.Append(visaHealthOption.ToString());
                    sb.Append("=true");
                    prefix = "&";
                }
            }

            return sb.ToString();
        }

        

        public string GetPropertyValue(string name)
        {
            if (ServerProperties.ContainsKey(name))
                return ServerProperties[name];
            return null;
        }

        public long GetPropertyValueLong(string name)
        {
            if (ServerProperties.ContainsKey(name))
                return long.Parse(ServerProperties[name]);
            return -1;
        }

        public FormattedNumber GetPropertyValueFormattedNumber(string name)
        {
            long value = GetPropertyValueLong(name);
            if (value >= 0)
                return new FormattedNumber(value);
            return FormattedNumber.MissingFormattedNumber;
        }

        public FormattedBytes GetPropertyValueFormattedBytes(string name)
        {
            long value = GetPropertyValueLong(name);
            if (value >= 0)
                return new FormattedBytes(value);
            return FormattedBytes.MissingFormattedBytes;
        }

        public string formatBytes(long bytes)
        {
            if (bytes < 1024)
            {
                return bytes + " bytes";
            }
            double kb = (double)bytes / 1024.0f;
            double mb = kb / 1024.0f;
            double gb = mb / 1024.0f;
            double tb = gb / 1024.0f;

            if (tb > 1.0)
            {
                return tb.ToString("N2") + " TB";
            }
            else if (gb > 1.0)
            {
                return gb.ToString("N2") + " GB";
            }
            else if (mb > 1.0)
            {
                return mb.ToString("N2") + " MB";
            }
            else
            {
                return kb.ToString("N2") + " KB";
            }
        }


        public event PropertyChangedEventHandler PropertyChanged;
    }

    public enum VixHealthLoadStatus
    {
        unknown, loading, loaded
    }

    /// <summary>
    /// Comparer is used to do a case insensitive check for a key in the dictionary
    /// </summary>
    public class VixServerHealthKeyComparator : IEqualityComparer<string>
    {

        public bool Equals(string x, string y)
        {
            return x.Equals(y, StringComparison.CurrentCultureIgnoreCase);
        }

        public int GetHashCode(string obj)
        {
            // ensure the case of the string is not relevant
            return obj.ToLower().GetHashCode();
        }
    }

    public enum VisaHealthOption
    {       
        jmx,
        environment_variables,
        custom_transactionLog,
        custom_vixCache,
        custom_tomcatLogs,
        monitoredError
    }

    class UpdateHealthParameters
    {
        public UpdateVisaHealthCompletedDelegate asyncUpdateVisaHealthCompletedEvent { get; private set; }
        public VisaHealthOption[] visaHealthOptions {get;private set;}
        public int Timeout { get; private set; }

        public UpdateHealthParameters(UpdateVisaHealthCompletedDelegate asyncUpdateVisaHealthCompletedEvent, 
            VisaHealthOption[] visaHealthOptions, int timeout)
        {
            this.asyncUpdateVisaHealthCompletedEvent = asyncUpdateVisaHealthCompletedEvent;
            this.visaHealthOptions = visaHealthOptions;
            this.Timeout = timeout;
        }
    }
}
