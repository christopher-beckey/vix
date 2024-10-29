namespace Hydra.IX.Common
{
    public class PreferenceRequest
    {
        public string Application { get; set; }
        public string Scope { get; set; }
        public string Context { get; set; }
        public string Key { get; set; }
    }
}