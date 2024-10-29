using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml;
using GalaSoft.MvvmLight.Messaging;
using VISAHealthMonitorCommon.messages;
using VISACommon;
using VISAHealthMonitorCommon;
using System.Runtime.CompilerServices;
using System.Reflection;

namespace VixHealthMonitorCommon.monitoredproperty
{
    public class MonitoredPropertyManager
    {

        public List<ConfiguredMonitoredProperty> MonitoredProperties { get; private set; }
        public string Outputdirectory { get; private set; }

        public VixHealthMonitorConfiguration Configuration { get; private set; }
        //public SortedSet<MonitoredProperty> RecentUpdates { get; private set; }

        private MonitoredPropertyManager(VixHealthMonitorConfiguration configuration, string outputDirectory)
        {
            MonitoredProperties = new List<ConfiguredMonitoredProperty>();
            //RecentUpdates = new SortedSet<MonitoredProperty>(new MonitoredPropertyComparer());
            this.Configuration = configuration;
            this.Outputdirectory = outputDirectory;
            Messenger.Default.Register<VisaHealthUpdatedMessage>(this, msg => ReceiveVisaHealthUpdatedMessage(msg));
            LoadMonitoredProperties();
        }

        private void LoadMonitoredProperties()
        {
            FileInfo monitoredPropertiesFile = new FileInfo(GetMonitoredPropertiesConfigurationFilename());
            if (monitoredPropertiesFile.Exists)
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.Load(monitoredPropertiesFile.FullName);

                XmlNodeList monitoredPropertiesNodes = xmlDoc.SelectNodes("MonitoredProperties/MonitoredProperty");
                foreach (XmlNode monitoredPropertyNode in monitoredPropertiesNodes)
                {
                    string name = monitoredPropertyNode.Attributes["Name"].Value;

                    ConfiguredMonitoredPropertyType propertyType = ConfiguredMonitoredPropertyType.value;
                    if (monitoredPropertyNode.Attributes["Type"] != null)
                    {
                        string propertyTypeString = monitoredPropertyNode.Attributes["Type"].Value;
                        if (propertyTypeString == ConfiguredMonitoredPropertyType.property.ToString())
                            propertyType = ConfiguredMonitoredPropertyType.property;
                    }


                    if (!string.IsNullOrEmpty(name))
                    {
                        MonitoredProperties.Add(new ConfiguredMonitoredProperty(name, propertyType));
                    }
                }
            }
            else
            {
                // save default file
                XmlDocument xmlDoc = new XmlDocument();
                XmlNode rootNode = xmlDoc.CreateElement("MonitoredProperties");
                xmlDoc.AppendChild(rootNode);
                XmlNode sampleNode = xmlDoc.CreateElement("MonitoredProperty");
                XmlAttribute attr = xmlDoc.CreateAttribute("Name");
                attr.Value = "";
                sampleNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("Type");
                attr.Value = ConfiguredMonitoredPropertyType.value.ToString();
                sampleNode.Attributes.Append(attr);
                rootNode.AppendChild(sampleNode);

                xmlDoc.Save(monitoredPropertiesFile.FullName);
            }            
        }

