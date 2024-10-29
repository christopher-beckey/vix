using Hydra.Security;
using Hydra.VistA;
using System;
using System.IO;
using System.Xml;

namespace DesktopCommon
{
    public static class Utils
    {
        public static readonly string DateFormat = "yyyy-MM-dd";

        private static string configFile = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), @"VistA\TransactionEntryTracer.config");

        private static string accessCodeDecrypted;
        private static string accessCodeEncrypted;
        private static string delimiter;
        private static string logdir;
        private static string siteService;
        private static string verifyCodeDecrypted;
        private static string verifyCodeEncrypted;
        private static string vixJavaSecurityToken;

        public static string AccessCodeEncrypted
        {
            get => accessCodeEncrypted;
            set
            {
                accessCodeEncrypted = value;
                accessCodeDecrypted = CryptoUtil.DecryptAES(value);
            }
        }

        public static string AccessCodeDecrypted
        {
            get => accessCodeDecrypted;
        }

        public static string Delimiter
        {
            get => delimiter;
            set => delimiter = value;
        }

        public static string LogDir
        {
            get => logdir;
            set => logdir = value;
        }

        public static string SiteService
        {
            get => siteService;
            set => siteService = value;
        }

        public static string VerifyCodeEncrypted
        {
            get => verifyCodeEncrypted;
            set
            {
                verifyCodeEncrypted = value;
                verifyCodeDecrypted = CryptoUtil.DecryptAES(value);
            }
        }

        public static string VerifyCodeDecrypted
        {
            get => verifyCodeDecrypted;
        }

        public static string VixJavaSecurityToken
        {
            get => vixJavaSecurityToken;
        }

        public static string GetApplicationDir(string executablePath)
        {
            FileInfo file = new FileInfo(executablePath);
            return file.Directory.FullName;
        }

        public static string GetApplicationDir()
        {
            string path = Path.GetDirectoryName(System.Reflection.Assembly.GetAssembly(typeof(Utils)).CodeBase);
            return path;
        }

        public static string GetLogFilename(string siteNumber, DateTime fromDate)
        {
            string ext = Delimiter == "Tab" ? "tsv" : "csv";
            bool isToday = IsDateToday(fromDate);
            string partial = isToday ? ".partial" : "";
            return $@"{LogDir}\{siteNumber}\{fromDate.ToString(DateFormat)}.{ext}{partial}";
        }

        public static bool SetVixJavaSecurityToken(string server, int port, out string errorMsg)
        {
            errorMsg = "";
            try
            {
                VixClient vixClient = new VixClient($"http://{server}:{port}", AccessCodeDecrypted, VerifyCodeDecrypted, VixFlavor.Vix);
                vixJavaSecurityToken = vixClient.GetVixJavaSecurityToken(null);
                return true;
            }
            catch (Exception ex)
            {
                string fullEX = ex.ToString();
                if (fullEX.Contains("(401)"))
                    fullEX = $"Perhaps you need to change File > Options?{Environment.NewLine}{Environment.NewLine}{fullEX}";
                errorMsg = fullEX;
                return false;
            }
        }

        public static bool IsDateAfter(DateTime dt1, DateTime dt2)
        {
            int val = dt1.CompareTo(dt2);
            if (val > 0)
                return true;
            return false;
        }

        public static void InitializeConfig()
        {
            if (File.Exists(configFile))
                ReadConfig();
            else
            {
                AccessCodeEncrypted = ""; //"DEAJpoYRQO3JSDyOO7HXcA==";
                VerifyCodeEncrypted = ""; //"nR8BLZJNU2Na7wd4TEuWcmsi1nrNhF6F1Q7WH9yXz6g=";
                SiteService = "http://siteserver.vista.med.va.gov/VistaWebSvcs/ImagingExchangeSiteService.asmx";
                Delimiter = "Tab";
                if (Directory.Exists($@"G:\VIXLogs"))
                    LogDir = $@"G:\VIXLogs";
                else
                {
                    LogDir = $@"C:\Temp\VIXLogs";
                    if (!Directory.Exists(LogDir))
                    {
                        Directory.CreateDirectory(LogDir);
                    }
                }
                WriteConfig();
            }
        }

        public static void WriteConfig()
        {
            //VAI-1161: P348
            string parentFolder = Path.GetDirectoryName(configFile);
            if (!Directory.Exists(parentFolder))
            {
                Directory.CreateDirectory(parentFolder);
            }
            string DBQ = "\""; //double-quote
            string NL = Environment.NewLine;
            string config = $"<?xml version={DBQ}1.0{DBQ} encoding={DBQ}utf-8{DBQ}?>{NL}";
            config = config + $"<configuration>{NL}";
            config = config + $"  <section name={DBQ}VistA{DBQ}>{NL}";
            config = config + $"    <setting name={DBQ}AccessCode{DBQ} value={DBQ}{AccessCodeEncrypted}{DBQ}/>{NL}";
            config = config + $"    <setting name={DBQ}VerifyCode{DBQ} value={DBQ}{VerifyCodeEncrypted}{DBQ}/>{NL}";
            config = config + $"    <setting name={DBQ}SiteService{DBQ} value={DBQ}{SiteService}{DBQ}/>{NL}";
            config = config + $"  </section>{NL}";
            config = config + $"  <section name={DBQ}Tools{DBQ}>{NL}";
            config = config + $"    <setting name={DBQ}Delim{DBQ} value={DBQ}{Delimiter}{DBQ}/>{NL}";
            config = config + $"    <setting name={DBQ}LogDir{DBQ} value={DBQ}{LogDir}{DBQ}/>{NL}";
            config = config + $"  </section>{NL}";
            config = config + $"</configuration>{NL}";
            LockManager.GetLock(configFile, () => { File.WriteAllText(configFile, config); });
            if (!Directory.Exists(LogDir))
            {
                Directory.CreateDirectory(LogDir);
            }
        }

        public static void EditConfig()
        {
            frmOptions frm = new frmOptions();
            frm.ShowDialog();
            InitializeConfig();
        }

        private static void ReadConfig()
        {
            XmlDocument xmlDoc = new XmlDocument();
            xmlDoc.Load(configFile);
            AccessCodeEncrypted = GetConfigValue(xmlDoc, "VistA", "AccessCode");
            VerifyCodeEncrypted = GetConfigValue(xmlDoc, "VistA", "VerifyCode");
            SiteService = GetConfigValue(xmlDoc, "VistA", "SiteService");
            Delimiter = GetConfigValue(xmlDoc, "Tools", "Delim");
            LogDir = GetConfigValue(xmlDoc, "Tools", "LogDir");
        }

        private static string GetConfigValue(XmlDocument xmlDoc, string sectionName, string settingName)
        {
            string result = "";
            string xpath = $"//section[@name='{sectionName}']/setting[@name='{settingName}']";
            XmlNode node = xmlDoc.DocumentElement.SelectSingleNode(xpath);
            if (node != null)
            {
                XmlAttribute xmlAttr = node.Attributes["value"];
                if (xmlAttr != null)
                {
                    result = xmlAttr.Value;
                }
            }
            return result;
        }

        private static bool IsDateToday(DateTime date)
        {
            DateTime now = DateTime.Now;
            if ((now.Year == date.Year) &&
                (now.Month == date.Month) &&
                (now.Day == date.Day))
                return true;
            return false;
        }
    }
}
