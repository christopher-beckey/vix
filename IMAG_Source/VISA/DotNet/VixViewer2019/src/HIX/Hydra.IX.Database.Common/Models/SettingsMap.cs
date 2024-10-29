using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class SettingsMap
    {
        public int Id { get; set; }
        public int SettingRecord_Id { get; set; }
        public int UserRecord_Id { get; set; }
        public string Value { get; set; }
    }
}
