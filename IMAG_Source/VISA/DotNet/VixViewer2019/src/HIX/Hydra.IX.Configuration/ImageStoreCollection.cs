using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Configuration
{
    [ConfigurationCollection(typeof(ImageStoreElement))]
    public class ImageStoreCollection : ConfigurationElementCollection
    {
        internal const string PropertyName = "ImageStore";

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
            return new ImageStoreElement();
        }

        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((ImageStoreElement)(element)).Id;
        }

        public ImageStoreElement this[int idx]
        {
            get { return (ImageStoreElement)BaseGet(idx); }
        }

        [ConfigurationProperty("Path", DefaultValue = "")]
        public string Path
        {
            get { return (string)base["Path"]; }
        }

        [ConfigurationProperty("IsLocal", DefaultValue = true)]
        public bool IsLocal
        {
            get { return (bool)base["IsLocal"]; }
        }
    }
}
