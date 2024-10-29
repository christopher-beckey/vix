/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/12/2013
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
namespace ImagingClient.Infrastructure.Model
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    /// <summary>
    /// The Application Timeout Parameters
    /// </summary>
    [Serializable]
    public class ApplicationTimeoutParameters
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ApplicationTimeoutParameters"/> class.
        /// </summary>
        public ApplicationTimeoutParameters()
        {
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the Timeout in Seconds.
        /// </summary>
        public int TimeoutInSeconds { get; set; }

        #endregion
    }
}