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
namespace DicomImporter.Common.Services
{
    using System;
    using System.Windows.Threading;

    /// <summary>
    /// Provides a way of launching modal dialogs in MVVM
    /// </summary>
    public interface IImporterDialogService
    {
        #region Public Methods

        /// <summary>
        /// Opens a modal dialog asking the user an OK/Cancel question
        /// </summary>
        /// <param name="uiDispatcher">
        /// The UI thread dispatcher
        /// </param>
        /// <param name="fileCount">
        /// The number of DICOM files left in the staging directory
        /// </param>
        /// <param name="stagingRootPath">
        /// The staging directory root path
        /// </param>
        /// <returns>
        /// A value indicating if the user selected OK or Cancel
        /// </returns>
        bool ConfirmWorkItemDelete(Dispatcher uiDispatcher, int fileCount, string stagingRootPath);

        /// <summary>
        /// Opens a modal dialog asking the user to select service with OK/Cancel confirmation
        /// </summary>
        /// <param name="service">
        /// The user service selection
        /// </param>
        /// <returns>
        /// A value indicating if the user selected OK or Cancel
        /// </returns>
        bool SelectService(Dispatcher uiDispatcher, out string service);
        #endregion
    }
}