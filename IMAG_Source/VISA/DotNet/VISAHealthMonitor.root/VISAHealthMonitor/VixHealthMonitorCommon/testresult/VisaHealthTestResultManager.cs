using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using VISACommon;
using VISAHealthMonitorCommon;
using System.Xml;
using System.IO;

namespace VixHealthMonitorCommon.testresult
{
    public class VisaHealthTestResultManager
    {

        public VixHealthMonitorConfiguration Configuration { get; private set; }

        private VisaHealthTestResultManager(VixHealthMonitorConfiguration configuration)
        {
            this.Configuration = configuration;
            Messenger.Default.Register<VisaHealthUpdatedMessage>(this, msg => ReceiveVisaHealthUpdatedMessage(msg));
        }

        private static VisaHealthTestResultManager singleton = null;
        public static VisaHealthTestResultManager Manager
        {
            get
            {
                return singleton;
            }
        }

        public static void Initialize(VixHealthMonitorConfiguration configuration)
        {
            singleton = new VisaHealthTestResultManager(configuration);
        }

        public bool IsInitialized
        {
            get
            {
                return (singleton != null);
            }
        }

        public List<VisaHealthTestResult> GetVisaSourceTestResults(VisaSource visaSource)
        {
            List<VisaHealthTestResult> result = new List<VisaHealthTestResult>();
            string filename = GetSiteFilename(visaSource);
            if (File.Exists(filename))
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.Load(filename);

                XmlNodeList resultNodes = xmlDoc.SelectNodes("results/result");
                foreach (XmlNode resultNode in resultNodes)
                {
                    DateTime date = DateTime.Parse(resultNode.Attributes["date"].Value);
                    bool testFailed = bool.Parse(resultNode.Attributes["testFailed"].Value);
                    string reason = resultNode.Attributes["reason"].Value;
                    result.Add(new VisaHealthTestResult(visaSource, date, testFailed, reason));
                }
            }

            return result;
        }

        private void ReceiveVisaHealthUpdatedMessage(VisaHealthUpdatedMessage msg)
        {
            if (Configuration.LogHealthResults)
            {
                BaseVixHealth baseVixHealth = new BaseVixHealth(msg.VisaHealth, false);
                VisaHealthTestResult testResult = null;

                VixHealthLoadStatus loadStatus = baseVixHealth.VisaHealth.LoadStatus;

                if (loadStatus == VixHealthLoadStatus.loaded)
                {
                    if (!baseVixHealth.IsHealthy())
                    {
                        // unhealthy, always log
                        testResult = new VisaHealthTestResult(msg.VisaSource, DateTime.Now, true, baseVixHealth.UnhealthyReason);
                    }
                    else if (!Configuration.LogOnlyFailedHealthResults)
                    {
                        // healthy but we want to log it
                        testResult = new VisaHealthTestResult(msg.VisaSource, DateTime.Now, false, "");
                    }
                }
                else if(loadStatus == VixHealthLoadStatus.unknown)
                {
                    string errorMsg = baseVixHealth.VisaHealth.ErrorMessage;
                    if (errorMsg != null && errorMsg.Length > 0)
                    {
                        testResult = new VisaHealthTestResult(msg.VisaSource, DateTime.Now, true, errorMsg);
                    }
                }

                if (testResult != null)
                {
                    AddVisaSourceTestResult(testResult);
                }
            }
        }

        private void AddVisaSourceTestResult(VisaHealthTestResult testResult)
        {
            string filename = GetSiteFilename(testResult.VisaSource);
            XmlDocument xmlDoc = new XmlDocument();

            XmlNode resultsNode = null;
            if (File.Exists(filename))
            {
                xmlDoc.Load(filename);
                resultsNode = xmlDoc.SelectSingleNode("results");

            }
            else
            {
                resultsNode = xmlDoc.CreateElement("results");
                XmlAttribute a = xmlDoc.CreateAttribute("ID");
                a.Value = testResult.VisaSource.ID;
                resultsNode.Attributes.Append(a);
                xmlDoc.AppendChild(resultsNode);
            }

            XmlNode resultNode = xmlDoc.CreateElement("result");
            resultsNode.AppendChild(resultNode);

            XmlAttribute attr = xmlDoc.CreateAttribute("date");
            attr.Value = testResult.TestDate.ToString();
            resultNode.Attributes.Append(attr);
            attr = xmlDoc.CreateAttribute("testFailed");
            attr.Value = testResult.TestFailed.ToString();
            resultNode.Attributes.Append(attr);
            attr = xmlDoc.CreateAttribute("reason");
            attr.Value = testResult.TestFailureReason;
            resultNode.Attributes.Append(attr);

            xmlDoc.Save(filename);
        }

        private string GetSiteFilename(VisaSource visaSource)
        {
            DirectoryInfo testResultsDir = new DirectoryInfo(Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "results"));
            if (!testResultsDir.Exists)
            {
                testResultsDir.Create();
            }

            string resultsFilename = Path.Combine(testResultsDir.FullName, visaSource.ID + "_results.xml");
            return resultsFilename;
        }


    }
}
