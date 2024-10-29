using Hydra.Common; //VAI-707
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Xml;

namespace Hydra.Security
{
    public static class SecurityUtil
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public class ClientAuthentication
        {
            //These variable names must match the config file attribute names and the ClientAuthenticationElement.cs properties!
            public List<string> CertificateThumbprints;
            public StoreLocation StoreLocation;
            public StoreName StoreName;
            public string Username;
            public string Password;
            public bool IncludeVixSecurityToken;
        }

        //VAI-707: Added VIX Tools for custom authentication
        public class VixTool
        {
            public string Name;
            public string SecurityHandoff;
            public string Url;
            public bool IsCvix;
            public bool IsVix;
            public bool IsInternal; //VAI-1329
        }

        private static readonly string DBQ = "\""; //one double-quote

        static SecurityUtil()
        {
        }

        /// <summary>
        /// VixTools prepared for the tools View allowed by user authentication.
        /// </summary>
        public static List<VixTool> VixToolList { get; set; } //VAI-707

        /// <summary>
        /// Client Authentication Settings.
        /// </summary>
        public static List<ClientAuthentication> ClientAuthenticationList { get; set; } //VAI-707

        /// <summary>
        /// If true, do not check for the certificate's expiration date.
        /// </summary>
        public static bool BypassCertificateDateCheck { get; set; }

        /// <summary>
        /// If true, we are running a centralized VIX.
        /// </summary>
        public static bool IsCvix { get; set; }

        /// <summary>
        /// Example encrypted VIX Viewer Security Token for debugging. (VAI-707)
        /// </summary>
        /// <remarks>See SecurityToken.cs</remarks>
        public static string ExampleVVToken { get { return "MjAyMS0xMi0xMVQwNTowMDowMC4wMDA0OTc1WnwtRHZESUlqdGJOb3YzUFJxQmJsdDFVNW41bjdVV0oyMnhHUW9vR0xJQUdjWmtQc081Sld2YzZza2F2ZEJVckFZLXQycWg3b1RxNUFTbUNwZkE2ZDBRZGJnRXlORmw2WHRlR3BOQ0ZBeXVwOUgyRUw5a0ZvVEhpSUhIVTdLbnJyaXJBMVc4a3VtZFJGNmk2TFNPY0dpY2ZIdXBHbnc5aXhaR2hYcmlVSVdmbGxFazc3RGN3PT18Ym9hdGluZzF8OGYwYWUxNjItODQwOS00NTQwLTk3MGQtYzQ4ZTJiN2VkZWE4fHZWMmxvTWhLQytjSWVLM3JSa1BFZkdiQmJhMjgyTHI5ZEN1bDVDeHV3Sm9qUkN4NzlHejdPUWdvMWFBeW4rNHdzRVp1M2VacVlEZGRBOTFBeVFxd1FRRFpZVWhZUHpxdW1WWGNMTVhJSU40PQ%3d%3d"; } }

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

        /// <summary>
        /// Given a base 64 string, return it as-is or return its decoded value 
        /// </summary>
        /// <param name="given">The given base 64 string , envoded or not</param>
        /// <returns>A normal base 64 string</returns>
        /// <remarks>If the given string contains %, first URL decode. Then toggle according to the following.
        /// If the given string contains + or /, replace + with - and / with _.
        /// If the given string contains - or _, replace - with + and _ with /.</remarks>
        public static string DecodeEncodedBase64(string given)
        {
            string base64String = given;
            if (base64String.Contains("%"))
                base64String = System.Net.WebUtility.UrlDecode(base64String);
            //common URL encoding techique the Java code uses
            if (base64String.Contains("+") || base64String.Contains("/"))
                base64String = base64String.Replace('+', '-').Replace('/', '_');
            else
            {
                if (base64String.Contains("-") || base64String.Contains("_"))
                    base64String = base64String.Replace('-', '+').Replace('_', '/');
            }
            return base64String;
        }

