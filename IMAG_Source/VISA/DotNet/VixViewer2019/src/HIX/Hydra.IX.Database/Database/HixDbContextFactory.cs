using Hydra.IX.Database.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database
{
    public class HixDbContextFactory : IHixDbContextFactory
    {
        public static string ConnectionString { get; set; }
        public static int CommandTimeout { get; set; }

        public IHixDbContext Create()
        {
            return new HixDbContext(ConnectionString, CommandTimeout);
        }

        public static void SetDbContextInitializer()
        {
            HixDbContext.SetInitializeNoCreate();
        }
    }
}
