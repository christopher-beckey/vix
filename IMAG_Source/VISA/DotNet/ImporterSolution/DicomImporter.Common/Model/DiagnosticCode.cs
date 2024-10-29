/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/17/2013
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
namespace DicomImporter.Common.Model
{
    using System;
    using System.Xml.Serialization;

    /// <summary>
    /// The Diagnostic Code
    /// </summary>
    [Serializable]
    public class DiagnosticCode
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="DiagnosticCode" /> class.
        /// </summary>
        public DiagnosticCode()
        {
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the Name.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the description.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// Gets or sets the id.
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Gets the display name.
        /// </summary>
        [XmlIgnore]
        public string DisplayName
        {
            get
            {
                return this.Name + " (" + Id + ")";
            }
        }

        #endregion
    }
}