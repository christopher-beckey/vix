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
    using System.Linq;
    using System.Xml.Serialization;

    using ImagingClient.Infrastructure.Model;

    /// <summary>
    /// Represents an importer work item details instance.
    /// </summary>
    [Serializable]
    public class ImporterWorkItemDetails : INotifyPropertyChanged
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ImporterWorkItemDetails"/> class.
        /// </summary>
        public ImporterWorkItemDetails()
        {
            this.Reconciliations = new ObservableCollection<Reconciliation>();
            this.DicomDirPaths = new ObservableCollection<string>();
            this.NonDicomFiles = new ObservableCollection<NonDicomFile>();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ImporterWorkItemDetails"/> class.
        /// </summary>
        /// <param name="studies">
        /// The studies.
        /// </param>
        public ImporterWorkItemDetails(ObservableCollection<Study> studies)
        {
            this.Reconciliations = new ObservableCollection<Reconciliation>();
            this.DicomDirPaths = new ObservableCollection<string>();
            this.NonDicomFiles = new ObservableCollection<NonDicomFile>();
            this.Studies = studies;
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
        /// Gets a value indicating whether AnyStudiesToDelete.
        /// </summary>
        [XmlIgnore]
        public bool AnyStudiesToDelete
        {
            get
            {
                return this.StudyDeletionCount > 0;
            }
        }

        /// <summary>
        /// Gets or sets CurrentStudy.
        /// </summary>
        [XmlIgnore]
        public Study CurrentStudy { get; set; }

        /// <summary>
        /// Gets or sets DicomCorrectReason.
        /// </summary>
        public string DicomCorrectReason { get; set; }

        /// <summary>
        /// Gets or sets a collection holding the paths of DICOMDIR 
        /// files for the media bundle.
        /// </summary>
        /// <value>
        /// The dicom dir paths.
        /// </value>
        public ObservableCollection<string> DicomDirPaths { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether ImportStatusChecked.
        /// </summary>
        [XmlIgnore]
        public bool ImportStatusChecked { get; set; }

        /// <summary>
        /// Gets or sets InstrumentNickName.
        /// </summary>
        public string InstrumentNickName { get; set; }

        /// <summary>
        /// Gets or sets InstrumentService.
        /// </summary>
        public string InstrumentService { get; set; }

        /// <summary>
        /// Gets or sets InstrumentAcqLocation.
        /// </summary>
        public string InstrumentAcqLocation { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether IsMediaBundleStaged.
        /// </summary>
        public bool IsMediaBundleStaged { get; set; }

        /// <summary>
        /// Gets or sets LocalSourcePath.
        /// </summary>
        [XmlIgnore]
        public string LocalSourcePath { get; set; }

        /// <summary>
        /// Gets or sets MediaBundleSignature.
        /// </summary>
        [XmlIgnore]
        public string MediaBundleSignature { get; set; }

        /// <summary>
        /// Gets or sets MediaBundleStagingRootDirectory.
        /// </summary>
        public string MediaBundleStagingRootDirectory { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether MediaHasDicomDir.
        /// </summary>
        public bool MediaHasDicomDir { get; set; }

        /// <summary>
        /// Gets or sets MediaValidationMessage.
        /// </summary>
        public string MediaValidationMessage { get; set; }

        /// <summary>
        /// Gets or sets MediaValidationStatusCode.
        /// </summary>
        public int MediaValidationStatusCode { get; set; }

        /// <summary>
        /// Gets or sets NetworkLocationIen.
        /// </summary>
        public string NetworkLocationIen { get; set; }

        /// <summary>
        /// Gets or sets the non DICOM files.
        /// </summary>
        public ObservableCollection<NonDicomFile> NonDicomFiles { get; set; }

        /// <summary>
        /// Gets or sets the reconciler notes.
        /// </summary>
        public string ReconcilerNotes { get; set; }

        /// <summary>
        /// Gets or sets Reconciliations.
        /// </summary>
        public ObservableCollection<Reconciliation> Reconciliations { get; set; }

        /// <summary>
        /// Gets or sets ReconcilingTechnicianDuz.
        /// </summary>
        public string ReconcilingTechnicianDuz { get; set; }

        /// <summary>
        /// Gets or sets Studies.
        /// </summary>
        public ObservableCollection<Study> Studies { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether StudiesLoaded.
        /// </summary>
        [XmlIgnore]
        public bool StudiesLoaded { get; set; }

        /// <summary>
        /// Gets StudyDeletionCount.
        /// </summary>
        [XmlIgnore]
        public int StudyDeletionCount
        {
            get
            {
                if (this.Studies == null)
                {
                    return 0;
                }

                return this.Studies.Count(study => ((study != null) ? study.ToBeDeletedOnly : false));
            }
        }

        /// <summary>
        /// Gets or sets VaPatientFromStaging.
        /// </summary>
        public Patient VaPatientFromStaging { get; set; }

        /// <summary>
        /// Gets or sets WorkstationName.
        /// </summary>
        public string WorkstationName { get; set; }

        /// <summary>
        /// Gets or sets the import error message.
        /// </summary>
        /// <value>
        /// The import error message.
        /// </value>
        public string ImportErrorMessage { get; set; }

        #endregion
    }
}