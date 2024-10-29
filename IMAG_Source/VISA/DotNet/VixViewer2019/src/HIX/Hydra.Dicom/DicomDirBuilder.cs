using ClearCanvas.Dicom;
using Hydra.Entities;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;

namespace Hydra.Dicom
{
    public class DicomDirBuilder
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        private readonly DicomAttributeSQ _directoryRecordSequence;

        private DicomFile _dicomDirFile;

        private uint _fileOffset;

        public DicomDirBuilder(string aeTitle)
        {
            try
            {
                _dicomDirFile = new DicomFile();

                _dicomDirFile.MetaInfo[DicomTags.FileMetaInformationVersion].Values = new byte[] { 0x00, 0x01 };
                _dicomDirFile.MediaStorageSopClassUid = DicomUids.MediaStorageDirectoryStorage.UID;
                _dicomDirFile.SourceApplicationEntityTitle = aeTitle;
                _dicomDirFile.TransferSyntax = TransferSyntax.ExplicitVrLittleEndian;

                //_dicomDirFile.PrivateInformationCreatorUid = String.Empty;
                _dicomDirFile.DataSet[DicomTags.FileSetId].Values = String.Empty;
                ImplementationVersionName = DicomImplementation.Version;
                ImplementationClassUid = DicomImplementation.ClassUID.UID;

                _dicomDirFile.MediaStorageSopInstanceUid = DicomUid.GenerateUid().UID;

                // Set zero value so we can calculate the file Offset
                _dicomDirFile.DataSet[DicomTags.OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity].SetUInt32(0, 0);
                _dicomDirFile.DataSet[DicomTags.OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity].SetUInt32(0, 0);
                _dicomDirFile.DataSet[DicomTags.FileSetConsistencyFlag].SetUInt16(0, 0);

                _directoryRecordSequence = (DicomAttributeSQ)_dicomDirFile.DataSet[DicomTags.DirectoryRecordSequence];
            }
            catch (Exception ex)
            {
                //Platform.Log(LogLevel.Error, ex, "Exception initializing DicomDirectory");
                throw;
            }

        }

        public string ImplementationVersionName
        {
            get { return _dicomDirFile.ImplementationVersionName; }
            set
            {
                _dicomDirFile.ImplementationVersionName = value;
            }
        }

        public string ImplementationClassUid
        {
            get { return _dicomDirFile.ImplementationClassUid; }
            set
            {
                _dicomDirFile.ImplementationClassUid = value;
            }
        }


        private static DirectoryRecordSequenceItem CreateSeriesItem(DicomFile dicomFile)
        {
            IDictionary<uint, object> dicomTags = new Dictionary<uint, object>();
            dicomTags.Add(DicomTags.SeriesInstanceUid, null);
            dicomTags.Add(DicomTags.Modality, null);
            dicomTags.Add(DicomTags.SeriesDate, null);
            dicomTags.Add(DicomTags.SeriesTime, null);
            dicomTags.Add(DicomTags.SeriesNumber, null);
            dicomTags.Add(DicomTags.SeriesDescription, null);
            //dicomTags.Add(DicomTags.SeriesDescription, dicomFile.DataSet[DicomTags.SeriesDescription].GetString(0, String.Empty));

            return AddSequenceItem(DirectoryRecordType.Series, dicomFile.DataSet, dicomTags);
        }

        private static DirectoryRecordSequenceItem CreateStudyItem(DicomFile dicomFile)
        {
            IDictionary<uint, object> dicomTags = new Dictionary<uint, object>();
            dicomTags.Add(DicomTags.StudyInstanceUid, null);
            dicomTags.Add(DicomTags.StudyId, null);
            dicomTags.Add(DicomTags.StudyDate, null);
            dicomTags.Add(DicomTags.StudyTime, null);
            dicomTags.Add(DicomTags.AccessionNumber, null);
            dicomTags.Add(DicomTags.StudyDescription, null);

            return AddSequenceItem(DirectoryRecordType.Study, dicomFile.DataSet, dicomTags);
        }

