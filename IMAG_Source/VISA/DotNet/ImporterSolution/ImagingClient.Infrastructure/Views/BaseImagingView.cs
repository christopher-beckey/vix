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
namespace ImagingClient.Infrastructure.Views
{
    using System;
    using System.Windows.Controls;

    using Microsoft.Practices.Prism;

    /// <summary>
    /// The base imaging view.
    /// </summary>
    public class BaseImagingView : UserControl, IActiveAware
    {
        #region Constants and Fields

        /// <summary>
        /// The is active.
        /// </summary>
        private bool isActive;

        #endregion

        #region Public Events

        /// <summary>
        /// The is active changed.
        /// </summary>
        public event EventHandler IsActiveChanged;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets a value indicating whether IsActive.
        /// </summary>
        public bool IsActive
        {
            get
            {
                return this.isActive;
            }

            set
            {
                this.isActive = value;
                var viewModelActiveAware = this.DataContext as IActiveAware;
                if (viewModelActiveAware != null)
                {
                    viewModelActiveAware.IsActive = value;
                }
            }
        }

        #endregion
    }
}