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
namespace DicomImporter.Common.Interfaces.DataSources
{
    using System.Collections.ObjectModel;

    using DicomImporter.Common.Model;

    /// <summary>
    /// The interface specifying the required methods for the DICOM importer datasource.
    /// </summary>
    public interface IDicomImporterDataSource
    {
        /// <summary>
        /// Cancels an importer work item.
        /// </summary>
        /// <param name="workItem">
        /// The work item to cancel.
        /// </param>
        void CancelImporterWorkItem(ImporterWorkItem workItem);

        /// <summary>
        /// Creates an importer work item in the datastore.
        /// </summary>
        /// <param name="workItem">
        /// The work item to create.
        /// </param>
        /// <param name="storeInCache">
        /// Whether or not to store the work item in the cache.
        /// </param>
        void CreateImporterWorkItem(ImporterWorkItem workItem, bool storeInCache);

        /// <summary>
        /// Gets an Importer work item from the database after transtioning it
        /// to the specified "new status", as long as the work item is found to be in the 
        /// given "expected status".
        /// </summary>
        /// <param name="workItem">
        /// The work item to get and transition.
        /// </param>
        /// <param name="expectedStatus">
        /// The expected status of the work item.
        /// </param>
        /// <param name="newStatus">
        /// The new status of the work item.
        /// </param>
        /// <returns>
        /// The work item with the status transitioned to the newly requested status
        /// </returns>
        ImporterWorkItem GetAndTranstionImporterWorkItem(
            ImporterWorkItem workItem, string expectedStatus, string newStatus);

        /// <summary>
        /// Gets the list of diagnostic codes from the database.
        /// </summary>
        /// <returns>
        /// The list of sorted diagnostic codes
        /// </returns>
        ObservableCollection<DiagnosticCode> GetDiagnosticCodesList();

        /// <summary>
        /// Gets the list of imaging locations used during creation of a new radiology order.
        /// </summary>
        /// <returns>
        /// A collection of Imaging Location instances
        /// </returns>
        ObservableCollection<ImagingLocation> GetImagingLocationList();

        /// <summary>
        /// The get importer work item by key.
        /// </summary>
        /// <param name="workItemKey">
        /// The work item key.
        /// </param>
        /// <returns>
        /// The work item found using the specified key
        /// </returns>
        ImporterWorkItem GetImporterWorkItemByKey(string workItemKey);

        /// <summary>
        /// Gets the list of ordering locations used during creation of a new radiology order.
        /// </summary>
        /// <returns>
        /// A collection of OrderingLocation instances
        /// </returns>
        ObservableCollection<OrderingLocation> GetOrderingLocationList();

        /// <summary>
        /// Gets the list of ordering providers used during creation of a new radiology order,
        /// filtered to those starting with the value contained in searchString
        /// </summary>
        /// <param name="searchString">
        /// The search string used to filter the Ordering Providers.
        /// </param>
        /// <returns>
        /// A filtered list of Ordering Providers
        /// </returns>
        ObservableCollection<OrderingProvider> GetOrderingProviderList(string searchString);

        /// <summary>
        /// Gets a collection of orders for the specified patient
        /// </summary>
        /// <param name="patientDfn">
        /// The patient dfn.
        /// </param>
        /// <returns>
        /// The orders for the specified patient
        /// </returns>
        ObservableCollection<Order> GetOrdersForPatient(string patientDfn);

        /// <summary>
        /// Gets the list of allowed Origin Index values.
        /// </summary>
        /// <returns>
        /// A collection of OriginIndex instances
        /// </returns>
        ObservableCollection<OriginIndex> GetOriginIndexList();

        /// <summary>
        /// Gets a procedure object given its IEN
        /// </summary>
        /// <param name="id">
        /// The IEN of the procedure
        /// </param>
        /// <returns>
        /// The procedure that matches the specified IEN
        /// </returns>
        Procedure GetProcedureById(int id);

        /// <summary>
        /// Gets a collection of Procedures. If applyFilter is true, . If applyFilter is false,
        /// </summary>
        /// <param name="imagingLocationIen">The imaging location to filter on</param>
        /// <returns>
        /// The collection of Procedure instances
        /// </returns>
        ObservableCollection<Procedure> GetProcedureList(int imagingLocationIen);


