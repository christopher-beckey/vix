using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    [ConfigurationCollection(typeof(VixServiceElement))]
    public class VixServiceCollection : ConfigurationElementCollection
    {
        internal const string PropertyName = "VixService";

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
            return new VixServiceElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((VixServiceElement)(element)).ServiceType;
        }

        public VixServiceElement this[int idx]
        {
            get { return (VixServiceElement)BaseGet(idx); }
        }
    }
}
