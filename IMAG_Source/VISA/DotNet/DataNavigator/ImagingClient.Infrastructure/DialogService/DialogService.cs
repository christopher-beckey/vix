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

namespace ImagingClient.Infrastructure.DialogService
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Windows;
    using System.Windows.Documents;
    using System.Windows.Forms;
    using System.Windows.Media;
    using System.Windows.Threading;
    using ImagingClient.Infrastructure.Views;
    using Application = System.Windows.Application;
    using MessageBox = System.Windows.MessageBox;
    using PrintDialog = System.Windows.Controls.PrintDialog;
    using System.Threading.Tasks;

    /// <summary>
    /// Provides a way of launching modal dialogs in MVVM
    /// </summary>
    public class DialogService : IDialogService
    {
        /// <summary>
        /// Opens a modal dialog showing an alert message
        /// </summary>
        /// <param name="uiDispatcher">The UI thread dispatcher</param>
        /// <param name="message">The alert to be displayed</param>
        /// <param name="caption">The caption of the window</param>
        /// <param name="messageType">The type of the message</param>
        public void ShowAlertBox(Dispatcher uiDispatcher, string message, string caption, MessageTypes messageType)
        {
            uiDispatcher.Invoke(DispatcherPriority.Normal,
                                (Action)delegate
                                {
                                    MessageBox.Show(Application.Current.MainWindow, message, caption,
                                                    MessageBoxButton.OK, GetMessageBoxImage(messageType));
                                });
        }

        public void ShowAlertBox(TaskScheduler uiContext, string message, string caption, MessageTypes messageType)
        {
            Task.Factory.StartNew(() =>
                {
                    MessageBox.Show(Application.Current.MainWindow, message, caption,
                                    MessageBoxButton.OK, GetMessageBoxImage(messageType));
                },
                Task.Factory.CancellationToken,
                TaskCreationOptions.None,
                uiContext).Wait();
        }

        /// <summary>
        /// Opens a modal dialog asking the user an OK/Cancel question
        /// </summary>
        /// <param name="uiDispatcher">The UI thread dispatcher</param>
        /// <param name="message">The question to be asked</param>
        /// <param name="caption">The caption of the window</param>
        /// <param name="messageType">The type of the message</param>
        /// <returns>
        /// A value indicating if the user selected OK or Cancel
        /// </returns>
        public bool ShowOkCancelBox(Dispatcher uiDispatcher, string message, string caption, MessageTypes messageType)
        {
            bool returnValue = false;
            uiDispatcher.Invoke(DispatcherPriority.Normal,
                                (Action)delegate
                                             {
                                                 MessageBoxResult result =
                                                     MessageBox.Show(Application.Current.MainWindow, message, caption,
                                                                     MessageBoxButton.OKCancel,
                                                                     GetMessageBoxImage(messageType));
                                                 returnValue = ConvertResultToBoolean(result);
                                             });

            return returnValue;
        }

        /// <summary>
        /// Opens a modal dialog asking the user a yes/no question
        /// </summary>
        /// <param name="uiDispatcher">The UI thread dispatcher</param>
        /// <param name="message">The question to be asked</param>
        /// <param name="caption">The caption of the window</param>
        /// <param name="messageType">The type of the message</param>
        /// <returns>
        /// A value indicating if the user selected Yes or No
        /// </returns>
        public bool ShowYesNoBox(Dispatcher uiDispatcher, string message, string caption, MessageTypes messageType)
        {
            bool returnValue = false;
            uiDispatcher.Invoke(DispatcherPriority.Normal,
                                (Action)delegate
                                             {
                                                 MessageBoxResult result =
                                                     MessageBox.Show(Application.Current.MainWindow, message, caption,
                                                                     MessageBoxButton.YesNo,
                                                                     GetMessageBoxImage(messageType));
                                                 returnValue = ConvertResultToBoolean(result);
                                             });

            return returnValue;
        }

        /// <summary>
        /// Opens a modal dialog showing an exception
        /// </summary>
        /// <param name="e">The exception to display</param>
        public void ShowExceptionWindow(Exception e)
        {
            ExceptionWindow window = new ExceptionWindow(e);
            window.ShowDialog();
        }

        /// <summary>
        /// Displays the exception
        /// </summary>
        /// <param name="uiContext">The UI context.</param>
        /// <param name="e">The e.</param>
        public void ShowExceptionWindow(TaskScheduler uiContext, Exception e)
        {
            Task.Factory.StartNew(() =>
            {
                ExceptionWindow window = new ExceptionWindow(e);
                window.ShowDialog();
            },
                Task.Factory.CancellationToken,
                TaskCreationOptions.None,
                uiContext).Wait(); 
        }

        /// <summary>
        /// Opens a save file dialog
        /// </summary>
        /// <param name="defaultFileName">The default name of the file</param>
        /// <param name="defaultExtension">The default file extenstion</param>
        /// <returns>
        /// The full path to the saved file
        /// </returns>
        public string ShowSaveFileDialog(string defaultFileName, string defaultExtension)
        {
            return ShowSaveFileDialog(defaultFileName, defaultExtension, String.Empty);
        }

        /// <summary>
        /// Opens a save file dialog
        /// </summary>
        /// <param name="defaultFileName">The default name of the file</param>
        /// <param name="defaultExtension">The default file extenstion</param>
        /// <param name="filter">The file filter</param>
        /// <returns>
        /// The full path to the saved file
        /// </returns>
        public string ShowSaveFileDialog(string defaultFileName, string defaultExtension, string filter)
        {
            // Selected file name
            string fileName = string.Empty;

            // Configure save file dialog box
            Microsoft.Win32.SaveFileDialog dlg = new Microsoft.Win32.SaveFileDialog();
            dlg.FileName = defaultFileName; // Default file name
            dlg.DefaultExt = defaultExtension; // Default file extension
            dlg.Filter = filter; // Filter files by extension

            // Show save file dialog box
            Nullable<bool> result = dlg.ShowDialog();

            // Process save file dialog box results
            if (result == true)
            {
                // Save document
                fileName = dlg.FileName;
            }

            return fileName;
        }

        /// <summary>
        /// Opens a print dialog and sends the text to the printer.
        /// </summary>
        /// <param name="text">The text to print</param>
        /// <param name="description">A description of the job that is to be printed. This text appears in the user interface (UI) of the printer.</param>
        public void PrintTextDocument(string text, string description)
        {
            // Create the document, passing a new paragraph and new run using text
            FlowDocument doc = new FlowDocument(new Paragraph(new Run(text)));
            doc.TextAlignment = TextAlignment.Left;
            doc.ColumnWidth = 1000;
            doc.FontFamily = new FontFamily("Courier New");

            //Creates margin around the page
            doc.PagePadding = new Thickness(50);

            PrintDialog printDialog = new PrintDialog();
            if (printDialog.ShowDialog() == true)
            {
                // Send the document to the printer
                printDialog.PrintDocument(((IDocumentPaginatorSource)doc).DocumentPaginator, description);
            }
        }

        /// <summary>
        /// Gets a MessageBoxImage based on the message type
        /// </summary>
        /// <param name="messageType">The type of the message</param>
        /// <returns>The associated MessageBoxImage</returns>
        private MessageBoxImage GetMessageBoxImage(MessageTypes messageType)
        {
            if (messageType.Equals(MessageTypes.Question))
            {
                return MessageBoxImage.Question;
            }

            if (messageType.Equals(MessageTypes.Error))
            {
                return MessageBoxImage.Error;
            }

            if (messageType.Equals(MessageTypes.Warning))
            {
                return MessageBoxImage.Warning;
            }

            // Default to Information
            return MessageBoxImage.Information;
        }

        /// <summary>
        /// Converts a MessageBoxResult to a boolean
        /// </summary>
        /// <param name="result">The result of the MessageBox</param>
        /// <returns>False for No, None, and Cancel.  True for all others.</returns>
        private bool ConvertResultToBoolean(MessageBoxResult result)
        {
            if (result.Equals(MessageBoxResult.No) || result.Equals(MessageBoxResult.None) ||
                result.Equals(MessageBoxResult.Cancel))
            {
                return false;
            }

            // If it wasn't of the "no-equivalents", default to true
            return true;
        }
    }
}