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
    using System.Windows.Threading;
    using System.Threading.Tasks;

    /// <summary>
    /// Provides a way of launching modal dialogs in MVVM
    /// </summary>
    public interface IDialogService
    {
        /// <summary>
        /// Opens a modal dialog showing an alert message
        /// </summary>
        /// <param name="uiDispatcher">The UI thread dispatcher</param>
        /// <param name="message">The alert to be displayed</param>
        /// <param name="caption">The caption of the window</param>
        /// <param name="messageType">The type of the message</param>
        void ShowAlertBox(Dispatcher uiDispatcher, string message, string caption, MessageTypes messageType);

        void ShowAlertBox(TaskScheduler uiContext, string message, string caption, MessageTypes messageType);

        /// <summary>
        /// Opens a modal dialog asking the user an OK/Cancel question
        /// </summary>
        /// <param name="uiDispatcher">The UI thread dispatcher</param>
        /// <param name="message">The question to be asked</param>
        /// <param name="caption">The caption of the window</param>
        /// <param name="messageType">The type of the message</param>
        /// <returns>A value indicating if the user selected OK or Cancel</returns>
        bool ShowOkCancelBox(Dispatcher uiDispatcher, string message, string caption, MessageTypes messageType);

        /// <summary>
        /// Opens a modal dialog asking the user a yes/no question
        /// </summary>
        /// <param name="uiDispatcher">The UI thread dispatcher</param>
        /// <param name="message">The question to be asked</param>
        /// <param name="caption">The caption of the window</param>
        /// <param name="messageType">The type of the message</param>
        /// <returns>A value indicating if the user selected Yes or No</returns>
        bool ShowYesNoBox(Dispatcher uiDispatcher, string message, string caption, MessageTypes messageType);

        /// <summary>
        /// Opens a modal dialog showing an exception
        /// </summary>
        /// <param name="e">The exception to display</param>
        void ShowExceptionWindow(Exception e);

        /// <summary>
        /// Opens a modal dialog showing an exception.
        /// </summary>
        /// <param name="uiContext">The UI context.</param>
        /// <param name="e">The e.</param>
        void ShowExceptionWindow(TaskScheduler uiContext, Exception e);

        /// <summary>
        /// Opens a save file dialog
        /// </summary>
        /// <param name="defaultFileName">The default name of the file</param>
        /// <param name="defaultExtension">The default file extenstion</param>
        /// <returns>The full path to the saved file</returns>
        string ShowSaveFileDialog(string defaultFileName, string defaultExtension);

        /// <summary>
        /// Opens a save file dialog
        /// </summary>
        /// <param name="defaultFileName">The default name of the file</param>
        /// <param name="defaultExtension">The default file extenstion</param>
        /// <param name="filter">The file filter</param>
        /// <returns>The full path to the saved file</returns>
        string ShowSaveFileDialog(string defaultFileName, string defaultExtension, string filter);

        /// <summary>
        /// Opens a print dialog and sends the text to the printer.
        /// </summary>
        /// <param name="text">The text to print</param>
        /// <param name="description">A description of the job that is to be printed. This text appears in the user interface (UI) of the printer.</param>
        void PrintTextDocument(string text, string description);
    }
}
