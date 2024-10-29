using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;

namespace Vix.Viewer.Install
{
    public class UrlHelper
    {
        public static string ToUrl(dynamic obj, bool asLocalHost = false)
        {
            return ToUrl(asLocalHost ? "localhost" : obj.HostName, obj.Port, obj.UseTLS);
        }

        public static string ToUrl(string hostName, int port, bool useTLS)
        {
            return string.Format("{0}://{1}:{2}",
                useTLS ? "https" : "http",
                hostName,
                port);
        }

        public static void ParseObject(string text, dynamic obj)
        {
            Parse(text, (h, p, t) =>
                {
                    obj.HostName = h;
                    obj.Port = p;
                    obj.UseTLS = t;
                });
        }

        public static void Parse(string text, Action<string, int, bool> parseResult)
        {
            if (!string.IsNullOrEmpty(text))
            {
                bool hasPlus = text.Contains("+");
                if (hasPlus)
                    text = text.Replace("+", "localhost");

                try
                {
                    var uri = new Uri(text);
                    parseResult(hasPlus ? "+" : uri.Host, uri.Port, (string.Compare(uri.Scheme, "https", true) == 0));
                }
                catch (Exception)
                {
                }
            }
        }
    }


    public class ServiceProperties
    {
        [Browsable(false)]
        public string VixVersion { get; set; }

        [Browsable(true), Description("Host Name"), DisplayName("Host Name")]
        [RefreshProperties(RefreshProperties.All)]
        public string HostName { get; set; }

        [Browsable(true), Description("Port Number"), DisplayName("Port Number")]
        [RefreshProperties(RefreshProperties.All)]
        public int Port { get; set; }

        [Browsable(true), Description("Use TLS"), DisplayName("Use TLS")]
        [RefreshProperties(RefreshProperties.All)]
        public bool UseTLS { get; set; }

        public override string ToString()
        {
            return string.Format("[{0}]", UrlHelper.ToUrl(this));
        }
    }

    public class ViewerServiceProperties
    {
        [Browsable(false), Description("Host Name"), DisplayName("Host Name")]
        public string HostName { get; set; }

        [Browsable(true), Description("Port Number"), DisplayName("Port Number")]
        [RefreshProperties(RefreshProperties.All)]
        public int Port { get; set; }

        [Browsable(true), Description("Use TLS"), DisplayName("Use TLS")]
        [RefreshProperties(RefreshProperties.All)]
        public bool UseTLS { get; set; }

        [Browsable(true), Description("Trusted Client Port"), DisplayName("Trusted Client Port")]
        [RefreshProperties(RefreshProperties.All)]
        public string TrustedClientPort 
        { 
            get
            {
                return (_TrustedClientPort <= 0) ? "" : _TrustedClientPort.ToString();
            }

            set
            {
                int port = 0;
                int.TryParse(value, out port);

                _TrustedClientPort = port;
            }
        }

        [Browsable(false)]
        public int _TrustedClientPort { get; set; }

        [Description("Compress Images"), DisplayName("Compress Images")]
        [RefreshProperties(RefreshProperties.All)]
        public bool CompressImages { get; set; }

        [Browsable(true), Description("Override hostname in query results"), DisplayName("Override Hostname")]
        [RefreshProperties(RefreshProperties.All)]
        public string OverrideHostName { get; set; }

        public override string ToString()
        {
            var text = string.Format("[Port:{0}]", Port);

            if (UseTLS)
                text += ", TLS";

            if (!string.IsNullOrEmpty(TrustedClientPort))
                text += string.Format(", TrustedClientPort:{0}", TrustedClientPort);

            return text;
        }
    }

    public class RenderServiceProperties
    {
        [Browsable(false), Description("Host Name"), DisplayName("Host Name")]
        public string HostName { get; set; }

        [Browsable(true), Description("Port Number"), DisplayName("Port Number")]
        [RefreshProperties(RefreshProperties.All)]
        public int Port { get; set; }

        [Browsable(true), Description("Use TLS"), DisplayName("Use TLS")]
        [RefreshProperties(RefreshProperties.All)]
        public bool UseTLS { get; set; }

        public override string ToString()
        {
            if (UseTLS)
                return string.Format("[Port:{0}, Using TLS]", Port);
            else
                return string.Format("[Port:{0}]", Port);
        }
    }


    public class DatabaseProperties
    {
        [Description("Database Instance Name"), DisplayName("Instance Name")]
        [RefreshProperties(RefreshProperties.All)]
        public string InstanceName { get; set; }
           