        private static DirectoryRecordSequenceItem CreatePatientItem(DicomFile dicomFile)
        {
            IDictionary<uint, object> dicomTags = new Dictionary<uint, object>();
            dicomTags.Add(DicomTags.PatientsName, null);
            dicomTags.Add(DicomTags.PatientId, null);
            dicomTags.Add(DicomTags.PatientsBirthDate, null);
            dicomTags.Add(DicomTags.PatientsSex, null);

            return AddSequenceItem(DirectoryRecordType.Patient, dicomFile.DataSet, dicomTags);
        }

        private static DirectoryRecordSequenceItem CreateImageItem(DicomFile dicomFile, string optionalDicomDirFileLocation)
        {
            //if (String.IsNullOrEmpty(optionalDicomDirFileLocation))
            //{
            //    optionalDicomDirFileLocation = EvaluateRelativePath(_saveFileName, dicomFile.Filename);
            //}

            DirectoryRecordType type;
            if (DirectoryRecordDictionary.TryGetDirectoryRecordType(dicomFile.SopClass.Uid, out type))
            {
                string name;
                DirectoryRecordTypeDictionary.TryGetName(type, out name);

                IDictionary<uint, object> dicomTags = new Dictionary<uint, object>();
                dicomTags.Add(DicomTags.ReferencedFileId, optionalDicomDirFileLocation);
                dicomTags.Add(DicomTags.ReferencedSopClassUidInFile, dicomFile.SopClass.Uid);
                dicomTags.Add(DicomTags.ReferencedSopInstanceUidInFile, dicomFile.MediaStorageSopInstanceUid);
                dicomTags.Add(DicomTags.ReferencedTransferSyntaxUidInFile, dicomFile.TransferSyntaxUid);

                // NOTE:  This is a bit problematic, but sufficient for now. We should take into account
                // which tags are type 2 and which are type 1 and which are conditional when setting them 
                // in AddSequenceItem
                List<uint> tagList;
                if (DirectoryRecordDictionary.TryGetDirectoryRecordTagList(type, out tagList))
                    foreach (uint tag in tagList)
                        dicomTags.Add(tag, null);

                return AddSequenceItem(type, dicomFile.DataSet, dicomTags);
            }

            return null;
        }

        private static DirectoryRecordSequenceItem AddSequenceItem(DirectoryRecordType recordType, IDicomAttributeProvider dataSet, IDictionary<uint, object> tags)
        {
            DirectoryRecordSequenceItem dicomSequenceItem = new DirectoryRecordSequenceItem { ValidateVrLengths = false };
            dicomSequenceItem[DicomTags.OffsetOfTheNextDirectoryRecord].Values = 0;
            dicomSequenceItem[DicomTags.RecordInUseFlag].Values = 0xFFFF;
            dicomSequenceItem[DicomTags.OffsetOfReferencedLowerLevelDirectoryEntity].Values = 0;

            string recordName;
            DirectoryRecordTypeDictionary.TryGetName(recordType, out recordName);
            dicomSequenceItem[DicomTags.DirectoryRecordType].Values = recordName;

            DicomAttribute charSetAttrib;
            if (dataSet.TryGetAttribute(DicomTags.SpecificCharacterSet, out charSetAttrib))
                dicomSequenceItem[DicomTags.SpecificCharacterSet] = charSetAttrib.Copy();

            foreach (uint dicomTag in tags.Keys)
            {
                try
                {
                    ClearCanvas.Dicom.DicomTag dicomTag2 = DicomTagDictionary.GetDicomTag(dicomTag);
                    DicomAttribute attrib;
                    if (tags[dicomTag] != null)
                    {
                        dicomSequenceItem[dicomTag].Values = tags[dicomTag];
                    }
                    else if (dataSet.TryGetAttribute(dicomTag, out attrib))
                    {
                        dicomSequenceItem[dicomTag].Values = attrib.Values;
                    }
                    else
                    {
                        //Platform.Log(LogLevel.Info, "Cannot find dicomTag {0} for record type {1}", dicomTag2 != null ? dicomTag2.ToString() : dicomTag.ToString(), recordType);
                    }
                }
                catch (Exception ex)
                {
                    //Platform.Log(LogLevel.Error, ex, "Exception adding dicomTag {0} to directory record for record type {1}", dicomTag, recordType);
                }
            }

            return dicomSequenceItem;
        }

