// -----------------------------------------------------------------------
// <copyright file="PatientSensitiveValueType.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Jul 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Store patient sensitive level with vix
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

namespace VistA.Imaging.Telepathology.Common.VixModels
{
    using System.ComponentModel;
    using System.Xml.Serialization;

    public enum MagSensitiveLevel
    {
        DATASOURCE_FAILURE,
        NO_ACTION_REQUIRED,
        DISPLAY_WARNING,
        DISPLAY_WARNING_REQUIRE_OK,
        DISPLAY_WARNING_CANNOT_CONTINUE,
        ACCESS_DENIED
    }

    /// <summary>
    /// Store the patient sensitive level and message
    /// </summary>
    [XmlRoot("patientSensitiveValueType")]
    public class PatientSensitiveValueType : INotifyPropertyChanged
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="PatientSensitiveValueType"/> class
        /// </summary>
        public PatientSensitiveValueType()
        {
            this.SensitiveLevel = MagSensitiveLevel.NO_ACTION_REQUIRED;
            this.WarningMessage = string.Empty;
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

        /// <summary>
        /// Gets or sets the sensitive level of the patient
        /// </summary>
        [XmlElement("sensitiveLevel")]
        //public string SensitiveLevel { get; set; }
        public MagSensitiveLevel SensitiveLevel { get; set; }

        /// <summary>
        /// Gets the code of the sensitive level
        /// </summary>
        [XmlIgnore]
        public int SensitiveCode
        {
            get
            {
                switch (this.SensitiveLevel)
                {
                    case MagSensitiveLevel.DATASOURCE_FAILURE:
                        return -1;
                    case MagSensitiveLevel.NO_ACTION_REQUIRED:
                        return 0;
                    case MagSensitiveLevel.DISPLAY_WARNING:
                        return 1;
                    case MagSensitiveLevel.DISPLAY_WARNING_REQUIRE_OK:
                        return 2;
                    case MagSensitiveLevel.DISPLAY_WARNING_CANNOT_CONTINUE:
                        return 3;
                    case MagSensitiveLevel.ACCESS_DENIED:
                        return 4;
                    default:
                        return 0;
                }
            }
        }

        /// <summary>
        /// Gets or sets the warning message
        /// </summary>
        [XmlElement("warningMessage")]
        public string WarningMessage { get; set; }
    }
}
