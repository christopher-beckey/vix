using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.ComponentModel;
using System.Collections.ObjectModel;
using VISAHealthMonitorCommon;
using VISAHealthMonitorCommon.wiki;
using VISACommon;

namespace VixHealthMonitorCommon
{
    public class VixHealthMonitorConfiguration : INotifyPropertyChanged, WikiConfiguration
    {

        public static int defaultHealthTimeout = 45;
        public static string DefaultSiteServiceUrl = "http://siteserver.vista.med.va.gov/VistaWebSvcs/ImagingExchangeSiteService.asmx";

        private static VixHealthMonitorConfiguration vixHealthMonitorConfiguration = null;
        public static VixHealthMonitorConfiguration GetVixHealthMonitorConfiguration()
        {
            return vixHealthMonitorConfiguration;
        }

        public static void Save()
        {
            if (IsInitialized())
                vixHealthMonitorConfiguration.SaveInternal();
        }

        public static bool IsInitialized()
        {
            return vixHealthMonitorConfiguration != null;
        }

        public static void Initialize(string filename)
        {
            vixHealthMonitorConfiguration = new VixHealthMonitorConfiguration(filename);
        }

        private string filename;

        /// <summary>
        /// URL for the site service to use
        /// </summary>
        public string SiteServiceUrl { get; set; }
        /// <summary>
        /// Interval for automatic reloading (in minutes)
        /// </summary>
        public int ReloadInterval { get; set; }
        /// <summary>
        /// Determines if the application should be hidden when minimized
        /// </summary>
        public bool HideWhenMinimized { get; set; }

        public bool Admin { get; set; }

        public ObservableCollection<ListViewColumns> ColumnWidths { get; private set; }

        public int ThreadProcessingTimeCriticalLimit { get; set; }

        public ObservableCollection<WindowPosition> WindowPositions { get; set; }

        public int DriveCapacityCriticalLimitPercent { get; set; }
        public int DriveCapacityCriticalLimitGB { get; set; }

        public ObservableCollection<VisaHealthOption> HealthLoadOptions { get; private set; }
        public int HealthRequestTimeout { get; set; }

        public bool AlertFailedSites { get; set; }

        public string WikiRootUrl {get;set;}

        public bool ShowCVIXOnQuickView { get; set; }

        public bool LogHealthResults { get; set; }
        public bool LogOnlyFailedHealthResults { get; set; }

        public bool MonitorPropertyChanges { get; set; }

        public string EnvironmentTitle { get; set; }
        public ObservableCollection<VaSite> TestSites { get; private set; }

        private VixHealthMonitorConfiguration(string filename)
        {
            this.filename = filename;
            ColumnWidths = new ObservableCollection<ListViewColumns>();
            WindowPositions = new ObservableCollection<WindowPosition>();
            HealthLoadOptions = new ObservableCollection<VisaHealthOption>();
            TestSites = new ObservableCollection<VaSite>();
            Load();
        }

