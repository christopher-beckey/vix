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
namespace DicomImporter.Common.Model
{
    using System;
    using System.ComponentModel;
    using System.Xml.Serialization;
    //using System.Runtime.Serialization; [XmlIgnoreAttribute]

    /// <summary>
    /// Represents an imaging location.
    /// </summary>
    [Serializable]
    public class ImagingLocation : INotifyPropertyChanged
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ImagingLocation"/> class.
        /// </summary>
        public ImagingLocation()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ImagingLocation"/> class.
        /// </summary>
        /// <param name="id">
        /// The id.
        /// </param>
        /// <param name="name">
        /// The name.
        /// </param>
        public ImagingLocation(int id, string name)
        {
            this.Id = id;
            this.Name = name;
        }

        #endregion

        #region Public Events

        /// <summary>
        /// The property changed event
        /// </summary>
        [field: NonSerialized]//P237 - Critical fix - Avoid  arbitrary code execution vulnerability on or after the deserialization of this class.
        public event PropertyChangedEventHandler PropertyChanged;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the credit method.
        /// </summary>
        public string CreditMethod { get; set; }

        /// <summary>
        /// Gets or sets the Id.
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets the Name.
        /// </summary>
        public string Name { get; set; }

        #endregion
    }
}