        private string GetMonitoredPropertiesConfigurationFilename()
        {
            return Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "monitoredProperties.xml");
        }

        public void Save()
        {
            XmlDocument xmlDoc = new XmlDocument();
            XmlNode rootNode = xmlDoc.CreateElement("MonitoredProperties");
            xmlDoc.AppendChild(rootNode);

            foreach (ConfiguredMonitoredProperty monitoredProperty in MonitoredProperties)
            {
                XmlNode sampleNode = xmlDoc.CreateElement("MonitoredProperty");
                XmlAttribute attr = xmlDoc.CreateAttribute("Name");
                attr.Value = monitoredProperty.Name;
                sampleNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("Type");
                attr.Value = monitoredProperty.Type.ToString();
                sampleNode.Attributes.Append(attr);
                rootNode.AppendChild(sampleNode);
            }

            xmlDoc.Save(GetMonitoredPropertiesConfigurationFilename());
        }

        private void ReceiveVisaHealthUpdatedMessage(VisaHealthUpdatedMessage msg)
        {
            if (MonitoredProperties.Count > 0 && Configuration.MonitorPropertyChanges)
            {
                BaseVixHealth baseVixHealth = new BaseVixHealth(msg.VisaHealth, false);
                VixHealthLoadStatus loadStatus = baseVixHealth.VisaHealth.LoadStatus;
                // only care if we got data, otherwise not important
                if (loadStatus == VixHealthLoadStatus.loaded)
                {
                    LogHealthPropertiesIfChanged(baseVixHealth);                    
                }
            }
        }

        public List<MonitoredProperty> GetSiteMonitoredProperties(VisaSource visaSource)
        {
            Dictionary<string, MonitoredProperty> monitoredProperties = LoadPropertiesForSite(visaSource);
            List<MonitoredProperty> result = new List<MonitoredProperty>(monitoredProperties.Count);
            foreach (string key in monitoredProperties.Keys)
            {
                result.Add(monitoredProperties[key]);
            }
            return result;
        }

        private Dictionary<string, MonitoredProperty> LoadPropertiesForSite(VisaSource visaSource)
        {
            Dictionary<string, MonitoredProperty> properties = new Dictionary<string, MonitoredProperty>();
            string filename = GetSiteFilename(visaSource);
            if (File.Exists(filename))
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.Load(filename);
                XmlNodeList siteMonitoredPropertiesNodes = xmlDoc.SelectNodes("SiteMonitoredProperties/SiteMonitoredProperty");
                foreach (XmlNode siteMonitoredPropertyNode in siteMonitoredPropertiesNodes)
                {
                    string name = siteMonitoredPropertyNode.Attributes["Name"].Value;
                    MonitoredProperty monitoredProperty = new MonitoredProperty(visaSource, name);
                    properties.Add(name, monitoredProperty);

                    XmlNodeList historyNodes = siteMonitoredPropertyNode.SelectNodes("History");
                    foreach (XmlNode historyNode in historyNodes)
                    {
                        string value = historyNode.Attributes["Value"].Value;
                        string date = historyNode.Attributes["Date"].Value;
                        DateTime dt = DateTime.Parse(date);
                        monitoredProperty.MonitoredPropertyHistory.Add(dt, new MonitoredPropertyHistory(value, dt));
                    }
                }
            }
            return properties;
        }

        private void SavePropertiesForSite(VisaSource visaSource, Dictionary<string, MonitoredProperty> properties)
        {
            string filename = GetSiteFilename(visaSource);
            XmlDocument xmlDoc = new XmlDocument();
            XmlProcessingInstruction instruction =
                    xmlDoc.CreateProcessingInstruction("xml-stylesheet", "type='text/xsl' href='displayMonitoredProperties.xsl'");
            xmlDoc.AppendChild(instruction);

            XmlNode rootNode = xmlDoc.CreateElement("SiteMonitoredProperties");

            XmlAttribute attr = xmlDoc.CreateAttribute("SiteName");
            attr.Value = visaSource.Name;
            rootNode.Attributes.Append(attr);
            attr = xmlDoc.CreateAttribute("SiteNumber");
            attr.Value = visaSource.ID;
            rootNode.Attributes.Append(attr);


            xmlDoc.AppendChild(rootNode);
            foreach (string name in properties.Keys)
            {
                XmlNode propertyNode = xmlDoc.CreateElement("SiteMonitoredProperty");
                rootNode.AppendChild(propertyNode);
                attr = xmlDoc.CreateAttribute("Name");
                attr.Value = name;
                propertyNode.Attributes.Append(attr);
                MonitoredProperty monitoredProperty = properties[name];
                foreach (DateTime date in monitoredProperty.MonitoredPropertyHistory.Keys)
                {
                    MonitoredPropertyHistory history = monitoredProperty.MonitoredPropertyHistory[date];
                    XmlNode historyNode = xmlDoc.CreateElement("History");
                    propertyNode.AppendChild(historyNode);

                    attr = xmlDoc.CreateAttribute("Value");
                    historyNode.Attributes.Append(attr);
                    attr.Value = history.Value;

                    attr = xmlDoc.CreateAttribute("Date");
                    historyNode.Attributes.Append(attr);
                    attr.Value = history.DateUpdated.ToString();
                }
            }
            xmlDoc.Save(filename);
        }

        private void LogHealthPropertiesIfChanged(BaseVixHealth baseVixHealth)
        {
            VisaSource visaSource = baseVixHealth.VisaHealth.VisaSource;
            Dictionary<string, MonitoredProperty> properties = LoadPropertiesForSite(visaSource);
            List<MonitoredProperty> updatedProperties = new List<MonitoredProperty>();
            bool changed = false;
            foreach (ConfiguredMonitoredProperty configuredMonitoredProperty in MonitoredProperties)
            {
                string monitoredProperty = configuredMonitoredProperty.Name;
                ConfiguredMonitoredPropertyType propertyType = configuredMonitoredProperty.Type;
                //string currentVixPropertyValue = baseVixHealth.VisaHealth.GetPropertyValue(monitoredProperty);
                string currentVixPropertyValue = GetHealthValue(configuredMonitoredProperty, baseVixHealth);
                // ensure the value exists in the health
                if (currentVixPropertyValue != null)
                {
                    
                    MonitoredProperty currentValue = null;
                    if (properties.ContainsKey(monitoredProperty))
                    {
                        currentValue = properties[monitoredProperty];
                    }
                    if (currentValue == null)
                    {
                        DateTime now = DateTime.Now;
                        // this property was not previously monitored, add it
                        currentValue = new MonitoredProperty(visaSource, monitoredProperty);
                        currentValue.MonitoredPropertyHistory.Add(now, new MonitoredPropertyHistory(currentVixPropertyValue, now));
                        properties.Add(monitoredProperty, currentValue);
                        updatedProperties.Add(currentValue);
                        changed = true;
                    }
                    else
                    {
                        // there is a pre-existing value, check if there is a change in the value
                        if (currentValue.IsValueDifferentFromMostRecentValue(currentVixPropertyValue))
                        {
                            // value has changed, add a new entry
                            DateTime now = DateTime.Now;
                            currentValue.MonitoredPropertyHistory.Add(now, new MonitoredPropertyHistory(currentVixPropertyValue, now));
                            updatedProperties.Add(currentValue);
                            changed = true;
                        }
                    }
                }
            }
            if (changed)
            {
                SavePropertiesForSite(visaSource, properties);
                AddDailyProperty(visaSource, updatedProperties);
            }
            else
            {
                AddDailyProperty(null, null); // ensure the file gets created
            }
        }

        private string GetHealthValue(ConfiguredMonitoredProperty monitoredProperty, BaseVixHealth baseVixHealth)
        {
            string name = monitoredProperty.Name;
            if(monitoredProperty.Type == ConfiguredMonitoredPropertyType.value)
                return baseVixHealth.VisaHealth.GetPropertyValue(name);

            Type baseVixHealthType = baseVixHealth.GetType();
            PropertyInfo property = baseVixHealthType.GetProperty(name);
            if (property != null && property.CanRead)
            {
                object val = property.GetValue(baseVixHealth, null);
                if (val != null)
                    return val.ToString();
                return null;
            }
            // search for the property in the VisaHealth
            Type visaHealthType = baseVixHealth.VisaHealth.GetType();
            property = visaHealthType.GetProperty(name);
            if (property != null && property.CanRead)
            {
                object val = property.GetValue(baseVixHealth.VisaHealth, null);
                if (val != null)
                    return val.ToString();
                return null;
            }
            return null;
        }

        [MethodImpl(MethodImplOptions.Synchronized)]
        private void AddDailyProperty(VisaSource visaSource, List<MonitoredProperty> monitoredProperties)
        {
            string filename = GetDailyUpdatesFilename();
            XmlDocument xmlDoc = new XmlDocument();
            XmlNode dailyPropertiesNode = null;
            bool createEmptyFile = (visaSource == null && monitoredProperties == null);

            if (File.Exists(filename))
            {
                // file exists, do nothing
                if (createEmptyFile)
                    return;
                // they might be null to indicate we are creating an empty file                
                xmlDoc.Load(filename);
                dailyPropertiesNode = xmlDoc.SelectSingleNode("DailyProperties");
                
            }
            else
            {
                XmlProcessingInstruction instruction =
                    xmlDoc.CreateProcessingInstruction("xml-stylesheet", "type='text/xsl' href='displayDailyProperties.xsl'");
                xmlDoc.AppendChild(instruction);
                dailyPropertiesNode = xmlDoc.CreateElement("DailyProperties");
                xmlDoc.AppendChild(dailyPropertiesNode);

                DateTime now = DateTime.Now;

                XmlAttribute attr = xmlDoc.CreateAttribute("Date");
                attr.Value = now.ToString("MMMM d, yyyy");
                dailyPropertiesNode.Attributes.Append(attr);

                DateTime yesterday = now.AddDays(-1);
                DateTime tomorrow = now.AddDays(1);

                attr = xmlDoc.CreateAttribute("Tomorrow");
                attr.Value = "../../" + tomorrow.ToString("yyyy") + "/" + tomorrow.ToString("MM") + "/" + tomorrow.ToString("yyyy-MM-dd") + "_monitoredProperties.xml";
                dailyPropertiesNode.Attributes.Append(attr);

                attr = xmlDoc.CreateAttribute("Yesterday");
                attr.Value = "../../" + yesterday.ToString("yyyy") + "/" + yesterday.ToString("MM") + "/" + yesterday.ToString("yyyy-MM-dd") + "_monitoredProperties.xml";
                dailyPropertiesNode.Attributes.Append(attr);

                if (createEmptyFile)
                {
                    xmlDoc.Save(filename);
                    return;
                }

            }

            XmlNode siteNode = xmlDoc.SelectSingleNode("DailyProperties/Site[@SiteNumber='" + visaSource.ID + "']");
            if (siteNode == null)
            {
                siteNode = xmlDoc.CreateElement("Site");
                dailyPropertiesNode.AppendChild(siteNode);
                XmlAttribute attr = xmlDoc.CreateAttribute("SiteNumber");
                attr.Value = visaSource.ID;
                siteNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("SiteName");
                attr.Value = visaSource.Name;
                siteNode.Attributes.Append(attr);
            }

            foreach (MonitoredProperty monitoredProperty in monitoredProperties)
            {
                XmlNode monitoredPropertyNode = xmlDoc.CreateElement("Property");
                siteNode.AppendChild(monitoredPropertyNode);
                XmlAttribute attr = xmlDoc.CreateAttribute("Name");
                attr.Value = monitoredProperty.Name;
                monitoredPropertyNode.Attributes.Append(attr);

                MonitoredPropertyHistory monitoredPropertyHistory = monitoredProperty.MostRecentHistory;
                // shouldn't be null but just in case
                if (monitoredPropertyHistory != null)
                {
                    attr = xmlDoc.CreateAttribute("Value");
                    attr.Value = monitoredPropertyHistory.Value;
                    monitoredPropertyNode.Attributes.Append(attr);
                    attr = xmlDoc.CreateAttribute("DateUpdated");
                    attr.Value = monitoredPropertyHistory.DateUpdated.ToString();
                    monitoredPropertyNode.Attributes.Append(attr);
                }
            }

            xmlDoc.Save(filename);
        }

        public List<MonitoredProperty> GetDailyMonitoredProperties(DateTime date)
        {
            List<MonitoredProperty> result = new List<MonitoredProperty>();

            string filename = GetDailyUpdatesFilename(date);
            if (File.Exists(filename))
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.Load(filename);

                XmlNodeList siteNodes = xmlDoc.SelectNodes("DailyProperties/Site");
                foreach (XmlNode siteNode in siteNodes)
                {
                    string siteNumber = siteNode.Attributes["SiteNumber"].Value;
                    string siteName = siteNode.Attributes["SiteName"].Value;

                    VisaSource site = new VisaSource(siteNumber, siteName);

                    XmlNodeList propertyNodes = siteNode.SelectNodes("Property");
                    foreach (XmlNode propertyNode in propertyNodes)
                    {
                        string name = propertyNode.Attributes["Name"].Value;
                        string value = propertyNode.Attributes["Value"].Value;
                        string dateUpdated = propertyNode.Attributes["DateUpdated"].Value;
                        MonitoredProperty monitoredProperty = new MonitoredProperty(site, name);
                        DateTime dt = DateTime.Parse(dateUpdated);
                        monitoredProperty.MonitoredPropertyHistory.Add(dt, new MonitoredPropertyHistory(value, dt));
                        result.Add(monitoredProperty);
                    }
                }
            }

            return result;
        }

        private static MonitoredPropertyManager singleton = null;

        public static MonitoredPropertyManager Manager
        {
            get { return singleton; }
        }

        public static bool IsInitialized
        {
            get { return singleton != null; }
        }

        public static void Initialize(VixHealthMonitorConfiguration configuration, string outputDirectory)
        {
            singleton = new MonitoredPropertyManager(configuration, outputDirectory);
        }

        private string GetSiteFilename(VisaSource visaSource)
        {
            string dir = Outputdirectory;
            if (dir == null)
                dir = Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "results");

            DirectoryInfo testResultsDir = new DirectoryInfo(dir);
            if (!testResultsDir.Exists)
            {
                testResultsDir.Create();
            }

            string resultsFilename = Path.Combine(testResultsDir.FullName, visaSource.ID + "_monitoredProperties.xml");
            return resultsFilename;
        }

        private string GetDailyUpdatesFilename()
        {
            return GetDailyUpdatesFilename(DateTime.Now);
        }

        private string GetDailyUpdatesFilename(DateTime date)
        {
            string dir = Outputdirectory;
            if (dir == null)
                dir = Path.Combine(System.AppDomain.CurrentDomain.BaseDirectory, "results");

            dir = Path.Combine(dir, date.ToString("yyyy"), date.ToString("MM"));


            DirectoryInfo testResultsDir = new DirectoryInfo(dir);
            if (!testResultsDir.Exists)
            {
                testResultsDir.Create();
            }

            string resultsFilename = Path.Combine(testResultsDir.FullName, date.ToString("yyyy-MM-dd") + "_monitoredProperties.xml");
            return resultsFilename;
        }
    }

    public class ConfiguredMonitoredProperty
    {
        public string Name { get; private set; }
        public ConfiguredMonitoredPropertyType Type { get; private set; }

        public ConfiguredMonitoredProperty(string name, ConfiguredMonitoredPropertyType propertyType)
        {
            this.Name = name;
            this.Type = propertyType;
        }
    }

    public enum ConfiguredMonitoredPropertyType
    {
        value, property
    }
}