        private void Load()
        {
            if (System.IO.File.Exists(filename))
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.Load(filename);
                XmlNode settingsNode = xmlDoc.SelectSingleNode("/VixHealthMonitorConfiguration/Settings");

                SiteServiceUrl = settingsNode.Attributes["SiteServiceUrl"].Value;
                ReloadInterval = int.Parse(settingsNode.Attributes["ReloadInterval"].Value);
                HideWhenMinimized = bool.Parse(settingsNode.Attributes["HideWhenMinimized"].Value);
                if (settingsNode.Attributes["Admin"] != null)
                {
                    Admin = bool.Parse(settingsNode.Attributes["Admin"].Value);
                }
                if (settingsNode.Attributes["ThreadPorcessingTimeCriticalLimit"] != null)
                {
                    ThreadProcessingTimeCriticalLimit = int.Parse(settingsNode.Attributes["ThreadPorcessingTimeCriticalLimit"].Value);
                }
                if (settingsNode.Attributes["DriveCapacityCriticalLimitPercent"] != null)
                {
                    DriveCapacityCriticalLimitPercent = int.Parse(settingsNode.Attributes["DriveCapacityCriticalLimitPercent"].Value);
                }
                if (settingsNode.Attributes["DriveCapacityCriticalLimitGB"] != null)
                {
                    DriveCapacityCriticalLimitGB = int.Parse(settingsNode.Attributes["DriveCapacityCriticalLimitGB"].Value);
                }
                if (settingsNode.Attributes["HealthRequestTimeout"] != null)
                {
                    HealthRequestTimeout = int.Parse(settingsNode.Attributes["HealthRequestTimeout"].Value);
                }
                else
                {
                    HealthRequestTimeout = defaultHealthTimeout;
                }
                if (settingsNode.Attributes["AlertFailedSites"] != null)
                {
                    AlertFailedSites = bool.Parse(settingsNode.Attributes["AlertFailedSites"].Value);
                }
                else
                {
                    AlertFailedSites = true;
                }

                if (settingsNode.Attributes["WikiRootUrl"] != null)
                {
                    WikiRootUrl = settingsNode.Attributes["WikiRootUrl"].Value;
                }
                else
                {
                    WikiRootUrl = "http://vhacvixclu1a.r04.med.va.gov:8080/wiki/Wiki.jsp";
                }

                if (settingsNode.Attributes["ShowCVIXOnQuickView"] != null)
                {
                    ShowCVIXOnQuickView = bool.Parse(settingsNode.Attributes["ShowCVIXOnQuickView"].Value);
                }
                else
                {
                    ShowCVIXOnQuickView = true;
                }

                if (settingsNode.Attributes["LogHealthResults"] != null)
                {
                    LogHealthResults = bool.Parse(settingsNode.Attributes["LogHealthResults"].Value);
                }
                else
                {
                    LogHealthResults = false;
                }

                if (settingsNode.Attributes["LogOnlyFailedHealthResults"] != null)
                {
                    LogOnlyFailedHealthResults = bool.Parse(settingsNode.Attributes["LogOnlyFailedHealthResults"].Value);
                }
                else
                {
                    LogOnlyFailedHealthResults = true;
                }

                if (settingsNode.Attributes["MonitorPropertyChanges"] != null)
                {
                    MonitorPropertyChanges = bool.Parse(settingsNode.Attributes["MonitorPropertyChanges"].Value);
                }
                else
                {
                    MonitorPropertyChanges = true;
                }

                if (settingsNode.Attributes["EnvironmentTitle"] != null)
                {
                    EnvironmentTitle = settingsNode.Attributes["EnvironmentTitle"].Value;
                }
                else
                {
                    EnvironmentTitle = ""; ;
                }

                XmlNodeList windowNodes = settingsNode.SelectNodes("Windows/Window");
                foreach (XmlNode windowNode in windowNodes)
                {
                    string name = windowNode.Attributes["Name"].Value;
                    Double left = Double.Parse(windowNode.Attributes["Left"].Value);
                    Double width = Double.Parse(windowNode.Attributes["Width"].Value);
                    Double top = Double.Parse(windowNode.Attributes["Top"].Value);
                    Double height = Double.Parse(windowNode.Attributes["Height"].Value);
                    WindowPositions.Add(new WindowPosition(name,
                        left, top, height, width));
                }

                XmlNodeList healthLoadOptionNodes = settingsNode.SelectNodes("VisaHealthLoadOptions/Option");
                foreach (XmlNode optionNode in healthLoadOptionNodes)
                {
                    string option = optionNode.InnerText;
                    if (option == VisaHealthOption.custom_tomcatLogs.ToString())
                    {
                        HealthLoadOptions.Add(VisaHealthOption.custom_tomcatLogs);
                    }
                    else if (option == VisaHealthOption.custom_transactionLog.ToString())
                    {
                        HealthLoadOptions.Add(VisaHealthOption.custom_transactionLog);
                    }
                    else if (option == VisaHealthOption.custom_vixCache.ToString())
                    {
                        HealthLoadOptions.Add(VisaHealthOption.custom_vixCache);
                    }
                    else if (option == VisaHealthOption.environment_variables.ToString())
                    {
                        HealthLoadOptions.Add(VisaHealthOption.environment_variables);
                    }
                    else if (option == VisaHealthOption.jmx.ToString())
                    {
                        HealthLoadOptions.Add(VisaHealthOption.jmx);
                    }
                    else if (option == VisaHealthOption.monitoredError.ToString())
                    {
                        HealthLoadOptions.Add(VisaHealthOption.monitoredError);
                    }
                }

                XmlNodeList testSiteNodes = settingsNode.SelectNodes("TestSites/TestSite");
                foreach (XmlNode testSiteNode in testSiteNodes)
                {
                    string siteName = testSiteNode.Attributes["siteName"].Value;
                    string siteNumber = testSiteNode.Attributes["siteNumber"].Value;
                    string siteAbbr = testSiteNode.Attributes["siteAbbr"].Value;
                    string vixHost = testSiteNode.Attributes["vixHost"].Value;
                    int vixPort = int.Parse(testSiteNode.Attributes["vixPort"].Value);
                    string vistaHost = testSiteNode.Attributes["vistaHost"].Value;
                    int vistaPort = int.Parse(testSiteNode.Attributes["vistaPort"].Value);
                    VaSite site = new VaSite(siteName, siteNumber, siteAbbr,"", vistaHost, vistaPort, 
                        vixHost, vixPort, true);
                    TestSites.Add(site);
                }
            }
            else
            {
                // initialize with default values
                SiteServiceUrl = DefaultSiteServiceUrl;
                ReloadInterval = 20; // 20 minutes
                ThreadProcessingTimeCriticalLimit = 1200; // 20 minutes
                HideWhenMinimized = false;
                DriveCapacityCriticalLimitPercent = 95;
                DriveCapacityCriticalLimitGB = 4;
                HealthRequestTimeout = defaultHealthTimeout;
                AlertFailedSites = true;
                // default to all of them
                HealthLoadOptions.Add(VisaHealthOption.custom_tomcatLogs);
                HealthLoadOptions.Add(VisaHealthOption.custom_transactionLog);
                //HealthLoadOptions.Add(VisaHealthOption.custom_vixCache);
                HealthLoadOptions.Add(VisaHealthOption.environment_variables);
                HealthLoadOptions.Add(VisaHealthOption.jmx);
                WikiRootUrl = "http://vhacvixclu1a.r04.med.va.gov:8080/wiki/Wiki.jsp";
                LogHealthResults = false;
                LogOnlyFailedHealthResults = true;
                MonitorPropertyChanges = false;
                EnvironmentTitle = "";
            }
        }

