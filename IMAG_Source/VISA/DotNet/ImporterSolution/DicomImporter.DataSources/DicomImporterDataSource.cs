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
namespace DicomImporter.DataSources
{
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Net.Http;
    using System.Text;
   using System.Text.RegularExpressions;
   using System.Xml.Serialization;
    using DicomImporter.Common.Exceptions;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;

    using ImagingClient.Infrastructure.Rest;
    using ImagingClient.Infrastructure.Storage.Model;
    using ImagingClient.Infrastructure.StorageDataSource;
    using ImagingClient.Infrastructure.User.Model;
    using ImagingClient.Infrastructure.Utilities;
    using log4net;
    
    /// <summary>
    /// The dicom importer data source.
    /// </summary>
    public class DicomImporterDataSource : IDicomImporterDataSource
    {
        #region Constants and Fields

        /// <summary>
        /// The string returned when a compatible service is not found
        /// </summary>
        private const string CompatibleWebServiceNotFound = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><services></services>";

        /// <summary>
        /// The root of the IDSService
        /// </summary>
        private const string IDSServiceUrl = "IDSWebApp";

        /// <summary>
        /// The IDSService querystring for importer version 1
        /// </summary>
        private const string IDSServiceQueryPath = "VersionsService?type=DicomImporter&version=1";

        /// <summary>
        /// The IDSService querystring for importer version 1
        /// </summary>
        private const string ImporterCompatibilityQueryPath = "importerVersionCheck/isVersionCompatible?version=1";

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(DicomImporterDataSource));

        /// <summary>
        /// A dictionary of procedures by division and location.
        /// </summary>
        private static Dictionary<string, ObservableCollection<Procedure>> proceduresByDivisionAndLocation =
            new Dictionary<string, ObservableCollection<Procedure>>();

        /// <summary>
        /// A dictionary of procedures by division and location.
        /// </summary>
        private static Dictionary<int, Procedure> proceduresByIen = new Dictionary<int, Procedure>();

        /// <summary>
        /// The standard reports by divison
        /// </summary>
        private static Dictionary<string, ObservableCollection<StandardReport>> standardReportsByDivison =
            new Dictionary<string, ObservableCollection<StandardReport>>();

        /// <summary>
        /// The dicom importer service url.
        /// </summary>
        private const string DicomImporterServiceUrl = "DicomImporterWebApp";

        /// <summary>
        /// The VistaUserPreference Service Url.
        /// </summary>
        private const string VistaUserPreferenceServiceUrl = "VistaUserPreferenceWebApp/restservices";

        /// <summary>
        /// The diagnostic codes
        /// </summary>
        private ObservableCollection<DiagnosticCode> diagnosticCodes;

        /// <summary>
        /// The imaging locations.
        /// </summary>
        private ObservableCollection<ImagingLocation> imagingLocations;

        /// <summary>
        /// The ordering locations.
        /// </summary>
        private ObservableCollection<OrderingLocation> orderingLocations;

