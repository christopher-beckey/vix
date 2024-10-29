using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;

namespace Hydra.VistA.Parsers
{
    public static class PatientInformationParser
    {
        public static Hydra.Entities.Patient Parse(string text)
        {
            if (string.IsNullOrEmpty(text))
                return null;

            var patient = new Hydra.Entities.Patient();

            XDocument doc = XDocument.Parse(text);
            patient.DFN = doc.XPathGetText(@"patientType/dfn");
            patient.ICN = doc.XPathGetText(@"patientType/patientIcn");
            patient.dob = doc.XPathGetText(@"patientType/dob");
            patient.Sex = doc.XPathGetText(@"patientType/patientSex");
            patient.FullName = doc.XPathGetText(@"patientType/patientName");
            patient.Age = "";

            // use SSN for patient id
            var ssn = doc.XPathGetText(@"patientType/ssn");
            if (!string.IsNullOrEmpty(ssn))
                patient.ICN = ssn; 

            return patient;
        }

        //private static bool ParseDateTime(string text, out DateTime dateTime, out int age)
        //{
        //    dateTime = DateTime.MaxValue;
        //    age = 0;

        //    try
        //    {
        //        if (!string.IsNullOrEmpty(text) && (text.Length == 25))
        //            return false;

        //        dateTime = new DateTime(int.Parse(text.Substring(0, 4)),
        //                                int.Parse(text.Substring(5, 2)),
        //                                int.Parse(text.Substring(8, 2)),
        //                                int.Parse(text.Substring(11, 2)),
        //                                int.Parse(text.Substring(14, 2)),
        //                                int.Parse(text.Substring(17, 2)));
        //        var timeOffset = new TimeSpan(int.Parse(text.Substring(19, 3)), int.Parse(text.Substring(23, 2)), 0);
        //        var birthdate = new DateTimeOffset(dateTime, timeOffset).LocalDateTime;

        //        // calculate years
        //        var today = DateTime.Today;
        //        age = today.Year - birthdate.Year;
        //        if (birthdate > today.AddYears(-age)) age--;

        //        return true;
        //    }
        //    catch (Exception)
        //    {
        //        return false;
        //    }
        //}
    }
}
