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
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Text;
    using System.Xml.Serialization;

    using ImagingClient.Infrastructure.Model;
    using ImagingClient.Infrastructure.Utilities;

    using log4net;

    /// <summary>
    /// The study.
    /// </summary>
    [Serializable]
    public class Study : INotifyPropertyChanged
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(Study));

        // The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)

        /// <summary>
        /// The image counts by modality.
        /// </summary>
        private readonly Dictionary<string, int> imageCountsByModality = new Dictionary<string, int>();

        /// <summary>
        /// The image statistics.
        /// </summary>
        private string imageStatistics;

        /// <summary>
        /// The import status.
        /// </summary>
        private string importStatus;

        /// <summary>
        /// The modality codes.
        /// </summary>
        private string modalityCodes;

        /// <summary>
        /// The reconciled for import.
        /// </summary>
        private bool reconciledForImport;

        /// <summary>
        /// The study time.
        /// </summary>
        private string studyTime;

        /// <summary>
        /// The to be deleted only.
        /// </summary>
        private bool toBeDeletedOnly;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="Study"/> class.
        /// </summary>
        public Study()
        {
            this.OriginIndex = string.Empty;
            this.Series = new ObservableCollection<Series>();
        }

        #endregion

        #region Public Events

        /// <summary>
        /// The property changed.
        /// </summary>
        [field: NonSerialized]//P237 - Critical fix - Avoid  arbitrary code execution vulnerability on or after the deserialization of this class.
        public event PropertyChangedEventHandler PropertyChanged;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets AccessionNumber.
        /// </summary>
        public string AccessionNumber { get; set; }


        //BEGIN-Handle events for CompletelyImported status(p289-OITCOPondiS)
        private bool _CompletelyImported { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether CompletelyImported.
        /// </summary>
        [XmlIgnore]
        public bool CompletelyImported
        {
            get { return _CompletelyImported; }
            set
            {
                _CompletelyImported = value;
                this.RaisePropertyChanged("CompletelyImported");
            }
        }

        //END(p289-OITCOPondiS)

        ///// <summary>
        ///// Gets or sets a value indicating whether CompletelyImported.
        ///// </summary>
        //[XmlIgnore]
        //public bool CompletelyImported { get; set; }





        /// <summary>
        /// Gets or sets Description.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// Gets DisplayName.
        /// </summary>
        public string DisplayName
        {
            get
            {
                return "Study " + this.IdInMediaBundle;
            }
        }

        /// <summary>
        /// Gets Facility.
        /// </summary>
        [XmlIgnore]
        public string Facility
        {
            get
            {
                string facility = string.Empty;
                try
                {
                    facility = this.Series[0].Facility;
                }
                catch (Exception e)
                {
                    Logger.Info("Unable to obtain facility information from this study: " + e.Message, e);
                }

                return facility;
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether FailedImport.
        /// </summary>
        public bool FailedImport { get; set; }

        /// <summary>
        /// Gets FormattedStudyDate.
        /// </summary>
        [XmlIgnore]
        public string FormattedStudyDate
        {
            get
            {
                return DateTimeUtilities.ReformatDicomDateAsShortDate(this.StudyDate);
            }
        }

        /// <summary>
        /// Gets FormattedStudyTime.
        /// </summary>
        [XmlIgnore]
        public string FormattedStudyTime
        {
            get
            {
                return DateTimeUtilities.ReformatDicomTimeAsShortTime(this.StudyTime);
            }
        }

        /// <summary>
        /// Gets or sets IdInMediaBundle.
        /// </summary>
        public int IdInMediaBundle { get; set; }

        /// <summary>
        /// Gets ImageStatistics.
        /// </summary>
        [XmlIgnore]
        public string ImageStatistics
        {
            get
            {
                if (this.imageStatistics == null)
                {
                    this.imageStatistics = string.Empty;
                    foreach (Series series in this.Series)
                    {
                        string modality = series.Modality + string.Empty;
                        if (string.IsNullOrEmpty(modality))
                        {
                            modality = "Unknown Modality";
                        }

                        int imageCount = series.SopInstances.Count;

                        if (this.imageCountsByModality.ContainsKey(modality))
                        {
                            // We've already seen this modality. Add on the new image count
                            this.imageCountsByModality[modality] += imageCount;
                        }
                        else
                        {
                            // New Modality. Just map it to the count of images
                            this.imageCountsByModality.Add(modality, imageCount);
                        }
                    }

                    // Now that we've got all the image stats by modality, build the string
                    var sb = new StringBuilder();
                    foreach (string modality in this.imageCountsByModality.Keys)
                    {
                        if (sb.Length > 0)
                        {
                            sb.AppendLine();
                        }

                        sb.Append(modality + "=" + this.imageCountsByModality[modality]);
                    }

                    this.imageStatistics = sb.ToString();
                }

                return this.imageStatistics;
            }
        }

        /// <summary>
        /// Gets or sets the import error message.
        /// </summary>
        /// <value>
        /// The import error message.
        /// </value>
        public string ImportErrorMessage { get; set; }


            /// <summary>
        /// Gets or sets ImportStatus.
        /// </summary>
        public string ImportStatus
        {
            get
            {
                this.NumberOfImagesAlreadyImported = 0;
                this.TotalNumberOfImagesInStudy = 0;

                foreach (Series series in this.Series)
                {
                    foreach (SopInstance instance in series.SopInstances)
                    {
                        this.TotalNumberOfImagesInStudy++;
                        if (instance.IsImportedSuccessfully)
                        {
                            this.NumberOfImagesAlreadyImported++;
                        }
                    }
                }

                if (this.NumberOfImagesAlreadyImported == this.TotalNumberOfImagesInStudy
                    && this.TotalNumberOfImagesInStudy > 0)
                {
                    this.importStatus = ImportStatuses.Complete;
                }
                else if (this.NumberOfImagesAlreadyImported > 0)
                {
                    this.importStatus = ImportStatuses.Partial;
                }
                else
                {
                    this.importStatus = string.Empty;
                }

                return this.importStatus;
            }

            set
            {
                this.importStatus = value;
                this.RaisePropertyChanged("ImportStatus");
            }
        }

        /// <summary>
        /// Gets InstitutionAddress.
        /// </summary>
        [XmlIgnore]
        public string InstitutionAddress
        {
            get
            {
                string institutionAddress = string.Empty;
                try
                {
                    institutionAddress = this.Series[0].InstitutionAddress;
                }
                catch (Exception e)
                {
                    Logger.Info("Unable to obtain institution address information from this study: " + e.Message, e);
                }

                return institutionAddress;
            }
        }

        /// <summary>
        /// Gets or sets ModalitiesInStudy.
        /// </summary>
        public string ModalitiesInStudy { get; set; }

        /// <summary>
        /// Gets ModalityCodes.
        /// </summary>
        [XmlIgnore]
        public string ModalityCodes
        {
            get
            {
                if (string.IsNullOrEmpty(this.modalityCodes))
                {
                    var modalities = new HashSet<string>();
                    foreach (Series series in this.Series)
                    {
                        if (!modalities.Contains(series.Modality))
                        {
                            if (!string.IsNullOrEmpty(this.modalityCodes))
                            {
                                this.modalityCodes += ", ";
                            }

                            this.modalityCodes += series.Modality;

                            // Add it to the set
                            modalities.Add(series.Modality);
                        }
                    }
                }

                return this.modalityCodes;
            }
        }

        /// <summary>
        /// Gets or sets NumberOfImagesAlreadyImported.
        /// </summary>
        public int NumberOfImagesAlreadyImported { get; set; }

        /// <summary>
        /// Gets NumberOfImagesAvailableToImport.
        /// </summary>
        public int NumberOfImagesAvailableToImport
        {
            get
            {
                return this.TotalNumberOfImagesInStudy - this.NumberOfImagesAlreadyImported;
            }
        }

        /// <summary>
        /// Gets or sets OriginIndex.
        /// </summary>
        public string OriginIndex { get; set; }



        //BEGIN-Handle events for PartiallyImported status(p289-OITCOPondiS)
        private bool _PartiallyImported { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether CompletelyImported.
        /// </summary>
        [XmlIgnore]
        public bool PartiallyImported
        {
            get { return _PartiallyImported; }
            set
            {
                _PartiallyImported = value;
                this.RaisePropertyChanged("PartiallyImported");
            }
        }



        ///// <summary>
        ///// Gets or sets a value indicating whether PartiallyImported.
        ///// </summary>
        //[XmlIgnore]
        //public bool PartiallyImported { get; set; }

        /// <summary>
        /// Gets or sets Patient.
        /// </summary>
        public Patient Patient { get; set; }

        /// <summary>
        /// Gets or sets PreviouslyReconciledOrder.
        /// </summary>
        public Order PreviouslyReconciledOrder { get; set; }

        /// <summary>
        /// Gets or sets PreviouslyReconciledPatient.
        /// </summary>
        public Patient PreviouslyReconciledPatient { get; set; }

        /// <summary>
        /// Gets or sets Procedure.
        /// </summary>
        public string Procedure { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether ReconciledForImport.
        /// </summary>
        [XmlIgnore]
        public bool ReconciledForImport
        {
            get
            {
                bool isReconciled;
                if (this.ToBeDeletedOnly)
                {
                    isReconciled = false;
                }
                else
                {
                    isReconciled = this.reconciledForImport;
                }

                return isReconciled;
            }

            set
            {
                this.reconciledForImport = value;
                this.RaisePropertyChanged("ReconciledForImport");
            }
        }

        /// <summary>
        /// Gets or sets Reconciliation.
        /// </summary>
        public Reconciliation Reconciliation { get; set; }

        /// <summary>
        /// Gets ReconciliationStatus.
        /// </summary>
        [XmlIgnore]
        public string ReconciliationStatus
        {
            get
            {
                var statuses = new List<string>();

                // Only check other statuses if we're not deleting the study
                if (!this.ToBeDeletedOnly)
                {
                    // This study has a reconciliation, so show the I indicating
                    // it will be imported
                    if (this.Reconciliation != null)
                    {
                        this.ReconciledForImport = true;
                    }

                    // If the study is already completely or partially imported, show that status as well
                    if (!string.IsNullOrEmpty(this.ImportStatus))
                    {
                        if (this.ImportStatus.Equals(ImportStatuses.Complete))
                        {
                            this.CompletelyImported = true;
                        }

                        if (this.ImportStatus.Equals(ImportStatuses.Partial))
                        {
                            this.PartiallyImported = true;
                        }
                    }
                }

                string statusValue = null;
                foreach (string status in statuses)
                {
                    if (!string.IsNullOrEmpty(statusValue))
                    {
                        statusValue += ",";
                    }

                    statusValue += status;
                }

                // return statusValue;
                return string.Empty;
            }
        }

        /// <summary>
        /// Gets or sets ReferringPhysician.
        /// </summary>
        public string ReferringPhysician { get; set; }

        /// <summary>
        /// Gets or sets Series.
        /// </summary>
        public ObservableCollection<Series> Series { get; set; }

        /// <summary>
        /// Gets or sets StudyDate.
        /// </summary>
        public string StudyDate { get; set; }

        /// <summary>
        /// Gets or sets StudyTime.
        /// </summary>
        public string StudyTime
        {
            get
            {
                // If the study time is null, empty, or all zeros, set it to one minute
                // after midnight
                if (string.IsNullOrEmpty(this.studyTime) || this.studyTime.Equals("00") || this.studyTime.Equals("0000")
                    || this.studyTime.Equals("000000"))
                {
                    this.studyTime = "000100";
                }

                return this.studyTime;
            }

            set
            {
                this.studyTime = value;
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether ToBeDeletedOnly.
        /// </summary>
        public bool ToBeDeletedOnly
        {
            get
            {
                return this.toBeDeletedOnly;
            }

            set
            {
                this.toBeDeletedOnly = value;
                this.RaisePropertyChanged("ToBeDeletedOnly");
                this.RaisePropertyChanged("ReconciledForImport");
            }
        }

        /// <summary>
        /// Gets or sets TotalNumberOfImagesInStudy.
        /// </summary>
        public int TotalNumberOfImagesInStudy { get; set; }

        /// <summary>
        /// Gets or sets Uid.
        /// </summary>
        public string Uid { get; set; }

        /// <summary>
        /// Gets or sets UserSuppliedStudyDate.
        /// </summary>
        [XmlIgnore]
        public string UserSuppliedStudyDate { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// The refresh import status.
        /// </summary>
        public void RefreshImportStatus()
        {
            PropertyChangedEventHandler handler = this.PropertyChanged;
            if (handler != null)
            {
                handler.Invoke(this, new PropertyChangedEventArgs("ImportStatus"));
                handler.Invoke(this, new PropertyChangedEventArgs("ReconciliationStatus"));
            }
        }

        /// <summary>
        /// The renumber series and instances.
        /// </summary>
        public void RenumberSeriesAndInstances()
        {
            int seriesNumber = 1;

            foreach (Series series in this.Series)
            {
                // Set the series number
                series.SeriesNumber = seriesNumber.ToString();

                // Number the images in the series
                int imageNumber = 1;
                foreach (SopInstance instance in series.SopInstances)
                {
                    instance.ImageNumber = imageNumber.ToString();
                    imageNumber++;
                }

                // Increment the series number
                seriesNumber++;
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// The raise property changed.
        /// </summary>
        /// <param name="property">
        /// The property.
        /// </param>
        private void RaisePropertyChanged(string property)
        {
            PropertyChangedEventHandler handler = this.PropertyChanged;
            if (handler != null)
            {
                handler.Invoke(this, new PropertyChangedEventArgs(property));
            }
        }

        #endregion
    }
}