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
namespace ImagingClient.Infrastructure.Commands
{
    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// Application wide composite commands
    /// </summary>
    public static class CompositeCommands
    {
        #region Constants and Fields
          
        /// <summary>
        /// Command to logout of the application
        /// </summary>
        public static readonly CompositeCommand LogoutCommand = new CompositeCommand();

        /// <summary>
        /// Command to navigate to a different view
        /// </summary>
        public static readonly CompositeCommand NavigateCommand = new CompositeCommand();

        /// <summary>
        /// Command to shutdown the application
        /// </summary>
        public static readonly CompositeCommand ShutdownCommand = new CompositeCommand();

        /// <summary>
        /// Command to clear a reconciliation after timeout.
        /// </summary>
        public static readonly CompositeCommand TimeoutClearReconcileCommand = new CompositeCommand();

        #endregion
    }
}