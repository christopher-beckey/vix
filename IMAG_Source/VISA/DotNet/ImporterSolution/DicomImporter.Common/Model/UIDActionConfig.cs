/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 06/19/2012
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

namespace DicomImporter.Common.Model
{
    using System;

    /// <summary>
    /// Holds one UIDActionConfig record
    /// </summary>
    [Serializable]
    public class UIDActionConfig
    {
        /// <summary>
        /// Gets or sets the uid.
        /// </summary>
        /// <value>
        /// The uid.
        /// </value>
        public string Uid { get; set; }

        /// <summary>
        /// Gets or sets the description.
        /// </summary>
        /// <value>
        /// The description.
        /// </value>
        public string Description { get; set; }

        /// <summary>
        /// Gets or sets the action code.
        /// </summary>
        /// <value>
        /// The action code.
        /// </value>
        public string ActionCode { get; set; }

        /// <summary>
        /// Gets or sets the action comment.
        /// </summary>
        /// <value>
        /// The action comment.
        /// </value>
        public string ActionComment { get; set; }

        /// <summary>
        /// Gets or sets the icon filename.
        /// </summary>
        /// <value>
        /// The icon filename.
        /// </value>
        public string IconFilename { get; set; }
    }
}
