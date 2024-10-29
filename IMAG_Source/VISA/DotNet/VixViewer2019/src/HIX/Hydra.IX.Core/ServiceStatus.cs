using Hydra.IX.Configuration;
using Hydra.IX.Storage;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Core
{
    public class ServiceStatus
    {
        public static IDictionary<string, string> Get(Func<string> getUrl)
        {
            var dict = new Dictionary<string, string>();

            // root url
            dict["RENDER.RootUrl"] = getUrl();
            
            // database
            dict["RENDER.Database"] = HixConfigurationSection.Instance.Database.DataSource;

            // cache
            dict["RENDER.ImageStorePath"] = HixConfigurationSection.Instance.ImageStores.Path;
            dict["RENDER.CacheSizeMB"] = Math.Ceiling(StorageManager.Instance.GetDirectorySize(StorageManager.Instance.CacheImageStore)).ToString();
            dict["RENDER.DiskFreeSpaceMB"] = Math.Ceiling(StorageManager.Instance.GetDiskFreeSpaceMB()).ToString();

            return dict;
        }
    }
}
