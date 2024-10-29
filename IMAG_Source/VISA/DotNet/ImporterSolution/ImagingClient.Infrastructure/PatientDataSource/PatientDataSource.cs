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
namespace ImagingClient.Infrastructure.PatientDataSource
{
    using System.Collections.ObjectModel;

    using ImagingClient.Infrastructure.Model;
    using ImagingClient.Infrastructure.Rest;

    /// <summary>
    /// The patient data source.
    /// </summary>
    public class PatientDataSource : IPatientDataSource
    {
        #region Constants and Fields

        /// <summary>
        /// The patient service url.
        /// </summary>
        private string patientServiceUrl = "PatientWebApp";

        #endregion

        #region Public Methods

        /// <summary>
        /// Gets a collection of patients.
        /// </summary>
        /// <param name="searchCriteria">
        /// The search criteria.
        /// </param>
        /// <returns>
        /// A collection of patients
        /// </returns>
        public ObservableCollection<Patient> GetPatientList(string searchCriteria)
        {
            // Handle null string...
            searchCriteria += string.Empty;

            string resourcePath = string.Format("patient/getPatientList?searchCriteria={0}", searchCriteria.ToUpper());
            return RestUtils.DoGetObject<ObservableCollection<Patient>>(this.patientServiceUrl, resourcePath);
        }

        /// <summary>
        /// Gets the patient's sensitivity level.
        /// </summary>
        /// <param name="patientDfn">
        /// The patient icn.
        /// </param>
        /// <returns>
        /// The patient's sensitivity level
        /// </returns>
        public PatientSensitiveLevel GetPatientSensitivityLevel(string patientDfn)
        {
            string resourcePath = string.Format("patient/getPatientSensitivityLevelByDfn?patientDfn={0}", patientDfn);
            return RestUtils.DoGetObject<PatientSensitiveLevel>(this.patientServiceUrl, resourcePath);
        }


        /// <summary>
        /// Logs sensitive patient access.
        /// </summary>
        /// <param name="patientDfn">
        /// The patient Dfn.
        /// </param>
        public void LogSensitivePatientAccess(string patientDfn)
        {
            string resourcePath = string.Format("patient/logSensitivePatientAccessByDfn?patientDfn={0}", patientDfn);
            RestUtils.DoGetString(this.patientServiceUrl, resourcePath);
        }

        #endregion
    }
}