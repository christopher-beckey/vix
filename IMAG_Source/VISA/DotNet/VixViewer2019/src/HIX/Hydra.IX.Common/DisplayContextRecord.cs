using System.Collections.Generic;

namespace Hydra.IX.Common
{
    /// <summary>
    /// Basic display context information
    /// </summary>
    public class DisplayContextRecord
    {
        public string GroupUid { get; set; }
        public string ContextId { get; set; }
        public string Name { get; set; }
        public int ImageCount { get; set; }
        public IEnumerable<DisplayContextRecord> Children { get; set; }
    }
}