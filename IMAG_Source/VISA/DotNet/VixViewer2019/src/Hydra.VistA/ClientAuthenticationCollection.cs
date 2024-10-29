using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    [ConfigurationCollection(typeof(ClientAuthenticationElement))]
    public class ClientAuthenticationCollection : ConfigurationElementCollection
    {
        internal const string PropertyName = "add";

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
            return new ClientAuthenticationElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((ClientAuthenticationElement)(element)).CertificateThumbprints;
        }

        public ClientAuthenticationElement this[int idx]
        {
            get { return (ClientAuthenticationElement)BaseGet(idx); }
        }
    }
}
