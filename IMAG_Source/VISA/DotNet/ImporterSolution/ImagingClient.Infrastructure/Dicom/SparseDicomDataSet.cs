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
namespace ImagingClient.Infrastructure.Dicom
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Net;

    using global::Dicom;
    using global::Dicom.Data;

    using ImagingClient.Infrastructure.StorageDataSource;
    using ImagingClient.Infrastructure.Utilities;

    /// <summary>
    /// The sparse dicom data set.
    /// </summary>
    public class SparseDicomDataSet : IDicomDataSet
    {
        // Patient
        #region Constants and Fields

        /// <summary>
        /// The accession number tag.
        /// </summary>
        private const string AccessionNumberTag = "0x0008,0x0050";

        /// <summary>
        /// The facility tag.
        /// </summary>
        private const string FacilityTag = "0x0008,0x0080";

        /// <summary>
        /// The image number tag.
        /// </summary>
        private const string ImageNumberTag = "0x0020,0x0013";

        /// <summary>
        /// The institution address tag.
        /// </summary>
        private const string InstitutionAddressTag = "0x0008,0x0081";

        /// <summary>
        /// The modality tag.
        /// </summary>
        private const string ModalityTag = "0x0008,0x0060";

        /// <summary>
        /// The number of frames tag.
        /// </summary>
        private const string NumberOfFramesTag = "0x0028,0x0008";

        /// <summary>
        /// The patient birth date tag.
        /// </summary>
        private const string PatientBirthDateTag = "0x0010,0x0030";

        /// <summary>
        /// The patient id tag.
        /// </summary>
        private const string PatientIdTag = "0x0010,0x0020";

        /// <summary>
        /// The patient name tag.
        /// </summary>
        private const string PatientNameTag = "0x0010,0x0010";

        /// <summary>
        /// The patient sex tag.
        /// </summary>
        private const string PatientSexTag = "0x0010,0x0040";

        // Study

        /// <summary>
        /// The referring physician tag.
        /// </summary>
        private const string ReferringPhysicianTag = "0x0008,0x0090";

        /// <summary>
        /// The series date tag.
        /// </summary>
        private const string SeriesDateTag = "0x0008,0x0021";

        /// <summary>
        /// The series description tag.
        /// </summary>
        private const string SeriesDescriptionTag = "0x0008,0x103E";

        /// <summary>
        /// The series uid tag.
        /// </summary>
        private const string SeriesUidTag = "0x0020,0x000E";

        /// <summary>
        /// The sop class uid tag.
        /// </summary>
        private const string SopClassUidTag = "0x0008,0x0016";

        /// <summary>
        /// The sop instance uid tag.
        /// </summary>
        private const string SopInstanceUidTag = "0x0008,0x0018";

        /// <summary>
        /// The study date tag.
        /// </summary>
        private const string StudyDateTag = "0x0008,0x0020";

        /// <summary>
        /// The study description tag.
        /// </summary>
        private const string StudyDescriptionTag = "0x0008,0x1030";

        /// <summary>
        /// The study time tag.
        /// </summary>
        private const string StudyTimeTag = "0x0008,0x0030";

        /// <summary>
        /// The study uid tag.
        /// </summary>
        private const string StudyUidTag = "0x0020,0x000D";

        /// <summary>
        /// The transfer syntax uid tag.
        /// </summary>
        private const string TransferSyntaxUidTag = "0x0002,0x0010";

        /// <summary>
        /// The Performed Procedure Step Description tag.
        /// </summary>
        private const string PerformedProcedureStepDescriptionTag = "0x0040,0x0254";

        /// <summary>
        /// The tag value dictionary.
        /// </summary>
        private readonly Dictionary<string, string> tagValueDictionary = new Dictionary<string, string>();

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="SparseDicomDataSet"/> class.
        /// </summary>
        /// <param name="fileName">
        /// The file name.
        /// </param>
        /// <param name="serverShare">
        /// The server share.
        /// </param>
        /// <param name="username">
        /// The username.
        /// </param>
        /// <param name="password">
        /// The password.
        /// </param>
        public SparseDicomDataSet(string fileName, string serverShare, string username, string password)
        {
            NetworkConnection conn = null;
            try
            {
                if (serverShare.StartsWith("\\\\"))
                {
                    // Not a local drive. Open network connection
                    conn = NetworkConnection.GetNetworkConnection(
                        serverShare, new NetworkCredential(username, password));
                }

                this.ParseHeader(fileName);
            }
            finally
            {
                if (conn != null)
                {
                    conn.Dispose();
                }
            }
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="SparseDicomDataSet"/> class.
        /// </summary>
        /// <param name="fileName">
        /// The file name.
        /// </param>
        public SparseDicomDataSet(string fileName)
        {
            this.ParseHeader(fileName);
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets AccessionNumber.
        /// </summary>
        public string AccessionNumber
        {
            get
            {
                return this.GetTagValue(AccessionNumberTag);
            }
        }

        /// <summary>
        /// Gets a value indicating whether CanDisplayHeaderInfo.
        /// </summary>
        public bool CanDisplayHeaderInfo
        {
            get
            {
                return this.DataSetLoaded || this.FileMetaInfoRecordsLoaded;
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether DataSetLoaded.
        /// </summary>
        public bool DataSetLoaded { get; set; }

        /// <summary>
        /// Gets or sets ErrorMessage.
        /// </summary>
        public string ErrorMessage { get; set; }

        /// <summary>
        /// Gets Facility.
        /// </summary>
        public string Facility
        {
            get
            {
                return this.GetTagValue(FacilityTag);
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether FileMetaInfoRecordsLoaded.
        /// </summary>
        public bool FileMetaInfoRecordsLoaded { get; set; }

        /// <summary>
        /// Gets ImageNumber.
        /// </summary>
        public string ImageNumber
        {
            get
            {
                return this.GetTagValue(ImageNumberTag);
            }
        }

        /// <summary>
        /// Gets InstitutionAddress.
        /// </summary>
        public string InstitutionAddress
        {
            get
            {
                return this.GetTagValue(InstitutionAddressTag);
            }
        }

        /// <summary>
        /// Gets Modality.
        /// </summary>
        public string Modality
        {
            get
            {
                return this.GetTagValue(ModalityTag);
            }
        }

        /// <summary>
        /// Gets PerformedProcedureStepDescription.
        /// </summary>
        public string PerformedProcedureStepDescription
        {
            get
            {
                return this.GetTagValue(PerformedProcedureStepDescriptionTag);
            }
        }

        /// <summary>
        /// Gets NumberOfFrames.
        /// </summary>
        public string NumberOfFrames
        {
            get
            {
                return this.GetTagValue(NumberOfFramesTag);
            }
        }

        // Patient properties

        /// <summary>
        /// Gets PatientBirthDate.
        /// </summary>
        public string PatientBirthDate
        {
            get
            {
                string date = this.GetTagValue(PatientBirthDateTag);
                return string.IsNullOrEmpty(date) ? null : date;
            }
        }

        /// <summary>
        /// Gets PatientId.
        /// </summary>
        public string PatientId
        {
            get
            {
                return this.GetTagValue(PatientIdTag);
            }
        }

        /// <summary>
        /// Gets PatientName.
        /// </summary>
        public string PatientName
        {
            get
            {
                return this.GetTagValue(PatientNameTag);
            }
        }

        /// <summary>
        /// Gets PatientSex.
        /// </summary>
        public string PatientSex
        {
            get
            {
                return this.GetTagValue(PatientSexTag);
            }
        }

        // Study properties

        /// <summary>
        /// Gets ReferringPhysician.
        /// </summary>
        public string ReferringPhysician
        {
            get
            {
                return StringUtilities.ConvertDicomName(this.GetTagValue(ReferringPhysicianTag));
            }
        }

        // Series properties

        /// <summary>
        /// Gets SeriesDate.
        /// </summary>
        public string SeriesDate
        {
            get
            {
                string date = this.GetTagValue(SeriesDateTag);
                return string.IsNullOrEmpty(date) ? null : date;
            }
        }

        /// <summary>
        /// Gets SeriesDescription.
        /// </summary>
        public string SeriesDescription
        {
            get
            {
                return this.GetTagValue(SeriesDescriptionTag);
            }
        }

        /// <summary>
        /// Gets SeriesUid.
        /// </summary>
        public string SeriesUid
        {
            get
            {
                return this.GetTagValue(SeriesUidTag);
            }
        }

        /// <summary>
        /// Gets SopClassUid.
        /// </summary>
        public string SopClassUid
        {
            get
            {
                return this.GetTagValue(SopClassUidTag);
            }
        }

        /// <summary>
        /// Gets SopInstanceUid.
        /// </summary>
        public string SopInstanceUid
        {
            get
            {
                return this.GetTagValue(SopInstanceUidTag);
            }
        }

        /// <summary>
        /// Gets StudyDate.
        /// </summary>
        public string StudyDate
        {
            get
            {
                string date = this.GetTagValue(StudyDateTag);
                return string.IsNullOrEmpty(date) ? null : date;
            }
        }

        /// <summary>
        /// Gets StudyDescription.
        /// </summary>
        public string StudyDescription
        {
            get
            {
                return this.GetTagValue(StudyDescriptionTag);
            }
        }

        /// <summary>
        /// Gets StudyTime.
        /// </summary>
        public string StudyTime
        {
            get
            {
                string time = this.GetTagValue(StudyTimeTag);
                return string.IsNullOrEmpty(time) ? null : time;
            }
        }

        /// <summary>
        /// Gets StudyUid.
        /// </summary>
        public string StudyUid
        {
            get
            {
                return this.GetTagValue(StudyUidTag);
            }
        }

        /// <summary>
        /// Gets TransferSyntaxUid.
        /// </summary>
        public string TransferSyntaxUid
        {
            get
            {
                return this.GetTagValue(TransferSyntaxUidTag);
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Gets the tag value.
        /// </summary>
        /// <param name="tag">The tag.</param>
        /// <returns>The value for the specified tag</returns>
        private string GetTagValue(string tag)
        {
            string value = string.Empty;
            if (this.tagValueDictionary.ContainsKey(tag))
            {
                value = this.tagValueDictionary[tag];
            }

            return value;
        }

        /// <summary>
        /// The load sparse dictionary.
        /// </summary>
        /// <param name="fmi">
        /// The fmi.
        /// </param>
        /// <param name="dds">
        /// The dds.
        /// </param>
        private void LoadSparseDictionary(DcmFileMetaInfo fmi, DcmDataset dds)
        {
            try
            {
                if (dds != null)
                {
                    this.tagValueDictionary.Add(PatientNameTag, dds.GetValueString(DicomTags.PatientsName));
                    this.tagValueDictionary.Add(PatientIdTag, dds.GetValueString(DicomTags.PatientID));
                    this.tagValueDictionary.Add(PatientBirthDateTag, dds.GetValueString(DicomTags.PatientsBirthDate));
                    this.tagValueDictionary.Add(PatientSexTag, dds.GetValueString(DicomTags.PatientsSex));

                    this.tagValueDictionary.Add(StudyUidTag, dds.GetValueString(DicomTags.StudyInstanceUID));
                    this.tagValueDictionary.Add(StudyDateTag, dds.GetValueString(DicomTags.StudyDate));
                    this.tagValueDictionary.Add(StudyTimeTag, dds.GetValueString(DicomTags.StudyTime));
                    this.tagValueDictionary.Add(AccessionNumberTag, dds.GetValueString(DicomTags.AccessionNumber));
                    this.tagValueDictionary.Add(
                        ReferringPhysicianTag, dds.GetValueString(DicomTags.ReferringPhysiciansName));
                    this.tagValueDictionary.Add(StudyDescriptionTag, dds.GetValueString(DicomTags.StudyDescription));

                    this.tagValueDictionary.Add(SeriesUidTag, dds.GetValueString(DicomTags.SeriesInstanceUID));
                    this.tagValueDictionary.Add(SeriesDateTag, dds.GetValueString(DicomTags.SeriesDate));
                    this.tagValueDictionary.Add(SeriesDescriptionTag, dds.GetValueString(DicomTags.SeriesDescription));
                    this.tagValueDictionary.Add(ModalityTag, dds.GetValueString(DicomTags.Modality));
                    this.tagValueDictionary.Add(PerformedProcedureStepDescriptionTag, dds.GetValueString(DicomTags.PerformedProcedureStepDescription));
                    this.tagValueDictionary.Add(FacilityTag, dds.GetValueString(DicomTags.InstitutionName));
                    this.tagValueDictionary.Add(InstitutionAddressTag, dds.GetValueString(DicomTags.InstitutionAddress));

                    this.tagValueDictionary.Add(SopInstanceUidTag, dds.GetValueString(DicomTags.SOPInstanceUID));
                    this.tagValueDictionary.Add(SopClassUidTag, dds.GetValueString(DicomTags.SOPClassUID));
                    this.tagValueDictionary.Add(TransferSyntaxUidTag, fmi.TransferSyntax.ToString());
                    this.tagValueDictionary.Add(ImageNumberTag, dds.GetValueString(DicomTags.InstanceNumber));
                    this.tagValueDictionary.Add(this.NumberOfFrames, dds.GetValueString(DicomTags.NumberOfFrames));
                }
            }
            catch (Exception e)
            {
                this.ErrorMessage = "Unable to TagDictionary: " + e.Message;
            }
        }

        /// <summary>
        /// The parse header.
        /// </summary>
        /// <param name="fileName">
        /// The file name.
        /// </param>
        private void ParseHeader(string fileName)
        {
            try
            {
                if (!string.IsNullOrEmpty(fileName))
                {
                    if (File.Exists(fileName))
                    {
                        var dff = new DicomFileFormat();
                        dff.Load(fileName, DicomReadOptions.Default);
                        DcmFileMetaInfo fmi = dff.FileMetaInfo;
                        DcmDataset dds = dff.Dataset;

                        // Parse the header
                        this.LoadSparseDictionary(fmi, dds);
                    }
                    else
                    {
                        this.ErrorMessage = "File [" + fileName + "] does not exist";
                    }
                }
                else
                {
                    this.ErrorMessage = "No file specified";
                }
            }
            catch (Exception ex)
            {
                this.ErrorMessage = ex.Message;
            }
        }

        #endregion
    }
}