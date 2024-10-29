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
namespace ImagingClient.Infrastructure.Extensions
{
    using System;
    using System.Windows;
    using System.Windows.Interop;
    using System.Windows.Media;

    using IWin32Window = System.Windows.Forms.IWin32Window;

    /// <summary>
    /// The wpf window extensions.
    /// </summary>
    public static class WpfWindowExtensions
    {
        #region Public Methods

        /// <summary>
        /// Gets a window handle.
        /// </summary>
        /// <param name="visual">
        /// The visual.
        /// </param>
        /// <returns>A Win32 window handle</returns>
        public static IWin32Window GetIWin32Window(this Visual visual)
        {
            var source = PresentationSource.FromVisual(visual) as HwndSource;
            if (source != null)
            {
                IWin32Window win = new OldWindow(source.Handle);
                return win;
            }

            return null;
        }

        #endregion

        /// <summary>
        /// The old window.
        /// </summary>
        private class OldWindow : IWin32Window
        {
            #region Constants and Fields

            /// <summary>
            /// The _handle.
            /// </summary>
            private readonly IntPtr handle;

            #endregion

            #region Constructors and Destructors

            /// <summary>
            /// Initializes a new instance of the <see cref="OldWindow"/> class.
            /// </summary>
            /// <param name="handle">
            /// The handle.
            /// </param>
            public OldWindow(IntPtr handle)
            {
                this.handle = handle;
            }

            #endregion

            #region Explicit Interface Properties

            /// <summary>
            /// Gets Handle.
            /// </summary>
            IntPtr IWin32Window.Handle
            {
                get
                {
                    return this.handle;
                }
            }

            #endregion
        }
    }
}