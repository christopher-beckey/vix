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
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Xml.Serialization;

    using ImagingClient.Infrastructure.Model;

    /// <summary>
    /// The reconciliation.
    /// </summary>
    [Serializable]
    public class Reconciliation : INotifyPropertyChanged
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="Reconciliation"/> class.
        /// </summary>
        public Reconciliation()
        {
            NonDicomFiles = new ObservableCollection<NonDicomFile>();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="Reconciliation"/> class.
        /// </summary>
        /// <param name="study">
        /// The study.
        /// </param>
        public Reconciliation(Study study)
        {
            this.Study = study;
            NonDicomFiles = new ObservableCollection<NonDicomFile>();
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
        /// Gets or sets a value indicating whether CreateRadiologyOrder.
        /// </summary>
        public bool CreateRadiologyOrder { get; set; }

        /// <summary>
        /// Gets or sets the imaging location.
        /// </summary>
        public ImagingLocation ImagingLocation { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether IsPatientFromStaging.
        /// </summary>
        public bool IsPatientFromStaging { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether IsPatientPreviouslyResolved.
        /// </summary>
        public bool IsPatientPreviouslyResolved { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether IsReconciliationComplete.
        /// </summary>
        public bool IsReconciliationComplete { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether IsStudyToBeReadByVaRadiologist.
        /// </summary>
        public bool IsStudyToBeReadByVaRadiologist { get; set; }

        /// <summary>
        /// Gets or sets the non DICOM files.
        /// </summary>
        public ObservableCollection<NonDicomFile> NonDicomFiles { get; set; }

        /// <summary>
        /// Gets or sets Order.
        /// </summary>
        public Order Order { get; set; }

        /// <summary>
        /// Gets or sets Orders.
        /// </summary>
        [XmlIgnore]
        public ObservableCollection<Order> Orders { get; set; }

        /// <summary>
        /// Gets or sets Patient.
        /// </summary>
        public Patient Patient { get; set; }

        /// <summary>
        /// Gets or sets Study.
        /// </summary>
        [XmlIgnore]
        public Study Study { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether UseExistingOrder.
        /// </summary>
        public bool UseExistingOrder { get; set; }

        #endregion
    }
}