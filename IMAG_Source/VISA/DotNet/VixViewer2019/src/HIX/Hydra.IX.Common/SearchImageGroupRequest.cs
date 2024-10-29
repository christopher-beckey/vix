namespace Hydra.IX.Common
{
    public class SearchImageGroupRequest
    {
        public string GroupUid { get; set; }
        public string Name { get; set; }
        public string Tag { get; set; }
        public bool IncludeChildren { get; set; }
        public bool IncludeImages { get; set; }
        public int PageOffset { get; set; }
        public int PageSize { get; set; }
        public string Sort { get; set; }
    }
}