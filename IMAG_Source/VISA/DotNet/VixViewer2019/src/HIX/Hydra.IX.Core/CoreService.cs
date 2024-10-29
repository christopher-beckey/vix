using Hydra.IX.Database.Common;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Core
{
    public class CoreService : ICoreService
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private IHixDbContextFactory _HixDbContextFactory = null;

        public CoreService(IHixDbContextFactory hixDbContextFactory)
        {

        }

        public Common.NewImageGroupResponse CreateImageGroupRecord(Common.NewImageGroupRequest newImageGroupRequest)
        {
            throw new NotImplementedException();
        }

        public Common.ImageGroupRecord GetImageGroupRecord(string groupUid)
        {
            throw new NotImplementedException();
        }

        public Common.NewImageGroupResponse UpdateImageGroupRecord(Common.UpdateImageGroupRequest request)
        {
            throw new NotImplementedException();
        }

        public void DeleteImageGroupRecord(string groupUid)
        {
            throw new NotImplementedException();
        }

        public string GetImageGroupDataAsJson(string groupUid)
        {
            throw new NotImplementedException();
        }

        public Common.ImageGroupStatus GetImageGroupStatus(Common.ImageGroupStatusRequest request)
        {
            throw new NotImplementedException();
        }

        public Common.NewImageResponse CreateImageRecord(Common.NewImageRequest newImageRequest)
        {
            throw new NotImplementedException();
        }

        public Common.ImageRecord GetImageRecord(string imageUid)
        {
            throw new NotImplementedException();
        }

        public void SetImageRecordError(string imageUid, string error)
        {
            throw new NotImplementedException();
        }

        public void GetImagePart(Common.ImagePartRequest request)
        {
            throw new NotImplementedException();
        }

        public void StoreImage(string imageUid, System.IO.Stream stream)
        {
            throw new NotImplementedException();
        }

        public void ProcessImage(string imageUid, string filePath)
        {
            throw new NotImplementedException();
        }

        public void CreateDisplayContextRecord(Common.NewDisplayContextRequest request)
        {
            throw new NotImplementedException();
        }

        public void DeleteDisplayContextRecord(string contextId)
        {
            throw new NotImplementedException();
        }

        public Common.DisplayContextRecord GetDisplayContextRecord(string contextId)
        {
            throw new NotImplementedException();
        }

        public Common.SearchDisplayContextResponse SearchDisplayContextRecords(Common.SearchDisplayContextRequest request)
        {
            throw new NotImplementedException();
        }

        public Common.DicomDirResponse CreateDicomDir(Common.DicomDirRequest request)
        {
            throw new NotImplementedException();
        }

        public void CreateEventLogRecord(Common.EventLogRequest request)
        {
            throw new NotImplementedException();
        }

        public void AddDictionaryRecord(string name, string value)
        {
            throw new NotImplementedException();
        }

        public void DeleteDictionaryRecord(string name)
        {
            throw new NotImplementedException();
        }

        public string GetDictionaryRecord(string name)
        {
            throw new NotImplementedException();
        }

        public string[] SearchDictionaryRecords(string name)
        {
            throw new NotImplementedException();
        }

        public void PurgeCache()
        {
            throw new NotImplementedException();
        }

        public Log.LogSettings GetLogSettings()
        {
            throw new NotImplementedException();
        }

        public string GetLogFile(Common.LogSettingsRequest request)
        {
            throw new NotImplementedException();
        }
    }
}
