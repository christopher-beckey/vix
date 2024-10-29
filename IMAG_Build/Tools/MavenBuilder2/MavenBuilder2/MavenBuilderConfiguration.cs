using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace MavenBuilder2
{
    public class MavenBuilderConfiguration
    {
        private string mstrFilename;
        
        private string mstrVixBuildManifest;
        private string mstrEclipseWorkspace;
        private string mstrTomcatDir;
        private string mstrMavenRepository;
        private string mstrMaven2Home;
        private string mstrJreLibExtDir;
        private bool mbRunUnitTests = true;
        private bool mbUseBuildProject = true;

        public bool UseBuildProject
        {
            get { return mbUseBuildProject; }
            set { mbUseBuildProject = value; }
        }

        public string Filename
        {
            get { return mstrFilename; }
        }

        public bool RunUnitTests
        {
            get { return mbRunUnitTests; }
            set { mbRunUnitTests = value; }
        }

        public string JreLibExtDir
        {
            get { return mstrJreLibExtDir; }
            set { mstrJreLibExtDir = value; }
        }

        public string Maven2Home
        {
            get { return mstrMaven2Home; }
            set { mstrMaven2Home = value; }
        }

        public string VixBuildManifest
        {
            get { return mstrVixBuildManifest; }
            set { mstrVixBuildManifest = value; }
        }

        public string EclipseWorkspace
        {
            get { return mstrEclipseWorkspace; }
            set { mstrEclipseWorkspace = value; }
        }        

        public string TomcatDir
        {
            get { return mstrTomcatDir; }
            set { mstrTomcatDir = value; }
        }        

        public string MavenRepository
        {
            get { return mstrMavenRepository; }
            set { mstrMavenRepository = value; }
        }

        public bool Loaded
        {
            get
            {
                if ((!string.IsNullOrEmpty(mstrEclipseWorkspace)) &&
                    (!string.IsNullOrEmpty(mstrJreLibExtDir)) &&
                    (!string.IsNullOrEmpty(mstrMavenRepository)) &&
                    (!string.IsNullOrEmpty(mstrTomcatDir)) &&
                    (!string.IsNullOrEmpty(mstrVixBuildManifest)) &&
                    (!string.IsNullOrEmpty(mstrMaven2Home)) 
                    )
                {
                    return true;
                }
                return false;
            }
        }

        public MavenBuilderConfiguration(string filename)
        {
            /*
            mstrVixBuildManifest = @"C:\eclipse\workspace.trunk\ImagingExchange\VixBuildManifestPatch104VIX.xml";
            mstrTomcatDir = @"C:\Program Files\Apache Software Foundation\apache-tomcat-6.0.20";
            mstrEclipseWorkspace = @"c:\eclipse\workspace.trunk";
            mstrMavenRepository = @"C:\Documents and Settings\vhaiswwerfej\.m2\repository";
            mstrMaven2Home = @"c:\Program Files\Apache Software Foundation\apache-maven-2.1.0";
             * */
            mstrFilename = filename;
            Load();
        }

        private void Load()
        {
            if (System.IO.File.Exists(mstrFilename))
            {
                XmlDocument xmlDoc = new XmlDocument();
                xmlDoc.Load(mstrFilename);

                XmlNode settingsNode = xmlDoc.SelectSingleNode("MavenBuilder/Settings");
                if (settingsNode != null)
                {
                    mstrVixBuildManifest = settingsNode.Attributes["VixBuildManifest"].Value;
                    mstrTomcatDir = settingsNode.Attributes["TomcatDir"].Value;

                    mstrEclipseWorkspace = settingsNode.Attributes["EclipseWorkspace"].Value;
                    mstrMavenRepository = settingsNode.Attributes["Maven2Repository"].Value;
                    mstrMaven2Home = settingsNode.Attributes["Maven2Home"].Value;

                    if (settingsNode.Attributes["JreLibExtDir"] != null)
                    {
                        mstrJreLibExtDir = settingsNode.Attributes["JreLibExtDir"].Value;
                    }
                    if (settingsNode.Attributes["RunUnitTests"] != null)
                    {
                        mbRunUnitTests = bool.Parse(settingsNode.Attributes["RunUnitTests"].Value);
                    }
                    if (settingsNode.Attributes["UseBuildProject"] != null)
                    {
                        mbUseBuildProject = bool.Parse(settingsNode.Attributes["UseBuildProject"].Value);
                    }
                    
                }
            }
        }

        public void Save()
        {
            Save(mstrFilename);
        }

        public void Save(string filename)
        {
            mstrFilename = filename;
            XmlDocument xmlDoc = new XmlDocument();

            XmlNode rootNode = xmlDoc.CreateElement("MavenBuilder");
            xmlDoc.AppendChild(rootNode);

            XmlNode settingsNode = xmlDoc.CreateElement("Settings");
            rootNode.AppendChild(settingsNode);

            XmlAttribute attr = xmlDoc.CreateAttribute("VixBuildManifest");
            attr.Value = mstrVixBuildManifest;
            settingsNode.Attributes.Append(attr);

            attr = xmlDoc.CreateAttribute("TomcatDir");
            attr.Value = mstrTomcatDir;
            settingsNode.Attributes.Append(attr);

            attr = xmlDoc.CreateAttribute("EclipseWorkspace");
            attr.Value = mstrEclipseWorkspace;
            settingsNode.Attributes.Append(attr);

            attr = xmlDoc.CreateAttribute("Maven2Repository");
            attr.Value = mstrMavenRepository;
            settingsNode.Attributes.Append(attr);

            attr = xmlDoc.CreateAttribute("Maven2Home");
            attr.Value = mstrMaven2Home;
            settingsNode.Attributes.Append(attr);

            attr = xmlDoc.CreateAttribute("JreLibExtDir");
            attr.Value = mstrJreLibExtDir;
            settingsNode.Attributes.Append(attr);

            attr = xmlDoc.CreateAttribute("RunUnitTests");
            attr.Value = mbRunUnitTests.ToString();
            settingsNode.Attributes.Append(attr);

            attr = xmlDoc.CreateAttribute("UseBuildProject");
            attr.Value = mbUseBuildProject.ToString();
            settingsNode.Attributes.Append(attr);


            xmlDoc.Save(mstrFilename);
        }

    }
}
