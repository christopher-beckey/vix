/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 02/26/2013
 * Site Name:  Washington OI Field Office, Silver Spring, MD
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
namespace ImagingClient.Infrastructure.Views
{
    using System;
    using System.Drawing;
    using System.Timers;
    using System.Windows;
    using System.Windows.Interop;
    using System.Windows.Media.Imaging;
    using System.Windows.Threading;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.User.Model;

    /// <summary>
    /// Interaction logic for MessageBox.xaml
    /// </summary>
    public partial class MessageBox
    {
        #region Constants and Fields

        /// <summary>
        /// The countdown caption
        /// </summary>
        private const string CountdownCaption = "Importer Timeout";

        /// <summary>
        /// The countdown message
        /// </summary>
        private const string CountdownMessage = "Please press OK to continue working with the Importer or your Importer session will end in";
        
        /// <summary>
        /// The countdown mode
        /// </summary>
        private bool countdownMode;

        /// <summary>
        /// The countdown timer
        /// </summary>
        private Timer countdownTimer;

        /// <summary>
        /// The UI dispatcher
        /// </summary>
        private Dispatcher uiDispatcher;

        /// <summary>
        /// The seconds left
        /// </summary>
        private int secondsLeft = 10;

        /// <summary>
        /// The users response
        /// </summary>
        private MessageBoxResult userResponse;
        
        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="MessageBox" /> class.
        /// </summary>
        /// <param name="messageType">Type of the message.</param>
        /// <param name="logoutCountdownMode">if set to <c>true</c> [logout countdown mode].</param>
        /// <param name="dispatcher">The dispatcher.</param>
        public MessageBox(MessageTypes messageType, bool logoutCountdownMode, Dispatcher dispatcher) :
            this(string.Empty, string.Empty, messageType, logoutCountdownMode, dispatcher)
        {
            if (this.countdownMode)
            {
                this.Title = CountdownCaption;
                this.txtMessage.Text = CountdownMessage + " " + secondsLeft + " seconds";
            }
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="MessageBox" /> class.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="caption">The caption.</param>
        /// <param name="messageType">Type of the message.</param>
        public MessageBox(string message, string caption, MessageTypes messageType) :
            this(message, caption, messageType, false, null) {}

        /// <summary>
        /// Initializes a new instance of the <see cref="MessageBox" /> class.
        /// </summary>
        /// <param name="message">The message.</param>
        /// <param name="caption">The caption.</param>
        /// <param name="messageType">Type of the message.</param>
        /// <param name="logoutCountdownMode">if set to <c>true</c> [logout countdown mode].</param>
        /// <param name="dispatcher">The dispatcher.</param>
        public MessageBox(string message, string caption, MessageTypes messageType, bool logoutCountdownMode, Dispatcher dispatcher)
        {
            this.InitializeComponent();

            this.Title = caption;
            this.txtMessage.Text = message;
            this.uiDispatcher = dispatcher;
            this.countdownMode = logoutCountdownMode;
            this.userResponse = MessageBoxResult.None;
            this.imgMessageBox.Source = this.GetMessageBoxImage(messageType);

            this.SetButtonsVisibility(messageType);
 
            if (countdownMode)
            {
                // Sets up countdown Timer
                this.countdownTimer = new Timer(1000);
                this.countdownTimer.Elapsed += new ElapsedEventHandler(onTimeCountdown);
                this.countdownTimer.Enabled = true;
                this.countdownTimer.AutoReset = true;
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Gets the user response.
        /// </summary>
        /// <returns></returns>
        public MessageBoxResult GetUserResponse()
        {
            return this.userResponse;
        }

        #endregion

        #region Event Handlers

        /// <summary>
        /// Handles the Click event of the btnCancel control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.RoutedEventArgs"/> instance containing the event data.</param>
        private void Cancel_Click(object sender, RoutedEventArgs e)
        {
            this.CloseMessageBox(MessageBoxResult.Cancel);
        }

        /// <summary>
        /// Handles the Click event of the btnNo control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.RoutedEventArgs"/> instance containing the event data.</param>
        private void No_Click(object sender, RoutedEventArgs e)
        {
            this.CloseMessageBox(MessageBoxResult.No);
        }

        /// <summary>
        /// Handles the Click event of the btnOk control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.RoutedEventArgs"/> instance containing the event data.</param>
        private void OK_Click(object sender, RoutedEventArgs e)
        {
            if (this.countdownTimer != null)
            {
                this.countdownTimer.Stop();
            } 
            
            this.CloseMessageBox(MessageBoxResult.OK);
        }

        /// <summary>
        /// Raises the <see cref="E:System.Windows.Window.Closing" /> event.
        /// </summary>
        /// <param name="e">A <see cref="T:System.ComponentModel.CancelEventArgs" /> that contains the event data.</param>
        protected override void OnClosing(System.ComponentModel.CancelEventArgs e)
        {
            // only close the window if a button was pressed.
            if (this.userResponse == MessageBoxResult.None && !this.newUserLogin)
            {
                e.Cancel = true;
            }

            base.OnClosing(e);
        }

        /// <summary>
        /// Called when [message loaded].
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="e">The <see cref="RoutedEventArgs" /> instance containing the event data.</param>
        private void OnMessageLoaded(object sender, RoutedEventArgs e)
        {
            if (this.countdownMode)
            {
                this.countdownTimer.Start();
            }
        }

        /// <summary>
        /// Event Handler for when the time inteval has elapsed. This method is 
        /// used to check the the countdown time of the applications last seconds idle.
        /// </summary>
        /// <param name="source">The source.</param>
        /// <param name="args">The <see cref="ElapsedEventArgs" /> instance containing the event data.</param>
        private void onTimeCountdown(object source, ElapsedEventArgs args)
        {
            this.secondsLeft--;

            Action action = () =>
            {
                // close out the message because a timeout has occurred
                if (this.secondsLeft <= 0)
                {
                    UserContext.TimeoutOccurred = true;
                    this.countdownTimer.Stop();
                    this.CloseMessageBox(MessageBoxResult.No);
                }

                this.txtMessage.Text = CountdownMessage + " " + secondsLeft + " seconds";
            };

            if (uiDispatcher != null)
            {
                uiDispatcher.Invoke(DispatcherPriority.Normal, action);
            }
        }

        /// <summary>
        /// Handles the Click event of the btnYes control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.RoutedEventArgs"/> instance containing the event data.</param>
        private void Yes_Click(object sender, RoutedEventArgs e)
        {
            this.CloseMessageBox(MessageBoxResult.Yes);
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Closes the message box.
        /// </summary>
        /// <param name="result">The result.</param>
        private void CloseMessageBox(MessageBoxResult result)
        {
            this.userResponse = result;
            this.Close(null);
        }

        /// <summary>
        /// Gets the image for the message.
        /// </summary>
        /// <param name="messageType">Type of the message.</param>
        /// <returns></returns>
        private BitmapSource GetMessageBoxImage(MessageTypes messageType)
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

        /// <summary>
        /// Sets all of the buttons visibility based on the type of message.
        /// </summary>
        /// <param name="messageType">Type of the message.</param>
        private void SetButtonsVisibility(MessageTypes messageType)
        {
            switch (messageType)
            {
                case MessageTypes.Confirm:
                    this.btnOk.Visibility = System.Windows.Visibility.Visible;
                    this.btnCancel.Visibility = System.Windows.Visibility.Visible;
                    this.btnYes.Visibility = System.Windows.Visibility.Collapsed;
                    this.btnNo.Visibility = System.Windows.Visibility.Collapsed;

                    this.btnOk.Focus();
                    break;

                case MessageTypes.Question:
                    this.btnOk.Visibility = System.Windows.Visibility.Collapsed;
                    this.btnCancel.Visibility = System.Windows.Visibility.Collapsed;
                    this.btnYes.Visibility = System.Windows.Visibility.Visible;
                    this.btnNo.Visibility = System.Windows.Visibility.Visible;

                    this.btnYes.Focus();
                    break;

                default:
                    this.btnOk.Visibility = System.Windows.Visibility.Visible;
                    this.btnCancel.Visibility = System.Windows.Visibility.Collapsed;
                    this.btnYes.Visibility = System.Windows.Visibility.Collapsed;
                    this.btnNo.Visibility = System.Windows.Visibility.Collapsed;

                    this.btnOk.Focus();
                    break;
            } 
        }

        #endregion
    }
}