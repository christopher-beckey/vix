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
    using System.Runtime.InteropServices;
    using System.Windows;
    using System.Windows.Documents;
    using System.Windows.Forms;
    using System.Windows.Media;
    using System.Windows.Threading;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.Views;
    using Microsoft.Practices.Prism.Events;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// Provides a way of launching modal dialogs in MVVM
    /// </summary>
    public class DialogService : IDialogService
    {
        #region Constants and Fields

        /// <summary>
        /// The event aggregator
        /// </summary>
        private IEventAggregator eventAggregator = ServiceLocator.Current.GetInstance<IEventAggregator>();

        /// <summary>
        /// The hex code for closing a window.
        /// </summary>
        private const UInt32 WM_CLOSE = 0x0010;

        #endregion

        #region Public Methods

        /// <summary>
        /// Opens a print dialog and sends the text to the printer.
        /// </summary>
        /// <param name="text">
        /// The text to print
        /// </param>
        /// <param name="description">
        /// A description of the job that is to be printed. This text appears in the user interface (UI) of the printer.
        /// </param>
        public void PrintTextDocument(string text, string description)
        {
            // Create the document, passing a new paragraph and new run using text
            var doc = new FlowDocument(new Paragraph(new Run(text)))
                {
                    TextAlignment = TextAlignment.Left,
                    ColumnWidth = 1000,
                    FontFamily = new FontFamily("Courier New"),
                    PagePadding = new Thickness(50)
                };

            // Subscribes to the Logout Event
            this.eventAggregator.GetEvent<NewUserLoginEvent>().Subscribe(ClosePrintDialog);

            var printDialog = new System.Windows.Controls.PrintDialog();

            if (printDialog.ShowDialog() == true)
            {
                // Send the document to the printer
                printDialog.PrintDocument(((IDocumentPaginatorSource)doc).DocumentPaginator, description);
            }
        }

        /// <summary>
        /// Opens a modal dialog showing an alert message
        /// </summary>
        /// <param name="uiDispatcher">
        /// The UI thread dispatcher
        /// </param>
        /// <param name="message">
        /// The alert to be displayed
        /// </param>
        /// <param name="caption">
        /// The caption of the window
        /// </param>
        /// <param name="messageType">
        /// The type of the message
        /// </param>
        public MessageBoxResult ShowAlertBox(Dispatcher uiDispatcher, string message, string caption, MessageTypes messageType)
        {
            MessageBoxResult userResponse = MessageBoxResult.None;

            Action action = () =>
                {
                    var window = new ImagingClient.Infrastructure.Views.MessageBox(message, caption, messageType);
                    window.Owner = System.Windows.Application.Current.MainWindow;
                    window.SubscribeToNewUserLogin();
                    window.ShowDialog();

                    userResponse = window.GetUserResponse();
                };

            uiDispatcher.Invoke(DispatcherPriority.Normal, action);

            return userResponse;
        }

        /// <summary>
        /// Opens a modal dialog showing an alert message
        /// </summary>
        /// <param name="owner">
        /// The owning window
        /// </param>
        /// <param name="uiDispatcher">
        /// The UI thread dispatcher
        /// </param>
        /// <param name="message">
        /// The alert to be displayed
        /// </param>
        /// <param name="caption">
        /// The caption of the window
        /// </param>
        /// <param name="messageType">
        /// The type of the message
        /// </param>
        public void ShowAlertBox(Window owner, Dispatcher uiDispatcher, string message, string caption, MessageTypes messageType)
        {
            Action action = () =>
                {
                    var window = new ImagingClient.Infrastructure.Views.MessageBox(message, caption, messageType);
                    window.Owner = owner;
                    window.SubscribeToNewUserLogin();
                    window.ShowDialog();
                };

            uiDispatcher.Invoke( DispatcherPriority.Normal, action);
        }

        /// <summary>
        /// Opens a modal dialog showing an exception
        /// </summary>
        /// <param name="uiDispatcher">
        /// The UI thread dispatcher
        /// </param>
        /// <param name="e">
        /// The exception to display
        /// </param>
        public void ShowExceptionWindow(Dispatcher uiDispatcher, Exception e)
        {
            Action action = () =>
            {
                var window = new ExceptionWindow(e);
                window.Owner = System.Windows.Application.Current.MainWindow;
                window.SubscribeToNewUserLogin();
                window.ShowDialog();
            };

            uiDispatcher.Invoke(DispatcherPriority.Normal, action);
        }

        /// <summary>
        /// Shows the file browser dialog.
        /// </summary>
        /// <param name="filter">The filter.</param>
        /// <param name="owner">The owner.</param>
        public string[] ShowFileBrowserDialog(string filter, IWin32Window owner)
        {
            // configures dialog
            OpenFileDialog dlg = new OpenFileDialog();
            dlg.Filter = filter;
            dlg.Title = "Browse For File";
            dlg.Multiselect = true;

            // Subscribes to the Logout Event
            this.eventAggregator.GetEvent<NewUserLoginEvent>().Subscribe(CloseFileBrowserDialog);

            // displays dialog
            DialogResult result = dlg.ShowDialog(owner);

            if (result == DialogResult.OK)
            {
                return dlg.FileNames;
            }

            return null;
        }

        /// <summary>
        /// Opens a modal dialog asking the user an OK/Cancel question
        /// </summary>
        /// <param name="uiDispatcher">
        /// The UI thread dispatcher
        /// </param>
        /// <param name="message">
        /// The question to be asked
        /// </param>
        /// <param name="caption">
        /// The caption of the window
        /// </param>
        /// <param name="messageType">
        /// The type of the message
        /// </param>
        /// <returns>
        /// A value indicating if the user selected OK or Cancel
        /// </returns>  
        public bool ShowOkCancelBox(Dispatcher uiDispatcher, string message, string caption, MessageTypes messageType)
        {
            bool returnValue = false;

            Action action = () =>
                {
                    var window = new ImagingClient.Infrastructure.Views.MessageBox(message, caption, MessageTypes.Confirm);
                    window.Owner = System.Windows.Application.Current.MainWindow;
                    window.SubscribeToNewUserLogin();
                    window.ShowDialog();

                    returnValue = this.ConvertResultToBoolean(window.GetUserResponse());
                };

            uiDispatcher.Invoke(DispatcherPriority.Normal, action);

            return returnValue;
        }

        /// <summary>
        /// Opens a save file dialog
        /// </summary>
        /// <param name="defaultFileName">
        /// The default name of the file
        /// </param>
        /// <param name="defaultExtension">
        /// The default file extenstion
        /// </param>
        /// <returns>
        /// The full path to the saved file
        /// </returns>
        public string ShowSaveFileDialog(string defaultFileName, string defaultExtension)
        {
            return this.ShowSaveFileDialog(defaultFileName, defaultExtension, string.Empty);
        }

        /// <summary>
        /// Opens a save file dialog
        /// </summary>
        /// <param name="defaultFileName">
        /// The default name of the file
        /// </param>
        /// <param name="defaultExtension">
        /// The default file extenstion
        /// </param>
        /// <param name="filter">
        /// The file filter
        /// </param>
        /// <returns>
        /// The full path to the saved file
        /// </returns>
        public string ShowSaveFileDialog(string defaultFileName, string defaultExtension, string filter)
        {
            // Selected file name
            string fileName = string.Empty;

            // Configure save file dialog box
            var dlg = new Microsoft.Win32.SaveFileDialog
                {
                    FileName = defaultFileName, 
                    DefaultExt = defaultExtension, 
                    Filter = filter
                };

            // Subscribes to the Logout Event
            this.eventAggregator.GetEvent<NewUserLoginEvent>().Subscribe(CloseSaveFileDialog);

            // Show save file dialog box
            bool? result = dlg.ShowDialog();

            // Process save file dialog box results
            if (result == true)
            {
                // Save document
                fileName = dlg.FileName;
            }

            return fileName;
        }

        /// <summary>
        /// Shows the folder browser dialog.
        /// </summary>
        /// <param name="owner">
        /// The window that should be the owner of the dialog
        /// </param>
        /// <returns>The path of the selected file.</returns>
        public String ShowFolderBrowserDialog(IWin32Window owner)
        {
            String selectedPath = null;

            // Subscribes to the Logout Event
            this.eventAggregator.GetEvent<LogoutEvent>().Subscribe(CloseFolderBrowserDialog);

            FolderBrowserDialog dlg = new FolderBrowserDialog { ShowNewFolderButton = false };

            DialogResult result = dlg.ShowDialog(owner);

            if (result == DialogResult.OK)
            {
               selectedPath = dlg.SelectedPath;
            }

            return selectedPath;
        }

        /// <summary>
        /// Opens a modal dialog asking the user a yes/no question
        /// </summary>
        /// <param name="uiDispatcher">
        /// The UI thread dispatcher
        /// </param>
        /// <param name="message">
        /// The question to be asked
        /// </param>
        /// <param name="caption">
        /// The caption of the window
        /// </param>
        /// <param name="messageType">
        /// The type of the message
        /// </param>
        /// <returns>
        /// A value indicating if the user selected Yes or No
        /// </returns>
        public bool ShowYesNoBox(Dispatcher uiDispatcher, string message, string caption, MessageTypes messageType)
        {
            bool returnValue = false;

            Action action = () =>
                {
                    var window = new ImagingClient.Infrastructure.Views.MessageBox(message, caption, MessageTypes.Question);
                    window.Owner = System.Windows.Application.Current.MainWindow;
                    window.SubscribeToNewUserLogin();
                    window.ShowDialog();

                    returnValue = this.ConvertResultToBoolean(window.GetUserResponse());
                };

            uiDispatcher.Invoke(DispatcherPriority.Normal, action);
       
            return returnValue;
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Closes the file browser dialog.
        /// </summary>
        /// <param name="user">The user.</param>
        private void CloseFileBrowserDialog(string user)
        {
            int dialogWindow = FindWindow(null, "Browse For File");
            PostMessage(dialogWindow, WM_CLOSE, 0, 0);

            // Unsubscribes from the Logout Event
            this.eventAggregator.GetEvent<LogoutEvent>().Unsubscribe(CloseFileBrowserDialog);
        }

        /// <summary>
        /// Closes the folder browser dialog.
        /// </summary>
        /// <param name="user">The user.</param>
        private void CloseFolderBrowserDialog(string user)
        {
            int dialogWindow = FindWindow(null, "Browse For Folder");
            PostMessage(dialogWindow, WM_CLOSE, 0, 0);

            // Unsubscribes from the Logout Event
            this.eventAggregator.GetEvent<LogoutEvent>().Unsubscribe(CloseFolderBrowserDialog);
        }

        /// <summary>
        /// Closes the print dialog.
        /// </summary>
        /// <param name="user">The user.</param>
        private void ClosePrintDialog(string user)
        {
            int dialogWindow = FindWindow(null, "Print");
            PostMessage(dialogWindow, WM_CLOSE, 0, 0);

            // Unsubscribes from the Logout Event
            this.eventAggregator.GetEvent<LogoutEvent>().Unsubscribe(ClosePrintDialog);
        }

        /// <summary>
        /// Closes the save file dialog.
        /// </summary>
        /// <param name="user">The user.</param>
        private void CloseSaveFileDialog(string user)
        {
            int dialogWindow = FindWindow(null, "Save As");
            PostMessage(dialogWindow, WM_CLOSE, 0, 0);

            // Unsubscribes from the Logout Event
            this.eventAggregator.GetEvent<LogoutEvent>().Unsubscribe(CloseSaveFileDialog);
        }


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

        /// <summary>
        /// Finds a window currently open on the system..
        /// </summary>
        /// <param name="lpClassName">Name of the window class.</param>
        /// <param name="lpWindowName">The caption of the windowwindow.</param>
        /// <returns></returns>
        [DllImport("user32.dll")]
        private static extern int FindWindow(string lpClassName, string lpWindowName);

        /// <summary>
        /// Posts a message to a window.
        /// </summary>
        /// <param name="hWnd">The windows handle.</param>
        /// <param name="Msg">The message to be posted to the window.</param>
        /// <param name="wParam">The w param.</param>
        /// <param name="lParam">The l param.</param>
        /// <returns></returns>
        [return: MarshalAs(UnmanagedType.Bool)]
        [DllImport("user32.dll", SetLastError = true)]
        private static extern bool PostMessage(int hWnd, uint Msg, int wParam, int lParam);

        #endregion
    }
}
