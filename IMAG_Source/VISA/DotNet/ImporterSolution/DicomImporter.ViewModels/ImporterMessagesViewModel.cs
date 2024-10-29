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

namespace DicomImporter.ViewModels
{
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using DicomImporter.Common.Model;
    using ImagingClient.Infrastructure.DialogService;

    /// <summary>
    /// The Importer Messages View Model.
    /// </summary>
    public class ImporterMessagesViewModel : INotifyPropertyChanged
    {
        #region Constants and Fields

        /// <summary>
        /// The display one message height
        /// </summary>
        private const double DisplayOneMessageHeight = 25;

        /// <summary>
        /// The display two messages height
        /// </summary>
        private const double DisplayTwoMessagesHeight = 48;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ImporterMessagesViewModel" /> class.
        /// </summary>
        public ImporterMessagesViewModel()
        {
            this.Messages = new ObservableCollection<ImporterMessage>();
            this.MessagesMaxHeight = DisplayTwoMessagesHeight;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the height of the messages max.
        /// </summary>
        /// <value>
        /// The height of the messages max.
        /// </value>
        public double MessagesMaxHeight { get; set; }

        /// <summary>
        /// Gets or sets the Messages.
        /// </summary>
        public ObservableCollection<ImporterMessage> Messages { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [show only one message].
        /// </summary>
        public bool ShowOnlyOneMessage 
        {
            set
            {
                if (value)
                {
                    this.MessagesMaxHeight = DisplayOneMessageHeight;
                }
                else
                {
                    this.MessagesMaxHeight = DisplayTwoMessagesHeight;
                }

                this.RaisePropertyChanged("MessagesMaxHeight");
            }
        }

        #endregion

        #region Public Events

        /// <summary>
        /// The property changed.
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;
        
        #endregion

        #region Public Methods

        /// <summary>
        /// Adds the message to the list.
        /// </summary>
        /// <param name="messageType">Type of the message.</param>
        /// <param name="message">The message.</param>
        public void AddMessage(MessageTypes messageType, string message)
        {
            if (this.Messages == null)
            {
                this.Messages = new ObservableCollection<ImporterMessage>();
            }

            this.Messages.Insert(0, new ImporterMessage(messageType, message));

            this.RaisePropertyChanged("MessagesExist");
        }

        /// <summary>
        /// Clears all messages from the list.
        /// </summary>
        public void ClearMessages()
        {
            if (this.Messages == null)
            {
                this.Messages = new ObservableCollection<ImporterMessage>();
            }
            else
            {
                this.Messages.Clear();
            }

            this.RaisePropertyChanged("MessagesExist");
        }

        /// <summary>
        /// Gets a value indicating whether [messages exist] in the list.
        /// </summary>
        public bool MessagesExist 
        {
            get
            {
                if (this.Messages == null || this.Messages.Count == 0)
                {
                    return false;
                }

                return true;
            }
        }

        /// <summary>
        /// Removes the message.
        /// </summary>
        /// <param name="message">The message.</param>
        public void RemoveMessage(string message)
        {
            int index = 0;

            // will search for the object with the message and remove it
            foreach (ImporterMessage impMessage in this.Messages)
            {
                if (impMessage.Message.Equals(message))
                {
                    this.Messages.RemoveAt(index);
                    break;
                }

                index++;
            }

            this.RaisePropertyChanged("MessagesExist");
        }

        #endregion

        #region Methods

        /// <summary>
        /// The raise property changed.
        /// </summary>
        /// <param name="propertyName">
        /// The property name.
        /// </param>
        protected void RaisePropertyChanged(string propertyName)
        {
            PropertyChangedEventHandler handler = this.PropertyChanged;
            if (handler != null)
            {
                handler.Invoke(this, new PropertyChangedEventArgs(propertyName));
            }
        }


        #endregion

    }
}