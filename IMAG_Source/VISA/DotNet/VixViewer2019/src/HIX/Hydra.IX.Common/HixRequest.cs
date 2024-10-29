namespace Hydra.IX.Common
{
    public enum HixRequest
    {
        // image records
        CreateImageRecord,
        GetImageRecord,
        SetImageRecordError,
        StoreImage,
        ProcessImage,

        // image group records
        CreateImageGroupRecord,
        GetImageGroupData,
        GetImageGroupRecord,
        GetImageGroupStatus,
        UpdateImageGroupRecord,
        DeleteImageGroupRecord,
        CreateDicomDir,

        // display context
        GetDisplayContextRecord,
        SearchDisplayContextRecords,
        CreateDisplayContextRecord,
        DeleteDisplayContextRecord,
        CreatePRFile,

        // dictionary
        AddDictionaryRecord,
        DeleteDictionaryRecord,
        GetDictionaryRecord,
        SearchDictionaryRecords,

        // log 
        GetLogSettings,
        SetLogSettings,
        GetLogFile,
        GetLogEvents,
        DeleteLogFiles,

        // cache
        PurgeCache,
        GetImagePart,
        GetCacheStatus,

        // service
        Default,
        GetStatus,
        CreateEventLogRecord,
        CreateSettingRecord,
        GetPdfFile,  //VAI-307
        GetServePdf  //VAI-1284
    }
}