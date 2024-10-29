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
namespace ImagingClient.Infrastructure.Controls
{
    using System.Windows.Controls;
    using System.Windows.Data;
    using System.Windows.Input;

    /// <summary>
    /// Custom TextBox server control which handles "enter" key events
    /// Handles "enter" key events to update the underlying datasource
    /// </summary>
    public class SubmitTextBox : TextBox
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the SubmitTextBox class.
        /// Subscribes to the textbox's PreviewKeyDown event.
        /// </summary>
        public SubmitTextBox()
        {
            this.PreviewKeyDown += this.SubmitTextBox_PreviewKeyDown;
        }

        #endregion

        #region Methods

        /// <summary>
        /// Updates the underlying datasource when an "enter" key event is detected.
        /// </summary>
        /// <param name="sender">
        /// The object which sent the event
        /// </param>
        /// <param name="e">
        /// The arguments for the key event
        /// </param>
        private void SubmitTextBox_PreviewKeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                BindingExpression be = this.GetBindingExpression(TextProperty);
                if (be != null)
                {
                    be.UpdateSource();
                }
            }
        }

        #endregion
    }
}