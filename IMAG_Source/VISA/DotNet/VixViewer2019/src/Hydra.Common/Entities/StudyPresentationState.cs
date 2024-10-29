namespace Hydra.Common.Entities
{
    public class StudyPresentationState
    {
        public string Id { get; set; }
        public string Description { get; set; }
        public string DateTime { get; set; }
        public bool IsPrivate { get; set; }
        public bool IsEditable { get; set; }
        public string Data { get; set; }
        public string UserId { get; set; }
        public string UserDetails { get; set; }
        public string ContextId { get; set; }
        public bool IsExternal { get; set; }
        public string Source { get; set; }
        public string Tooltip { get; set; }
    }
}