        /// <summary>
        /// Use the VIX Java algorithm to either decrypt or encrypt a string
        /// <param name="op"/>The operation to perform, either "decrypt" or "encrypt"</param?
        /// <param name="textToEOperate">The text to perform the operation on</param>
        /// <param name="errorMsg">(Out)The error message or empty on success</param>
        /// </summary>
        /// <remarks>Refactored for VAI-903</remarks>
        public static string FromVixJava(string op, string textToOperate, out string errorMsg)
        {
            if ((op != "decrypt") && (op != "encrypt"))
            {
                errorMsg = $"Internal Server Error: Invalid Operation ({op})";
                return "";
            }
            try
            {
                errorMsg = "";
                //"Usage: java -jar x.jar -operation=[upgrade|downgrade|encrypt|decrypt] " +
                //"-input=[full path to control XML file|text to encrypt/decrypt] -password=[password]"
                string args = $@"-jar C:\VixConfig\Encryption\ImagingUtilities-0.1.jar -operation={op} -password={Globals.Config.VixUtilPassword} -input={DBQ}{textToOperate}{DBQ}";
                //Old algorithm
                //Encrypted string example is: xx/6C7fYWEIEknHGtUEVRvMti31QFQ==
                //Decrypted string example is: RADTECH,FIFTYTWO||20095||666669999||CAMP MASTER||500||1XWBAS1620-423141_3||||
                //New algorithm
                //Encrypted string example is: 5WDXGxDOLEo7a8TpJhr-gyVyTXKNiZbzWPFwMvMZvD79gSdWO1mIOKZJthpkfFu_Mu4WFbfd0zSm7eR4DGgXqAmWaVhAwLUOi4PNilH542jdPX14uy2UQ1VtYzFKIWC0QcAQnizhhFtaNqBsWa8b8vUeeimfng3Peyj7JHkNk3o=
                //Decrypted string example is: IMAGPROVIDERONETWOSIX,ONETWOSIX||126||843924956||CVIX||2001||VISTA IMAGING VIX^XUSBSE404-206377_7^200^9300||||||||1658063978366
                string procResult = ProcessUtil.RunExternalProcess("", "java", args, out errorMsg, Globals.Config.ExternalShortProcessTimeoutMilliseconds); //VAI-903
                string[] procResultParts = procResult.Split(new string[] { ": " }, StringSplitOptions.None);
                if (procResultParts.Length > 1) procResult = procResultParts[1].TrimStart();
                //VAI-1069
                if (errorMsg.Length > 0)
                {
                    //Temporary code while we transition to a new password
                    if (procResult == "Invalid password received")
                    {
                        string prevValue = "jwmkXkGyUCINJj7leyIPi4//uvF6HDKUXtH75MXJdlI=";
                        string prevDecryptedValue = CryptoUtil.DecryptAES(prevValue);
                        args = $@"-jar C:\VixConfig\Encryption\ImagingUtilities-0.1.jar -operation={op} -password={prevDecryptedValue} -input={DBQ}{textToOperate}{DBQ}";
                        procResult = ProcessUtil.RunExternalProcess("", "java", args, out errorMsg, Globals.Config.ExternalShortProcessTimeoutMilliseconds); //VAI-903
                        procResultParts = procResult.Split(new string[] { ": " }, StringSplitOptions.None);
                        if (procResultParts.Length > 1) procResult = procResultParts[1].TrimStart();
                    }
                }
                return procResult;
            }
            catch (Exception ex)
            {
                errorMsg = ex.ToString();
                return "";
            }
        }

        public static ClientAuthentication ValidateCertificate(X509Certificate certificate)
        {
            if (ClientAuthenticationList.Count == 0)
                throw new Hydra.Common.Exceptions.HydraWebException(System.Net.HttpStatusCode.InternalServerError, "Client authentication not configured.");

            X509Store store = null;

            try
            {
                if (certificate == null)
                    throw new Hydra.Common.Exceptions.BadRequestException("Client certificate is not present");

                CheckExpirationDate(certificate);

                var certificateThumbprint = (certificate as X509Certificate2).Thumbprint;

                foreach (var item in ClientAuthenticationList)
                {
                    bool isClientAuthorized = false;

                    if (item.CertificateThumbprints.Count > 0)
                    {
                        isClientAuthorized = item.CertificateThumbprints.Any(x => string.Compare(x, certificateThumbprint, true) == 0);
                    }
                    else
                    {
                        store = new X509Store(item.StoreName, item.StoreLocation);
                        store.Open(OpenFlags.ReadOnly);
                        var cert = store.Certificates.OfType<X509Certificate2>().FirstOrDefault(x => x.Thumbprint == certificateThumbprint);
                        isClientAuthorized = (cert != null);
                    }

                    if (isClientAuthorized)
                        return item;
                }

                throw new Hydra.Common.Exceptions.BadRequestException("Client certificate does not match");
            }
            finally
            {
                if (store != null)
                    store.Close();
            }
        }

