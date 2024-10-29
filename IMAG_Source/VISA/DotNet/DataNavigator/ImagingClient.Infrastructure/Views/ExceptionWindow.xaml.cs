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


using System;
using System.Text;
using System.Windows;
using ImagingClient.Infrastructure.Exceptions;
using log4net;

namespace ImagingClient.Infrastructure.Views
{
    /// <summary>
    /// Interaction logic for ExceptionWindow.xaml
    /// </summary>
    public partial class ExceptionWindow : Window
    {

        private static ILog Logger = LogManager.GetLogger(typeof(ExceptionWindow));


        public ExceptionWindow(Exception ex)
        {
            InitializeComponent();

            if (ex is ServerException)
            {

                ServerException serverException = (ServerException) ex;
                // Get the error message
                string errorMessage = 
                    "A problem has occurred. Please confirm that the\n" +
                    "VistA Imaging Exchange (VIX) and VistA database are online and available from this workstation.\n\n" +
                    "Additional error information can be found below.";

                // Get the error details
                String errorDetails = GetErrorDetails(serverException);

                // Log the message to log4net
                Logger.Error(errorDetails);

                // Set the text fields
                lblExceptionMessage.Content = errorMessage;
                txtExceptionDetails.Text = errorDetails;
            }
            else 
            {
                // Get the error message
                string errorMessage = "A problem has occurred. Additional error information can be found below.";

                // Set the text fields
                lblExceptionMessage.Content = errorMessage;

                String logMessage = "";

                // will get the root cause of the exception. (Base Exception)
                if (ex is AggregateException)
                {
                    Exception baseEx = ((AggregateException)ex).GetBaseException();

                    txtExceptionDetails.Text = baseEx.Message + "\n" + baseEx.StackTrace;
                    logMessage = errorMessage + "\n" + txtExceptionDetails.Text;
                }
                else
                {
                    txtExceptionDetails.Text = ex.Message + "\n" + ex.StackTrace;
                    logMessage = errorMessage + "\n" + ex.StackTrace;
                }

                // Log the message to log4net
                Logger.Error(logMessage);
            }
        }

        private String GetErrorDetails(ServerException se)
        {
            StringBuilder errorDetails = new StringBuilder();
            errorDetails.AppendLine("Server-side error information and stack trace:");
            errorDetails.AppendLine("-----------------------------------------------------");
            errorDetails.AppendLine(se.ToString());
            errorDetails.AppendLine("");
            errorDetails.AppendLine("Client-side stack trace:");
            errorDetails.AppendLine("-----------------------------------------------------");
            errorDetails.AppendLine(se.StackTrace);
            return errorDetails.ToString();
        }


        private void btnClose_Click(object sender, RoutedEventArgs e)
        {
            Close();
        }
    }
}