        public static string CreateDicomDirXml(DicomFile dicomFile, string imageFileName)
        {
            if (dicomFile.DataSet == null)
                return null;

            DirectoryRecordSequenceItem imageRecord = CreateImageItem(dicomFile, imageFileName);

            return (imageRecord != null) ?ConvertDicomDir(imageRecord) : null;
        }

        public static string CreateStudyDicomDirXml(DicomFile dicomFile)
        {
            DirectoryRecordSequenceItem studyRecord = CreateStudyItem(dicomFile);
            return ConvertDicomDir(studyRecord);
        }

        public static string CreateSeriesDicomDirXml(DicomFile dicomFile)
        {
            DirectoryRecordSequenceItem seriesRecord = CreateSeriesItem(dicomFile);
            return ConvertDicomDir(seriesRecord);
        }

        public static string CreatePatientDicomDirXml(DicomFile dicomFile)
        {
            DirectoryRecordSequenceItem patientRecord = CreatePatientItem(dicomFile);
            return ConvertDicomDir(patientRecord);
        }

        private DirectoryRecordSequenceItem _rootRecord;

        private static DirectoryRecordSequenceItem ParseDicomDirXml(string dicomDirXml)
        {
            DirectoryRecordSequenceItem dicomSequenceItem = new DirectoryRecordSequenceItem { ValidateVrLengths = false };

            XDocument doc = XDocument.Parse(dicomDirXml);
            IEnumerable<XElement> attribList = from attrib in doc.Root.Elements() select attrib;
            foreach (XElement e in attribList)
            {
                uint tagValue = uint.Parse(e.Attribute("Tag").Value); 
                ClearCanvas.Dicom.DicomTag tag = ClearCanvas.Dicom.DicomTag.GetTag(tagValue);

                dicomSequenceItem[tag].Values = e.Value;
            }

            return dicomSequenceItem;
        }

        private static string ConvertDicomDir(DirectoryRecordSequenceItem item)
        {
            try
            {
                XDocument doc = new XDocument
                    (
                        new XDeclaration("1.0", "utf-8", "yes"),
                        new XElement("Attributes",
                                     from attrib in item
                                     select new XElement("Attrib", new XAttribute("Tag", attrib.Tag.TagValue), new XAttribute("VR", attrib.Tag.VR.ToString()), attrib.ToString()))
                    );

                return doc.ToString();
            }
            catch (Exception)
            {
                return null;
            }
        }

        public object AddPatient(string patientId, string dicomDirXml)
        {
            DirectoryRecordSequenceItem patientRecord = null;

            if (_rootRecord == null)
                _rootRecord = patientRecord = ParseDicomDirXml(dicomDirXml);
            else
            {
                // add at the end
                DirectoryRecordSequenceItem currentPatient = _rootRecord;
                while (currentPatient != null)
                {
                    if (currentPatient[DicomTags.PatientId].Equals(patientId))
                    {
                        patientRecord = currentPatient;
                        break;
                    }

                    if (currentPatient.NextDirectoryRecord == null)
                    {
                        patientRecord = currentPatient.NextDirectoryRecord = ParseDicomDirXml(dicomDirXml);
                        break;
                    }

                    currentPatient = currentPatient.NextDirectoryRecord;
                }
            }

            return patientRecord;
        }

        public object AddStudy(object parent, string studyInstanceUid, string dicomDirXml)
        {
            DirectoryRecordSequenceItem studyRecord = null;
            DirectoryRecordSequenceItem patientRecord = parent as DirectoryRecordSequenceItem;

