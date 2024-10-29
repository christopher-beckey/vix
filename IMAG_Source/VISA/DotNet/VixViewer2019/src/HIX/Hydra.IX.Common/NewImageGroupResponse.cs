namespace Hydra.IX.Common
{
    public class NewImageGroupResponse
    {
        public string GroupUid { get; set; }
        public string ParentGroupUid { get; set; }
        public string Path { get; set; }
        public bool IsProcessed { get; set; }
        public string Name { get; set; }
        public int DbId { get; set; }
    }
}