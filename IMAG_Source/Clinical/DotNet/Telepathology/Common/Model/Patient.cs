// -----------------------------------------------------------------------
// <copyright file="Patient.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Jan 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Paul Pentapaty, Duc Nguyen
//  Description: Patient's information
//        ;; +--------------------------------------------------------------------+
//        ;; Property of the US Government.
//        ;; No permission to copy or redistribute this software is given.
//        ;; Use of unreleased versions of this software requires the user
//        ;;  to execute a written test agreement with the VistA Imaging
//        ;;  Development Office of the Department of Veterans Affairs,
//        ;;  telephone (301) 734-0100.
//        ;;
//        ;; The Food and Drug Administration classifies this software as
//        ;; a Class II medical device.  As such, it may not be changed
//        ;; in any way.  Modifications to this software may result in an
//        ;; adulterated medical device under 21CFR820, the use of which
//        ;; is considered to be a violation of US Federal Statutes.
//        ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Common.Model
{
    using System;
    using System.ComponentModel;
    using System.Xml.Serialization;

    /// <summary>
    /// Patient model
    /// </summary>
    [XmlRoot("pathologyPatientType")]
    public class Patient : INotifyPropertyChanged
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="Patient"/> class
        /// </summary>
        public Patient()
        {
            this.PatientICN = string.Empty;
            this.Sex = string.Empty;
            this.DOB = string.Empty;
            this.PatientName = string.Empty;
        }
        
        /// <remarks>
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </remarks>
        /// <summary>
        /// Event to be raised when a property is changed
        /// </summary>
#pragma warning disable 0067
        // Warning disabled because the event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 0067

        //public string PatientDFN { get; set; }

        /// <summary>
        /// Gets or sets the national unique identifier for the patient
        /// </summary>
        [XmlElement("patientIcn")]
        public string PatientICN { get; set; }

        /// <summary>
        /// Gets or sets the DFN for the patient. to be used if ICN is not available
        /// </summary>
        [XmlElement("patientDfn")]
        public string PatientDFN { get; set; }

        /// <summary>
        /// Gets or sets the local DFN for the patient
        /// </summary>
        public string LocalDFN { get; set; }

        /// <summary>
        /// Gets or sets patient's name
        /// </summary>
        [XmlElement("patientName")]
        public string PatientName { get; set; }

        [XmlIgnore]
        public string PatientShortID { get; set; }

        [XmlIgnore]
        public bool PatientSensitive { get; set; }

        /// <summary>
        /// Gets or sets patient's sex
        /// </summary>
        [XmlElement("patientSex")]
        public string Sex { get; set; }

        /// <summary>
        /// Gets or sets patient's dob
        /// </summary>
        [XmlElement("dob")]
        public string DOB { get; set; }

        /// <summary>
        /// Gets the patient's age
        /// </summary>
        [XmlIgnore]
        public string Age
        {
            get
            {
                if (!string.IsNullOrEmpty(this.DOB))
                {
                    DateTime birthday;
                    if (DateTime.TryParse(this.DOB, out birthday))
                    {
                        int age = DateTime.Today.Year - birthday.Year;
                        if (birthday > DateTime.Today.AddYears(-age))
                        {
                            age--;
                        }
                        return age.ToString();
                    }
                }

                return string.Empty;
            }
        }
    }
}
