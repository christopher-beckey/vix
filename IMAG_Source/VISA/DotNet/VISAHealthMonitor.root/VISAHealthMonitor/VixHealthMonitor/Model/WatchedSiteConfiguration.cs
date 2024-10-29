using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;

namespace VixHealthMonitor.Model
{
    public class WatchedSiteConfiguration
    {
        public List<string> WatchedSites { get; private set; }

        private readonly string Filename;

        private WatchedSiteConfiguration(string filename)
        {
            WatchedSites = new List<string>();
            this.Filename = filename;
            LoadConfiguration();
        }

        public static WatchedSiteConfiguration Initialize(string filename)
        {
            _watchedSiteConfiguration = new WatchedSiteConfiguration(filename);
            return _watchedSiteConfiguration;

        }

        private static WatchedSiteConfiguration _watchedSiteConfiguration = null;

        public static WatchedSiteConfiguration GetWatchedSiteConfiguration()
        {
            return _watchedSiteConfiguration ;
        }

        private void LoadConfiguration()
        {
            if (System.IO.File.Exists(Filename))
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.Load(Filename);
                XmlNodeList watchedSiteNodes = xmlDoc.SelectNodes("/VixHealthMonitorWatchedSites/WatchedSite");
                foreach (XmlNode watchedSite in watchedSiteNodes)
                {
                    string siteId = watchedSite.Attributes["SiteId"].Value;
                    WatchedSites.Add(siteId);
                }
            }
        }

        public void Save()
        {
            XmlDocument xmlDoc = new XmlDocument();
            XmlNode rootNode = xmlDoc.CreateElement("VixHealthMonitorWatchedSites");
            xmlDoc.AppendChild(rootNode);

            foreach (string siteNumber in WatchedSites)
            {
                XmlNode watchedSiteNode = xmlDoc.CreateElement("WatchedSite");
                rootNode.AppendChild(watchedSiteNode);
                XmlAttribute attr = xmlDoc.CreateAttribute("SiteId");
                attr.Value = siteNumber;
                watchedSiteNode.Attributes.Append(attr);
            }

            xmlDoc.Save(Filename);
        }

        public bool IsSiteWatched(string SiteId)
        {
            foreach (string siteId in WatchedSites)
            {
                if (siteId == SiteId)
                    return true;
            }
            return false;   
        }
    }

    /*
    public class WatchedSite
    {
        public string SiteNumber { get; set; }
    }*/
}
