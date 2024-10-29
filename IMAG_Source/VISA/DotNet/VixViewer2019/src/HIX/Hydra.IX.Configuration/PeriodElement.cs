using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Configuration
{
    public class PeriodElement : ConfigurationElement
    {
        [ConfigurationProperty("Id", IsRequired = true, IsKey = true)]
        public int Id
        {
            get { return (int)base["Id"]; }
        }

        [ConfigurationProperty("Time", IsRequired = true)]
        public string Time
        {
            get { return (string)base["Time"]; }
        }
    }
}