        [Description("Database Password"), DisplayName("Password"), PasswordPropertyText(true)]
        public string Password { get; set; }

        [Browsable(false)]
        public string OriginalPassword { get; set; }

        public override string ToString()
        {
            return string.IsNullOrEmpty(InstanceName)? null : string.Format("[{0}]", InstanceName);
        }
    }

    public class StorageProperties
    {
        [Description("Image Cache Directory"), DisplayName("Image Cache Directory")]
        [EditorAttribute(typeof(System.Windows.Forms.Design.FolderNameEditor), typeof(System.Drawing.Design.UITypeEditor))]
        public string ImageCacheDirectory { get; set; }

        public override string ToString()
        {
            return null;
        }
    }

    public class PurgeProperties
    {
        [Description("Number of days to keep studies in cache. To disable this setting, set value to 0"), DisplayName("Maximum Age (Days)")]
        [RefreshProperties(RefreshProperties.All)]
        public int MaxAgeDays { get; set; }

        [Description("Maximum Cache size. To disable this setting, set value to 0"), DisplayName("Maximum Cache Size (MB)")]
        [RefreshProperties(RefreshProperties.All)]
        public int MaxCacheSizeMB { get; set; }

        [Description("Cache purge times. 24 Hour format. Use semi-colon for multiple values."), DisplayName("Purge Times")]
        [RefreshProperties(RefreshProperties.All)]
        public string PurgeTimes { get; set; }

        [Description("Enable/Disable Purge"), DisplayName("Enabled")]
        [RefreshProperties(RefreshProperties.All)]
        public bool Enabled { get; set; }

        public PurgeProperties()
        {
            MaxCacheSizeMB = 1024;
            MaxAgeDays = 2;
            Enabled = true;
            PurgeTimes = "00:00";
        }

        public override string ToString()
        {
            return null;
        }
    }

    public class OptionsProperties
    {
        [Description("Overide user security keys to enable Print and Export"), DisplayName("Override Print/Export Security Keys")]
        [RefreshProperties(RefreshProperties.All)]
        public bool OverrideExportKeys { get; set; }

        public override string ToString()
        {
            return null;
        }
    }

    public class ViewerProperties
    {
        /*
         
         Viewer Service
            Port
            Use TLS
            Compress Images
         
         Render Service
            Port
            Use TLS
         
         Site Service
            Host Name
            Port
            Use TLS
         
         VIX
            Host Name
            Port
            Use TLS
         
         Database
            Instance Name
            Password
         
         Storage
            Image Cache Directory
         
         */

        [DisplayName("Viewer Service")]
        [TypeConverter(typeof(ExpandableObjectConverter))]
        public ViewerServiceProperties ViewerServiceProperties { get; set; }

        [DisplayName("Render Service")]
        [TypeConverter(typeof(ExpandableObjectConverter))]
        public RenderServiceProperties RenderServiceProperties { get; set; }

        [DisplayName("Site Service")]
        [TypeConverter(typeof(ExpandableObjectConverter))]
        public ServiceProperties SiteServiceProperties { get; set; }

        [DisplayName("VIX Service")]
        [TypeConverter(typeof(ExpandableObjectConverter))]
        public ServiceProperties VixServiceProperties { get; set; }

        //[DisplayName("Authentication Service")]
        //[TypeConverter(typeof(ExpandableObjectConverter))]
        //public ServiceProperties AuthenticationServiceProperties { get; set; }

        [DisplayName("Database")]
        [TypeConverter(typeof(ExpandableObjectConverter))]
        public DatabaseProperties DatabaseProperties { get; set; }

        [DisplayName("Storage")]
        [TypeConverter(typeof(ExpandableObjectConverter))]
        public StorageProperties StorageProperties { get; set; }

        [DisplayName("Purge")]
        [TypeConverter(typeof(ExpandableObjectConverter))]
        public PurgeProperties PurgeProperties { get; set; }

        [DisplayName("Options")]
        [TypeConverter(typeof(ExpandableObjectConverter))]
        [Browsable(false)]
        public OptionsProperties OptionsProperties { get; set; }

        [Browsable(false)]
        public string ViewerConfigFileName { get; private set; }

        [Browsable(false)]
        public string RenderConfigFileName { get; private set; }

        [Browsable(false)]
        public bool ResetViewerSettings { get; private set; }

