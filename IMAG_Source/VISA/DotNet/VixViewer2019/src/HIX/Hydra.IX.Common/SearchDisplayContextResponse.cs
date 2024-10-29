namespace Hydra.IX.Common
{
    public class SearchDisplayContextResponse
    {
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int RecordCount { get; set; }
        public int PageCount { get; set; }
        public DisplayContextRecord[] Results { get; set; }
    }
}