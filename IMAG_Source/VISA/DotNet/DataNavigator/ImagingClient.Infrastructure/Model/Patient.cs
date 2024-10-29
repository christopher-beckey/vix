/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
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
 */


using System;
using System.ComponentModel;
using ImagingClient.Infrastructure.Utilities;

namespace ImagingClient.Infrastructure.Model
{
    [Serializable]
    public class Patient : INotifyPropertyChanged
    {
        // The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
        private String patientName;

        public string PatientIcn { get; set; }
        public string Dfn { get; set; }
        public string Ssn { get; set; }
        public string Dob { get; set; }
        public string VeteranStatus { get; set; }

        private string patientSex = "";
        public string PatientSex
        {
            get
            {
                if (String.IsNullOrEmpty(patientSex))
                {
                    patientSex = "Unknown";
                }
                else if (patientSex.Equals("M", StringComparison.CurrentCultureIgnoreCase) ||
                    patientSex.Equals("Male", StringComparison.CurrentCultureIgnoreCase))
                {
                    patientSex = "Male";
                }
                else if (patientSex.Equals("F", StringComparison.CurrentCultureIgnoreCase) ||
                    patientSex.Equals("Female", StringComparison.CurrentCultureIgnoreCase))
                {
                    patientSex = "Female";
                }
                else
                {
                    patientSex = "Unknown";
                }

                return patientSex;
            }
            set { patientSex = value; }
        }

        public string PatientName
        {
            get
            {
                return StringUtilities.ConvertDicomName(patientName);
            }
            set { patientName = value; }
        }

    }
}
