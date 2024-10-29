--This script is used for creating the empty database.
--When we change the database: Update this file with the new schema, 
--run it to create a new empty database (i.e. sqlite3 SQLiteEmptyDb.db < schema.sql),
--and overwrite both .db files in src\HIX\Hydra.IX.Database\Db

DROP TABLE IF EXISTS [DictionaryRecords];
CREATE TABLE [DictionaryRecords] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"ParentId"		integer,
	"Name"		nvarchar COLLATE NOCASE,
	"Value"		nvarchar COLLATE NOCASE

);

DROP TABLE IF EXISTS [DisplayContexts];
CREATE TABLE [DisplayContexts] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"ContextId"		nvarchar(150) NOT NULL COLLATE NOCASE,
	"GroupUid"		nvarchar(40) NOT NULL COLLATE NOCASE,
	"Name"		nvarchar COLLATE NOCASE,
	"IsTagged"		bit,
	"IsDeleted"		bit,
	"Data"		nvarchar COLLATE NOCASE,
	"ImageCount"		integer NOT NULL

);
DROP INDEX IF EXISTS [DisplayContexts_DisplayContext_Index];
CREATE UNIQUE INDEX [DisplayContexts_DisplayContext_Index]
ON [DisplayContexts]
([GroupUid], [ContextId]);
DROP TABLE IF EXISTS [EventLogRecords];
CREATE TABLE [EventLogRecords] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"StartTime"		datetime,
	"EndTime"		datetime,
	"TransactionUid"		nvarchar COLLATE NOCASE,
	"ContextType"		integer NOT NULL,
	"Context"		nvarchar COLLATE NOCASE,
	"MessageType"		integer NOT NULL,
	"Message"		nvarchar COLLATE NOCASE

);
DROP TABLE IF EXISTS [ImageBackupRecords]; 
CREATE TABLE [ImageBackupRecords] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"ImageUid"		nvarchar(40) NOT NULL COLLATE NOCASE,
	"ImageStoreId"		integer NOT NULL,
	"IsComplete"		bit NOT NULL,
	"IsSucceeded"		bit,
	"RetryCount"		integer NOT NULL,
	"Status"		nvarchar COLLATE NOCASE

);
CREATE UNIQUE INDEX [ImageBackupRecords_ImageBackupRecord_Index]
ON [ImageBackupRecords]
([ImageUid], [ImageStoreId]);
DROP TABLE IF EXISTS [ImageGroups];
CREATE TABLE [ImageGroups] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"GroupUid"		nvarchar COLLATE NOCASE,
	"ParentGroupUid"		nvarchar COLLATE NOCASE,
	"RootGroupUid"		nvarchar COLLATE NOCASE,
	"StudyGroupUid"		nvarchar COLLATE NOCASE,
	"DateCreated"		datetime NOT NULL,
	"DateAccessed"		datetime,
	"FolderNumber"		integer NOT NULL,
	"RelativePath"		nvarchar COLLATE NOCASE,
	"ImageStoreId"		integer NOT NULL,
	"Xml"		nvarchar COLLATE NOCASE,
	"Name"		nvarchar COLLATE NOCASE,
	"IsTagged"		bit,
	"IsDeleted"		bit

);
DROP TABLE IF EXISTS [ImageParts];
CREATE TABLE [ImageParts] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"GroupUid"		nvarchar COLLATE NOCASE,
	"ImageUid"		nvarchar(40) NOT NULL COLLATE NOCASE,
	"DateCreated"		datetime NOT NULL,
	"Frame"		integer NOT NULL,
	"Type"		integer NOT NULL,
	"Transform"		integer NOT NULL,
	"AbsolutePath"		nvarchar COLLATE NOCASE,
	"IsStatic"		bit NOT NULL,
	"IsEncrypted"		bit NOT NULL,
	"OverlayIndex"		integer

);
DROP INDEX IF EXISTS [ImageParts_ImagePart_Index];
CREATE UNIQUE INDEX [ImageParts_ImagePart_Index]
ON [ImageParts]
([ImageUid], [Frame], [OverlayIndex], [Type], [Transform]);
DROP TABLE IF EXISTS [ImageFiles];
CREATE TABLE [ImageFiles] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"ImageUid"		nvarchar(40) NOT NULL COLLATE NOCASE,
	"RootGroupUid"		nvarchar COLLATE NOCASE,
	"GroupUid"		nvarchar(40) NOT NULL COLLATE NOCASE,
	"ExternalImageId"		nvarchar COLLATE NOCASE,
	"ImageType"		integer NOT NULL,
	"FileName"		nvarchar COLLATE NOCASE,
	"FileType"		integer NOT NULL,
	"RelativePath"		nvarchar COLLATE NOCASE,
	"IsUploaded"		bit NOT NULL,
	"DateUploaded"		datetime,
	"IsEncrypted"		bit NOT NULL,
	"IsProcessed"		bit NOT NULL,
	"IsSynced"		bit NOT NULL,
	"IsSucceeded"		bit,
	"IsDeleted"		bit,
	"Status"		nvarchar COLLATE NOCASE,
	"IsDicom"		bit,
	"SeriesInstanceUid"		nvarchar COLLATE NOCASE,
	"StudyInstanceUid"		nvarchar COLLATE NOCASE,
	"SopInstanceUid"		nvarchar COLLATE NOCASE,
	"InstanceNumber"		integer NOT NULL,
	"SeriesNumber"		integer NOT NULL,
	"ImageXml"		nvarchar COLLATE NOCASE,
	"IsTagged"		bit,
	"RefImageUid"		nvarchar COLLATE NOCASE,
	"DicomDirXml"		nvarchar COLLATE NOCASE,
	"DicomXml"		nvarchar COLLATE NOCASE,
	"Description"		nvarchar COLLATE NOCASE,
	"StudyId"		nvarchar COLLATE NOCASE,
	"StudyDescription"		nvarchar COLLATE NOCASE,
	"StudyDateTime"		nvarchar COLLATE NOCASE,
	"PatientDescription"		nvarchar COLLATE NOCASE,
	"IsOwner"		bit NOT NULL,
	"AlternatePath"		nvarchar COLLATE NOCASE,
	"BlobType"		integer

);
CREATE INDEX [ImageFiles_ImageFile_Index]
ON [ImageFiles]
([GroupUid], [IsUploaded], [IsProcessed], [IsSucceeded], [IsDicom]);
DROP TABLE IF EXISTS [RuleRecords];
CREATE TABLE [RuleRecords] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"Name"		nvarchar COLLATE NOCASE,
	"UserId"		integer NOT NULL,
	"Scope"		nvarchar COLLATE NOCASE,
	"ValueType"		nvarchar COLLATE NOCASE,
	"Value"		nvarchar COLLATE NOCASE,
	"IsDefault"		bit NOT NULL

);
DROP TABLE IF EXISTS [SeriesRecords];
CREATE TABLE [SeriesRecords] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"GroupUid"		nvarchar(40) NOT NULL COLLATE NOCASE,
	"SeriesInstanceUid"		nvarchar(100) NOT NULL COLLATE NOCASE,
	"StudyInstanceUid"		nvarchar COLLATE NOCASE,
	"SeriesNumber"		integer NOT NULL,
	"SeriesXml"		nvarchar COLLATE NOCASE,
	"DicomDirXml"		nvarchar COLLATE NOCASE

);
DROP INDEX IF EXISTS [SeriesRecords_SeriesRecord_Index];
CREATE UNIQUE INDEX [SeriesRecords_SeriesRecord_Index]
ON [SeriesRecords]
([GroupUid], [SeriesInstanceUid]);
DROP TABLE IF EXISTS [SettingRecords];
CREATE TABLE [SettingRecords] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"Name"		nvarchar(150) NOT NULL COLLATE NOCASE,
	"DefaultValue"		nvarchar COLLATE NOCASE

);
DROP INDEX IF EXISTS [SettingRecords_SettingRecord_Index];
CREATE UNIQUE INDEX [SettingRecords_SettingRecord_Index]
ON [SettingRecords]
([Name]);
DROP TABLE IF EXISTS [SettingsMaps];
CREATE TABLE [SettingsMaps] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"SettingRecord_Id"		integer NOT NULL,
	"UserRecord_Id"		integer NOT NULL,
	"Value"		nvarchar COLLATE NOCASE

);
DROP TABLE IF EXISTS [StudyParentRecords];
CREATE TABLE [StudyParentRecords] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"GroupUid"		nvarchar(40) NOT NULL COLLATE NOCASE,
	"StudyParentId"		nvarchar(100) NOT NULL COLLATE NOCASE,
	"StudyParentXml"		nvarchar COLLATE NOCASE,
	"DicomDirXml"		nvarchar COLLATE NOCASE

);
DROP INDEX IF EXISTS [StudyParentRecords_PatientRecord_Index];
CREATE UNIQUE INDEX [StudyParentRecords_PatientRecord_Index]
ON [StudyParentRecords]
([GroupUid], [StudyParentId]);
DROP TABLE IF EXISTS [StudyRecords];
CREATE TABLE [StudyRecords] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"GroupUid"		nvarchar(40) NOT NULL COLLATE NOCASE,
	"DicomStudyId"		nvarchar COLLATE NOCASE,
	"StudyInstanceUid"		nvarchar(100) NOT NULL COLLATE NOCASE,
	"PatientId"		nvarchar COLLATE NOCASE,
	"StudyXml"		nvarchar COLLATE NOCASE,
	"DicomDirXml"		nvarchar COLLATE NOCASE

);
DROP INDEX IF EXISTS [StudyRecords_StudyRecord_Index];
CREATE UNIQUE INDEX [StudyRecords_StudyRecord_Index]
ON [StudyRecords]
([GroupUid], [StudyInstanceUid]);
DROP TABLE IF EXISTS [TagMaps];
CREATE TABLE [TagMaps] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"TagId"		integer NOT NULL,
	"RefUid"		nvarchar(40) NOT NULL COLLATE NOCASE

);
DROP INDEX IF EXISTS [TagMaps_TagMap_Index];
CREATE UNIQUE INDEX [TagMaps_TagMap_Index]
ON [TagMaps]
([TagId], [RefUid]);
DROP TABLE IF EXISTS [Tags];
CREATE TABLE [Tags] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"Name"		nvarchar COLLATE NOCASE

);
DROP TABLE IF EXISTS [UserRecords];
CREATE TABLE [UserRecords] (
	"Id"		integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	"ExternalId"		nvarchar(150) NOT NULL COLLATE NOCASE,
	"Name"		nvarchar COLLATE NOCASE

);
DROP INDEX IF EXISTS [UserRecords_UserRecord_Index];
CREATE UNIQUE INDEX [UserRecords_UserRecord_Index]
ON [UserRecords]
([ExternalId]);

PRAGMA journal_mode = wal;
