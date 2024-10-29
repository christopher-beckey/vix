using System.Collections.Generic;

namespace Hydra.Entities
{
    public class Measurement
    {
        public PixelSpacing PixelSpacing { get; set; }

        public List<USRegion> UsRegions { get; set; }
    }
}