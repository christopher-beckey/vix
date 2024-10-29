/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 04/30/2013
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
namespace ImagingClient.Infrastructure.Views
{
    using System.Windows;
    using System.Windows.Input;
    using ImagingClient.Infrastructure.Events;
    using Microsoft.Practices.Prism.Events;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// BaseWindow is used to hold all common methods and values
    /// used by all of the individiual "Pop Up" Windows.
    /// </summary>
    public class BaseWindow : Window
    {
        #region Constants and Fields

        /// <summary>
        /// The event aggregator
        /// </summary>
        protected IEventAggregator eventAggregator;

        /// <summary>
        /// The new user login
        /// </summary>
        protected bool newUserLogin;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="BaseWindow" /> class.
        /// </summary>
        public BaseWindow()
        {
            this.newUserLogin = false;
           // this.ShowInTaskbar = false;
            this.eventAggregator = ServiceLocator.Current.GetInstance<IEventAggregator>();
           
            // handlers added to help determine application idle time.
            this.KeyDown += new KeyEventHandler(onKeyAction);
            this.MouseMove += new MouseEventHandler(onMouseMove);
            this.MouseWheel += new MouseWheelEventHandler(onMouseWheel);
            this.MouseDown += new MouseButtonEventHandler(onMouseAction);
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Subscribes to new user login events.
        /// </summary>
        public void SubscribeToNewUserLogin()
        {
            this.eventAggregator.GetEvent<NewUserLoginEvent>().Subscribe(Close);
        }

        #endregion

        #region Protected Methods

        /// <summary>
        /// Closes the window but first unsubscribes from the NewUserLoginEvent.
        /// </summary>
        /// <param name="user">The DUZ of the user that was recently logged in.</param>
        protected void Close(string userDUZ)
        {
            if (userDUZ != null)
            {
                newUserLogin = true;
            }

            this.eventAggregator.GetEvent<NewUserLoginEvent>().Unsubscribe(Close);
            this.Close();
        }

        #endregion

        #region Event Handlers

        /// <summary>
        /// Event handler for when a key on the keyboard is pressed within the window. 
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="args">The <see cref="KeyboardEventArgs" /> instance containing the event data.</param>
        private void onKeyAction(object sender, KeyboardEventArgs args)
        {
            this.NotifyofAction();
        }

        /// <summary>
        /// Event handler for when a button on the mouse is pressed within the window. 
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="arg">The <see cref="MouseButtonEventArgs" /> instance containing the event data.</param>
        private void onMouseAction(object sender, MouseButtonEventArgs arg)
        {
            this.NotifyofAction();
        }

        /// <summary>
        /// Event handler for when the mouse is moved within the window. 
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="args">The <see cref="MouseEventArgs" /> instance containing the event data.</param>
        private void onMouseMove(object sender, MouseEventArgs args)
        {
            this.NotifyofAction();
        }

        /// <summary>
        /// Event handler for when the wheel on the mouse is used within the window. 
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="args">The <see cref="MouseWheelEventArgs" /> instance containing the event data.</param>
        private void onMouseWheel(object sender, MouseWheelEventArgs args)
        {
            this.NotifyofAction();
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Notifies a subscribed event handler of user action on the window.
        /// </summary>
        private void NotifyofAction()
        {
            this.eventAggregator.GetEvent<UserActionEvent>().Publish(this.Name);
        }

        #endregion
    }
}
