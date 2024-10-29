namespace DicomImporter.Common.Model
{
    public class UserPreference
    {
        public string Source { get; set; }
        public string Service { get; set; }
        public string Modality { get; set; }
        public string Procedure { get; set; }
        public string MaxRows { get; set; }
        public string RowOrder { get; set; }
        public string WorkItemSubtype { get; set; }
        public string PatientName { get; set; }
        public string DateRangeType { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
    }
}