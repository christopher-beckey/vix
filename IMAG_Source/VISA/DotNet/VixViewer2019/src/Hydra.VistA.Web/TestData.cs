using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Web
{
    public class HeaderData
    {
        public string[] Names { get; set; }
        public string[] Values { get; set; }
    }

    public class QueryData
    {
        public string PatientName { get; set; }
        public string PatientICN { get; set; }
        public string ContextId { get; set; }
        public string Comment { get; set; }
        public string Url { get; set; }
        public string Content { get; set; }
    }

    public class SearchParam
    {
        public string DateRange { get; set; }
        public string CapturedBy { get; set; }
        public string Status { get; set; }
        public string Percentage { get; set; }
        public string MaxNumber { get; set; }
        public string FilterBy { get; set; }
    }

    public class QATestData
    {
        public List<SearchParam> SearchParams { get; set; }
    }

    public class TestData
    {
        public HeaderData HeaderData { get; set;  }
        public QueryData QueryData { get; set; } 
    }
}
