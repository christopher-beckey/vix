namespace Hydra.Common
{
    public class Grid
    {
        public int Rows { get; set; }
        public int Columns { get; set; }
        public int? Row { get; set; }
        public int? Column { get; set; }
        public Grid[] Children { get; set; }
    }
}