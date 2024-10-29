using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using VISACommon;
using System.Configuration;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using VISAHealthMonitorCommon;
using System.Xml;
using System.IO;
using VixHealthMonitorCommon;
using System.Reflection;
using VISAHealthMonitorCommon.formattedvalues;
using VixHealthMonitorCommon.monitoredproperty;

namespace VixHealthMonitorDailyStatus
{
    class Program
    {
        static void Main(string[] args)
        {
            //ImagingExchangeSiteService siteService = new ImagingExchangeSiteService();

            Program p = new Program();
            p.RunProgram();
            
        }

        public Program()
        {
        }

        private List<VaSite> vixSites = null;
        private Dictionary<string, SiteInformation> lastUpdated = new Dictionary<string, SiteInformation>();
        private VixCounts vixCounts = null;

        public void RunProgram()
        {
            string url = ConfigurationManager.AppSettings["siteServiceUrl"];
            int timeout = int.Parse(ConfigurationManager.AppSettings["timeout"]);
            string outputPropertiesDirectory = ConfigurationManager.AppSettings["outputPropertiesDirectory"];

            List<VaSite> sites = SiteService.SiteServiceHelper.getVaSites(url, true);
            vixSites = new List<VaSite>();
            foreach (VaSite site in sites)
            {
                //if (site.IsVix)
                if(site.IsVixOrCvix)
                {
                    vixSites.Add(site);
                    // this is necessary so it initializes the list of health objects
                    VisaHealthManager.GetVisaHealth(site);
                }
            }
            vixSites.Sort(new VaSiteComparer());
            Console.WriteLine("Testing " + sites.Count + " sites");
            Messenger.Default.Register<AllSourcesHealthUpdateMessage>(this, msg => ReceiveAllSourcesHealthUpdateMessage(msg));
            Messenger.Default.Register<VisaHealthUpdatedMessage>(this, msg => ReceiveVisaHealthUpdatedMessage(msg));
            VisaHealthOption[] options = new VisaHealthOption[] { VisaHealthOption.jmx, VisaHealthOption.environment_variables };
            vixCounts = new VixCounts(vixSites);
            vixCounts.OnValuesUpdatedEvent += new VixHealthMonitorCommon.model.ValuesUpdatedDelegate(ValuesUpdated);

            string settingsFilename = System.AppDomain.CurrentDomain.BaseDirectory + @"\settings.xml";
            VixHealthMonitorConfiguration.Initialize(settingsFilename);
            VixHealthMonitorConfiguration.Save();
            MonitoredPropertyManager.Initialize(VixHealthMonitorConfiguration.GetVixHealthMonitorConfiguration(), outputPropertiesDirectory);


            DateTime now = DateTime.Now;
            string dailySitePropertiesDirectory = Path.Combine(outputPropertiesDirectory, now.ToString("yyyy"), now.ToString("MM"));
            if (Directory.Exists(dailySitePropertiesDirectory))
            {
                string dailySitePropertiesXslFile = Path.Combine(dailySitePropertiesDirectory, "displayDailyProperties.xsl");
                if (!File.Exists(dailySitePropertiesXslFile))
                {
                    Console.WriteLine("Daily Site Properties XSL File does not exist in '" + dailySitePropertiesDirectory + "', will attempt to copy");
                    string dailySitePropertiesXslFileSourceFile = Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "displayDailyProperties.xsl");
                    if (File.Exists(dailySitePropertiesXslFileSourceFile))
                    {
                        File.Copy(dailySitePropertiesXslFileSourceFile, dailySitePropertiesXslFile);
                    }
                    else
                    {
                        Console.WriteLine("Daily Site Properties XSL Source File not found, cannot copy");
                    }
                }
            }


            VISAHealthMonitorCommon.VisaHealthManager.RefreshHealth(vixSites, true, false, options, timeout);
            
        }

        private void ReceiveAllSourcesHealthUpdateMessage(AllSourcesHealthUpdateMessage msg)
        {
            // all sites are done
            if (msg.Completed)
            {
                Console.WriteLine("All sites health updated");
                healthLoaded = true;
                OutputResultsIfAllDataLoaded();

                // want to also output the statistics however because of the messaging we don't know the order of the messaging, so this might fire before the statistics are actually updated
                // need to get an event message when the statistics are updated so we know they are ready to be used



            }
        }

        private bool healthLoaded = false;
        private bool statisticsLoaded = false;

        private void OutputResultsIfAllDataLoaded()
        {
            if (healthLoaded && statisticsLoaded)
                OutputResults();
        }

        private void ReceiveVisaHealthUpdatedMessage(VisaHealthUpdatedMessage msg)
        {
            Console.WriteLine("Site '" + msg.VisaSource.DisplayName + "' health updated.");
        }

