using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SQLite;
using System.Data.SQLite.EF6;
using System.Data.Entity.Core.Common;

namespace Hydra.IX.Database
{
    public class HixDbConfiguration : DbConfiguration
    {
        public HixDbConfiguration()
        {
            SetProviderFactory("System.Data.SQLite", SQLiteFactory.Instance); //This line causes verify completed in...to print to console in debug mode, probably from within the System.Data.SQLite library
            SetProviderFactory("System.Data.SQLite.EF6", SQLiteProviderFactory.Instance);
            SetProviderServices("System.Data.SQLite", (DbProviderServices)SQLiteProviderFactory.Instance.GetService(typeof(DbProviderServices)));
        }
    }
}
