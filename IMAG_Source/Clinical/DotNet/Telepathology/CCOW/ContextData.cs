/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 4/11/2012
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Paul Pentapaty
 * Description: 
 * 
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *       
 * 
 */

namespace VistA.Imaging.Telepathology.CCOW
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using VERGENCECONTEXTORLib;
    using VistA.Imaging.Telepathology.Common.Model;

    public class ContextData
    {
        private Dictionary<string, string> Map = new Dictionary<string, string>();

        const string PatientDFNNameFormat = "patient.id.mrn.dfn_{0}{1}";

        const string PatientICNNameFormat = "patient.id.mrn.nationalidnumber{0}";

        public ContextData()
        {
        }

        public ContextData(IContextItemCollection contextItemCollection)
        {
            this.SetContextCollection(contextItemCollection);
        }

        public ContextData(Patient patient)
        {
            Map[PatientDFNName] = patient.LocalDFN;
            Map[PatientICNName] = patient.PatientICN;
        }

        private string PatientDFNName
        {
            get
            {
                return string.Format(PatientDFNNameFormat, 
                                     UserContext.LocalSite.SiteStationNumber,
                                     UserContext.LocalSite.IsProductionAccount? "" : "_test");
            }
        }

        private string PatientICNName
        {
            get
            {
                return string.Format(PatientICNNameFormat,
                                     UserContext.LocalSite.IsProductionAccount ? "" : "_test");
            }
        }

        public void SetContextCollection(IContextItemCollection contextItemCollection)
        {
            this.Clear();

            for (int i = 1; i <= contextItemCollection.Count(); i++)
            {
                ContextItem item = contextItemCollection.Item(i);

                Console.WriteLine("Name: " + item.Name);
                Console.WriteLine("Prefix: " + item.Prefix);
                Console.WriteLine("Role: " + item.Role);
                Console.WriteLine("Subject: " + item.Subject);
                Console.WriteLine("Suffix: " + item.Suffix);
                Console.WriteLine("Value: " + item.Value);

                Map[item.Name] = item.Value;
            }
        }

        public ContextItemCollection GetContextCollection()
        {
            ContextItemCollection contextItemCollection = new ContextItemCollection();

            foreach (KeyValuePair<string, string> pair in this.Map)
            {
                ContextItem item = new ContextItem();
                item.Name = pair.Key;
                item.Value = pair.Value;

                contextItemCollection.Add(item);
            }

            return contextItemCollection;
        }

        public string GetValue(string name)
        {
            return this.Map.ContainsKey(name) ? this.Map[name] : null;
        }

        public bool IsEqual(ContextData contextData)
        {
            // match only patient DFNs for now
            string itemName = PatientDFNName;

            string value1 = this.GetValue(itemName);
            string value2 = contextData.GetValue(itemName);

            if (string.IsNullOrEmpty(value1) || string.IsNullOrEmpty(value2))
            {
                return false;
            }

            //// for now, partial match is OK.
            //if ((value1.StartsWith(value2)) || (value2.StartsWith(value1)))
            //{
            //    return true;
            //}

            return (string.Compare(value1, value2, true) == 0);
        }

        public void Clear()
        {
            this.Map.Clear();
        }
    }
}
