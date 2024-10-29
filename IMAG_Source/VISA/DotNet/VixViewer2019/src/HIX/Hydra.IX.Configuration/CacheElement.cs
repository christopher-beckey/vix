using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Configuration
{
    [ConfigurationCollection(typeof(PeriodElement))]
    public class CacheElement : ConfigurationElementCollection
    {
        internal const string PropertyName = "Period";

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
            return new PeriodElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((PeriodElement)(element)).Id;
        }

        public PeriodElement this[int idx]
        {
            get { return (PeriodElement)BaseGet(idx); }
        }

    }
}
