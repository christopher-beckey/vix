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
namespace DicomImporter.Common.Model
{
    using System;

    /// <summary>
    /// The importer work item statuses.
    /// </summary>
    [Serializable]
    public class ImporterWorkItemStatuses
    {
        #region Constants and Fields

        /// <summary>
        /// The "cancelled direct import staging" status.
        /// </summary>
        public const string CancelledDirectImportStaging = "CancelledDirectImportStaging";

        /// <summary>
        /// The "cancelled staging" status.
        /// </summary>
        public const string CancelledStaging = "CancelledStaging";

        /// <summary>
        /// The "failed direct import staging" status.
        /// </summary>
        public const string FailedDirectImportStaging = "FailedDirectImportStaging";

        /// <summary>
        /// The "failed import" status.
        /// </summary>
        public const string FailedImport = "FailedImport";

        /// <summary>
        /// The "failed staging" status.
        /// </summary>
        public const string FailedStaging = "FailedStaging";

        /// <summary>
        /// The "import complete" status.
        /// </summary>
        public const string ImportComplete = "ImportComplete";

        /// <summary>
        /// The "importing" status.
        /// </summary>
        public const string Importing = "Importing";

        /// <summary>
        /// The "in reconciliation" status.
        /// </summary>
        public const string InReconciliation = "InReconciliation";

        /// <summary>
        /// The "new" status.
        /// </summary>
        public const string New = "New";

        /// <summary>
        /// The "ready for import" status.
        /// </summary>
        public const string ReadyForImport = "ReadyForImport";

        #endregion
    }
}