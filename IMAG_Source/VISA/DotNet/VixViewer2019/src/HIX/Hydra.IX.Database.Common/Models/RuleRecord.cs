using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class RuleRecord
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public int UserId { get; set; }
        public string Scope { get; set; }
        public string ValueType { get; set; }
        public string Value { get; set; }
        public bool IsDefault { get; set; }
    }
}
