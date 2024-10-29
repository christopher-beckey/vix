namespace Hydra.Entities
{
    public class Overlay
    {
        public int FrameIndex { get; set; }
        public int OverlayIndex { get; set; }
        public string Label { get; set; }
        public string Description { get; set; }
        public int Rows { get; set; }
        public int Columns { get; set; }
        public int BitDepth { get; set; }
    }
}