using System.Collections.Generic;

namespace Hydra.Entities
{
    public class MeasurementType
    {
        public string Label { get; set; }

        public string Id { get; set; }

        public int Type { get; set; } // 0:length, 1:point

        public int Axis { get; set; } // 0:X, 1:Y

        public List<MeasurementType> Items { get; set; }
    }
}