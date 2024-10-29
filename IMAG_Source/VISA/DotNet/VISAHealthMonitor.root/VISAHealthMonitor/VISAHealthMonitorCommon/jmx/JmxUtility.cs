using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;
using System.Net;
using System.Xml;
using VISAHealthMonitorCommon.formattedvalues;

namespace VISAHealthMonitorCommon.jmx
{
    public class JmxUtility
    {
        public static List<JmxThread> GetActiveThreads(VisaSource visaSource)
        {
            string url = getJmxRestServicesBaseUrl(visaSource);
            url += "/threads";

            List<JmxThread> threads = new List<JmxThread>();
            XmlDocument xmlDoc = IOUtilities.MakeXmlWebRequest(url);

            XmlNodeList threadNodes = xmlDoc.SelectNodes("/threadInfosType/threads");
            foreach (XmlNode threadNode in threadNodes)
            {
                int lockOwnerId = -1;
                string lockName = null;
                int threadId = -1;
                string threadName = null;
                string threadState = null;
                string lockOwnerName = null;
                XmlNode lockOwnerIdNode = threadNode.SelectSingleNode("lockOwnerId");
                if (lockOwnerIdNode != null)
                    lockOwnerId = int.Parse(lockOwnerIdNode.InnerText);
                XmlNode threadIdNode = threadNode.SelectSingleNode("threadId");
                if (threadIdNode != null)
                    threadId = int.Parse(threadIdNode.InnerText);
                XmlNode lockNameNode = threadNode.SelectSingleNode("lockName");
                if (lockNameNode != null)
                    lockName = lockNameNode.InnerText;
                XmlNode threadNameNode = threadNode.SelectSingleNode("threadName");
                if (threadNameNode != null)
                    threadName = threadNameNode.InnerText;
                XmlNode threadStateNode = threadNode.SelectSingleNode("threadState");
                if (threadStateNode != null)
                    threadState = threadStateNode.InnerText;
                XmlNode lockOwnerNameNode = threadNode.SelectSingleNode("lockOwnerName");
                if (lockOwnerNameNode != null)
                    lockOwnerName = lockOwnerNameNode.InnerText;
                threads.Add(new JmxThread(threadId, threadName, threadState, lockOwnerId, lockOwnerName, lockName));
            }

            return threads;
        }

        public static List<JmxThreadStackTraceElement> getThreadStackTrace(VisaSource visaSource, int threadId)
        {
            string url = getJmxRestServicesBaseUrl(visaSource);
            url += "/thread/stack/id/" + threadId;

            return getThreadStackTrace(url);
        }

        public static List<JmxThreadStackTraceElement> getThreadStackTrace(VisaSource visaSource, string threadName)
        {
            string url = getJmxRestServicesBaseUrl(visaSource);
            url += "/thread/stack/name/" + threadName;

            return getThreadStackTrace(url);
        }

        private static List<JmxThreadStackTraceElement> getThreadStackTrace(string url)
        {
            List<JmxThreadStackTraceElement> stackTrace = new List<JmxThreadStackTraceElement>();

            XmlDocument xmlDoc = IOUtilities.MakeXmlWebRequest(url);

            XmlNodeList stackTraceNodes = xmlDoc.SelectNodes("/stackTraceElementsType/stackTraceElement");
            foreach (XmlNode stackTraceNode in stackTraceNodes)
            {
                string className = null;
                int lineNumber = -1;
                string methodName = null;
                string filename = null;

                XmlNode classNameNode = stackTraceNode.SelectSingleNode("className");
                if (classNameNode != null)
                    className = classNameNode.InnerText;

                XmlNode lineNumberNode = stackTraceNode.SelectSingleNode("lineNumber");
                if (lineNumberNode != null)
                    lineNumber = int.Parse(lineNumberNode.InnerText);

                XmlNode methodNameNode = stackTraceNode.SelectSingleNode("methodName");
                if (methodNameNode != null)
                    methodName = methodNameNode.InnerText;

                XmlNode fileNameNode = stackTraceNode.SelectSingleNode("fileName");
                if (fileNameNode != null)
                    filename = fileNameNode.InnerText;
                stackTrace.Add(new JmxThreadStackTraceElement(className, methodName, filename, lineNumber));
            }

            return stackTrace;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="visaSource"></param>
        /// <param name="healthMonitorKey"></param>
        /// <returns></returns>
        public static string GetRequestProcessorWorkerThread(VisaSource visaSource, string requestProcessorName)
        {
            //CatalinaRequestProcessingTime_HttpRequest1_RequestProcessor_http-8080
            //HttpRequest2_RequestProcessor_http-8443
            string[] underscorePieces = requestProcessorName.Split('_');

            // objectName = Catalina:type=RequestProcessor,worker=http-8080,name=HttpRequest1
            // attribute = bytesSent

            string objectName = "Catalina:type=RequestProcessor,worker=" + underscorePieces[2] + ",name=" + underscorePieces[0];
            string attribute = "workerThreadName";
            return GetJmxBeanValue(visaSource, objectName, attribute); 
        }

        public static string GetJmxBeanValue(VisaSource visaSource, KnownJmxAttribute knownJmxAttribute)
        {
            return GetJmxBeanValue(visaSource, knownJmxAttribute.ObjectName, knownJmxAttribute.Attribute);
        }

        public static string GetJmxBeanValue(VisaSource visaSource, string objectName, string attribute)
        {
            string url = getJmxRestServicesBaseUrl(visaSource);
            url += "/mbean/" + objectName + "/" + attribute;

            XmlDocument xmlDoc = IOUtilities.MakeXmlWebRequest(url);

            XmlNode valueNode = xmlDoc.SelectSingleNode("/mBeanAttributeType/value");
            if (valueNode != null)
            {
                return valueNode.InnerText;
            }
            throw new Exception("Null value node from source");
        }
        
        private static string getJmxRestServicesBaseUrl(VisaSource visaSource)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("http://");
            sb.Append(visaSource.VisaHost);
            sb.Append(":");
            sb.Append(visaSource.VisaPort.ToString());
            sb.Append("/JmxWebApp/restservices/jmx");

            return sb.ToString();
        }