            if (patientRecord.LowerLevelDirectoryRecord == null)
                patientRecord.LowerLevelDirectoryRecord = studyRecord = ParseDicomDirXml(dicomDirXml);
            else
            {
                DirectoryRecordSequenceItem currentStudy = patientRecord.LowerLevelDirectoryRecord;
                while (currentStudy != null)
                {
                    if (currentStudy[DicomTags.StudyInstanceUid].Equals(studyInstanceUid))
                    {
                        studyRecord = currentStudy;
                        break;
                    }

                    if (currentStudy.NextDirectoryRecord == null)
                    {
                        studyRecord = currentStudy.NextDirectoryRecord = ParseDicomDirXml(dicomDirXml);
                        break;
                    }

                    currentStudy = currentStudy.NextDirectoryRecord;
                }
            }

            return studyRecord;
        }

        public object AddSeries(object parent, string seriesInstanceUid, string dicomDirXml)
        {
            DirectoryRecordSequenceItem seriesRecord = null;
            DirectoryRecordSequenceItem studyRecord = parent as DirectoryRecordSequenceItem;

            if (studyRecord.LowerLevelDirectoryRecord == null)
                studyRecord.LowerLevelDirectoryRecord = seriesRecord = ParseDicomDirXml(dicomDirXml);
            else
            {
                DirectoryRecordSequenceItem currentSeries = studyRecord.LowerLevelDirectoryRecord;
                while (currentSeries != null)
                {
                    if (currentSeries[DicomTags.SeriesInstanceUid].Equals(seriesInstanceUid))
                    {
                        seriesRecord = currentSeries;
                        break;
                    }

                    if (currentSeries.NextDirectoryRecord == null)
                    {
                        seriesRecord = currentSeries.NextDirectoryRecord = ParseDicomDirXml(dicomDirXml);
                        break;
                    }

                    currentSeries = currentSeries.NextDirectoryRecord;
                }
            }

            return seriesRecord;
        }

        public object AddImage(object parent, object previousItem, string fileLocation, string dicomDirXml)
        {
            DirectoryRecordSequenceItem seriesRecord = parent as DirectoryRecordSequenceItem;
            DirectoryRecordSequenceItem imageRecord = null;

            if (seriesRecord.LowerLevelDirectoryRecord == null)
            {
                seriesRecord.LowerLevelDirectoryRecord = imageRecord = ParseDicomDirXml(dicomDirXml);
            }
            else
            {
                imageRecord = (previousItem as DirectoryRecordSequenceItem).NextDirectoryRecord = ParseDicomDirXml(dicomDirXml);
            }

            imageRecord[DicomTags.ReferencedFileId].Values = fileLocation;

            return imageRecord;
        }

        private void AddDirectoryRecordsToSequenceItem(DirectoryRecordSequenceItem root)
        {
            if (root == null)
                return;

            _directoryRecordSequence.AddSequenceItem(root);

            if (root.LowerLevelDirectoryRecord != null)
                AddDirectoryRecordsToSequenceItem(root.LowerLevelDirectoryRecord);

            if (root.NextDirectoryRecord != null)
                AddDirectoryRecordsToSequenceItem(root.NextDirectoryRecord);
        }

        private void CalculateOffsets(TransferSyntax syntax, DicomWriteOptions options)
        {
            foreach (DicomSequenceItem sq in (DicomSequenceItem[])_dicomDirFile.DataSet[DicomTags.DirectoryRecordSequence].Values)
            {
                DirectoryRecordSequenceItem record = sq as DirectoryRecordSequenceItem;
                if (record == null)
                    throw new ApplicationException("Unexpected type for directory record: " + sq.GetType());

                record.Offset = _fileOffset;

                _fileOffset += 4 + 4; // Sequence Item Tag

                _fileOffset += record.CalculateWriteLength(syntax, options & ~DicomWriteOptions.CalculateGroupLengths);
                if (!Flags.IsSet(options, DicomWriteOptions.ExplicitLengthSequenceItem))
                    _fileOffset += 4 + 4; // Sequence Item Delimitation Item
            }
            if (!Flags.IsSet(options, DicomWriteOptions.ExplicitLengthSequence))
                _fileOffset += 4 + 4; // Sequence Delimitation Item
        }

