using System.Configuration;
using Hydra.IX.Common;
using Hydra.Security;

namespace Hydra.VistA
{
    public class VistAConfigurationSection : ConfigurationSection
    {
        private static VistAConfigurationSection _instance = null;
        private static object _syncLock = new object();

        //[ConfigurationProperty("ViewerRootPath", DefaultValue = "vix/viewer")]
        //public string ViewerRootPath
        //{
        //    get { return (string)base["ViewerRootPath"]; }
        //}
        [ConfigurationProperty("VixServices", IsRequired = true)]
        public VixServiceCollection VixServices
        {
            get
            {
                return ((VixServiceCollection)(base["VixServices"]));
            }

            set
            {
                base["VixServices"] = value;
            }
        }

        [ConfigurationProperty("WorkerPoolSize", DefaultValue = 3)]
        public int WorkerPoolSize
        {
            get { return (int)base["WorkerPoolSize"]; }
        }

        [ConfigurationProperty("WorkerPoolStartingPort", DefaultValue = 9700)]
        public int WorkerPoolStartingPort
        {
            get { return (int)base["WorkerPoolStartingPort"]; }
        }

        [ConfigurationProperty("WorkerThreadPoolSize", DefaultValue = 5)]
        public int WorkerThreadPoolSize
        {
            get { return (int)base["WorkerThreadPoolSize"]; }
        }

        [ConfigurationProperty("UtilPwd", DefaultValue = "DEAJpoYRQO3JSDyOO7HXcA==")]
        public string UtilPwd
        {
            get { return (string)base["UtilPwd"]; } //VIX Java password for decrypt/encrypt tool
        }

        [ConfigurationProperty("QueryThreadPoolSize", DefaultValue = 10)]
        public int QueryThreadPoolSize
        {
            get { return (int)base["QueryThreadPoolSize"]; }
        }

        [ConfigurationProperty("WorkerBaseAddress", DefaultValue = "net.pipe://localhost/")]
        public string WorkerBaseAddress
        {
            get { return (string)base["WorkerBaseAddress"]; }
        }

        [ConfigurationProperty("SecurityTokenTimeout", DefaultValue = 30)]
        public int SecurityTokenTimeout
        {
            get { return (int)base["SecurityTokenTimeout"]; }
        }

        [ConfigurationProperty("SecurityTokenTimeoutType", DefaultValue = SecurityTokenTimeoutType.UntilMidnight)]
        public SecurityTokenTimeoutType SecurityTokenTimeoutType
        {
            get { return (SecurityTokenTimeoutType)base["SecurityTokenTimeoutType"]; }
        }

        [ConfigurationProperty("DiagnosticImageQuality", DefaultValue = 0)]
        public int DiagnosticImageQuality
        {
            get { return (int)base["DiagnosticImageQuality"]; }
        }

        public static VistAConfigurationSection Instance
        {
            get
            {
                lock (_syncLock)
                {
                    return _instance;
                }
            }

            set
            {
                lock (_syncLock)
                {
                    _instance = value;
                }
            }
        }

        public static void Initialize(string configFilePath)
        {
            configFilePath = ConfigurationLocator.ResolveConfigFilePath(configFilePath);
            VistAConfigurationSection.Instance = ConfigurationLocator.GetConfigurationSection(configFilePath, "VistA") as VistAConfigurationSection;
            VistAConfigurationSection.Instance.ConfigFilePath = configFilePath;

            SecurityUtil.Encrypt(configFilePath); //VAI-707
        }

        protected override void PostDeserialize()
        {
            base.PostDeserialize();

            if (VixServices != null)
            {
                // check if all services are present

            }
        }

        public VixServiceElement GetVixService(VixServiceType vixServiceType)
        {
            if (VixServices != null)
            {
                for (int i = 0; i < VixServices.Count; i++)
                {
                    if (VixServices[i].ServiceType == vixServiceType)
                        return VixServices[i];
                }
            }

            return null;
        }

        public string ConfigFilePath { get; private set; }

        [ConfigurationProperty("Policies", IsDefaultCollection = false)]
        public NameValueConfigurationCollection PolicySettings
        {
            get
            {
                return (NameValueConfigurationCollection)base["Policies"];
            }
        }

        [ConfigurationProperty("ClientAuthentication", IsRequired = false, IsDefaultCollection = false)]
        public ClientAuthenticationCollection ClientAuthenticationSettings
        {
            get
            {
                return ((ClientAuthenticationCollection)(base["ClientAuthentication"]));
            }

            set
            {
                base["ClientAuthentication"] = value;
            }
        }

        //VAI-707
        [ConfigurationProperty("VixTools", IsDefaultCollection = false)]
        public NameValueConfigurationCollection VixToolSettings => (NameValueConfigurationCollection)base["VixTools"];
    }
}
