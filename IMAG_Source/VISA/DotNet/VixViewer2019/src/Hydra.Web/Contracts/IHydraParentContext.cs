using Hydra.IX.Common;
using Hydra.VistA;
using Hydra.Web.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Http.Headers;

namespace Hydra.Web.Contracts
{
    public interface IHydraParentContext
    {
        //VAI-707: Refactored many method signatures to encapsulate parameters
        void GetImagePart(Hydra.IX.Common.ImagePartRequest imagePartRequest, Action<Stream, int, string, HttpHeaders> responseDelegate);
        DisplayContextDetails GetDisplayContext(VistAQuery vistAQuery);
        void DeleteDisplayContext(VistAQuery vistaQuery);
        void PrepareForDisplay(VistAQuery vistAQuery);
        void CacheDisplayContext(VistAQuery vistaQuery, string body);
        List<EventLogItem> GetEvents(Dictionary<string, object> requestParams);
        void AddDictionaryItem(string level, string name, string value, VistAQuery vistaQuery);
        void DeleteDictionaryItem(string level, string name, VistAQuery vistaQuery);
        string GetDictionaryItem(string level, string name, VistAQuery vistaQuery);
        void ExportDisplayContext(VistAQuery vistaQuery, Action<Stream, int, string, HttpHeaders> responseDelegate);
        void ValidateSession(string securityToken, Dictionary<string, IEnumerable<string>> requestHeaders, string clientHostAddress);
        DicomDirManifest CreateDicomDirManifest(VistAQuery vistaQuery);
        void GetImage(ImageQuery imageQuery, Action<Stream, int, string, HttpHeaders> responseDelegate);
        string GetImageUrn(string imageUid); //VAI-707

        // Presentation states
        List<Hydra.Common.Entities.StudyPresentationState> GetPresentationStates(VistAQuery vistaQuery);
        string AddPresentationState(VistAQuery vistaQuery, Hydra.Common.Entities.StudyPresentationState pstate);
        void DeletePresentationState(VistAQuery vistaQuery, Hydra.Common.Entities.StudyPresentationState pstate);

        // Metadata
        string GetMetadata(MetadataQuery metadataQeury);
        DisplayContextMetadata GetDisplayContextMetadata(VistAQuery vistaQuery);
        ImageDeleteResponse[] DeleteImageMetadata(VistAQuery vistaQuery, ImageDeleteRequest request);
        string GetMetadataImageInfo(Nancy.NancyContext ctx);
        void SensitiveImageMetadata(VistAQuery vistaQuery, SensitiveImageRequest request);

        List<string> GetImageDeleteReasons(VistAQuery vistaQuery);
        List<string> GetPrintReasons(VistAQuery vistaQuery);

        // ROI
        string GetCDBurners(VistAQuery vistaQuerys);
        void DownloadDisclosure(VistAQuery vistaQuery, string patientId, string guid, Action<Stream, int, string, HttpHeaders> responseDelegate);

        // QA
        string GetCaptureUsers(VistAQuery vistaQuery, string fromDate, string throughDate);
        string GetImageFilters(VistAQuery vistaQuery, string userId);
        string GetImageFilterDetails(VistAQuery vistaQuery, string filterIEN);
        string SetImageProperties(VistAQuery vistaQuery, dynamic imgArgs);
        string GetImageProperties(VistAQuery vistaQuery, string imageIEN);
        string SearchStudy(VistAQuery vistaQuery, string siteId, string studyFilter);
        string GetQAReviewReportStat(VistAQuery vistaQuery, string flags, string fromDate, string throughDate);
        string GetQAReviewReports(VistAQuery vistaQuery, string userId);

        // Image edit
        dynamic GetImageEditOptions(VistAQuery vistaQuery, string indexes);

        // User
        UserDetails GetUserDetails(VistAQuery vistaQuery);
        string UserClientHostAddress { get; set; } //VAI-707: Added for session handling

        // ExternalLink
        ExternalLink[] GetExternalLinks(Dictionary<string, object> requestParams);
        string HelpFilePath { get; }

        // Purge
        void PurgeCache(VistAQuery vistaQuery);

        // Log
        Hydra.IX.Common.LogSettingsResponse GetLogSettings(string application);
        void SetLogSettings(Hydra.IX.Common.LogSettingsRequest request);
        Hydra.IX.Common.LogSettingsResponse GetLogFiles(string application);
        void GetLogFile(string application, string logFileName, Action<Stream, int, string, HttpHeaders> responseDelegate);
        Hydra.IX.Common.LogSettingsResponse GetLogEvents(string application, string logFileName, int pageSize, int pageIndex);
        void DeleteLogFiles(string application, string logFileName);

        IDictionary<string, string> GetServiceStatus();
    }
}
