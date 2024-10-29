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
    /// <summary>
    /// The patient sensitive levels.
    /// </summary>
    public class PatientSensitiveLevels
    {
        #region Constants and Fields

        /// <summary>
        /// The access denied.
        /// </summary>
        public const string AccessDenied = "ACCESS_DENIED";

        /// <summary>
        /// The data source failure.
        /// </summary>
        public const string DataSourceFailure = "DATASOURCE_FAILURE";

        /// <summary>
        /// The display warning.
        /// </summary>
        public const string DisplayWarning = "DISPLAY_WARNING";

        /// <summary>
        /// The display warning cannot continue.
        /// </summary>
        public const string DisplayWarningCannotContinue = "DISPLAY_WARNING_CANNOT_CONTINUE";

        /// <summary>
        /// The display warning require ok.
        /// </summary>
        public const string DisplayWarningRequireOk = "DISPLAY_WARNING_REQUIRE_OK";

        /// <summary>
        /// The no action required.
        /// </summary>
        public const string NoActionRequired = "NO_ACTION_REQUIRED";

        #endregion
    }
}