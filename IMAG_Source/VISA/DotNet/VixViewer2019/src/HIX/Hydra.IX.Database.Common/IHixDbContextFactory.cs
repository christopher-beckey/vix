using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public interface IHixDbContextFactory
    {
        IHixDbContext Create();
    }
}
