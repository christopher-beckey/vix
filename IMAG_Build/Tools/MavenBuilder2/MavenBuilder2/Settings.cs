using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace MavenBuilder2
{
    public class Settings
    {
        private readonly string mstrFilename;

        private string mstrMavenBuilderConfiguration = null;

        public string MavenBuilderConfiguration
        {
            get { return mstrMavenBuilderConfiguration; }
            set { mstrMavenBuilderConfiguration = value; }
        }

        public Settings(string filename)
        {
            mstrFilename = filename;
            Load();
        }

        private void Load()
        {
            if (System.IO.File.Exists(mstrFilename))
            {
                XmlDocument xmlDoc = new XmlDocument();
                try
                {
                    xmlDoc.Load(mstrFilename);

                    XmlNode settingsNode = xmlDoc.SelectSingleNode("MavenBuilder2/Settings");
                    mstrMavenBuilderConfiguration = settingsNode.Attributes["MavenBuilderConfigurationFile"].Value;
                }
                catch (Exception )
                {
                    // not showing exception
                }
            }
        }

        public void Save()
        {
            XmlDocument xmlDoc = new XmlDocument();
            XmlNode rootNode = xmlDoc.CreateElement("MavenBuilder2");
            xmlDoc.AppendChild(rootNode);
            XmlNode settingsNode = xmlDoc.CreateElement("Settings");
            rootNode.AppendChild(settingsNode);

            XmlAttribute attr = xmlDoc.CreateAttribute("MavenBuilderConfigurationFile");
            attr.Value = mstrMavenBuilderConfiguration;
            settingsNode.Attributes.Append(attr);

            xmlDoc.Save(mstrFilename);
        }
    }
}
