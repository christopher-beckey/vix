using System;
using System.Collections.Generic;
using System.Text;

namespace MavenBuilder2
{
    public class VixProject
    {
        private readonly int mintBuildOrder;
        private readonly string mstrProjectType;
        private readonly string mstrProjectName;
        private string mstrMavenLastModified;
        private string mstrTomcatLastModified;

        private readonly string mstrProjectVersion = "0.1";

        public string ProjectVersion
        {
            get { return mstrProjectVersion; }
        } 

        public int BuildOrder
        {
            get { return mintBuildOrder; }
        } 

        public string ProjectName
        {
            get { return mstrProjectName; }
        } 

        public string MavenLastModified
        {
            get { return mstrMavenLastModified; }
            set { mstrMavenLastModified = value; }
        }

        public string TomcatLastModified
        {
            get { return mstrTomcatLastModified; }
            set { mstrTomcatLastModified = value; }
        }        

        public string ProjectType
        {
            get { return mstrProjectType; }
        } 

        public VixProject(int buildOrder, string projectName, string projectType)
        {
            mstrProjectName = projectName;
            mstrProjectType = projectType;
            mintBuildOrder = buildOrder;
        }
            
    }
}
