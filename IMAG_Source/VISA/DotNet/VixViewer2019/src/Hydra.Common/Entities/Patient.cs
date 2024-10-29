namespace Hydra.Entities
{
    public class Patient
    {
        public string FullName { get; set; }

        public string DFN { get; set; }

        public string ICN { get; set; }

        public string SiteNumber { get; set; }

        public string Description { get; set; }

        //public string Id { get; set; }

        public string dob { get; set; }

        public string Age { get; set; }

        public string Sex { get; set; }

        public string DicomDirXml { get; set; }
    }
}