        private void OutputResults()
        {
            try
            {
                LoadLastUpdated();
                OutputXmlResults();
                OutputCsvResults();            
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        public void ValuesUpdated()
        {
            // when the statistics are calculated this event fires

            statisticsLoaded = true;
            OutputResultsIfAllDataLoaded();
        }

        private void LoadLastUpdated()
        {
            lastUpdated.Clear();
            string outputFile = ConfigurationManager.AppSettings["outputXmlFile"];
            if (!string.IsNullOrEmpty(outputFile))
            {
                XmlDocument xmlDoc = new XmlDocument();
                if (File.Exists(outputFile))
                {
                    xmlDoc.Load(outputFile);
                    foreach (XmlNode rootNode in xmlDoc.ChildNodes)
                    {
                        if (rootNode.Name == "VixHealth")
                        {
                            XmlNodeList siteNodes = rootNode.SelectNodes("Sites/Site");
                            foreach (XmlNode siteNode in siteNodes)
                            {
                                string siteNumber = siteNode.Attributes["Number"].Value;
                                string lastLoaded = "";
                                long healthLoadedCount = 0L;
                                long successfulHealthLoadedCount = 0L;
                                if (siteNode.Attributes["LastLoaded"] != null)
                                {
                                    lastLoaded = siteNode.Attributes["LastLoaded"].Value;
                                }
                                if (siteNode.Attributes["HealthLoadedCount"] != null)
                                {
                                    healthLoadedCount = long.Parse(siteNode.Attributes["HealthLoadedCount"].Value);
                                }
                                if (siteNode.Attributes["SuccessfulHealthLoadedCount"] != null)
                                {
                                    successfulHealthLoadedCount = long.Parse(siteNode.Attributes["SuccessfulHealthLoadedCount"].Value);
                                }

                                lastUpdated.Add(siteNumber, new SiteInformation(siteNumber, lastLoaded, healthLoadedCount, successfulHealthLoadedCount));
                            }
                        }
                    }
                }
            }
        }

        private void OutputXmlResults()
        {
            string outputFile = ConfigurationManager.AppSettings["outputXmlFile"];
            if (!string.IsNullOrEmpty(outputFile))
            {

                XmlDocument xmlDoc = new XmlDocument();
                Dictionary<string, int> versionCounts = new Dictionary<string, int>();

                XmlProcessingInstruction instruction =
                    xmlDoc.CreateProcessingInstruction("xml-stylesheet", "type='text/xsl' href='display.xsl'");
                xmlDoc.AppendChild(instruction);

                XmlNode rootNode = xmlDoc.CreateElement("VixHealth");
                xmlDoc.AppendChild(rootNode);
                XmlNode sitesNode = xmlDoc.CreateElement("Sites");
                rootNode.AppendChild(sitesNode);

                XmlAttribute attr = xmlDoc.CreateAttribute("DateUpdated");
                attr.Value = DateTime.Now.ToString();
                sitesNode.Attributes.Append(attr);

                attr = xmlDoc.CreateAttribute("VixSites");
                attr.Value = vixSites.Count.ToString();
                sitesNode.Attributes.Append(attr);

                attr = xmlDoc.CreateAttribute("DailyPropertiesUrl");
                DateTime now = DateTime.Now;
                attr.Value = "sites/" + now.ToString("yyyy") + "/" + now.ToString("MM") + "/" + now.ToString("yyyy-MM-dd") + "_monitoredProperties.xml";
                sitesNode.Attributes.Append(attr);

                string csvFilename = ConfigurationManager.AppSettings["outputCsvFile"];
                if (!string.IsNullOrEmpty(csvFilename))
                {
                    FileInfo file = new FileInfo(csvFilename);
                    attr = xmlDoc.CreateAttribute("CsvFile");
                    attr.Value = file.Name;
                    sitesNode.Attributes.Append(attr);
                }

                foreach (VaSite site in vixSites)
                {
                    XmlNode siteNode = xmlDoc.CreateElement("Site");
                    sitesNode.AppendChild(siteNode);
                    attr = xmlDoc.CreateAttribute("Name");
                    attr.Value = site.Name;
                    siteNode.Attributes.Append(attr);
                    attr = xmlDoc.CreateAttribute("Number");
                    attr.Value = site.SiteNumber;
                    siteNode.Attributes.Append(attr);
                    attr = xmlDoc.CreateAttribute("SiteUrl");
                    attr.Value = "sites/" + site.SiteNumber + ".xml";
                    siteNode.Attributes.Append(attr);
                    string lastUpdatedDate = "";
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);

                    SiteInformation siteInformation = null;
                    if (lastUpdated.ContainsKey(site.SiteNumber))
                    {
                        siteInformation = lastUpdated[site.SiteNumber];
                    }
                    else
                    {
                        siteInformation = new SiteInformation(site.SiteNumber, "", 0, 0);
                    }


                    if (health.LoadStatus == VixHealthLoadStatus.loaded)
                    {
                        attr = xmlDoc.CreateAttribute("Version");
                        string version = health.VisaVersion;
                        attr.Value = version;
                        siteNode.Attributes.Append(attr);
                        if (versionCounts.ContainsKey(version))
                        {
                            versionCounts[version] = versionCounts[version] + 1;
                        }
                        else
                        {
                            versionCounts.Add(version, 1);
                        }
                        lastUpdatedDate = DateTime.Now.ToString();
                        siteInformation.LastLoaded = lastUpdatedDate;
                        siteInformation.HealthRequestCount = siteInformation.HealthRequestCount + 1;
                        siteInformation.SuccessfulHealthRequestCount = siteInformation.SuccessfulHealthRequestCount + 1;
                        OutputSiteHealthDetails(health, site);
                    }
                    else
                    {
                        attr = xmlDoc.CreateAttribute("Error");
                        attr.Value = health.ErrorMessage;
                        siteNode.Attributes.Append(attr);

                        siteInformation.HealthRequestCount = siteInformation.HealthRequestCount + 1;
                        
                        
                        //if(lastUpdated.ContainsKey(site.SiteNumber))
                        //    lastUpdatedDate = lastUpdated[site.SiteNumber].LastLoaded;

                    }
                    attr = xmlDoc.CreateAttribute("LastLoaded");
                    attr.Value = siteInformation.LastLoaded;// lastUpdatedDate;
                    siteNode.Attributes.Append(attr);
                    attr = xmlDoc.CreateAttribute("HealthLoadedCount");
                    attr.Value = siteInformation.HealthRequestCount.ToString();
                    siteNode.Attributes.Append(attr);
                    attr = xmlDoc.CreateAttribute("SuccessfulHealthLoadedCount");
                    attr.Value = siteInformation.SuccessfulHealthRequestCount.ToString();
                    siteNode.Attributes.Append(attr);

                    double percentLoadedSuccessfully = 0F;
                    if (siteInformation.HealthRequestCount > 0)
                    {
                        percentLoadedSuccessfully = ((double)siteInformation.SuccessfulHealthRequestCount / (double)siteInformation.HealthRequestCount);
                    }
                    percentLoadedSuccessfully *= 100.0;
                    attr = xmlDoc.CreateAttribute("SuccessfulHealthLoadedPercent");
                    attr.Value = percentLoadedSuccessfully.ToString("N2");
                    siteNode.Attributes.Append(attr);

                }

                XmlNode statsNode = xmlDoc.CreateElement("Statistics");
                rootNode.AppendChild(statsNode);

                XmlNode versionsNode = xmlDoc.CreateElement("Versions");
                statsNode.AppendChild(versionsNode);
                foreach (string version in versionCounts.Keys)
                {
                    XmlNode versionNode = xmlDoc.CreateElement("Version");
                    versionsNode.AppendChild(versionNode);
                    attr = xmlDoc.CreateAttribute("Version");
                    attr.Value = version;
                    versionNode.Attributes.Append(attr);
                    attr = xmlDoc.CreateAttribute("Count");
                    attr.Value = versionCounts[version].ToString() ;
                    versionNode.Attributes.Append(attr);
                }

                XmlNode statisticValuesNode = xmlDoc.CreateElement("Values");
                statsNode.AppendChild(statisticValuesNode);
                OutputObject(statisticValuesNode, vixCounts);

                Console.WriteLine("Write XML results to file " + outputFile);
                xmlDoc.Save(outputFile);                
            }
        }

        private void OutputSiteHealthDetails(VisaHealth visaHealth, VaSite vaSite)
        {
            BaseVixHealth baseVixHealth = null;
            if (vaSite.IsVix)
            {
                baseVixHealth = new VixHealth(visaHealth, false);
            }
            else
            {
                baseVixHealth = new CvixHealth(visaHealth, false);
            }

            string outputSitesDirectory = ConfigurationManager.AppSettings["outputSitesDirectory"];
            if (!Directory.Exists(outputSitesDirectory))
            {
                Directory.CreateDirectory(outputSitesDirectory);
            }
            string filename = outputSitesDirectory + "\\" + vaSite.SiteNumber + ".xml";
            XmlDocument xmlDoc = new XmlDocument();
            XmlProcessingInstruction instruction =
                    xmlDoc.CreateProcessingInstruction("xml-stylesheet", "type='text/xsl' href='displaysite.xsl'");
            xmlDoc.AppendChild(instruction);

            XmlNode rootSiteNode = xmlDoc.CreateElement("Site");
            xmlDoc.AppendChild(rootSiteNode);

            XmlAttribute attr = xmlDoc.CreateAttribute("SiteName");
            attr.Value = vaSite.Name;
            rootSiteNode.Attributes.Append(attr);

            attr = xmlDoc.CreateAttribute("SiteNumber");
            attr.Value = vaSite.SiteNumber;
            rootSiteNode.Attributes.Append(attr);

            attr = xmlDoc.CreateAttribute("LastUpdated");
            attr.Value = baseVixHealth.VisaHealth.LastUpdateTime.ToString();
            rootSiteNode.Attributes.Append(attr);

            XmlNode valuesNode = xmlDoc.CreateElement("Values");
            rootSiteNode.AppendChild(valuesNode);

            //OutputSiteValue(valuesNode, "Version", baseVixHealth.VisaHealth.VisaVersion);
            OutputObject(valuesNode, baseVixHealth);
            OutputObject(valuesNode, baseVixHealth.VisaHealth);
            /*
            PropertyInfo [] properties = baseVixHealth.GetType().GetProperties();
            foreach (PropertyInfo property in properties)
            {
                if (property.CanRead)
                {
                    object val = property.GetValue(baseVixHealth, null);
                    if(val != null)
                        OutputSiteValue(valuesNode, property.Name, val.ToString());
                }
            }*/

            xmlDoc.Save(filename);
        }

        private void OutputObject(XmlNode parentNode, object obj)
        {
            PropertyInfo[] properties = obj.GetType().GetProperties();
            foreach (PropertyInfo property in properties)
            {
                if (property.CanRead)
                {
                    Type type = property.PropertyType;
                    if (isAllowedType(type))
                    {
                        object val = property.GetValue(obj, null);
                        if (val != null)
                            OutputSiteValue(parentNode, property.Name, val.ToString());
                    }
                }
            }
        }

        private Type[] allowedTypes = new Type[] { 
            typeof(string), 
            typeof(FormattedNumber),
            typeof(FormattedBytes),
            typeof(FormattedDate),
            typeof(FormattedDecimal),
            typeof(FormattedTime)
        };

        private bool isAllowedType(Type type)
        {
            foreach (Type t in allowedTypes)
            {
                if (t == type)
                    return true;
            }

            return false;
        }

        private void OutputSiteValue(XmlNode parentNode, string name, string value)
        {
            XmlDocument xmlDoc = parentNode.OwnerDocument;
            XmlNode node = xmlDoc.CreateElement("Property");
            XmlAttribute attr = xmlDoc.CreateAttribute("name");
            attr.Value = name;
            node.Attributes.Append(attr);
            attr = xmlDoc.CreateAttribute("value");
            attr.Value = value;
            node.Attributes.Append(attr);
            parentNode.AppendChild(node);
        }

        private void OutputCsvResults()
        {
            string outputCsvFile = ConfigurationManager.AppSettings["outputCsvFile"];
            string delimiter = ",";
            if (!string.IsNullOrEmpty(outputCsvFile))
            {
                StreamWriter writer = new StreamWriter(outputCsvFile, false);

                StringBuilder headerLine = new StringBuilder();
                headerLine.Append("Site Name");
                headerLine.Append(delimiter);
                headerLine.Append("Site Number");
                headerLine.Append(delimiter);
                headerLine.Append("Version");
                headerLine.Append(delimiter);
                headerLine.Append("Error");
                headerLine.Append(delimiter);
                headerLine.Append("LastLoaded");
                
                writer.WriteLine(headerLine.ToString());
                foreach (VaSite site in vixSites)
                {
                    StringBuilder siteLine = new StringBuilder();
                    siteLine.Append("\"" + site.Name + "\"");
                    siteLine.Append(delimiter);
                    siteLine.Append(site.SiteNumber);
                    siteLine.Append(delimiter);
                    VisaHealth health = VisaHealthManager.GetVisaHealth(site);
                    siteLine.Append(health.VisaVersion);
                    siteLine.Append(delimiter);
                    siteLine.Append("\"" + health.ErrorMessage + "\"");
                    siteLine.Append(delimiter);
                    if (lastUpdated.ContainsKey(site.SiteNumber))
                    {
                        siteLine.Append(lastUpdated[site.SiteNumber]);
                    }
                    else
                    {
                        // nothing to output
                    }

                    writer.WriteLine(siteLine.ToString());
                }

                writer.Flush();
                writer.Close();
            }
        }
    }
}
