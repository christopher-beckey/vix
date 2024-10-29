using System;
using System.Collections.Generic;

namespace Hydra.Common.Entities
{
    public enum ReleaseHistoryType
    {
        Release,
        Feature,
        Improvement,
        Bug
    }

    public class ReleaseHistoryItem
    {
        public ReleaseHistoryType Type { get; set; }
        public string Name { get; set; }
        public string Text { get; set; }
        public DateTime? TimeStamp { get; set; }
        public List<ReleaseHistoryItem> Items { get; set; }
    }
}