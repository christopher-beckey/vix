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

using DicomImporter.Common.Services;

namespace DicomImporter.Views
{
    using System;
    using System.Windows;
    using System.Windows.Controls;
    using System.Windows.Documents;
    using System.Windows.Media;
    using System.Windows.Threading;

    using ImagingClient.Infrastructure.Views;

    using Microsoft.Win32;
    using ImagingClient.Infrastructure.DialogService;

    /// <summary>
    /// Provides a way of launching modal dialogs in MVVM
    /// </summary>
    public class ImporterDialogService : IImporterDialogService
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
        public bool ConfirmWorkItemDelete(Dispatcher uiDispatcher, int fileCount, string stagingRootPath)
        {
            if (fileCount > 0)
            {
                bool returnValue = false;
                Action action = () =>
                {
                    DeleteWithRemainingFilesWindow window = new DeleteWithRemainingFilesWindow(fileCount, stagingRootPath);
                    window.SubscribeToNewUserLogin();
                    window.ShowDialog();
                    window.Owner = Application.Current.MainWindow;
                    returnValue = window.IsDeleteRequested;
                };

                uiDispatcher.Invoke(DispatcherPriority.Normal, action);

                return returnValue;
            }
            else
            {
                bool returnValue = false;
           
                Action action = () =>
                {
                    var window = new ImagingClient.Infrastructure.Views.MessageBox("Are you sure you want to delete this importer item?",
                                                                                   "Confirm Delete", MessageTypes.Question);
                    window.SubscribeToNewUserLogin();
                    window.ShowDialog();

                    returnValue = this.ConvertResultToBoolean(window.GetUserResponse());
                };

                uiDispatcher.Invoke(DispatcherPriority.Normal, action);

                return returnValue;
            }
        }

        /// <summary>
        /// Opens a modal dialog asking the user to select service with OK/Cancel confirmation
        /// </summary>
        /// <param name="service">
        /// The user service selection
        /// </param>
        /// <returns>
        /// A value indicating if the user selected OK or Cancel
        /// </returns>
        public bool SelectService(Dispatcher uiDispatcher, out string service)
        {
            bool returnValue = false;
            service = string.Empty;
            string selectedService = string.Empty;
            Action action = () =>
            {
                SelectServiceWindow window = new SelectServiceWindow();
                window.ShowDialog();
                window.Owner = Application.Current.MainWindow;
                returnValue = window.IsServiceSelected;
                selectedService = returnValue ? window.getService() : string.Empty;
            };

            uiDispatcher.Invoke(DispatcherPriority.Normal, action);

            service = selectedService;
            return returnValue;
        }

        #endregion

        #region Methods

        /// <summary>
        /// Converts a MessageBoxResult to a boolean
        /// </summary>
        /// <param name="result">
        /// The result of the MessageBox
        /// </param>
        /// <returns>
        /// False for No, None, and Cancel.  True for all others.
        /// </returns>
        private bool ConvertResultToBoolean(MessageBoxResult result)
        {
            if (result.Equals(MessageBoxResult.No) || result.Equals(MessageBoxResult.None)
                || result.Equals(MessageBoxResult.Cancel))
            {
                return false;
            }

            // If it wasn't of the "no-equivalents", default to true
            return true;
        }

        #endregion

    }
}