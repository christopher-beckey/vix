using Hydra.IX.Common;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Core
{
    public interface ICoreService
    {
        NewImageGroupResponse CreateImageGroupRecord(NewImageGroupRequest newImageGroupRequest);
        ImageGroupRecord GetImageGroupRecord(string groupUid);
        NewImageGroupResponse UpdateImageGroupRecord(UpdateImageGroupRequest request);
        void DeleteImageGroupRecord(string groupUid);
        string GetImageGroupDataAsJson(string groupUid);
        ImageGroupStatus GetImageGroupStatus(ImageGroupStatusRequest request);
        NewImageResponse CreateImageRecord(NewImageRequest newImageRequest);
        ImageRecord GetImageRecord(string imageUid);
        void SetImageRecordError(string imageUid, string error);
        void GetImagePart(ImagePartRequest request);
        void StoreImage(string imageUid, Stream stream);
        void ProcessImage(string imageUid, string filePath);
        void CreateDisplayContextRecord(NewDisplayContextRequest request);
        void DeleteDisplayContextRecord(string contextId);
        DisplayContextRecord GetDisplayContextRecord(string contextId);
        SearchDisplayContextResponse SearchDisplayContextRecords(SearchDisplayContextRequest request);
        //todo
        // ServiceStats GetServiceStats()
        DicomDirResponse CreateDicomDir(DicomDirRequest request);
        void CreateEventLogRecord(EventLogRequest request);
        void AddDictionaryRecord(string name, string value);
        void DeleteDictionaryRecord(string name);
        string GetDictionaryRecord(string name);
        string[] SearchDictionaryRecords(string name);
        void PurgeCache();
        LogSettings GetLogSettings();
        string GetLogFile(LogSettingsRequest request);
    }
}