        [Browsable(false)]
        public bool ResetRenderSettings { get; private set; }

        private const int _COMPRESSEDQUALITY = 70;

        public ViewerProperties()
        {
            ViewerServiceProperties = new ViewerServiceProperties();
            RenderServiceProperties = new RenderServiceProperties();
            SiteServiceProperties = new ServiceProperties();
            VixServiceProperties = new ServiceProperties();
            
            DatabaseProperties = new DatabaseProperties();
            StorageProperties = new StorageProperties();
            PurgeProperties = new PurgeProperties();
            OptionsProperties = new OptionsProperties();

            ResetViewerSettings = false;
            ResetRenderSettings = false;
        }

        public void Load(string viewerConfigfileName = null, string renderConfigfileName = null)
        {
            if (!string.IsNullOrEmpty(viewerConfigfileName))
                ReadViewerConfigFile(viewerConfigfileName);

            if (!string.IsNullOrEmpty(renderConfigfileName))
                ReadRenderConfigFile(renderConfigfileName);
        }

        public void Save()
        {
            if (File.Exists(ViewerConfigFileName))
                SaveViewerConfigFile(ViewerConfigFileName);

            if (File.Exists(RenderConfigFileName))
                SaveRenderConfigFile(RenderConfigFileName);
        }

        public void ResetSecurityConfiguration()
        {
            if (File.Exists(ViewerConfigFileName) && ResetViewerSettings)
            {
                SaveViewerConfigFile(ViewerConfigFileName, true);
            }

            if (File.Exists(RenderConfigFileName) && ResetRenderSettings)
            {
                SaveRenderConfigFile(RenderConfigFileName, true);
            }
        }

        private void ReadViewerConfigFile(string fileName)
        {
            // set defaults
            ViewerServiceProperties.CompressImages = false;

            XDocument doc = XDocument.Load(fileName);

            var vista = doc.Root.Element("VistA");
            var attr = vista.Attribute("DiagnosticImageQuality");
            if (attr != null)
            {
                int imageQuality = 0;
                if (int.TryParse(attr.Value, out imageQuality))
                    ViewerServiceProperties.CompressImages = (imageQuality == _COMPRESSEDQUALITY);
            }

            var vixServiceCollection = doc.XPathSelectElements("//VixService");
            foreach (var vixService in vixServiceCollection)
            {
                switch (vixService.Attribute("ServiceType").Value)
                {
                    case "SiteService":
                        UrlHelper.ParseObject(vixService.Attribute("RootUrl").Value, SiteServiceProperties);
                        break;

                    case "Local":
                        UrlHelper.ParseObject(vixService.Attribute("RootUrl").Value, VixServiceProperties);
                        break;

                    case "Viewer":
                        {
                            UrlHelper.ParseObject(vixService.Attribute("RootUrl").Value, ViewerServiceProperties);

                            attr = vixService.Attribute("PublicHostName");
                            if (attr != null)
                            {
                                ViewerServiceProperties.OverrideHostName = attr.Value;
                            }

                            ViewerServiceProperties.TrustedClientPort = "";
                            attr = vixService.Attribute("TrustedClientRootUrl");
                            if (attr != null)
                            {
                                UrlHelper.Parse(attr.Value, (h, p, t) =>
                                    {
                                        ViewerServiceProperties.TrustedClientPort = p.ToString();
                                    });
                            }
                        }
                        break;
                }
            }

            var policyCollection = doc.XPathSelectElements("//Policies/add");
            foreach (var policy in policyCollection)
            {
                var policyName = policy.Attribute("name").Value;
                if (policyName == "Viewer.OverrideExportKeys")
                {
                    OptionsProperties.OverrideExportKeys = (policy.Attribute("value").Value.ToLower() == "true");
                    break;
                }
            }

            ViewerConfigFileName = fileName;

            // simply set reset to true
            ResetViewerSettings = true;
        }

