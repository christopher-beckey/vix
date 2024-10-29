using Hydra.IX.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Configuration
{
    public class ImageStoreElement : ConfigurationElement
    {
        public const int DefaultFolderLevels = 6;

        [ConfigurationProperty("Id", IsRequired = true, IsKey = true)]
        public int Id 
        {
            get { return (int)base["Id"]; }
        }

        [ConfigurationProperty("Type", IsRequired = true, DefaultValue = ImageStoreType.Primary)]
        public ImageStoreType Type
        {
            get { return (ImageStoreType)base["Type"]; }
        }

        [ConfigurationProperty("Path", IsRequired = true)]
        public string Path
        {
            get { return (string)base["Path"]; }
        }

        [ConfigurationProperty("IsLocal", DefaultValue = true)]
        public bool IsLocal
        {
            get { return (bool)base["IsLocal"]; }
        }

        [ConfigurationProperty("IsEnabled", IsRequired = false, DefaultValue = true)]
        public bool IsEnabled
        {
            get { return (bool)base["IsEnabled"]; }
        }

        [ConfigurationProperty("AutoCreate", DefaultValue = true)]
        public bool AutoCreate
        {
            get { return (bool)base["AutoCreate"]; }
        }

        [ConfigurationProperty("FolderLevels", IsRequired = false, DefaultValue = DefaultFolderLevels)]
        public int FolderLevels
        {
            get { return (int)base["FolderLevels"]; }
        }

        [ConfigurationProperty("IsEncrypted", DefaultValue = false)]
        public bool IsEncrypted
        {
            get { return (bool)base["IsEncrypted"]; }
        }

        [ConfigurationProperty("SourceId", IsRequired = false)]
        public int SourceId
        {
            get { return (int)base["SourceId"]; }
        }

        [ConfigurationProperty("SearchOrder", IsRequired = false)]
        public int SearchOrder
        {
            get { return (int)base["SearchOrder"]; }
        }

        [ConfigurationProperty("SecureElements")]
        public SecureElementCollection SecureElements
        {
            get
            {
                return ((SecureElementCollection)(base["SecureElements"]));
            }

            set
            {
                base["SecureElements"] = value;
            }
        }

        [ConfigurationProperty("DiskFullThreshold", DefaultValue = 2048)]
        public int DiskFullThreshold
        {
            get { return (int)base["DiskFullThreshold"]; }
        }
    }
}
