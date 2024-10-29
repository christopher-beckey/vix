using Hydra.Security;
using System.Configuration;
using System.Xml;

namespace Hydra.IX.Common
{
    public class HixConfigurationFile
    {
        public static T GetHixSection<T>(string filePath, string sectionName) where T : ConfigurationSection
        {
            System.Configuration.Configuration config =
                ConfigurationManager.OpenMappedExeConfiguration(new ExeConfigurationFileMap { ExeConfigFilename = filePath }, 
                                                                (ConfigurationUserLevel.None));

            return config.GetSection(sectionName) as T;
        }

        public static void Encrypt(string filePath)
        {
            XmlDocument doc = new XmlDocument { PreserveWhitespace = true };
            doc.Load(filePath);

            // get a list of all secure elements
            bool saveFile = false;
            XmlNodeList nodeList = doc.SelectNodes(".//SecureElement");
            foreach (XmlNode node in nodeList)
            {
                bool isEncrypted = bool.Parse(node.Attributes["IsEncrypted"].Value);
                if (!isEncrypted)
                {
                    string value = node.Attributes["Value"].Value;
                    node.Attributes["Value"].Value = CryptoUtil.EncryptAES(value);
                    node.Attributes["IsEncrypted"].Value = "true";
                    saveFile = true;
                }
            }

            if (saveFile)
                doc.Save(filePath);
        }
    }
}