        private void SaveViewerConfigFile(string fileName, bool securitySettingsOnly = false)
        {
            XDocument doc = XDocument.Load(fileName);

            if (!securitySettingsOnly)
            {
                var vista = doc.Root.Element("VistA");
                vista.SetAttributeValue("DiagnosticImageQuality", ViewerServiceProperties.CompressImages ? _COMPRESSEDQUALITY.ToString() : null);

                var vixServiceCollection = doc.XPathSelectElements("//VixService");
                foreach (var vixService in vixServiceCollection)
                {
                    switch (vixService.Attribute("ServiceType").Value)
                    {
                        case "SiteService":
                            vixService.Attribute("RootUrl").Value = UrlHelper.ToUrl(SiteServiceProperties);
                            break;

                        case "Local":
                            vixService.Attribute("RootUrl").Value = UrlHelper.ToUrl(VixServiceProperties);
                            break;

                        case "Viewer":
                            {
                                vixService.Attribute("RootUrl").Value = UrlHelper.ToUrl(ViewerServiceProperties);

                                vixService.SetAttributeValue("PublicHostName",
                                    string.IsNullOrEmpty(ViewerServiceProperties.OverrideHostName) ?
                                            null :
                                            ViewerServiceProperties.OverrideHostName);

                                vixService.SetAttributeValue("TrustedClientRootUrl",
                                    (ViewerServiceProperties._TrustedClientPort > 0) ?
                                            UrlHelper.ToUrl(ViewerServiceProperties.HostName, ViewerServiceProperties._TrustedClientPort, true) :
                                            null);
                            }
                            break;

                        case "Render":
                            vixService.Attribute("RootUrl").Value = UrlHelper.ToUrl(RenderServiceProperties, true);
                            break;
                    }
                }
            }

            if (ResetViewerSettings)
            {
                var policyCollection = doc.XPathSelectElements("//Policies/add");
                foreach (var policy in policyCollection)
                {
                    switch (policy.Attribute("name").Value)
                    {
                        case "Security.EnablePromiscuousMode":
                        case "Viewer.EnableDashboard":
                            {
                                policy.SetAttributeValue("value", "false");
                            }
                            break;
                    }
                }

                // set version specific settings
                if (!string.IsNullOrEmpty(VixServiceProperties.VixVersion))
                {
                    switch (VixServiceProperties.VixVersion)
                    {
                        case "201":
                            SetPolicy(doc, "Viewer.ImageInformationLink", "Popup");
                            SetPolicy(doc, "Viewer.QAReviewLink", "Hide");
                            SetPolicy(doc, "Viewer.ROIStatusLink", "Popup");
                            SetPolicy(doc, "Viewer.ROISubmissionLink", "Popup");
                            SetPolicy(doc, "Viewer.UserGuideLink", "New");
                            break;

                        case "205":
                            SetPolicy(doc, "Viewer.ImageInformationLink", "Popup");
                            SetPolicy(doc, "Viewer.QAReviewLink", "Hide");
                            SetPolicy(doc, "Viewer.ROIStatusLink", "Hide");
                            SetPolicy(doc, "Viewer.ROISubmissionLink", "Hide");
                            SetPolicy(doc, "Viewer.UserGuideLink", "New");

                            // override print options
                            OptionsProperties.OverrideExportKeys = true;
                            break;

                        case "221":
                            SetPolicy(doc, "Viewer.ImageInformationLink", "Popup");
                            SetPolicy(doc, "Viewer.QAReviewLink", "Popup");
                            SetPolicy(doc, "Viewer.QAReportLink", "Popup");
                            SetPolicy(doc, "Viewer.ROIStatusLink", "Popup");
                            SetPolicy(doc, "Viewer.ROISubmissionLink", "Popup");
                            SetPolicy(doc, "Viewer.UserGuideLink", "New");
                            break;

                        default:
                            SetPolicy(doc, "Viewer.ImageInformationLink", "Popup");
                            SetPolicy(doc, "Viewer.QAReviewLink", "Popup");
                            SetPolicy(doc, "Viewer.QAReportLink", "Popup");
                            SetPolicy(doc, "Viewer.ROIStatusLink", "Popup");
                            SetPolicy(doc, "Viewer.ROISubmissionLink", "Popup");
                            SetPolicy(doc, "Viewer.UserGuideLink", "New");
                            break;
                    }
                }

                // set options
                SetPolicy(doc, "Viewer.OverrideExportKeys", OptionsProperties.OverrideExportKeys.ToString().ToLower());

                // Check for old-style Client authentication
                var vista = doc.Root.Element("VistA");
                if (vista != null)
                {
                    var clientAuth = doc.XPathSelectElements("//ClientAuthentication").FirstOrDefault();
                    if (clientAuth == null)
                    {
                        // Important: add empty client authentication
                        vista.Add(new XElement("ClientAuthentication"));
                    }
                    else
                    {
                        // if attributes are present, then it is old-style. Remove all children and attributes
                        if (clientAuth.Attributes().Count() > 0)
                            clientAuth.RemoveAll();
                    }
                }

                ResetViewerSettings = false;
            }


            doc.Save(fileName);
        }

