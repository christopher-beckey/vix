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
    using System.Windows;
    using System.Windows.Controls;

    /// <summary>
    /// The password box assistant.
    /// </summary>
    public static class PasswordBoxAssistant
    {
        #region Constants and Fields

        /// <summary>
        /// The bind password.
        /// </summary>
        public static readonly DependencyProperty BindPassword = DependencyProperty.RegisterAttached(
            "BindPassword", 
            typeof(bool), 
            typeof(PasswordBoxAssistant), 
            new PropertyMetadata(false, OnBindPasswordChanged));

        /// <summary>
        /// The bound password.
        /// </summary>
        public static readonly DependencyProperty BoundPassword = DependencyProperty.RegisterAttached(
            "BoundPassword", 
            typeof(string), 
            typeof(PasswordBoxAssistant), 
            new PropertyMetadata(string.Empty, OnBoundPasswordChanged));

        /// <summary>
        /// The updating password.
        /// </summary>
        private static readonly DependencyProperty UpdatingPassword =
            DependencyProperty.RegisterAttached(
                "UpdatingPassword", typeof(bool), typeof(PasswordBoxAssistant), new PropertyMetadata(false));

        #endregion

        #region Public Methods

        /// <summary>
        /// Gets the bind password.
        /// </summary>
        /// <param name="dp">The dp.</param>
        /// <returns>Whether or not to bind the password</returns>
        public static bool GetBindPassword(DependencyObject dp)
        {
            return (bool)dp.GetValue(BindPassword);
        }

        /// <summary>
        /// Gets the bound password.
        /// </summary>
        /// <param name="dp">The dp.</param>
        /// <returns>The bound password value</returns>
        public static string GetBoundPassword(DependencyObject dp)
        {
            return (string)dp.GetValue(BoundPassword);
        }

        /// <summary>
        /// The set bind password.
        /// </summary>
        /// <param name="dp">
        /// The dp.
        /// </param>
        /// <param name="value">
        /// The value.
        /// </param>
        public static void SetBindPassword(DependencyObject dp, bool value)
        {
            dp.SetValue(BindPassword, value);
        }

        /// <summary>
        /// The set bound password.
        /// </summary>
        /// <param name="dp">
        /// The dp.
        /// </param>
        /// <param name="value">
        /// The value.
        /// </param>
        public static void SetBoundPassword(DependencyObject dp, string value)
        {
            dp.SetValue(BoundPassword, value);
        }

        #endregion

        #region Methods

        /// <summary>
        /// Determines whether or not the password is being updated.
        /// </summary>
        /// <param name="dp">The dp.</param>
        /// <returns>Whether or not the password is being updated</returns>
        private static bool GetUpdatingPassword(DependencyObject dp)
        {
            return (bool)dp.GetValue(UpdatingPassword);
        }

        /// <summary>
        /// The handle password changed.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private static void HandlePasswordChanged(object sender, RoutedEventArgs e)
        {
            var box = sender as PasswordBox;

            // set a flag to indicate that we're updating the password
            SetUpdatingPassword(box, true);

            // push the new password into the BoundPassword property
            if (box != null)
            {
                SetBoundPassword(box, box.Password);
                SetUpdatingPassword(box, false);
            }
        }

        /// <summary>
        /// The on bind password changed.
        /// </summary>
        /// <param name="dp">
        /// The dp.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private static void OnBindPasswordChanged(DependencyObject dp, DependencyPropertyChangedEventArgs e)
        {
            // when the BindPassword attached property is set on a PasswordBox,
            // start listening to its PasswordChanged event
            var box = dp as PasswordBox;

            if (box == null)
            {
                return;
            }

            var wasBound = (bool)e.OldValue;
            var needToBind = (bool)e.NewValue;

            if (wasBound)
            {
                box.PasswordChanged -= HandlePasswordChanged;
            }

            if (needToBind)
            {
                box.PasswordChanged += HandlePasswordChanged;
            }
        }

        /// <summary>
        /// The on bound password changed.
        /// </summary>
        /// <param name="d">
        /// The d.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private static void OnBoundPasswordChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            var box = d as PasswordBox;

            // only handle this event when the property is attached to a PasswordBox
            // and when the BindPassword attached property has been set to true
            if (d == null || !GetBindPassword(d))
            {
                return;
            }

            if (box != null)
            {
                // avoid recursive updating by ignoring the box's changed event
                box.PasswordChanged -= HandlePasswordChanged;

                var newPassword = (string)e.NewValue;

                if (!GetUpdatingPassword(box))
                {
                    box.Password = newPassword;
                }

                box.PasswordChanged += HandlePasswordChanged;
            }
        }

        /// <summary>
        /// The set updating password.
        /// </summary>
        /// <param name="dp">
        /// The dp.
        /// </param>
        /// <param name="value">
        /// The value.
        /// </param>
        private static void SetUpdatingPassword(DependencyObject dp, bool value)
        {
            dp.SetValue(UpdatingPassword, value);
        }

        #endregion
    }
}