        /// <summary>
        /// Create a user identity and store it in the server's session cache
        /// </summary>
        /// <param name="vixViewerSecurityToken"></param>
        /// <param name="userId"></param>
        /// <param name="hostAddress"></param>
        /// <remarks>The code was in one place prior to P269, but was centralized in P269 for VAI-707 for multiple calls</returns>
        public static void CreateUserSession(string vixViewerSecurityToken, string userId, string hostAddress)
        {
            UserIdentity currentUser = new UserIdentity() { HttpStatusCode = Nancy.HttpStatusCode.OK };
            //The standard .NET way to create claims is to use List<Claim> and add multiple Claim objects, like the following:
            //    currentUser.Claims = new List<Claim>();
            //    claims.Add(new Claim(ClaimTypes.Role, "User"));
            //NancyFX, however uses Claims as List<string>, and we can't override it.
            //If we want to add more than just the security token in the future, we can use the pipe (|) symbol like key|value.
            currentUser.Claims = new List<string>() { vixViewerSecurityToken };
            SessionManager.Instance.AddUserSession(vixViewerSecurityToken, userId, currentUser, hostAddress);
        }

        private static void CheckExpirationDate(X509Certificate certification)
        {
            if (!BypassCertificateDateCheck)
            {
                var certDate = System.Convert.ToDateTime(certification.GetExpirationDateString());
                if (System.DateTime.UtcNow >= certDate)
                    throw new Hydra.Common.Exceptions.BadRequestException("Client certificate has expired.");
            }
        }

        /// <summary>
        /// Get a valid URL, which is only for this server, to deter hackers
        /// </summary>
        /// <param name="url">The potential URL</param>
        /// <returns>The URL if it is safe, otherwise an empty string</returns>
        /// <remarks>Originally written for VAI-760.</remarks>
        public static string GetValidUrl(string url)
        {
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Validating a URL.", "url", url);

            var url1a = "https://localhost:";
            var url1b = "http://localhost:";
            string myFqdn = Util.GetFqdn();
            var url2a = $"https://{myFqdn}:".ToLower();
            var url2b = $"http://{myFqdn}:".ToLower();
            string lcUrl = url.ToLower();
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Seeing if.lowercase URL starts with any of these.", "url1a", url1a, "url1b", url1b, "url2a", url2a, "url2b", url2b);
            if (lcUrl.StartsWith(url1a) || lcUrl.StartsWith(url1b) || lcUrl.StartsWith(url2a) || lcUrl.StartsWith(url2b))
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Yes, valid.");
                return url;
            }
            else
            {
                //VAI-1384: We might be running through a load balancer
                string lcUrlPrefix = lcUrl;
                string pre1 = "http://";
                string pre2 = "https://";
                if (lcUrl.StartsWith(pre1)) lcUrlPrefix = lcUrl.Substring(pre1.Length);
                if (lcUrl.StartsWith(pre2)) lcUrlPrefix = lcUrl.Substring(pre2.Length);
                int i = lcUrlPrefix.IndexOf("/");
                if (i > 0) lcUrlPrefix = lcUrlPrefix.Substring(0, i);
                i = lcUrlPrefix.IndexOf(":");
                if (i > 0) lcUrlPrefix = lcUrlPrefix.Substring(0, i);
                string suffix = ".va.gov";
                if ((lcUrlPrefix.Length >= suffix.Length) && lcUrlPrefix.EndsWith(suffix))
                {
                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Yes, valid.");
                    return url;
                }
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("No, invalid.");
                return "";
            }
        }
    }
}
