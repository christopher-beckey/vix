namespace Hydra.Common
{
    public class ECGParams
    {
        public int DrawType { get; set; }
        public int GridType { get; set; }
        public int ImageWidth { get; set; }
        public int ImageHeight { get; set; }
        public int GridColor { get; set; }
        public int SignalThickness { get; set; }
        public int Gain { get; set; }
        public string ExtraLeads { get; set; }
    }
}