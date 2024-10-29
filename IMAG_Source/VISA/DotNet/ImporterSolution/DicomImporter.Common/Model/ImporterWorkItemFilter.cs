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
    using System.Configuration;

    using ImagingClient.Infrastructure.Configuration;
    using ImagingClient.Infrastructure.User.Model;

    /// <summary>
    /// The importer work item filter.
    /// </summary>
    public class ImporterWorkItemFilter
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ImporterWorkItemFilter"/> class.
        /// </summary>
        public ImporterWorkItemFilter()
        {
            this.Type = ImporterWorkListTypes.Importer;
            this.Subtype = string.Empty;
            this.Status = string.Empty;
            this.PlaceId = UserContext.UserCredentials.SiteNumber;
            this.PatientName = string.Empty;
            this.Source = string.Empty;
            this.StudyUid = string.Empty;
            this.AccessionNumber = string.Empty;
            this.PatientId = string.Empty;
            this.OriginIndex = string.Empty;
            this.Service = string.Empty;
            this.Modality = string.Empty;
            this.Procedure = string.Empty;
            this.ShortCircuitTagName = "DcmCrctInstKey";
            this.MaximumNumberOfItemsToReturn = ConfigUtils.GetAppSetting("MaximumNumberOfItemsToReturn");
            this.LastIenProcessed = string.Empty;
            this.FromDate = string.Empty;
            this.ToDate = string.Empty;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the AccessionNumber.
        /// </summary>
        public string AccessionNumber { get; set; }

        /// <summary>
        /// Gets or sets the OriginIndex.
        /// </summary>
        public string OriginIndex { get; set; }

        /// <summary>
        /// Gets or sets the Service.
        /// </summary>
        public string Service { get; set; }

        /// <summary>
        /// Gets or sets the Modality.
        /// </summary>
        public string Modality { get; set; }

        /// <summary>
        /// Gets or sets the Procedure.
        /// </summary>
        public string Procedure { get; set; }

        /// <summary>
        /// Gets or sets the PatientId.
        /// </summary>
        public string PatientId { get; set; }

        /// <summary>
        /// Gets or sets the PatientName.
        /// </summary>
        public string PatientName { get; set; }

        /// <summary>
        /// Gets or sets the PlaceId.
        /// </summary>
        public string PlaceId { get; set; }

        /// <summary>
        /// Gets or sets the Source.
        /// </summary>
        public string Source { get; set; }

        /// <summary>
        /// Gets or sets the Status.
        /// </summary>
        public string Status { get; set; }

        /// <summary>
        /// Gets or sets the StudyUid.
        /// </summary>
        public string StudyUid { get; set; }

        /// <summary>
        /// Gets or sets the Subtype.
        /// </summary>
        public string Subtype { get; set; }

        /// <summary>
        /// Gets or sets the Type.
        /// </summary>
        public string Type { get; set; }

        /// <summary>
        /// Gets or sets the name of the short circuit tag, an optimization which allows M to stop adding tags to the 
        /// output array for each work item once the first instance of this tag is found.
        /// </summary>
        /// <value>
        /// The name of the short circuit tag.
        /// </value>
        public string ShortCircuitTagName { get; set; }

        /// <summary>
        /// Gets or sets the maximum number of items to return from a search. This value is picked up from a configuration parameter
        /// in app.config. In general, it will be an empty string, which returns all matching rows. If there is a problem in which a site
        /// is timing out due to too many records, however, this provides a "short circuit" that allows us to return a subset of rows until
        /// they can pare down their backlog.
        /// </summary>
        /// <value>
        /// The maximum number of items to return.
        /// </value>
        public string MaximumNumberOfItemsToReturn { get; set; }

        /// <summary>
        /// Gets or sets the Last Work Item Ien Processed. 
        /// </summary>
        public string LastIenProcessed { get; set; }

        /// <summary>
        /// Gets or sets the Retrieval Order - newer to older (-1) or older to newer (1). 
        /// </summary>
        public string RetrievalOrder { get; set; }
        public string FromDate { get; set; }
        public string ToDate { get; set; }
        #endregion
    }
}