        /// <summary>
        /// Supported in P122 and beyond
        /// </summary>
        private static string[] jmxUnsupportedVersions = 
            new string[] { "30.83", "30.104", "30.105" };

        public static bool IsJmxSupported(VisaHealth visaHealth)
        {
            string version = visaHealth.VisaVersion;
            foreach (string unsupportedVersion in jmxUnsupportedVersions)
            {
                if (version.StartsWith(unsupportedVersion))
                    return false;
            }
            return true;
        }

        public static FormattedNumber GetJavaThreads(VisaSource visaSource)
        {
            string objectName = "java.lang:type=Threading";
            string value = GetJmxBeanValue(visaSource, objectName, "ThreadCount");
            if (value == null || value.Length < 0)
            {
                return FormattedNumber.UnknownFormattedNumber;
            }
            else
            {
                return new FormattedNumber(long.Parse(value));
            }
        }

        public static List<JmxMemoryInformation> GetMemoryInformation(VisaHealth visaHealth)
        {
            string osArchitecture = visaHealth.GetPropertyValue("OSArchitecture");
            FormattedNumber processors = visaHealth.GetPropertyValueFormattedNumber("SystemAvailableProcessors");
            List<MemoryPool> objectNames = new List<MemoryPool>();
            // the name is slightly different for 64-bit systems with more than 1 processor
            if (osArchitecture != "x86" && processors.IsValueSet && processors.Number > 1)
            {
                // 64-bit with more than one processor
                objectNames.Add(new MemoryPool("Eden Space", "java.lang:type=MemoryPool,name=PS Eden Space", GetEdenSpaceDescription()));
                objectNames.Add(new MemoryPool("Survivor Space", "java.lang:type=MemoryPool,name=PS Survivor Space", GetSurvivorSpaceDescription()));
                objectNames.Add(new MemoryPool("Tenured Gen", "java.lang:type=MemoryPool,name=PS Old Gen", getTenuredGenDescription()));
            }
            else
            {
                objectNames.Add(new MemoryPool("Eden Space", "java.lang:type=MemoryPool,name=Eden Space", GetEdenSpaceDescription()));
                objectNames.Add(new MemoryPool("Survivor Space", "java.lang:type=MemoryPool,name=Survivor Space", GetSurvivorSpaceDescription()));
                objectNames.Add(new MemoryPool("Tenured Gen", "java.lang:type=MemoryPool,name=Tenured Gen", getTenuredGenDescription()));
            }

            List<JmxMemoryInformation> result = new List<JmxMemoryInformation>();

            foreach (MemoryPool memoryPool in objectNames)
            {
                string value = GetJmxBeanValue(visaHealth.VisaSource, memoryPool.JmxObjectName, "Usage");
                result.Add(JmxMemoryInformation.ParseMemoryHealthResponse(memoryPool.Name, memoryPool.Description, value));
            }

            return result;
        }

        private static string GetEdenSpaceDescription()
        {
            return "The pool from which memory is initially allocated for most objects";
        }

        private static string GetSurvivorSpaceDescription()
        {
            return "The pool containing objects that have survived the garbage collection of the Eden space";
        }

        private static string getTenuredGenDescription()
        {
            return "The pool containing objects that have existed for some time in the survivor space";
        }
    }

    public class MemoryPool
    {
        public string Name { get; private set; }
        public string JmxObjectName { get; private set; }
        public string Description { get; private set; }

        public MemoryPool(string name, string jmxObjectName, string description)
        {
            this.Name = name;
            this.JmxObjectName = jmxObjectName;
            this.Description = description;
        }
    }
}
