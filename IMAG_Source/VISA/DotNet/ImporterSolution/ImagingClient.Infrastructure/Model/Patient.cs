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
namespace ImagingClient.Infrastructure.Model
{
    using System;
    using System.ComponentModel;
    using System.Xml.Serialization;

    using ImagingClient.Infrastructure.Utilities;

    /// <summary>
    /// The patient.
    /// </summary>
    [Serializable]
    public class Patient : INotifyPropertyChanged
    {
        // The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        #region Constants and Fields

        /// <summary>
        /// The patient name.
        /// </summary>
        private string patientName;

        /// <summary>
        /// The patient sex.
        /// </summary>
        private string patientSex = string.Empty;

        #endregion

        #region Public Events

        /// <summary>
        /// The property changed.
        /// </summary>
        [field: NonSerialized]//P237 - Critical fix - Avoid  arbitrary code execution vulnerability on or after the deserialization of this class.
        public event PropertyChangedEventHandler PropertyChanged;

        #endregion

        [XmlIgnore] 
        public string Details
        {
            get
            {
                //BEGIN-Fortify Mitigation recommendation for Privacy Violation : Heap inspection.Commenting ssn since code stores sensitive data in an insecure manner, making it possible to extract data via inspecting the heap.(p289-OITCOPondiS)
                string name = PatientName + "     ";
                //string ssn = Ssn.PadRight(15);
                string birthDate = FormattedBirthDate.PadRight(15);
                string sex = PatientSex;
                //return name + ssn + birthDate + sex;
                return name +  birthDate + sex;
                //END
            }
        }

        #region Public Properties

        /// <summary>
        /// Gets or sets Dfn.
        /// </summary>
        public string Dfn { get; set; }

        /// <summary>
        /// Gets or sets Dob.
        /// </summary>
        public string Dob { get; set; }

        /// <summary>
        /// Gets FormattedBirthDate.
        /// </summary>
        [XmlIgnore]
        public string FormattedBirthDate
        {
            get
            {
                return DateTimeUtilities.ReformatDicomDateAsShortDate(this.Dob);
            }
        }

        /// <summary>
        /// Gets or sets PatientIcn.
        /// </summary>
        public string PatientIcn { get; set; }

        /// <summary>
        /// Gets or sets PatientName.
        /// </summary>
        public string PatientName
        {
            get
            {
                return StringUtilities.ConvertDicomName(this.patientName);
            }

            set
            {
                this.patientName = value;
            }
        }

        /// <summary>
        /// Gets or sets PatientSex.
        /// </summary>
        public string PatientSex
        {
            get
            {
                if (string.IsNullOrEmpty(this.patientSex))
                {
                    this.patientSex = "Unknown";
                }
                else if (this.patientSex.Equals("M", StringComparison.CurrentCultureIgnoreCase)
                         || this.patientSex.Equals("Male", StringComparison.CurrentCultureIgnoreCase))
                {
                    this.patientSex = "Male";
                }
                else if (this.patientSex.Equals("F", StringComparison.CurrentCultureIgnoreCase)
                         || this.patientSex.Equals("Female", StringComparison.CurrentCultureIgnoreCase))
                {
                    this.patientSex = "Female";
                }
                else
                {
                    this.patientSex = "Unknown";
                }

                return this.patientSex;
            }

            set
            {
                this.patientSex = value;
            }
        }

        /// <summary>
        /// Gets or sets Ssn.
        /// </summary>
        public string Ssn { get; set; }

        /// <summary>
        /// Gets or sets VeteranStatus.
        /// </summary>
        public string VeteranStatus { get; set; }

        #endregion
    }
}