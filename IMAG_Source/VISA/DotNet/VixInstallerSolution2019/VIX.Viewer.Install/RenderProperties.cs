using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Vix.Viewer.Install
{
    public class RenderProperties
    {
        [Description("Render Url"), DisplayName("Render Url")]
        public string RenderUrl { get; set; }

        [Description("Data Source"), DisplayName("Data Source")]
        public string DataSource { get; set; }

        [Description("Database Password"), DisplayName("Database Password")]
        public string DataSourcePassword { get; set; }

        [Browsable(false)]
        public string RenderConfigFileName { get; private set; }

        [Description("Purge Settings"), DisplayName("Purge")]
        [RefreshProperties(RefreshProperties.All)]
        public PurgeProperties PurgeProperties { get; set; }

        public RenderProperties(string fileName = null)
        {
            if (!string.IsNullOrEmpty(fileName))
                LoadRenderConfigFile(fileName);
        }

        public void Save()
        {
            if (!File.Exists(RenderConfigFileName))
                return;

            SaveRenderConfigFile(RenderConfigFileName);
        }

        public void LoadRenderConfigFile(string fileName)
        {
            XDocument doc = XDocument.Load(fileName);

            RenderUrl = doc.Root.Element(@"Render").Attribute("ServerUrl").Value;

            XElement hix = doc.Root.Element("Hix");
            DataSource = hix.Element("Database").Attribute("DataSource").Value;
            foreach (var node in hix.Descendants("SecureElement"))
            {
                string name = node.Attribute("Name").Value;
                if (name == "Password")
                    DataSourcePassword = node.Attribute("Value").Value;
            }

            RenderConfigFileName = fileName;

            PurgeProperties = new PurgeProperties()
            {
                Enabled = true,
                MaxAgeDays = 2,
                MaxCacheSizeMB = 1024,
                PurgeTimes = "12:00"
            };

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
        }
        
        private void SaveRenderConfigFile(string fileName)
        {
            XDocument doc = XDocument.Load(fileName);

            doc.Root.Element(@"Render").Attribute("ServerUrl").Value = RenderUrl;

            XElement hix = doc.Root.Element("Hix");
            hix.Element("Database").Attribute("DataSource").Value = DataSource;

            foreach (var node in hix.Descendants("SecureElement"))
            {
                string name = node.Attribute("Name").Value;
                if (name == "Password")
                    node.Attribute("Value").Value = DataSourcePassword;
            }

            var purge = hix.Element("Purge");
            if (purge == null)
            {
                purge = new XElement("Purge");
                hix.Add(purge);
            }

            purge.Attribute("Enabled").Value = PurgeProperties.Enabled.ToString();
            purge.Attribute("PurgeTimes").Value = PurgeProperties.PurgeTimes;
            purge.Attribute("MaxAgeDays").Value = PurgeProperties.MaxAgeDays.ToString();
            purge.Attribute("MaxCacheSizeMB").Value = PurgeProperties.MaxCacheSizeMB.ToString();

            doc.Save(fileName);
        }

        public void Validate()
        {
            if (string.IsNullOrEmpty(RenderUrl))
                throw new ArgumentException("Service Url is not valid");

            if (string.IsNullOrEmpty(DataSource))
                throw new ArgumentException("Database server name is not valid");
        }

    }
}
