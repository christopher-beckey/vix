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
namespace ImagingClient.Infrastructure.Views
{
    using System;
    using System.Text;
    using System.Windows;
    using ImagingClient.Infrastructure.Exceptions;
    using log4net;

    /// <summary>
    /// Interaction logic for ExceptionWindow.xaml
    /// </summary>
    public partial class ExceptionWindow
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(ExceptionWindow));

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ExceptionWindow"/> class.
        /// </summary>
        /// <param name="ex">
        /// The ex.
        /// </param>
        public ExceptionWindow(Exception ex) : base()
        {
            this.InitializeComponent();

            if (ex is ServerException)
            {
                var serverException = (ServerException)ex;

                // Get the error message
                string errorMessage =
                    "A problem has occurred that prevents your imagery from being imported. Please confirm that the\n"
                    +
                    "VistA Imaging Exchange (VIX) and VistA database are online and available from this workstation.\n\n"
                    + "Additional error information can be found below.";

                // Get the error details
                string errorDetails = this.GetErrorDetails(serverException);

                // Log the message to log4net
                Logger.Error(errorDetails);

                // Set the text fields
                this.lblExceptionMessage.Content = errorMessage;
                this.txtexceptionDetails.Text = errorDetails;
            }
            else
            {
                // Get the error message
                string errorMessage = "A problem has occurred while processing a DICOM Importer III action or request.\n\n"
                                      + "Additional error information can be found below.";

                // Set the text fields
                this.lblExceptionMessage.Content = errorMessage;
                this.txtexceptionDetails.Text = ex.Message + "\n" + ex.StackTrace;

                // Log the message to log4net
                string logMessage = errorMessage + "\n" + ex.StackTrace;
                Logger.Error(logMessage);
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Handles the Click event of the btnClose control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.RoutedEventArgs"/> instance containing the event data.</param>
        private void Close_Click(object sender, RoutedEventArgs e)
        {
            this.Close(null);
        }

        /// <summary>
        /// Gets the error details.
        /// </summary>
        /// <param name="se">The se.</param>
        /// <returns>the error details</returns>
        private string GetErrorDetails(ServerException se)
        {
            var errorDetails = new StringBuilder();
            errorDetails.AppendLine("Server-side error information and stack trace:");
            errorDetails.AppendLine("-----------------------------------------------------");
            errorDetails.AppendLine(se.ToString());
            errorDetails.AppendLine(string.Empty);
            errorDetails.AppendLine("Client-side stack trace:");
            errorDetails.AppendLine("-----------------------------------------------------");
            errorDetails.AppendLine(se.StackTrace);
            return errorDetails.ToString();
        }

        #endregion
    }
}