        /// <summary>
        /// Gets a report
        /// </summary>
        /// <param name="reportParameters">
        /// The report parameters, for use in generating the correct report.
        /// </param>
        /// <returns>
        /// A Report instance containing the contents of the report
        /// </returns>
        Report GetReport(ReportParameters reportParameters);

        /// <summary>
        /// Gets the list of standard reports from the database.
        /// </summary>
        /// <returns>
        /// The list of sorted standard reports
        /// </returns>
        ObservableCollection<StandardReport> GetStandardReportsList();

        /// <summary>
        /// Gets the import status for a study (Completely imported, Partially imported,
        /// or not imported at all).
        /// </summary>
        /// <param name="study">
        /// The study for which to check import status.
        /// </param>
        /// <returns>
        /// The study, with each SOP Instance populated with it's correct "already on file"
        /// flag value.
        /// </returns>
        Study GetStudyImportStatus(Study study);

        /// <summary>
        /// Gets the list of UIDActionConfig records from the database.
        /// </summary>
        /// <returns>
        /// the list of UIDActionConfig entries
        /// </returns>
        ObservableCollection<UIDActionConfig> GetUIDActionConfigEntries();

        /// <summary>
        /// Gets a list of work items that match the provided filter.
        /// </summary>
        /// <param name="filter">
        /// A populated ImporterWorkItemFilter instance for filtering the work items.
        /// </param>
        /// <returns>
        /// The collection of ImporterWorkItems that match the filter
        /// </returns>

        ObservableCollection<ImporterWorkItem> GetWorkItemList(ImporterWorkItemFilter filter);
        /// <summary>
        /// Get All unique sources in Work Items
        /// </summary>
        /// <returns>
        /// All unique sources in Work Items
        /// </returns>
        ObservableCollection<string> GetWorkItemSources();

        /// <summary>
        /// Get All unique modalities in Work Items
        /// </summary>
        /// <returns>
        /// All unique modalities in Work Items
        /// </returns>
        ObservableCollection<string> GetWorkItemModalities();

        /// <summary>
        /// Get All unique procedures in Work Items
        /// </summary>
        /// <returns>
        /// All unique procedures in Work Items
        /// </returns>
        ObservableCollection<string> GetWorkItemProcedures();

        /// <summary>
        /// Reads a DICOMDIR file and returns a fully populated collection of studies.
        /// </summary>
        /// <param name="filePath">
        /// The file path of the DICOMDIR file.
        /// </param>
        /// <returns>
        /// A collection of studies as specified in the DICOMDIR file, with all series and 
        /// SOPInstances objects created and populated.
        /// </returns>
        ObservableCollection<Study> ReadDicomDir(string filePath);

        /// <summary>
        /// The update work item.
        /// </summary>
        /// <param name="workItem">
        /// The work item.
        /// </param>
        /// <param name="expectedStatus">
        /// The expected status.
        /// </param>
        /// <param name="newStatus">
        /// The new status.
        /// </param>
        void UpdateWorkItem(ImporterWorkItem workItem, string expectedStatus, string newStatus);

        /// <summary>
        /// The update work item service.
        /// </summary>
        /// <param name="workItemId">
        /// The work item Id where the service will be updated.
        /// </param>
        /// <param name="modality">
        /// The work item tag modality - used for x-ref
        /// </param>
        /// <param name="procedure">
        /// The work item tag procedure - used for x-ref
        /// </param>
        /// <param name="service">
        /// The work item tag service - work item tag service will be updated with this value
        /// </param>
        bool UpdateWorkItemService(string service, string modality, string procedure, string newService, out string errMsg);
        
        public bool LoadUserPreferences(out UserPreference pref, bool temp);

        public bool SaveUserPreferences(string pref, bool temp, out string errMsg);

        string ReadImageText(int workItemId);


        /// <summary>
        /// Determines whether the VIX is compatible with this client.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if VIX is compatible; otherwise, <c>false</c>.
        /// </returns>
        bool IsVixCompatible();

        /// <summary>
        /// Determines whether Vista is compatible with this client.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if Vista is compatible; otherwise, <c>false</c>.
        /// </returns>
        bool IsVistaCompatible();

    }
}