        /// <summary>
        /// The origin index list.
        /// </summary>
        private ObservableCollection<OriginIndex> originIndexList;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="DicomImporterDataSource"/> class.
        /// </summary>
        /// <param name="storageDataSource">
        /// The storage data source.
        /// </param>
        public DicomImporterDataSource(IStorageDataSource storageDataSource)
        {
            this.StorageDataSource = storageDataSource;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets StorageDataSource.
        /// </summary>
        public IStorageDataSource StorageDataSource { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// The cancel importer work item.
        /// </summary>
        /// <param name="workItem">
        /// The work item.
        /// </param>
        public void CancelImporterWorkItem(ImporterWorkItem workItem)
        {
            if ((workItem != null) && (workItem.WorkItemDetails != null))
            {
                // Decouple the studies from the reconciliations
                if (workItem.WorkItemDetails.Studies != null)
                {
                    foreach (Study study in workItem.WorkItemDetails.Studies)
                    {
                        study.Reconciliation = null;
                        study.ToBeDeletedOnly = false;
                    }
                }

                // Decouple the Orders from the Reconciliations
                if (workItem.WorkItemDetails.Reconciliations != null)
                {
                    if (workItem.WorkItemDetails.Reconciliations != null)
                    {
                        foreach (Reconciliation reconciliation in workItem.WorkItemDetails.Reconciliations)
                        {
                            if (reconciliation.Order != null)
                            {
                                reconciliation.Order.Reconciliation = null;
                            }
                        }
                    }
                }

                // Remove all reconciliations
                workItem.WorkItemDetails.Reconciliations = null;

                // If this is an item from the Worklist, revert the status so someone else can work the item
                if (workItem.Subtype != ImporterWorkItemSubtype.DirectImport.Code)
                {
                    this.UpdateWorkItem(workItem, ImporterWorkItemStatuses.InReconciliation, workItem.OriginalStatus);
                }

                // Remove the working copy from the cache
                ImporterWorkItemCache.Remove(workItem);
            }
        }

        /// <summary>
        /// The create importer work item.
        /// </summary>
        /// <param name="workItem">
        /// The work item.
        /// </param>
        /// <param name="storeInCache">
        /// The store in cache.
        /// </param>
        public void CreateImporterWorkItem(ImporterWorkItem workItem, bool storeInCache)
        {
            // Only bother to actually create a work item if we got far enough to stage something. If the
            // staging directory hasn't even been set up yet, there's nothing for a user to work, and not
            // even anything for the background process to clean up later.
            if (!string.IsNullOrEmpty(workItem.WorkItemDetails.MediaBundleStagingRootDirectory))
            {
                workItem.PlaceId = UserContext.UserCredentials.SiteNumber;

                // Write the details out to a file and clear it so we don't stream it to the server
                // inbound
                this.WriteAndClearWorkItemDetails(workItem);

                // Convert the object to XML
                string workItemXml = this.ConvertObjectToXml<ImporterWorkItem>(workItem);
                HttpContent workItemContent = new StringContent(workItemXml);

                workItem = RestUtils.DoPost<ImporterWorkItem>(
                    DicomImporterServiceUrl, "importerWorkItem/createImporterWorkItem", workItemContent);

                // Cache the workitem if it will be worked now (i.e. direct import)
                if (storeInCache)
                {
                    ImporterWorkItemCache.Add(workItem);
                }
            }
        }

        /// <summary>
        /// Gets an Importer work item from the database after transtioning it
        /// to the specified "new status", as long as the work item is found to be in the
        /// given "expected status".
        /// </summary>
        /// <param name="workItem">The work item to get and transition.</param>
        /// <param name="expectedStatus">The expected status of the work item.</param>
        /// <param name="newStatus">The new status of the work item.</param>
        /// <returns>
        /// The work item with the status transitioned to the newly requested status
        /// </returns>
        public ImporterWorkItem GetAndTranstionImporterWorkItem(
            ImporterWorkItem workItem, string expectedStatus, string newStatus)
        {
            string queryString = string.Format("?workItemId={0}", workItem.Id);
            queryString += string.Format("&expectedStatus={0}", expectedStatus);
            queryString += string.Format("&newStatus={0}", newStatus);
            queryString += string.Format("&updatingUser={0}", UserContext.UserCredentials.Duz);
            queryString += "&updatingApplication=";

            string resourcePath = "importerWorkItem/getAndTransitionWorkItem" + queryString;
            return RestUtils.DoGetObject<ImporterWorkItem>(DicomImporterServiceUrl, resourcePath);
        }

        /// <summary>
        /// Gets the list of diagnostic codes from the database.
        /// </summary>
        /// <returns>
        /// The list of sorted diagnostic codes
        /// </returns>
        public ObservableCollection<DiagnosticCode> GetDiagnosticCodesList()
        {
            if (this.diagnosticCodes == null)
            {
                string resourcePath = string.Format("order/getDiagnosticCodeList?siteId={0}",
                                                    UserContext.UserCredentials.SiteNumber);

                this.diagnosticCodes = RestUtils.DoGetObject<ObservableCollection<DiagnosticCode>>(
                                             DicomImporterServiceUrl, resourcePath);

                // Sort the diagnostic codes
                IOrderedEnumerable<DiagnosticCode> sortedList = this.diagnosticCodes.OrderBy(x => x.Name);
                this.diagnosticCodes = new ObservableCollection<DiagnosticCode>(sortedList);
            }

            return this.diagnosticCodes;
        }

        /// <summary>
        /// Gets the list of imaging locations used during creation of a new radiology order.
        /// </summary>
        /// <returns>
        /// A collection of Imaging Location instances
        /// </returns>
        public ObservableCollection<ImagingLocation> GetImagingLocationList()
        {
         //   if (this.imagingLocations == null)
         //   {
                string resourcePath = string.Format(
                    "order/getImagingLocationList?siteId={0}", UserContext.UserCredentials.SiteNumber);
                this.imagingLocations =
                    RestUtils.DoGetObject<ObservableCollection<ImagingLocation>>(
                        DicomImporterServiceUrl, resourcePath);

                IOrderedEnumerable<ImagingLocation> sortedList = this.imagingLocations.OrderBy(x => x.Name);
                this.imagingLocations = new ObservableCollection<ImagingLocation>(sortedList);
         //   }

            return this.imagingLocations;
        }

        /// <summary>
        /// The get importer work item by key.
        /// </summary>
        /// <param name="workItemKey">The work item key.</param>
        /// <returns>
        /// The work item found using the specified key
        /// </returns>
        public ImporterWorkItem GetImporterWorkItemByKey(string workItemKey)
        {
            return ImporterWorkItemCache.Get(workItemKey);
        }

        /// <summary>
        /// Gets the list of ordering locations used during creation of a new radiology order.
        /// </summary>
        /// <returns>
        /// A collection of OrderingLocation instances
        /// </returns>
        public ObservableCollection<OrderingLocation> GetOrderingLocationList()
        {
            if (this.orderingLocations == null)
            {
                string resourcePath = string.Format(
                    "order/getOrderingLocationList?siteId={0}", UserContext.UserCredentials.SiteNumber);
                this.orderingLocations =
                    RestUtils.DoGetObject<ObservableCollection<OrderingLocation>>(
                        DicomImporterServiceUrl, resourcePath);

                IOrderedEnumerable<OrderingLocation> sortedList = this.orderingLocations.OrderBy(x => x.Name);
                this.orderingLocations = new ObservableCollection<OrderingLocation>(sortedList);
            }

            return this.orderingLocations;
        }

        /// <summary>
        /// Gets the list of ordering providers used during creation of a new radiology order,
        /// filtered to those starting with the value contained in searchString
        /// </summary>
        /// <param name="searchString">The search string used to filter the Ordering Providers.</param>
        /// <returns>
        /// A filtered list of Ordering Providers
        /// </returns>
        public ObservableCollection<OrderingProvider> GetOrderingProviderList(string searchString)
        {
            string resourcePath = string.Format(
                "order/getOrderingProviderList?siteId={0}&searchString={1}", 
                UserContext.UserCredentials.SiteNumber, 
                searchString);

            var orderingProviders =
                RestUtils.DoGetObject<ObservableCollection<OrderingProvider>>(
                    DicomImporterServiceUrl, resourcePath);

            // Sort the ordering providers
            IOrderedEnumerable<OrderingProvider> sortedList = orderingProviders.OrderBy(x => x.Name);
            orderingProviders = new ObservableCollection<OrderingProvider>(sortedList);

            return orderingProviders;
        }

        /// <summary>
        /// Gets a collection of orders for the specified patient
        /// </summary>
        /// <param name="patientDfn">The patient dfn.</param>
        /// <returns>
        /// The orders for the specified patient
        /// </returns>
        public ObservableCollection<Order> GetOrdersForPatient(string patientDfn)
        {
            string resourcePath = string.Format(
                "order/getOrdersForPatient?patientDfn={0}&siteId={1}", patientDfn, UserContext.UserCredentials.SiteNumber);
            var orders = RestUtils.DoGetObject<ObservableCollection<Order>>(DicomImporterServiceUrl, resourcePath);
            var sortedOrders = new ObservableCollection<Order>(orders.OrderByDescending(o => o.OrderDateAsDateTime));

            // We found some orders. For each RADIOLOGY order, attach the procedure object 
            // to them so we have the data at import time. If it's a consult,
            // we don't bother with this since we don't create, register, or status consults.
            foreach (Order order in sortedOrders)
            {
                if (order.Specialty.Equals("RAD", StringComparison.CurrentCultureIgnoreCase))
                {
                    order.Procedure = this.GetProcedureById(order.ProcedureId);
                }
            }

            return sortedOrders;
        }

        /// <summary>
        /// Gets the list of allowed Origin Index values.
        /// </summary>
        /// <returns>
        /// A collection of OriginIndex instances
        /// </returns>
        public ObservableCollection<OriginIndex> GetOriginIndexList()
        {
            if (this.originIndexList == null)
            {
                string resourcePath = "study/getOriginIndexList";
                this.originIndexList =
                    RestUtils.DoGetObject<ObservableCollection<OriginIndex>>(DicomImporterServiceUrl, resourcePath);
                this.originIndexList.Insert(0, new OriginIndex());

                OriginIndex.OriginIndexList = this.originIndexList;
            }

            return this.originIndexList;
        }

        /// <summary>
        /// Gets a procedure by id.
        /// </summary>
        /// <param name="procedureIen">
        /// The ien of the procedure to return.
        /// </param>
        /// <returns>
        /// The procedure found by matching on Ids
        /// </returns>
        public Procedure GetProcedureById(int procedureIen)
        {
            // See if we have cached the procedure yet.
            if (!proceduresByIen.ContainsKey(procedureIen))
            {
                string currentDivision = UserContext.UserCredentials.SiteNumber;

                // Get the procedures
                string resourcePath = string.Format(
                    "order/getProcedureList?siteId={0}&imagingLocationIen=&procedureIen={1}", currentDivision,
                    procedureIen);

                var procedures = RestUtils.DoGetObject<ObservableCollection<Procedure>>(DicomImporterServiceUrl,
                                                                                        resourcePath);
                
                // If we found the procedure, add the modifiers and put it in the cache.
                if (procedures != null && procedures.Count > 0)
                {
                    AttachModifiersToProcedures(procedures);
                    Procedure procedure = procedures[0];

                    proceduresByIen.Add(procedure.Id, procedure);
                }

            }

            // Return the first procedure from the cache if it exists, otherwise return null
            return (proceduresByIen.ContainsKey(procedureIen)) ? proceduresByIen[procedureIen] : null;

        }

        /// <summary>
        /// Gets a collection of Procedures for a given imaging location.
        /// </summary>
        /// <param name="imagingLocationIen">The imaging location to filter on</param>
        /// <returns>
        /// The collection of Procedure instances
        /// </returns>
        public ObservableCollection<Procedure> GetProcedureList(int imagingLocationIen)
        {
            string currentDivision = UserContext.UserCredentials.SiteNumber;
            string cacheKey = currentDivision + "_" + imagingLocationIen;

            // If we don't have the procedures for the current division, go get them...
            if (!proceduresByDivisionAndLocation.ContainsKey(cacheKey))
            {
                // Get the procedures
                string resourcePath = string.Format(
                    "order/getProcedureList?siteId={0}&imagingLocationIen={1}&procedureIen=", currentDivision, imagingLocationIen);

                var procedures = RestUtils.DoGetObject<ObservableCollection<Procedure>>(DicomImporterServiceUrl, resourcePath);

                AttachModifiersToProcedures(procedures);
                
                // Sort the procedures and add them to the dictionary
                IOrderedEnumerable<Procedure> sortedList = procedures.OrderBy(x => x.Name);
                proceduresByDivisionAndLocation.Add(cacheKey, new ObservableCollection<Procedure>(sortedList));

                // Add the procedures to the cache by IEN as well...
                foreach (Procedure procedure in procedures)
                {
                    if (!proceduresByIen.ContainsKey(procedure.Id))
                    {
                        proceduresByIen.Add(procedure.Id, procedure);
                    }
                }
            }

            // Return the procedures from the dictionary
            return proceduresByDivisionAndLocation[cacheKey];
        }

        /// <summary>
        /// Attaches the appropriate procedure modifiers to a list of procedures.
        /// </summary>
        /// <param name="procedures">The procedures.</param>
        private void AttachModifiersToProcedures(ObservableCollection<Procedure> procedures)
        {
            // Get the procedure modifiers
            ObservableCollection<ProcedureModifier> procedureModifiers = this.GetProcedureModifierList();

            // Build index of procedure modifiers by imaging type, so we can link to procedures
            var map = new Dictionary<int, ObservableCollection<ProcedureModifier>>();

            foreach (ProcedureModifier modifier in procedureModifiers)
            {
                int key = modifier.ImagingTypeId;
                if (!map.ContainsKey(key))
                {
                    map.Add(key, new ObservableCollection<ProcedureModifier>());
                }

                map[key].Add(modifier);
            }

            // Now, go through the procedures and add their modifiers by imaging type key
            foreach (Procedure procedure in procedures)
            {
                int key = procedure.ImagingTypeId;
                if (map.ContainsKey(key))
                {
                    procedure.ProcedureModifiers = map[key];
                }
            }
        }

        /// <summary>
        /// Gets a report
        /// </summary>
        /// <param name="reportParameters">The report parameters, for use in generating the correct report.</param>
        /// <returns>
        /// A Report instance containing the contents of the report
        /// </returns>
        public Report GetReport(ReportParameters reportParameters)
        {
            string contentXml = this.ConvertObjectToXml<ReportParameters>(reportParameters);
            HttpContent httpContent = new StringContent(contentXml);

            return RestUtils.DoPost<Report>(DicomImporterServiceUrl, "importerReport/getReport", httpContent);
        }

        /// <summary>
        /// Gets the list of standard reports from the database.
        /// </summary>
        /// <returns>
        /// The list of sorted standard reports
        /// </returns>
        public ObservableCollection<StandardReport> GetStandardReportsList()
        {
            // If we don't have the standard reports for the current division, go get them...
            if (!DicomImporterDataSource.standardReportsByDivison.ContainsKey(UserContext.UserCredentials.SiteNumber))
            {
                // Get the reports
                string resourcePath = string.Format("order/getStandardReportList?siteId={0}",
                                                    UserContext.UserCredentials.SiteNumber);

                var standardReports = RestUtils.DoGetObject<ObservableCollection<StandardReport>>(
                                        DicomImporterServiceUrl, resourcePath);

                // Sorts the standard reports
                IOrderedEnumerable<StandardReport> sortedList = standardReports.OrderBy(x => x.ReportName);
                standardReports = new ObservableCollection<StandardReport>(sortedList);

                // Removes all extra new lines that may or may not be apart of the Report data.
                for (int i = 0; i < standardReports.Count; i++)
                {
                    standardReports[i].ReportText = this.RemoveExtraNewLines(standardReports[i].ReportText);
                    standardReports[i].Impression = this.RemoveExtraNewLines(standardReports[i].Impression);
                }

                DicomImporterDataSource.standardReportsByDivison.Add(UserContext.UserCredentials.SiteNumber,
                                                  new ObservableCollection<StandardReport>(standardReports));
            }

            // Return the standard reports from the dictionary
            return DicomImporterDataSource.standardReportsByDivison[UserContext.UserCredentials.SiteNumber];
        }

        /// <summary>
        /// Gets the import status for a study (Completely imported, Partially imported,
        /// or not imported at all).
        /// </summary>
        /// <param name="study">The study for which to check import status.</param>
        /// <returns>
        /// The study, with each SOP Instance populated with it's correct "already on file"
        /// flag value.
        /// </returns>
        public Study GetStudyImportStatus(Study study)
        {
            // Next, extract the ImporterWorkItemDetails and convert to String Content
            string contentXml = this.ConvertObjectToXml<Study>(study);
            HttpContent content = new StringContent(contentXml);

            // Finally call update Post
            study = RestUtils.DoPost<Study>(DicomImporterServiceUrl, "study/importStatus", content);

            return study;
        }

        /// <summary>
        /// Gets the list of UIDActionConfig records from the database.
        /// </summary>
        /// <returns>
        /// the list of UIDActionConfig entries
        /// </returns>
        public ObservableCollection<UIDActionConfig> GetUIDActionConfigEntries()
        {
            string resourcePath = string.Format("study/getUIDActionList");
            return RestUtils.DoGetObject<ObservableCollection<UIDActionConfig>>(DicomImporterServiceUrl, resourcePath);
        }

        /// <summary>
        /// Gets a list of work items that match the provided filter.
        /// </summary>
        /// <param name="filter">A populated ImporterWorkItemFilter instance for filtering the work items.</param>
        /// <returns>
        /// The collection of ImporterWorkItems that match the filter
        /// </returns>
        public ObservableCollection<ImporterWorkItem> GetWorkItemList(ImporterWorkItemFilter filter)
        {
            // Next, extract the ImporterWorkItemDetails and convert to String Content
            string contentXml = this.ConvertObjectToXml<ImporterWorkItemFilter>(filter);
            HttpContent content = new StringContent(contentXml);

            // Finally call update Post
            return RestUtils.DoPost<ObservableCollection<ImporterWorkItem>>(
                DicomImporterServiceUrl, "importerWorkItem/getWorkItemList", content);
        }

        /// <summary>
        /// Reads a DICOMDIR file and returns a fully populated collection of studies.
        /// </summary>
        /// <param name="filePath">The file path of the DICOMDIR file.</param>
        /// <returns>
        /// A collection of studies as specified in the DICOMDIR file, with all series and
        /// SOPInstances objects created and populated.
        /// </returns>
        public ObservableCollection<Study> ReadDicomDir(string filePath)
        {
            string dicomDir = BinaryFileToBase64StringConverter.ConvertFile(filePath);
            HttpContent dicomDirContent = new StringContent(dicomDir);

            return RestUtils.DoPost<ObservableCollection<Study>>(
                DicomImporterServiceUrl, "dicomdir/readDicomDir", dicomDirContent);
        }

        /// <summary>
        /// Get All unique sources in Work Items
        /// </summary>
        /// <returns>
        /// All unique sources in Work Items
        /// </returns>
        public ObservableCollection<String> GetWorkItemSources()
        {
            ObservableCollection<ImporterFilter> filters = RestUtils.DoGetObject<ObservableCollection<ImporterFilter>>(
                DicomImporterServiceUrl, "importerWorkItem/getWorkItemSources");
            return FillWorkItemFilters(filters);
        }

        /// <summary>
        /// Get All unique modalities in Work Items
        /// </summary>
        /// <returns>
        /// All unique modalities in Work Items
        /// </returns>
        public ObservableCollection<String> GetWorkItemModalities()
        {
            ObservableCollection<ImporterFilter> filters = RestUtils.DoGetObject<ObservableCollection<ImporterFilter>>(
                DicomImporterServiceUrl, "importerWorkItem/getWorkItemModalities");
            return FillWorkItemFilters(filters);
        }

        /// <summary>
        /// Get All unique procedures in Work Items
        /// </summary>
        /// <returns>
        /// All unique procedures in Work Items
        /// </returns>
        public ObservableCollection<String> GetWorkItemProcedures()
        {
            ObservableCollection<ImporterFilter> filters = RestUtils.DoGetObject<ObservableCollection<ImporterFilter>>(
                DicomImporterServiceUrl, "importerWorkItem/getWorkItemProcedures");
            return FillWorkItemFilters(filters);
        }

        public ObservableCollection<string> FillWorkItemFilters(ObservableCollection<ImporterFilter> filters)
        {
            ObservableCollection<string> sources = new ObservableCollection<string>();
            foreach (var item in filters)
            {
                sources.Add(item.Code);
            }
            return sources;
        }



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
        public void UpdateWorkItem(ImporterWorkItem workItem, string expectedStatus, string newStatus)
        {
            // Upate the Work Item. First, build the querystring
            string resourcePath = "importerWorkItem/updateImporterWorkItem";
            resourcePath += "?workItemId=" + workItem.Id;
            resourcePath += "&expectedStatus=" + expectedStatus;
            resourcePath += "&newStatus=" + newStatus;
            resourcePath += "&updatingUser=" + UserContext.LastLoggedInUsersDUZ;
            resourcePath += "&updatingApplication=";

            // If the work item details are not null, write the details out to a file and clear it so 
            // we don't stream it to the server inbound
            if (workItem.WorkItemDetails != null)
            {
                this.WriteAndClearWorkItemDetails(workItem);
            }

            // Next, convert to the workitem to String Content to be sent as postdata
            string contentXml = this.ConvertObjectToXml<ImporterWorkItem>(workItem);
            HttpContent content = new StringContent(contentXml);

            // Post the results
            RestUtils.DoPost(DicomImporterServiceUrl, resourcePath, content);

            // Update the workItem with the new status
            workItem.Status = newStatus;
        }

        /// <summary>
        /// Read Image file in the cache based on the following parameters
        /// and return the text
        /// </summary>
        /// <param name="workItemId">
        /// The work item ID.
        /// </param>
        /// <param name="filePath">
        /// The image filename.
        /// </param>
        public string ReadImageText(int workItemId)
        {
            string queryString = string.Format("?siteId={0}", UserContext.UserCredentials.SiteNumber);
            queryString += string.Format("&workItemId={0}", workItemId);
            queryString += string.Format("&updatingUser={0}", UserContext.UserCredentials.Duz);
            
            string resourcePath = "importerWorkItem/readDicomImageText" + queryString;
            return RestUtils.DoGetString(DicomImporterServiceUrl, resourcePath);


            //string queryString = string.Format("?workItemId={0}", workItemId);
            //queryString += string.Format("&expectedStatus={0}", ImporterWorkItemStatuses.InReconciliation);
            //queryString += string.Format("&newStatus={0}", ImporterWorkItemStatuses.InReconciliation);
            //queryString += string.Format("&updatingUser={0}", UserContext.UserCredentials.Duz);
            //queryString += "&updatingApplication=";

            //string resourcePath = "importerWorkItem/getAndTransitionWorkItem" + queryString;
            //ImporterWorkItem importerWorkItem = RestUtils.DoGetObject<ImporterWorkItem>(DicomImporterServiceUrl, resourcePath);

            //// First, get the media bundle root path for later display
            //string networkLocationIen = importerWorkItem.WorkItemDetails.NetworkLocationIen;
            //NetworkLocationInfo networkLocationInfo =
            //    this.StorageDataSource.GetNetworkLocationDetails(networkLocationIen);
            //string serverPath = networkLocationInfo.PhysicalPath;
            //string mediaBundleRoot = importerWorkItem.WorkItemDetails.MediaBundleStagingRootDirectory;
            //string fullMediaBundlePath = PathUtilities.CombinePath(serverPath, mediaBundleRoot);
            //string imageFile = PathUtilities.CombinePath(fullMediaBundlePath, filePath);
            //string reportText = "Report for " + imageFile + "^" + "Impression for " + imageFile;
            //return reportText;

        }

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
        public bool UpdateWorkItemService(string service, string modality, string procedure, string newService, out string errMsg)
        {
            string queryString = string.Format("?service={0}", service);
            queryString += string.Format("&modality={0}", modality);
            queryString += string.Format("&procedure={0}", procedure);
            queryString += string.Format("&newService={0}", newService);

            string resourcePath = "importerWorkItem/updateService" + queryString;
            string result = RestUtils.DoGetString(DicomImporterServiceUrl, resourcePath);
            if (result.Equals("0"))
            {
                errMsg = String.Empty;
                return true;
            }
            else
            {
                errMsg = result.Split('^')[1];
                return false;
            }
        }

        public bool LoadUserPreferences(out UserPreference pref, bool temp)
        {
            string queryString = string.Format("?entity={0}", "USR");
            queryString += string.Format("&key={0}", temp ? "DICOMIMPORTERTEMP" : "DICOMIMPORTER");

            string resourcePath = "userPreference/load" + queryString;
            try
            {
                string result = RestUtils.DoGetString(VistaUserPreferenceServiceUrl, resourcePath);
                pref = translateUserPreferenceResult(result);
                return true;
            }
            catch
            {
                pref = null;
                return false;
            }
        }

        public bool SaveUserPreferences(string pref, bool temp, out string errMsg)
        {
            errMsg = string.Empty;
            string queryString = string.Format("?entity={0}", "USR");
            queryString += string.Format("&key={0}", temp ? "DICOMIMPORTERTEMP" : "DICOMIMPORTER");

            string resourcePath = "userPreference/store" + queryString;
            try
            {
                HttpContent content = new StringContent(pref);
                bool result = RestUtils.DoPost(VistaUserPreferenceServiceUrl, resourcePath, content);
                if (!result)
                {
                    errMsg = "Failed to Save User Preference";
                }
                return result;
            }
            catch
            {
                errMsg = "Exception: Failed to Save User Preference";
                return false;
            }
        }

        private UserPreference translateUserPreferenceResult(string result)
        {
            UserPreference pref = new UserPreference();
            string[] stringArray = result.Split(new string[] { "</value>" }, StringSplitOptions.RemoveEmptyEntries);
            string[] row = stringArray[0].Split(new string[] { "<value>" }, StringSplitOptions.RemoveEmptyEntries);
            string[] values = row[1].Split('^'); //MAXROWS=100^ROWORDER=-1^SOURCE=VA^MODALITY=CR^SERVICE=Radiology
            for (int i = 0; i < values.Length; i++)
            {
                string[] value = values[i].Split('=');
                if (value[0].Equals("MAXROWS"))
                {
                    pref.MaxRows = value[1];
                }
                else if (value[0].Equals("MODALITY"))
                {
                    pref.Modality = value[1];
                }
                else if (value[0].Equals("PROCEDURE"))
                {
                    pref.Procedure = value[1];
                }
                else if (value[0].Equals("ROWORDER"))
                {
                    pref.RowOrder = value[1];
                }
                else if (value[0].Equals("SERVICE"))
                {
                    pref.Service = value[1];
                }
                else if (value[0].Equals("SOURCE"))
                {
                    pref.Source = value[1];
                }
                else if (value[0].Equals("SUBTYPE"))
                {
                    pref.WorkItemSubtype = value[1];
                }
                else if (value[0].Equals("PATNAME"))
                {
                    pref.PatientName = value[1];
                }
                else if (value[0].Equals("DATETYPE"))
                {
                    pref.DateRangeType = value[1];
                }
                else if (value[0].Equals("FROMDATE"))
                {
                    pref.FromDate = value[1];
                }
                else if (value[0].Equals("TODATE"))
                {
                    pref.ToDate = value[1];
                }
            }
            return pref;
        }

        /// <summary>
        /// Determines whether the VIX is compatible with this client.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if VIX is compatible; otherwise, <c>false</c>.
        /// </returns>
        public bool IsVixCompatible()
        {
            string result = RestUtils.DoGetString(IDSServiceUrl, IDSServiceQueryPath).Trim();

            if (result.Trim().Equals(CompatibleWebServiceNotFound, StringComparison.CurrentCultureIgnoreCase))
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        /// <summary>
        /// Determines whether Vista is compatible with this client.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if Vista is compatible; otherwise, <c>false</c>.
        /// </returns>
        public bool IsVistaCompatible()
        {
            string result = RestUtils.DoGetString(DicomImporterServiceUrl, ImporterCompatibilityQueryPath).Trim();

            if (result.Trim().Equals("true"))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// Converts an object to an XML string.
        /// </summary>
        /// <param name="objectToConvert">
        /// The object to convert.
        /// </param>
        /// <typeparam name="T">
        /// The type of the object to convert
        /// </typeparam>
        /// <returns>
        /// A string containing the XML representation of the object
        /// </returns>
        private string ConvertObjectToXml<T>(object objectToConvert)
        {
            var objectAsXml = new StringBuilder();

            // Convert object to string by using XmlSerializer
            using (var writer = new StringWriter(objectAsXml))
            {
                var xs = new XmlSerializer(typeof(T));
                xs.Serialize(writer, objectToConvert);
            }

            return objectAsXml.ToString();
        }

        /// <summary>
        /// Gets the procedure modifier list.
        /// </summary>
        /// <returns>
        /// The collection of procedure modifiers
        /// </returns>
        private ObservableCollection<ProcedureModifier> GetProcedureModifierList()
        {
            string resourcePath = string.Format(
                "order/getProcedureModifierList?siteId={0}", UserContext.UserCredentials.SiteNumber);
            var procedureModifiers =
                RestUtils.DoGetObject<ObservableCollection<ProcedureModifier>>(
                    DicomImporterServiceUrl, resourcePath);

            // Sort the procedure modifiers
            IOrderedEnumerable<ProcedureModifier> sortedList = procedureModifiers.OrderBy(x => x.Name);
            procedureModifiers = new ObservableCollection<ProcedureModifier>(sortedList);

            return procedureModifiers;
        }

        /// <summary>
        /// Removes the extra new lines.
        /// </summary>
        /// <param name="text">The text.</param>
        /// <returns></returns>
        private string RemoveExtraNewLines(string text)
        {
            text = text.Replace("\n \n", "#$%HGU*&&*JE@FFE^ht45");
            text = text.Replace("\n", "");
            text =  text.Replace("#$%HGU*&&*JE@FFE^ht45", Environment.NewLine + Environment.NewLine);

            return text.Replace("     ", " ");
        }
                
        /// <summary>
        /// Writes and clears work item details.
        /// </summary>
        /// <param name="workItem">
        /// The work item.
        /// </param>
        private void WriteAndClearWorkItemDetails(ImporterWorkItem workItem)
        {
            bool isValidate = false;
            NetworkLocationInfo networkLocationInfo = new NetworkLocationInfo();
            // Capture the relevant information from the Details and put it in a Reference instance
            var detailsRef = new ImporterWorkItemDetailsReference();
            detailsRef.NetworkLocationIen = workItem.WorkItemDetails.NetworkLocationIen;
            detailsRef.MediaBundleStagingRootDirectory = workItem.WorkItemDetails.MediaBundleStagingRootDirectory;
            detailsRef.VaPatientFromStaging = workItem.WorkItemDetails.VaPatientFromStaging;
            workItem.WorkItemDetailsReference = detailsRef;
            //Fortify Mitigation recommendation for Path manipulation. Add code to santize the NetworkLocationIen variable string to be  well-formed  before calling network connection.(p289-OITCOPondiS)
            if (workItem != null && workItem.WorkItemDetails != null && !string.IsNullOrEmpty(workItem.WorkItemDetails.NetworkLocationIen))
                isValidate = PathUtilities.SantizeFilePathStatus(workItem.WorkItemDetails.NetworkLocationIen);
            //Process only if variable string is well-formed .(p289-OITCOPondiS)
            if (isValidate)
                networkLocationInfo = this.StorageDataSource.GetNetworkLocationDetails(workItem.WorkItemDetails.NetworkLocationIen);
            string serverAndShare = networkLocationInfo.PhysicalPath;
            string rootDir = workItem.WorkItemDetails.MediaBundleStagingRootDirectory;
            NetworkConnection conn = null;            
            //Fortify Mitigation recommendation for Path manipulation. Add code to santize the path variable string to be  well-formed  before utilizing FileInfo.(p289-OITCOPondiS)            
            isValidate = PathUtilities.SantizeFilePathStatus(serverAndShare);
            try
            {
                if (serverAndShare.StartsWith("\\\\") && isValidate)
                {
                    // Not a local drive. Open network connection
                    conn = NetworkConnection.GetNetworkConnection(
                        serverAndShare,
                        new NetworkCredential(networkLocationInfo.Username, networkLocationInfo.Password));

                    if (conn == null)
                    {
                        throw new NetworkLocationConnectionException("Could not connect to the current write location at '" + serverAndShare + "'");
                    }
                }

                //Fortify Mitigation recommendation for Path manipulation. Added code to Well-formed the path string validation before using FileInfo.(p289-OITCOPondiS)
                string fullPath = PathUtilities.CombinePath(serverAndShare, rootDir);

                //Fortify Mitigation recommendation for Path manipulation. Process code only when wel-formed fullPath string is rendered.(p289-OITCOPondiS)
                if (!string.IsNullOrEmpty(fullPath))
                {
                    //Fortify Mitigation recommendation for Path manipulation. Added code to Well-formed the path string validation before using FileInfo.(p289-OITCOPondiS)
                    fullPath = PathUtilities.CombinePath(fullPath, "ImporterWorkItemDetails.xml");

                  // Create the directory if it doesn't exist
                  /*
                  P332 - Gary Pham (oitlonphamg) (based on secondary code review meeting)
                  Validate string for nonprintable characters based on Fortify software recommendation.
                   */
                  //Old code commented by Gary Pham
                  //if (Regex.IsMatch(fullPath, "^[A-Za-z0-9 _.,\\\\!'/$;:%-]+$"))
                  //Begin - New code added by Gary Pham
                  //Logger.Info("Before regexvalidfilepath:  " + fullPath);
                  if (StringUtilities.IsRegexValidFilePath(fullPath))
                  //End - New code added by Gary Pham
					   {
                     //Logger.Info("After regexvalidfilepath:  " + fullPath);
	                    FileInfo f = new FileInfo(fullPath);
	                    if (f.Directory != null && !f.Directory.Exists)
	                    {
	                        f.Directory.Create();
	                    }
	
	                    if (File.Exists(fullPath))
	                    {
	                        try
	                        {
	                            File.SetAttributes(fullPath, FileAttributes.Normal);
	                            File.Delete(fullPath);
	                        }
	                        catch (Exception e)
	                        {
                        //Old - commented by Gary Pham
                        //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.Logged other details without by passing the actual issue reported by tool.(p289-OITCOPondiS)
                        //Logger.Info("Unable to delete existing XML file: " + fullPath, e);
                        //Begin - added this line of development based on secondary code review meeting.
                        Logger.Error("Unable to delete existing XML file - ", e);
                        //End - added this line of development based on secondary code review meeting.
                        /*Gary Pham (oitlonphamg)
                        P332
                        Validate string for nonprintable characters based on Fortify software recommendation.
                        */
                        //String strTemp = "Unable to delete existing XML file - " + e.Message;
						
						            //if (Regex.IsMatch(strTemp, "^[A-Za-z0-9 _.,\\\\!'/$;:%-]+$"))
                              //Begin - New code added by Gary Pham
                              // Commented out because of secondary code review meeting.
                              //if (StringUtilities.IsRegexValidLog(strTemp))
	                           //       Logger.Info(strTemp);
	                        }
	                    }
	
	                    // Stream it to an xml file
	                    var serializer = new XmlSerializer(typeof(ImporterWorkItemDetails));
	                    TextWriter tw = new StreamWriter(fullPath);
	                    serializer.Serialize(tw, workItem.WorkItemDetails);
	                    tw.Close();
	                    //BEGIN-To display the work item element StandardReportNumber if not dirty (p289-OITCOPondiS)
	                    string xml = File.ReadAllText(fullPath);
	                    xml = xml.Replace(" xsi:nil=\"true\"", "");
	                    File.WriteAllText(fullPath, xml);
	                    //END-To display the work item element StandardReportNumber if not dirty (p289-OITCOPondiS)
	                    // Now that it's safely stored, remove the reference so it doesn't get streamed.
	                    workItem.WorkItemDetails = null;
					}
					
					else
                    	Logger.Error("Network path string contains invalid characters. XML file is not generated. Please contact administrator.");
	
                }
                else
                {
                    Logger.Error("Network location is not sanitized. XML file is not generated. Please contact administrator.");
                }
            }
            catch (Exception e)
            {
               Logger.Error(e.Message, e);
            }
            finally
            {
                if (conn != null)
                {
                    conn.Dispose();
                }
            }
        }
        

        
        #endregion
    }
}