        private void SaveInternal()
        {
            XmlDocument xmlDoc = new XmlDocument();

            XmlNode rootNode = xmlDoc.CreateElement("VixHealthMonitorConfiguration");
            xmlDoc.AppendChild(rootNode);

            XmlNode settingsNode = xmlDoc.CreateElement("Settings");
            rootNode.AppendChild(settingsNode);

            XmlAttribute attr = xmlDoc.CreateAttribute("SiteServiceUrl");
            settingsNode.Attributes.Append(attr);
            attr.Value = SiteServiceUrl;

            attr = xmlDoc.CreateAttribute("ReloadInterval");
            settingsNode.Attributes.Append(attr);
            attr.Value = ReloadInterval.ToString();

            attr = xmlDoc.CreateAttribute("HideWhenMinimized");
            settingsNode.Attributes.Append(attr);
            attr.Value = HideWhenMinimized.ToString();

            // this is a hidden field, only output if true
            if (Admin)
            {
                attr = xmlDoc.CreateAttribute("Admin");
                settingsNode.Attributes.Append(attr);
                attr.Value = Admin.ToString();
            }

            attr = xmlDoc.CreateAttribute("ThreadPorcessingTimeCriticalLimit");
            settingsNode.Attributes.Append(attr);
            attr.Value = ThreadProcessingTimeCriticalLimit.ToString();

            attr = xmlDoc.CreateAttribute("DriveCapacityCriticalLimitPercent");
            settingsNode.Attributes.Append(attr);
            attr.Value = DriveCapacityCriticalLimitPercent.ToString();

            attr = xmlDoc.CreateAttribute("DriveCapacityCriticalLimitGB");
            settingsNode.Attributes.Append(attr);
            attr.Value = DriveCapacityCriticalLimitGB.ToString();

            attr = xmlDoc.CreateAttribute("HealthRequestTimeout");
            settingsNode.Attributes.Append(attr);
            attr.Value = HealthRequestTimeout.ToString();

            attr = xmlDoc.CreateAttribute("AlertFailedSites");
            settingsNode.Attributes.Append(attr);
            attr.Value = AlertFailedSites.ToString();

            attr = xmlDoc.CreateAttribute("WikiRootUrl");
            settingsNode.Attributes.Append(attr);
            attr.Value = WikiRootUrl;

            attr = xmlDoc.CreateAttribute("ShowCVIXOnQuickView");
            settingsNode.Attributes.Append(attr);
            attr.Value = ShowCVIXOnQuickView.ToString();

            attr = xmlDoc.CreateAttribute("LogHealthResults");
            settingsNode.Attributes.Append(attr);
            attr.Value = LogHealthResults.ToString();

            attr = xmlDoc.CreateAttribute("LogOnlyFailedHealthResults");
            settingsNode.Attributes.Append(attr);
            attr.Value = LogOnlyFailedHealthResults.ToString();

            attr = xmlDoc.CreateAttribute("MonitorPropertyChanges");
            settingsNode.Attributes.Append(attr);
            attr.Value = MonitorPropertyChanges.ToString();

            attr = xmlDoc.CreateAttribute("EnvironmentTitle");
            settingsNode.Attributes.Append(attr);
            attr.Value = EnvironmentTitle;

            XmlNode windowsNodes = xmlDoc.CreateElement("Windows");
            settingsNode.AppendChild(windowsNodes);
            foreach (WindowPosition windowPosition in WindowPositions)
            {
                XmlNode windowNode = xmlDoc.CreateElement("Window");
                windowsNodes.AppendChild(windowNode);
                attr = xmlDoc.CreateAttribute("Name");
                attr.Value = windowPosition.Name;
                windowNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("Left");
                attr.Value = windowPosition.Left.ToString();
                windowNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("Top");
                attr.Value = windowPosition.Top.ToString();
                windowNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("Width");
                attr.Value = windowPosition.Width.ToString();
                windowNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("Height");
                attr.Value = windowPosition.Height.ToString();
                windowNode.Attributes.Append(attr);
            }

            XmlNode columnWidthsNode = xmlDoc.CreateElement("ColumnWidths");
            settingsNode.AppendChild(columnWidthsNode);
            foreach (ListViewColumns lvc in ColumnWidths)
            {
                XmlNode listViewColumnsNode = xmlDoc.CreateElement("ListViewColumns");
                columnWidthsNode.AppendChild(listViewColumnsNode);
                attr = xmlDoc.CreateAttribute("ContainerName");
                attr.Value = lvc.ContainerName;
                listViewColumnsNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("ViewName");
                attr.Value = lvc.ViewName;
                listViewColumnsNode.Attributes.Append(attr);

                XmlNode columnsNode = xmlDoc.CreateElement("Columns");
                listViewColumnsNode.AppendChild(columnsNode);
                foreach (int columnWidth in lvc.ColumnSizes)
                {
                    XmlNode columnNode = xmlDoc.CreateElement("Column");
                    columnsNode.AppendChild(columnNode);
                    attr = xmlDoc.CreateAttribute("Width");
                    attr.Value = columnWidth.ToString();
                    columnNode.Attributes.Append(attr);
                }
            }

            XmlNode visaHealthLoadOptionsNode = xmlDoc.CreateElement("VisaHealthLoadOptions");
            settingsNode.AppendChild(visaHealthLoadOptionsNode);
            foreach (VisaHealthOption vho in HealthLoadOptions)
            {
                XmlNode optionNode = xmlDoc.CreateElement("Option");
                visaHealthLoadOptionsNode.AppendChild(optionNode);
                optionNode.InnerText = vho.ToString();
            }

            /**
             XmlNodeList testSiteNodes = settingsNode.SelectNodes("TestSites/TestSite");
                foreach (XmlNode testSiteNode in testSiteNodes)
                {
                    string siteName = testSiteNode.Attributes["siteName"].Value;
                    string siteNumber = "T" + testSiteNode.Attributes["siteNumber"].Value;
                    string siteAbbr = testSiteNode.Attributes["siteAbbr"].Value;
                    string vixHost = testSiteNode.Attributes["vixHost"].Value;
                    int vixPort = int.Parse(testSiteNode.Attributes["vixPort"].Value);
                    VaSite site = new VaSite(siteName, siteNumber, siteAbbr, "", "", 0, vixHost, vixPort);
                    TestSites.Add(site);
                }
             */

            XmlNode testSitesNode = xmlDoc.CreateElement("TestSites");
            settingsNode.AppendChild(testSitesNode);
            foreach (VaSite testSite in TestSites)
            {
                XmlNode testSiteNode = xmlDoc.CreateElement("TestSite");
                testSitesNode.AppendChild(testSiteNode);
                attr = xmlDoc.CreateAttribute("siteName");
                attr.Value = testSite.Name;
                testSiteNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("siteNumber");
                attr.Value = testSite.SiteNumber;
                testSiteNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("siteAbbr");
                attr.Value = testSite.SiteAbbr;
                testSiteNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("vixHost");
                attr.Value = testSite.VisaHost;
                testSiteNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("vixPort");
                attr.Value = testSite.VisaPort.ToString();
                testSiteNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("vistaHost");
                attr.Value = testSite.VistaHost;
                testSiteNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("vistaPort");
                attr.Value = testSite.VistaPort.ToString();
                testSiteNode.Attributes.Append(attr);
            }


            xmlDoc.Save(filename);
        }

