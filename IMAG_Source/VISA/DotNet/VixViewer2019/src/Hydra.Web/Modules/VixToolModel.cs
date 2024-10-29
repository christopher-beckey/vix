namespace Hydra.Web.Modules
{
    /// <summary>
    /// Provide a model for tools View.
    /// </summary>
    /// <remarks>Added for VAI-707, but anything can use this.</remarks>
    public class VixToolModel
    {
        public string BaseUrl { get; set; } //VAI-915
        public string BseToken { get; set; }
        public string ToolId { get; set; }
        public string SecurityHandoff { get; set; }
        public string Title { get; set; }
        public string ToolUrl { get; set; }
        public string VixJavaSecurityToken { get; set; }
        public string VixViewerSecurityToken { get; set; }
    }
}
