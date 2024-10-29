namespace Hydra.Common.Entities
{
    public class PresentationState
    {
        public string Id { get; set; }
        public string ImageId { get; set; }
        public string FrameNumber { get; set; }
        public GraphicObject[] Objects { get; set; }
        public GraphicLayer[] Layers { get; set; }
    }
}