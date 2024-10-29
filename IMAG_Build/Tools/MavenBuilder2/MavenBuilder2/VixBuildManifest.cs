using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace MavenBuilder2
{
    public class VixBuildManifest
    {
        private readonly string mstrFilename;

        public VixBuildManifest(string filename)
        {
            mstrFilename = filename;
        }

        public List<VixProject> GetProjects(bool useBuildProject)
        {
            List<VixProject> projects = new List<VixProject>();

            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.Load(mstrFilename);
            int count = 1;

            XmlNode rootNode = xmlDoc.ChildNodes[1];

            string xpath = "/Build/BuildProjects/BuildProject";
            if (!useBuildProject)
            {
                xpath = "/Build/CvsProjects/CvsProject";
            }

            XmlNodeList projectNodes = rootNode.SelectNodes(xpath);
            foreach (XmlNode projectNode in projectNodes)
            {
                string projectType = projectNode.Attributes["dependencyType"].Value;
                string projectName = projectNode.InnerText;
                projects.Add(new VixProject(count++, projectName, projectType));                
            }

            return projects;
        }
    }
}