        private static void SetOffsets(DirectoryRecordSequenceItem root)
        {
            if (root.NextDirectoryRecord != null)
            {
                root[DicomTags.OffsetOfTheNextDirectoryRecord].Values = root.NextDirectoryRecord.Offset;
                SetOffsets(root.NextDirectoryRecord);
            }
            else
                root[DicomTags.OffsetOfTheNextDirectoryRecord].Values = 0;

            if (root.LowerLevelDirectoryRecord != null)
            {
                root[DicomTags.OffsetOfReferencedLowerLevelDirectoryEntity].Values = root.LowerLevelDirectoryRecord.Offset;
                SetOffsets(root.LowerLevelDirectoryRecord);
            }
            else
                root[DicomTags.OffsetOfReferencedLowerLevelDirectoryEntity].Values = 0;
        }

        public void Save(Stream stream)
        {
            const DicomWriteOptions options = DicomWriteOptions.Default;

            if (_rootRecord == null)
                throw new InvalidOperationException("No Dicom Files added, cannot save dicom directory");

            //_saveFileName = fileName;

            // Clear so that the calculations work properly on the length.
            _directoryRecordSequence.ClearSequenceItems();

            //Calculate the offset in the file to the beginning of the Directory Record Sequence Tag
            _fileOffset = 128 // Preamble Length
                + 4 // DICM Characters
                + _dicomDirFile.MetaInfo.CalculateWriteLength(_dicomDirFile.TransferSyntax, DicomWriteOptions.CalculateGroupLengths) // Must calc including Group lengths for (0002,0000)
                + _dicomDirFile.DataSet.CalculateWriteLength(0, DicomTags.DirectoryRecordSequence - 1, _dicomDirFile.TransferSyntax, options); // Length without the Directory Record Sequence Attribute

            //Add the offset for the Directory Record sequence tag itself
            _fileOffset += 4; // element tag
            if (_dicomDirFile.TransferSyntax.ExplicitVr)
            {
                _fileOffset += 2 + 2 + 4; // 2 (VR) + 2 (reserved) + 4 (length)
            }
            else
            {
                _fileOffset += 4; // length
            }

            // go through the tree of records and add them back into the dataset.
            AddDirectoryRecordsToSequenceItem(_rootRecord);

            // Double check to make sure at least one file was added.
            if (_rootRecord != null)
            {
                // Calculate offsets for each directory record
                CalculateOffsets(_dicomDirFile.TransferSyntax, options);

                // Traverse through the tree and set the offsets.
                SetOffsets(_rootRecord);

                //Set the offsets in the dataset 
                _dicomDirFile.DataSet[DicomTags.OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity].Values = _rootRecord.Offset;

                DirectoryRecordSequenceItem lastRoot = _rootRecord;
                while (lastRoot.NextDirectoryRecord != null) lastRoot = lastRoot.NextDirectoryRecord;

                _dicomDirFile.DataSet[DicomTags.OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity].Values =
                    lastRoot.Offset;
            }
            else
            {
                _dicomDirFile.DataSet[DicomTags.OffsetOfTheFirstDirectoryRecordOfTheRootDirectoryEntity].Values = 0;
                _dicomDirFile.DataSet[DicomTags.OffsetOfTheLastDirectoryRecordOfTheRootDirectoryEntity].Values = 0;
            }

            try
            {
                _dicomDirFile.Save(stream, options);

            }
            catch (Exception ex)
            {
                //Platform.Log(LogLevel.Error, ex, "Error saving dicom File {0}", fileName);
                throw;
            }
        }

        public bool IsValid()
        {
            // just check the root record for now
            return (_rootRecord != null);
        }

    }
}
