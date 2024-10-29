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
    /// <summary>
    /// The DICOM data set interface.
    /// </summary>
    public interface IDicomDataSet
    {
        #region Public Properties

        /// <summary>
        /// Gets AccessionNumber.
        /// </summary>
        string AccessionNumber { get; }

        /// <summary>
        /// Gets a value indicating whether CanDisplayHeaderInfo.
        /// </summary>
        bool CanDisplayHeaderInfo { get; }

        /// <summary>
        /// Gets or sets a value indicating whether DataSetLoaded.
        /// </summary>
        bool DataSetLoaded { get; set; }

        /// <summary>
        /// Gets or sets ErrorMessage.
        /// </summary>
        string ErrorMessage { get; set; }

        /// <summary>
        /// Gets Facility.
        /// </summary>
        string Facility { get; }

        /// <summary>
        /// Gets or sets a value indicating whether FileMetaInfoRecordsLoaded.
        /// </summary>
        bool FileMetaInfoRecordsLoaded { get; set; }

        /// <summary>
        /// Gets ImageNumber.
        /// </summary>
        string ImageNumber { get; }

        /// <summary>
        /// Gets InstitutionAddress.
        /// </summary>
        string InstitutionAddress { get; }

        /// <summary>
        /// Gets Modality.
        /// </summary>
        string Modality { get; }

        /// <summary>
        /// Gets PerformedProcedureStepDescription.
        /// </summary>
        string PerformedProcedureStepDescription { get; }

        /// <summary>
        /// Gets NumberOfFrames.
        /// </summary>
        string NumberOfFrames { get; }

        /// <summary>
        /// Gets PatientBirthDate.
        /// </summary>
        string PatientBirthDate { get; }

        /// <summary>
        /// Gets PatientId.
        /// </summary>
        string PatientId { get; }

        /// <summary>
        /// Gets PatientName.
        /// </summary>
        string PatientName { get; }

        /// <summary>
        /// Gets PatientSex.
        /// </summary>
        string PatientSex { get; }

        /// <summary>
        /// Gets ReferringPhysician.
        /// </summary>
        string ReferringPhysician { get; }

        /// <summary>
        /// Gets SeriesDate.
        /// </summary>
        string SeriesDate { get; }

        /// <summary>
        /// Gets SeriesDescription.
        /// </summary>
        string SeriesDescription { get; }

        /// <summary>
        /// Gets SeriesUid.
        /// </summary>
        string SeriesUid { get; }

        /// <summary>
        /// Gets SopClassUid.
        /// </summary>
        string SopClassUid { get; }

        /// <summary>
        /// Gets SopInstanceUid.
        /// </summary>
        string SopInstanceUid { get; }

        /// <summary>
        /// Gets StudyDate.
        /// </summary>
        string StudyDate { get; }

        /// <summary>
        /// Gets StudyDescription.
        /// </summary>
        string StudyDescription { get; }

        /// <summary>
        /// Gets StudyTime.
        /// </summary>
        string StudyTime { get; }

        /// <summary>
        /// Gets StudyUid.
        /// </summary>
        string StudyUid { get; }

        /// <summary>
        /// Gets TransferSyntaxUid.
        /// </summary>
        string TransferSyntaxUid { get; }

        #endregion
    }
}