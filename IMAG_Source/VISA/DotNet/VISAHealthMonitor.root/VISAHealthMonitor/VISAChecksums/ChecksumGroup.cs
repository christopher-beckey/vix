using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace VISAChecksums
{
    public class ChecksumGroup
    {

        public Dictionary<string, FileDetails> Checksums { get; private set; }
        public string Version { get; private set; }
        public LibraryType LibraryType { get; private set; }
        public VisaType VisaType { get; private set; }
        public OsArchitecture OsArchitecture { get; private set; }


        public ChecksumGroup(string version, LibraryType libraryType, VisaType visaType, OsArchitecture osArchitecture)
        {
            Checksums = new Dictionary<string, FileDetails>();
            this.Version = version;
            this.LibraryType = libraryType;
            this.VisaType = visaType;
            this.OsArchitecture = osArchitecture;
        }

        public void Save(string filename)
        {
            ToXml().Save(filename);
        }

        public XmlDocument ToXml()
        {
            XmlDocument xmlDoc = new XmlDocument();

            XmlNode checksumsNode = xmlDoc.CreateElement("Checksums");
            xmlDoc.AppendChild(checksumsNode);
            XmlAttribute attr = xmlDoc.CreateAttribute("version");
            attr.Value = Version;
            checksumsNode.Attributes.Append(attr);
            attr = xmlDoc.CreateAttribute("libraryType");
            attr.Value = LibraryType + "";
            checksumsNode.Attributes.Append(attr);
            attr = xmlDoc.CreateAttribute("visaType");
            attr.Value = VisaType + "";
            checksumsNode.Attributes.Append(attr);
            attr = xmlDoc.CreateAttribute("generatedHostname");
            attr.Value = Environment.MachineName;
            checksumsNode.Attributes.Append(attr);
            attr = xmlDoc.CreateAttribute("osArchitecture");
            attr.Value = OsArchitecture + "";
            checksumsNode.Attributes.Append(attr);

            foreach (FileDetails fileChecksum in Checksums.Values)
            {
                XmlNode checksumNode = xmlDoc.CreateElement("Checksum");
                checksumsNode.AppendChild(checksumNode);
                attr = xmlDoc.CreateAttribute("filename");
                attr.Value = fileChecksum.Filename;
                checksumNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("checksum");
                attr.Value = fileChecksum.Checksum;
                checksumNode.Attributes.Append(attr);
                attr = xmlDoc.CreateAttribute("size");
                attr.Value = fileChecksum.FileSize + "";
                checksumNode.Attributes.Append(attr);
            }


            return xmlDoc;
        }

        public static ChecksumGroup FromXml(string xml)
        {
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(xml);

            XmlNode checksumsNode = xmlDoc.SelectSingleNode("Checksums");
            string version = checksumsNode.Attributes["version"].Value;
            string libraryTypeString = checksumsNode.Attributes["libraryType"].Value;
            string visaTypeString = checksumsNode.Attributes["visaType"].Value;

            OsArchitecture osArchitecture = OsArchitecture.x86;
            if (checksumsNode.Attributes["osArchitecture"] != null)
            {
                osArchitecture = OsArchitectureFromString(checksumsNode.Attributes["osArchitecture"].Value);
            }

            LibraryType libraryType = LibraryTypeFromString(libraryTypeString);
            VisaType visaType = VisaTypeFromString(visaTypeString);

            ChecksumGroup result = new ChecksumGroup(version, libraryType, visaType, osArchitecture);

            XmlNodeList checksumNodes = checksumsNode.SelectNodes("Checksum");
            foreach (XmlNode checksumNode in checksumNodes)
            {
                string filename = checksumNode.Attributes["filename"].Value;
                string checksum = checksumNode.Attributes["checksum"].Value;
                long size = long.Parse(checksumNode.Attributes["size"].Value);
                result.Checksums.Add(filename, new FileDetails(filename, checksum, size));
            }

            return result;
        }

        public static OsArchitecture OsArchitectureFromString(string value)
        {
            switch (value)
            {
                case "x64":
                    return OsArchitecture.x64;
                default:
                    return OsArchitecture.x86;
            }
        }

        public static LibraryType LibraryTypeFromString(string value)
        {
            switch (value)
            {
                case "tomcatLib":
                    return LibraryType.tomcatLib;
                default:
                    return LibraryType.jreLibExt;
            }
        }

        public static VisaType VisaTypeFromString(string value)
        {
            switch (value)
            {
                case "vix":
                    return VisaType.vix;
                case "cvix":
                    return VisaType.cvix;
                default:
                    return VisaType.hdig;
            }
        }
    }

    public enum LibraryType
    {
        tomcatLib, jreLibExt
    }

    public enum VisaType
    {
        vix, cvix, hdig
    }

    public enum OsArchitecture
    {
        x86, x64
    }
}