        public WindowPosition GetWindowPosition(string name)
        {
            foreach (WindowPosition windowPosition in WindowPositions)
            {
                if (windowPosition.Name == name)
                    return windowPosition;

            }

            WindowPosition wp = new WindowPosition(name);
            WindowPositions.Add(wp);

            return wp;
        }

        public ListViewColumns GetListViewColumns(string containerName, string viewName)
        {
            foreach (ListViewColumns lvc in ColumnWidths)
            {
                if (lvc.ContainerName == containerName && lvc.ViewName == viewName)
                {
                    return lvc;
                }
            }
            ListViewColumns l = new ListViewColumns();
            l.ViewName = viewName;
            l.ContainerName = containerName;
            ColumnWidths.Add(l);
            return l;
        }

        public event PropertyChangedEventHandler PropertyChanged;

        public bool IsVisaHealthOptionSelected(VisaHealthOption visaHealthOption)
        {
            foreach (VisaHealthOption vho in HealthLoadOptions)
            {
                if (vho == visaHealthOption)
                    return true;
            }
            return false;
        }

        public VisaHealthOption[] GetHealthLoadOptionsArray()
        {
            if (HealthLoadOptions == null || HealthLoadOptions.Count == 0)
                return null;
            VisaHealthOption[] result = new VisaHealthOption[HealthLoadOptions.Count];
            for (int i = 0; i < HealthLoadOptions.Count; i++)
            {
                result[i] = HealthLoadOptions[i];
            }
            return result;
        }
    }

    

    /*
    public class ListViewColumnHeaderSize
    {
        public string ColumnHeaderName { get; set; }
        public int ColumnHeaderWidth { get; set; }
    }*/

    public class ListViewColumns : INotifyPropertyChanged
    {
        public string ContainerName { get; set; }
        public string ViewName { get; set; }
        public ObservableCollection<int> ColumnSizes { get; private set; }

        public ListViewColumns()
        {
            ColumnSizes = new ObservableCollection<int>();
            for (int i = 0; i < 25; i++)
            {
                ColumnSizes.Add(150);
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
    }

    public class WindowPosition : INotifyPropertyChanged
    {
        public string Name { get; set; }
        public Double Left { get; set; }
        public Double Top { get; set; }
        public Double Height { get; set; }
        public Double Width { get; set; }

        public WindowPosition(string name)
        {
            this.Name = name;
            Height= 657f;
            Width = 1031f;
        }

        public WindowPosition(string name, Double left, Double top, Double height, Double width)
        {
            this.Name = name;
            this.Left = left;
            this.Top = top;
            this.Width = width;
            this.Height = height;
        }

        public event PropertyChangedEventHandler PropertyChanged;
    }
}
