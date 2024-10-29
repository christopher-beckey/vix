using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class PolicyUtil
    {
        public static bool IsPolicyEnabled(string name, bool defaultValue = false)
        {
            var collection = VistAConfigurationSection.Instance.PolicySettings;
            if (collection == null)
                return defaultValue;

            var value = GetPolicySetting(name, collection);
            if (string.IsNullOrEmpty(value))
                return defaultValue;

            return ((string.Compare(value, "true", true) == 0) || 
                    (string.Compare(value, "yes", true) == 0) ||
                    (string.Compare(value, "enable", true) == 0));
        }

        public static int GetPolicySettingsInt(string name, int defaultValue)
        {
            var collection = VistAConfigurationSection.Instance.PolicySettings;
            if (collection == null)
                return defaultValue;

            var value = GetPolicySetting(name, collection);
            if (!string.IsNullOrEmpty(value))
            {
                int intValue;
                if (int.TryParse(value, out intValue))
                    return intValue;
            }

            return defaultValue;
        }

        public static TimeSpan GetPolicySettingsTimeSpan(string name, TimeSpan defaultValue)
        {
            var collection = VistAConfigurationSection.Instance.PolicySettings;
            if (collection == null)
                return defaultValue;

            var value = GetPolicySetting(name, collection);
            if (!string.IsNullOrEmpty(value))
            {
                double doubleValue;
                if (double.TryParse(value, out doubleValue))
                {
                    return TimeSpan.FromMinutes(doubleValue);
                }
            }

            return defaultValue;
        }

        public static string GetPolicySettingsText(string name, string defaultValue = null)
        {
            var collection = VistAConfigurationSection.Instance.PolicySettings;
            if (collection == null)
                return defaultValue;

            var value = GetPolicySetting(name, collection);
            if (value == null)
                return defaultValue;

            return value;
        }

        private static string GetPolicySetting(string name, NameValueConfigurationCollection collection)
        {
            try
            {
                if (!collection.AllKeys.Any(x => (string.Compare(x, name, true) == 0)))
                    return null;

                return collection[name].Value;
            }
            catch (Exception)
            {
                return null;
            }
        }
    }
}
