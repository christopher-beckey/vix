/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 06/11/2013
 * Site Name:  Washington OI Field Office, Columbia, MD
 * Developer:  Lenard Williams
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
    using System.Drawing;
    using System.Windows;
    using System.Windows.Interop;
    using System.Windows.Media.Imaging;
    using ImagingClient.Infrastructure.DialogService;

    /// <summary>
    /// Contains an Importer Message
    /// </summary>
    public class ImporterMessage
    {
        #region Constants and Fields

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ImporterMessage" /> class.
        /// </summary>
        /// <param name="messageType">Type of the message.</param>
        /// <param name="message">The message.</param>
        public ImporterMessage(MessageTypes messageType, string message)
        {
            this.Image = this.GetImageSource(messageType);
            this.Message = message;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the image.
        /// </summary>
        public BitmapSource Image { get; set; }

        /// <summary>
        /// Gets or sets the message.
        /// </summary>
        public string Message { get; set; }

        #endregion

        #region Private Methods

        /// <summary>
        /// Gets the image for the message type.
        /// </summary>
        /// <param name="messageType">Type of the message.</param>
        /// <returns></returns>
        private BitmapSource GetImageSource(MessageTypes messageType)
        {
            BitmapSource icon = null;

            switch (messageType)
            {
                case MessageTypes.Confirm:
                case MessageTypes.Question:
                    icon = Imaging.CreateBitmapSourceFromHIcon(SystemIcons.Question.Handle, Int32Rect.Empty, BitmapSizeOptions.FromEmptyOptions());
                    break;

                case MessageTypes.Error:
                    icon = Imaging.CreateBitmapSourceFromHIcon(SystemIcons.Error.Handle, Int32Rect.Empty, BitmapSizeOptions.FromEmptyOptions());
                    break;

                case MessageTypes.Warning:
                    icon = Imaging.CreateBitmapSourceFromHIcon(SystemIcons.Warning.Handle, Int32Rect.Empty, BitmapSizeOptions.FromEmptyOptions());
                    break;

                default:
                    icon = Imaging.CreateBitmapSourceFromHIcon(SystemIcons.Information.Handle, Int32Rect.Empty, BitmapSizeOptions.FromEmptyOptions());
                    break;
            }

            return icon;
        }

        #endregion
    }
}
