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
namespace VistaCommon
{
    using System.Collections.Generic;

    /// <summary>
    /// The patient.
    /// </summary>
    public class Patient
    {
        #region Constants and Fields

        /// <summary>
        /// might want to remove this...
        /// </summary>
        private List<Site> visitedSites = new List<Site>();

        #endregion

        #region Constructors and Destructors

        public Patient() { }

        /// <summary>
        /// Initializes a new instance of the <see cref="Patient"/> class.
        /// </summary>
        /// <param name="patientIcn">
        /// The patient icn.
        /// </param>
        /// <param name="patientName">
        /// The patient name.
        /// </param>
        public Patient(string patientIcn, string patientName)
        {
            this.PatientIcn = patientIcn;
            this.PatientName = patientName;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Patient"/> class.
        /// </summary>
        /// <param name="patientIcn">
        /// The patient icn.
        /// </param>
        public Patient(string patientIcn)
            : this(patientIcn, string.Empty)
        {
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets DateOfBirth.
        /// </summary>
        public string DateOfBirth { get; set; }

        /// <summary>
        /// Gets or sets the local DFN for the patient
        /// </summary>
        public string LocalDFN { get; set; }

        /// <summary>
        /// Gets PatientIcn.
        /// </summary>
        public string PatientIcn { get; set; }

        /// <summary>
        /// Gets or sets PatientName.
        /// </summary>
        public string PatientName { get; set; }

        /// <summary>
        /// Gets or sets PatientSex.
        /// </summary>
        public string PatientSex { get; set; }

        /// <summary>
        /// Gets or sets VeteranStatus.
        /// </summary>
        public string VeteranStatus { get; set; }

        /// <summary>
        /// Gets VisitedSites.
        /// </summary>
        public List<Site> VisitedSites
        {
            get
            {
                return this.visitedSites;
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Returns a <see cref="System.String"/> that represents this instance.
        /// </summary>
        /// <returns>
        /// A <see cref="System.String"/> that represents this instance.
        /// </returns>
        public override string ToString()
        {
            return this.PatientName;
        }

        #endregion
    }
}