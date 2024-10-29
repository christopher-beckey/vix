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
namespace DicomImporter.Common.Exceptions
{
    /// <summary>
    /// Constants representing known error codes that may be returned from 
    /// Importer REST calls. Allows for creation of a specific exception
    /// on the client side, mirroring the exception on the server side.
    /// </summary>
    public class ImporterErrorCodes
    {
        /// <summary>
        /// Standard Internal Server error code from HTML spec
        /// </summary>
        public const int InternalServerErrorCode = 500;
        
        /// <summary>
        /// Error code returned from REST service specifying that the
        /// specified work item was not found.
        /// </summary>
        public const int WorkItemNotFoundErrorCode = 1000;

        /// <summary>
        /// Error code returned from REST service specifying that the
        /// specified work item was not in the expected status
        /// </summary>
        public const int InvalidWorkItemStatusErrorCode = 1001;
        
        /// <summary>
        /// Error code returned from REST service specifying that the
        /// outside location is not configured
        /// </summary>
        public const int OutsideLocationConfigurationErrorCode = 2000;
    }
}