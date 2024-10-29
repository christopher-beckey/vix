using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Common
{
    [ConfigurationCollection(typeof(SecureElement))]
    public class SecureElementCollection : ConfigurationElementCollection
    {
        internal const string PropertyName = "SecureElement";

        public override ConfigurationElementCollectionType CollectionType
        {
            get
            {
                return ConfigurationElementCollectionType.BasicMapAlternate;
            }
        }

        protected override string ElementName
        {
            get
            {
                return PropertyName;
            }
        }

        protected override bool IsElementName(string elementName)
        {
            return elementName.Equals(PropertyName,
              StringComparison.InvariantCultureIgnoreCase);
        }

        public override bool IsReadOnly()
        {
            return false;
        }

        protected override ConfigurationElement CreateNewElement()
        {
            return new SecureElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((SecureElement)(element)).Name;
        }

        public SecureElement this[int idx]
        {
            get { return (SecureElement)BaseGet(idx); }
        }

        public SecureElement this[string key]
        {
            get 
            { 
                // case insensitive search
                SecureElement item = null;
                for (int i = 0; i < Count; i++)
                {
                    item = (SecureElement) BaseGet(i);
                    if (string.Compare(item.Name, key, true) == 0)
                        return item;
                }

                return null;
            }
        }

        public void SetProperties(object target)
        {
            Type type = target.GetType();

            for (int i = 0; i < Count; i++)
            {
                SecureElement item = (SecureElement)BaseGet(i);
                PropertyInfo propInfo = type.GetProperty(item.Name, BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.Instance);
                if (propInfo == null)
                    continue;

                propInfo.SetValue(target, item.Value);
            }
        }
    }
}
