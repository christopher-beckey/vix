namespace Hydra.IX.Common
{
    public class NewImageGroupRequest
    {
        public string ParentGroupUid { get; set; }
        public string Name { get; set; }
        public string Tag { get; set; }
        public string RequestedImageGroupUid { get; set; }
    }
}