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

    /// <summary>
    /// The importer work item.
    /// </summary>
    [Serializable]
    public class ImporterWorkItem : INotifyPropertyChanged
    {
        #region Constants and Fields

        /// <summary>
        /// The key.
        /// </summary>
        private string key;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ImporterWorkItem"/> class.
        /// </summary>
        public ImporterWorkItem()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ImporterWorkItem"/> class.
        /// </summary>
        /// <param name="source">
        /// The source of the work item.
        /// </param>
        /// <param name="patientName">
        /// The patient name associated with the work item.
        /// </param>
        /// <param name="status">
        /// The status of the work item.
        /// </param>
        /// <param name="lastModifiedBy">
        /// The individual or system that last modified the work item.
        /// </param>
        public ImporterWorkItem(string source, string patientName, string status, string lastModifiedBy)
        {
            this.Source = source;
            this.Service = String.Empty;
            this.Modality = String.Empty;
            this.Procedure = String.Empty;
            this.PatientName = patientName;
            this.Status = status;
            this.UpdatingUser = lastModifiedBy;
        }

        public ImporterWorkItem(string source, string service, string modality, string procedure, string patientName, string status, string lastModifiedBy)
        {
            this.Source = source;
            this.Service = service;
            this.Modality = modality;
            this.Procedure = procedure;
            this.PatientName = patientName;
            this.Status = status;
            this.UpdatingUser = lastModifiedBy;
        }

        #endregion

        #region Public Events

        /// <summary>
        /// The property changed event.
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </summary>
        [field: NonSerialized]//P237 - Critical fix - Avoid  arbitrary code execution vulnerability on or after the deserialization of this class.
        public event PropertyChangedEventHandler PropertyChanged;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets CreatingApplication.
        /// </summary>
        public string CreatingApplication { get; set; }

        /// <summary>
        /// Gets the creating entity.
        /// </summary>
        [XmlIgnore]
        public string CreatedBy
        {
            get
            {
                return !string.IsNullOrEmpty(this.CreatingUserDisplayName) ? this.CreatingUserDisplayName : this.CreatingApplication;
            }
        }

        /// <summary>
        /// Gets or sets CreatingUser.
        /// </summary>
        public string CreatingUser { get; set; }

        /// <summary>
        /// Gets or sets CreatingUserDisplayName.
        /// </summary>
        public string CreatingUserDisplayName { get; set; }

        /// <summary>
        /// Gets or sets CreatedDate.
        /// </summary>
        public string CreatedDate { get; set; }

        /// <summary>
        /// Gets or sets DicomCorrectReason.
        /// </summary>
        public string DicomCorrectReason { get; set; }

        /// <summary>
        /// Gets or sets Id.
        /// </summary>
        public int Id { get; set; }

        /// <summary>
        /// Gets or sets Key.
        /// </summary>
        /// <exception cref="InvalidOperationException">
        /// If key is specified, return the key. Otherwise, try to return the ID as a string, as long
        /// as it's greater than zero. If neither the key nor the ID is populated, raise an exception.
        /// </exception>
        [XmlIgnore]
        public string Key
        {
            get
            {
                // Try to return explicitly set key first
                if (!string.IsNullOrEmpty(this.key))
                {
                    return this.key;
                }

                // If no explicity set key, return the Id if greater than 0
                if (this.Id > 0)
                {
                    return this.Id.ToString();
                }

                // If we made it here, the Id is zero, but no one has set the key. Throw an exception.
                throw new InvalidOperationException("Key must be set explicity or Id must have a value greater than 0");
            }

            set
            {
                this.key = value;
            }
        }

        /// <summary>
        /// Gets the last modifying entity.
        /// </summary>
        [XmlIgnore]
        public string LastModifiedBy
        {
            get
            {
                return !string.IsNullOrEmpty(this.UpdatingUserDisplayName) ? this.UpdatingUserDisplayName : this.UpdatingApplication;
            }
        }

        /// <summary>
        /// Gets or sets the media category.
        /// </summary>
        public MediaCategory MediaCategory { get; set; }

        /// <summary>
        /// Gets or sets UpdatingApplication.
        /// </summary>
        public string UpdatingApplication { get; set; }

        /// <summary>
        /// Gets or sets UpdatingUser.
        /// </summary>
        public string UpdatingUser { get; set; }

        /// <summary>
        /// Gets or sets UpdatingUserDisplayName.
        /// </summary>
        public string UpdatingUserDisplayName { get; set; }

        /// <summary>
        /// Gets or sets LastUpdateDate.
        /// </summary>
        public string LastUpdateDate { get; set; }

        /// <summary>
        /// Gets or sets OriginIndex.
        /// </summary>
        public string OriginIndex { get; set; }

        /// <summary>
        /// Gets OriginIndexDescription.
        /// </summary>
        [XmlIgnore]
        public string OriginIndexDescription
        {
            get
            {
                OriginIndex index = Model.OriginIndex.GetOriginIndexByCode(this.OriginIndex);

                if (index != null)
                {
                    return index.Description;
                }

                return string.Empty;
            }
        }

        /// <summary>
        /// Gets or sets OriginalStatus.
        /// </summary>
        [XmlIgnore]
        public string OriginalStatus { get; set; }

        /// <summary>
        /// Gets or sets PatientName.
        /// </summary>
        public string PatientName { get; set; }

        /// <summary>
        /// Gets or sets PlaceId.
        /// </summary>
        public string PlaceId { get; set; }

        /// <summary>
        /// Gets or sets Source.
        /// </summary>
        public string Source { get; set; }

        /// <summary>
        /// Gets or sets Status.
        /// </summary>
        public string Status { get; set; }

        /// <summary>
        /// Gets or sets Subtype.
        /// </summary>
        public string Subtype { get; set; }

        /// <summary>
        /// Gets or sets Type.
        /// </summary>
        public string Type { get; set; }

        /// <summary>
        /// Gets or sets Service.
        /// </summary>
        public string Service { get; set; }

        /// <summary>
        /// Gets or sets Modality.
        /// </summary>
        public string Modality { get; set; }

        /// <summary>
        /// Gets or sets Procedure.
        /// </summary>
        public string Procedure { get; set; }

        /// <summary>
        /// Gets or sets WorkItemDetails.
        /// </summary>
        public ImporterWorkItemDetails WorkItemDetails { get; set; }

        /// <summary>
        /// Gets or sets WorkItemDetailsReference.
        /// </summary>
        public ImporterWorkItemDetailsReference WorkItemDetailsReference { get; set; }

        /// <summary>
        /// Gets or sets LastIenFlag.
        /// </summary>
        public string LastIenFlag { get; set; }
        #endregion
    }
}