        private void SetPolicy(XDocument doc, string name, string value)
        {
            var policies = doc.XPathSelectElements("//Policies").FirstOrDefault();
            if (policies == null)
                return;

            var searchString = String.Format("add[@name = '{0}']", name);
            var policy = policies.XPathSelectElement(searchString);
            if (policy == null)
            {
                policy = new XElement("add");
                policy.SetAttributeValue("name", name);
                policies.Add(policy);
            }

            policy.SetAttributeValue("value", value);
        }

        private void ReadRenderConfigFile(string fileName)
        {
            XDocument doc = XDocument.Load(fileName);

            XElement render = doc.Root.Element("Render");
            UrlHelper.ParseObject(render.Attribute("ServerUrl").Value, RenderServiceProperties);

            XElement hix = doc.Root.Element("Hix");
            DatabaseProperties.InstanceName = hix.Element("Database").Attribute("DataSource").Value;
            foreach (var node in hix.Descendants("SecureElement"))
            {
                string name = node.Attribute("Name").Value;
                if (name == "Password")
                    DatabaseProperties.Password = DatabaseProperties.OriginalPassword = node.Attribute("Value").Value;
            }

            var purge = hix.Element("Purge");
            if (purge != null)
            {
                var attrib = purge.Attribute("PurgeTimes");
                if (attrib != null)
                    PurgeProperties.PurgeTimes = attrib.Value;

                attrib = purge.Attribute("MaxAgeDays");
                if (attrib != null)
                {
                    int val = 0;
                    if (int.TryParse(attrib.Value, out val))
                        PurgeProperties.MaxAgeDays = val;
                }

                attrib = purge.Attribute("MaxCacheSizeMB");
                if (attrib != null)
                {
                    int val = 0;
                    if (int.TryParse(attrib.Value, out val))
                        PurgeProperties.MaxCacheSizeMB = val;
                }

                attrib = purge.Attribute("Enabled");
                if (attrib != null)
                {
                    bool val = false;
                    if (bool.TryParse(attrib.Value, out val))
                        PurgeProperties.Enabled = val;
                }
            }

            StorageProperties.ImageCacheDirectory = hix.Element("ImageStores").Attribute("Path").Value;

            RenderConfigFileName = fileName;

            // simply enable reset
            ResetRenderSettings = true;
        }

        private void SaveRenderConfigFile(string fileName, bool securitySettingsOnly = false)
        {
            XDocument doc = XDocument.Load(fileName);

            if (!securitySettingsOnly)
            {
                XElement render = doc.Root.Element("Render");
                render.Attribute("ServerUrl").Value = UrlHelper.ToUrl(RenderServiceProperties);

                XElement hix = doc.Root.Element("Hix");
                hix.Element("Database").Attribute("DataSource").Value = DatabaseProperties.InstanceName;
                foreach (var node in hix.Descendants("SecureElement"))
                {
                    string name = node.Attribute("Name").Value;           
                    if (name == "Password")
                    {
                        if (DatabaseProperties.Password != DatabaseProperties.OriginalPassword)
                        {
                            node.Attribute("Value").Value = DatabaseProperties.Password;
                            node.Attribute("IsEncrypted").Value = "false";
                        }
                    }
                }

                hix.Element("ImageStores").Attribute("Path").Value = StorageProperties.ImageCacheDirectory;

                var purge = hix.Element("Purge");
                if (purge == null)
                {
                    purge = new XElement("Purge");
                    hix.Add(purge);
                }

                purge.SetAttributeValue("Enabled", PurgeProperties.Enabled.ToString());
                purge.SetAttributeValue("PurgeTimes", PurgeProperties.PurgeTimes);
                purge.SetAttributeValue("MaxAgeDays", PurgeProperties.MaxAgeDays.ToString());
                purge.SetAttributeValue("MaxCacheSizeMB", PurgeProperties.MaxCacheSizeMB.ToString());
            }

            if (ResetRenderSettings)
            {
                XElement hix = doc.Root.Element("Hix");
                if (hix != null)
                {
                    var processor = hix.Element("Processor");
                    if (processor != null)
                        processor.SetAttributeValue("ConvertTiffToPdf", "true");
                }

                ResetRenderSettings = false;
            }

            doc.Save(fileName);
        }
    }
}
