using System;
using System.Collections.Generic;
using System.IO;
namespace Hydra.VistA
{
    interface IVixClient
    {
        void GetImage(string imageUrn, string securityToken, string transactionUid, System.IO.Stream outputStream, TimeSpan timeout, int retryCount);
        string GetPatientStudies(string patientICN, string patientDFN, string siteNumber, string securityToken, string imageFilter, bool isDash, VixHeaders vixHeaders = null);
        string GetVixJavaSecurityToken(VixHeaders vixHeaders);
        string GetStudyMetadata(string transactionUid, string contextId, string vixJavaSecurityToken, string dfn, string icn, string siteNumber);
        string GetStudyReport(string transactionUid, string contextId, string token, string dfn, string icn, string siteNumber);
        string QuerySiteService(string siteNumber);
        string GetDevFields(string objectUrn, string securityToken, VixHeaders vixHeaders = null);
        string GetGlobalNodes(string objectUrn, string securityToken, VixHeaders vixHeaders = null);
        string GetStudiesMetadata(string transactionUid, IEnumerable<string> contextIds, string vixSecurityToken, string patientDFN, string patientICN, string siteNumber, TimeSpan timeout);
        string GetPStateRecords(string contextId, string vixSecurityToken, bool includeDetails, bool includeOtherUsers);
        void AddPStateRecord(string contextId, string pStateUid, string name, string source, string data, string vixSecurityToken, string pstateFilePath);
        void DeletePStateRecord(string contextId, string pStateUid, string vixSecurityToken);
        string GetUserDetails(string userId, string siteNumber, string securityToken, VixHeaders vixHeaders = null);
        string DeleteImages(string[] imageUrns, string reasonForDelete, string siteNumber, string securityToken, VixHeaders vixHeaders);
        void SensitiveImages(string[] imageUrns, bool isSensitive, string siteNumber, string securityToken, VixHeaders vixHeaders);
        List<string> GetImageDeleteReasons(string securityToken);
        List<string> GetPrintReasons(string securityToken);
        string VerifyElectronicSignature(string eSignature, string siteNumber, string securityToken, VixHeaders vixHeaders = null);
        void StorePreference(string name, string value, string userId, bool isSystemLevel, string vixSecurityToken);
        string RetrievePreference(string name, string userId, bool isSystemLevel, string vixSecurityToken);
        string GetOtherPStateInformation(string contextId, string vixSecurityToken);
        string LogImageExport(string siteNumber, string imageUrn, string reason, string vixViewerSecurityToken, VixHeaders vixHeaders = null);
        string GetPatientInformation(string patientICN, string patientDFN, string siteNumber, string vixJavaSecurityToken, VixHeaders vixHeaders);
        string GetROIStatus(string patientICN, string patientDFN, string siteNumber, string vixSecurityToken, VixHeaders vixHeaders);
        string GetTreatingFacilities(string patientICN, string patientDFN, string siteNumber, string vixSecurityToken, VixHeaders vixHeaders);
        string GetVixVersion();
        string GetCDBurners(string securityToken);
        string SubmitROIRequest(string patientICN, string siteNumber, List<string> groupIENs, string target, string securityToken);
        string GetCaptureUsers(string securityToken, string fromDate, string throughDate);
        string GetImageFilters(string securityToken, string userId);
        string GetImageFilterDetails(string securityToken, string filterIEN);
        string SetImageProperties(string securityToken, dynamic imgArgs);
        string GetImageProperties(string securityToken, string imageIEN);
        string SearchStudy(string securityToken, string siteId, string studyFilter);
        string GetQAReviewReportStat(string securityToken, string flags, string fromDate, string throughDate);
        string GetQAReviewReports(string securityToken, string userId);
        void DownloadDisclosure(string securityToken, string patientId, string guid, Stream outputStream);
        dynamic GetImageEditOptions(string securityToken, string indexes);
    }
}
