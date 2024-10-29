namespace Hydra.Common.Entities
{
    public class GraphicObject
    {
        public string Id { get; set; }
        public string Type { get; set; }
        public int[] Points { get; set; }
        public string Text { get; set; }
        public int GraphicLayerIndex { get; set; }
        public GraphicStyle Style { get; set; }
    }
}