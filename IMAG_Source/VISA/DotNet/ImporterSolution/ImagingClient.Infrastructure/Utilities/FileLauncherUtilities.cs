/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 11/21/2011
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
namespace ImagingClient.Infrastructure.Utilities
{
    using System;
    using System.Diagnostics;
    using System.IO;
    using System.Windows.Threading;

    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Views;

    /// <summary>
    /// The File Launcher Utiltities
    /// </summary>
    public class FileLauncherUtilities
    {
        #region Constants and Fields

        /// <summary>
        /// The importer user manual.
        /// </summary>
        private const string ImporterUserManual = "MAG_DICOM_Importer_User_Manual.pdf";

        #endregion

        #region Public Methods

        /// <summary>
        /// Views the PDF.
        /// </summary>
        /// <param name="uiDispatcher">The UI dispatcher.</param>
        /// <param name="filePath">The file path.</param>
        /// <param name="fileName">Name of the file.</param>
        public static void ViewPDF(Dispatcher uiDispatcher, string filePath, string fileName)
        {
            ViewFile(uiDispatcher, filePath, fileName, "PDF");
        }

        /// <summary>
        /// Views the file.
        /// </summary>
        /// <param name="uiDispatcher">The UI dispatcher.</param>
        /// <param name="filePath">The file path.</param>
        /// <param name="fileName">Name of the file.</param>
        /// <param name="fileType">Type of the file.</param>
        public static void ViewFile(Dispatcher uiDispatcher, string filePath, string fileName, string fileType)
        {
            var dialogService = new DialogService();

            if (File.Exists(filePath))
            {
      
                ProcessStartInfo psi = new ProcessStartInfo
                    {
                        UseShellExecute = true,
                        FileName = filePath
                    };

                try
                {
                    Process.Start(psi);
                }
                catch (System.ComponentModel.Win32Exception)
                {
                    string errorMessage = "A default " + fileType +" program is not installed. The Dicom Importer is unable to "
                                          + "open the " + fileName;

                    dialogService.ShowAlertBox(uiDispatcher, errorMessage, "Unable to Open File", MessageTypes.Warning);
                }
                catch (Exception ex)
                {
                    dialogService.ShowExceptionWindow(uiDispatcher, ex);
                }
            }
            else
            {
                dialogService.ShowAlertBox(uiDispatcher,
                    "Couldn't find the " + fileName + ": " + filePath, 
                    fileName + " Not Found", 
                    MessageTypes.Warning);
            }
        }

        /// <summary>
        /// Views the user manual.
        /// </summary>
        /// <param name="uiDispatcher">The UI dispatcher.</param>
        public static void ViewUserManual(Dispatcher uiDispatcher)
        {
            ViewFile(uiDispatcher, ImporterUserManual, "User Manual", "PDF");
        }

        #endregion
    }
}