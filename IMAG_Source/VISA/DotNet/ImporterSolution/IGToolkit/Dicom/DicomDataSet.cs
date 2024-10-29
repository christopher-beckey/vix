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


using System;
using System.Collections.Generic;
using System.Net;
using GearCORELib;
using GearFORMATSLib;
using GearMEDLib;
using System.Collections.ObjectModel;
using ImagingClient.Infrastructure.Dicom;
using ImagingClient.Infrastructure.Utilities;

namespace IGToolkit.Dicom
{
    public class DicomDataSet : IDicomDataSet
    {
        // Patient
        private const string PatientNameTag = "0010,0010";
        private const string PatientIdTag = "0010,0020";
        private const string PatientBirthDateTag = "0010,0030";
        private const string PatientSexTag = "0010,0040";

        // Study
        private const string StudyUidTag = "0020,000D";
        private const string StudyDateTag = "0008,0020";
        private const string StudyTimeTag = "0008,0030";
        private const string ReferringPhysicianTag = "0008,0090";
        private const string AccessionNumberTag = "0008,0050";
        private const string StudyDescriptionTag = "0008,1030";

        // Series
        private const string SeriesUidTag = "0020,000E";
        private const string SeriesDateTag = "0008,0021";
        private const string SeriesDescriptionTag = "0008,103E";
        private const string ModalityTag = "0008,0060";
        private const string FacilityTag = "0008,0080";
        private const string InstitutionAddressTag = "0008,0081";

        // SopInstance
        private const string SopInstanceUidTag = "0008,0018";
        private const string SopClassUidTag = "0004,1510";
        private const string TransferSyntaxUidTag = "0004,1512";
        private const string ImageNumberTag = "0020,0013";
        private const string NumberOfFramesTag = "0028,0008";

        private Dictionary<String, String> tagValueDictionary = new Dictionary<string, string>();
        public ObservableCollection<DicomHeaderRecord> DataSetRecords { get; set; }
        public ObservableCollection<DicomHeaderRecord> FileMetaInfoRecords { get; set; }
        public bool DataSetLoaded { get; set; }
        public bool FileMetaInfoRecordsLoaded { get; set; }
        public bool CanDisplayHeaderInfo { get { return DataSetLoaded || FileMetaInfoRecordsLoaded; } }
        public String ErrorMessage { get; set; }

        public IGMedPage CurrentMedPage { get; set; }
        public IGMedDataDict MedDataDict { get; set; }
        public IGMedElemList DataSet { get; set; }

        // Patient properties
        public String PatientName { get { return GetTagValue(PatientNameTag); } }
        public String PatientId { get { return GetTagValue(PatientIdTag); } }
        public String PatientBirthDate { get { return GetTagValue(PatientBirthDateTag); } }
        public String PatientSex { get { return GetTagValue(PatientSexTag); } }

        // Study properties
        public String StudyUid { get { return GetTagValue(StudyUidTag); } }
        public String StudyDate { get { return GetTagValue(StudyDateTag); } }
        public String StudyTime { get { return GetTagValue(StudyTimeTag); } }
        public String AccessionNumber { get { return GetTagValue(AccessionNumberTag); } }
        public String StudyDescription { get { return GetTagValue(StudyDescriptionTag); } }
        public String ReferringPhysician { get { return StringUtilities.ConvertDicomName(GetTagValue(ReferringPhysicianTag)); } }

        // Series properties
        public String SeriesUid { get { return GetTagValue(SeriesUidTag); } }
        public String SeriesDate { get { return GetTagValue(SeriesDateTag); } }
        public String SeriesDescription { get { return GetTagValue(SeriesDescriptionTag); } }
        public String Modality { get { return GetTagValue(ModalityTag); } }
        public String Facility { get { return GetTagValue(FacilityTag); } }
        public String InstitutionAddress { get { return GetTagValue(InstitutionAddressTag); } }

        // SOP Instance properties
        public String SopInstanceUid { get { return GetTagValue(SopInstanceUidTag); } }
        public String SopClassUid { get { return GetTagValue(SopClassUidTag); } }
        public String TransferSyntaxUid { get { return GetTagValue(TransferSyntaxUidTag); } }
        public String ImageNumber { get { return GetTagValue(ImageNumberTag); } }
        public String NumberOfFrames { get { return GetTagValue(NumberOfFramesTag); } }

        private string GetTagValue(string tag)
        {
            String value = String.Empty;
            if (tagValueDictionary.ContainsKey(tag))
            {
                value = tagValueDictionary[tag];
            }

            return value;
        }

        public DicomDataSet(String fileName, String serverShare, String username, String password)
        {
            NetworkConnection conn = null;
            try
            {
                if (serverShare.StartsWith("\\\\"))
                {
                    // Not a local drive. Open network connection
                    conn = NetworkConnection.GetNetworkConnection(serverShare, new NetworkCredential(username, password));
                }
                LoadImageAndParseHeader(fileName);
            }
            finally
            {
                if (conn != null)
                {
                    conn.Dispose();
                }
            }

        }

        public DicomDataSet(String fileName)
        {
            LoadImageAndParseHeader(fileName);
        }

        private void LoadImageAndParseHeader(string fileName)
        {
            // Load the image
            if (LoadImage(fileName))
            {
                // Parse the header
                ParseHeader();
            }
        }

        private bool LoadImage(string fileName)
        {
            bool result = false;
            try
            {
                IGPage currentPage = IGComponentManager.getComponentManager().IGCoreCtrl.CreatePage();
                CreateMedPage(currentPage);
                CreateMedDataDict();
                currentPage.Clear();

                if (!string.IsNullOrEmpty(fileName))
                {
                    if (System.IO.File.Exists(fileName))
                    {
                        
                        IIGIOLocation ioLocation = (IIGIOLocation)IGComponentManager.getComponentManager().IGFormatsCtrl.CreateObject(enumIGFormatsObjType.IG_FORMATS_OBJ_IOFILE);
                        ((IGIOFile)ioLocation).FileName = fileName;
                        IGComponentManager.getComponentManager().IGFormatsCtrl.LoadPageFromFile(currentPage, fileName, 0);

                        result = true;
                    }
                    else
                    {
                        ErrorMessage = "File [" + fileName + "] does not exist";
                    }
                }
                else
                {
                    ErrorMessage = "No file specified";
                }
            }
            catch (Exception ex)
            {
                ErrorMessage = ex.Message;
            }
            return result;
        }

        private void ParseHeader()
        {
           
            if (!CurrentMedPage.IsDICOMStructurePresent(enumIGMedDICOMStructureType.MED_STRUCTURE_TYPE_DATASET))
            {
                ErrorMessage = "Current image does not contain a DataSet";
            }
            else
            {
                LoadDataSetRecords();
                LoadFileMetaInfoRecords();
            }
        }


        private void LoadDataSetRecords()
        {
            try
            {
                DataSet = CurrentMedPage.DataSet;

                if ((DataSet != null) && (DataSet.ElemCount > 0))
                {
                    DataSet.MoveFirst(enumIGMedLevelOption.MED_DCM_MOVE_LEVEL_FLOAT);
                    DataSetRecords = ReadHeaderRecords();
                }
            }
            catch (Exception e)
            {
                ErrorMessage = "Unable to load DataSet records: " + e.Message;
            }
        }

        private void LoadFileMetaInfoRecords()
        {
            try
            {
                DataSet = CurrentMedPage.FileMetaInfo;

                if ((DataSet != null) && (DataSet.ElemCount > 0))
                {
                    DataSet.MoveFind(enumIGMedLevelOption.MED_DCM_MOVE_LEVEL_FLOAT,
                                     (int)enumIGMedTag.DCM_TAG_FileMetaInformationVersion);
                    FileMetaInfoRecords = ReadHeaderRecords();
                }
            }
            catch (Exception e)
            {
                ErrorMessage = "Unable to load Group 2 records: " + e.Message;
            }
        }
        private ObservableCollection<DicomHeaderRecord> ReadHeaderRecords()
        {

            ObservableCollection<DicomHeaderRecord> headerRecords = new ObservableCollection<DicomHeaderRecord>();

            IGMedDataElem currentElem;
            int tagIndex;
            IGMedVRInfo vrInfo;

            currentElem = DataSet.CurrentElem;

            for (tagIndex = 0; tagIndex < DataSet.ElemCount; tagIndex++)
            {

                // Create a new header record
                DicomHeaderRecord dicomHeaderRecord = new DicomHeaderRecord();
                dicomHeaderRecord.TagIndex = tagIndex;

                vrInfo = MedDataDict.GetVRInfo(currentElem.ValueRepresentation);

                // Set the hex tag name
                dicomHeaderRecord.Tag = String.Format("{0:X4},{1:X4}",
                                                 MedDataDict.GetTagGroup(currentElem.Tag),
                                                 MedDataDict.GetTagElement(currentElem.Tag));

                // Set the human readable tag name
                IGMedTagInfo tagInfo = MedDataDict.GetTagInfo(currentElem.Tag);
                dicomHeaderRecord.TagName = tagInfo.Name;

                if ((currentElem.Tag == (int) enumIGMedTag.DCM_TAG_PixelData) && (DataSet.CurrentLevel == 0))
                {
                    // If this is the pixel data tag, set the value representation and value length fields
                    dicomHeaderRecord.ValueRepresentation = vrInfo.StringID;
                    dicomHeaderRecord.ValueLength = "<Pixel Data> bytes=" +
                                               String.Format("{0:000}", currentElem.ValueLength);
                }
                else if ((currentElem.Tag == (int) enumIGMedTag.DCM_TAG_ItemItem) ||
                         (currentElem.Tag == (int) enumIGMedTag.DCM_TAG_ItemDelimitationItem) ||
                         (currentElem.Tag == (int) enumIGMedTag.DCM_TAG_SequenceDelimitationItem))
                {
                    // Sequence - ignore...
                }
                else
                {

                    // Other Data elements. Set the value representation, length, multiplicity, 
                    // and level now. 
                    dicomHeaderRecord.ValueRepresentation = vrInfo.StringID;
                    dicomHeaderRecord.ValueMultiplicity = String.Format("{0:00}", currentElem.ValueMultiplicity);
                    dicomHeaderRecord.Level = int.Parse(String.Format("{0:0}", DataSet.CurrentLevel));
                    dicomHeaderRecord.DataValue = GetDataValue(currentElem, vrInfo);
                    dicomHeaderRecord.ValueLength = currentElem.ValueLength.ToString();

                    // Replace -1 with --
                    if (dicomHeaderRecord.ValueLength.Equals("-1"))
                    {
                        dicomHeaderRecord.ValueLength = "--";
                    }
                }

                headerRecords.Add(dicomHeaderRecord);
                if (!tagValueDictionary.ContainsKey(dicomHeaderRecord.Tag))
                {
                    tagValueDictionary.Add(dicomHeaderRecord.Tag, dicomHeaderRecord.DataValue);
                }
                DataSet.MoveNext(enumIGMedLevelOption.MED_DCM_MOVE_LEVEL_FLOAT);
            }


            return headerRecords;
        }

        private String GetDataValue(IGMedDataElem currentElem, IGMedVRInfo vrInfo)
        {
            String dataValue = String.Empty;

            if (((currentElem.ValueRepresentation == enumIGMedVR.MED_DCM_VR_OB) ||
                 (currentElem.ValueRepresentation == enumIGMedVR.MED_DCM_VR_OW) ||
                 (currentElem.ValueRepresentation == enumIGMedVR.MED_DCM_VR_UN)))
            {
                // Hex VRs
                dataValue = GetHexVRValue(currentElem);
            }
            else if (vrInfo.ItemType == enumIGSysDataType.AM_TID_META_STRING)
            {
                // String VRs
                dataValue = GetStringVRValue(currentElem);
            }
            else
            {
                // The simplest way - output data as string
                // This works for all VRs.
                dataValue += currentElem.OutputDataToString(0, -1, "\\", 100);
            }

            return dataValue;
        }


        private string GetHexVRValue(IGMedDataElem currentElem)
        {
            int itemIndex = 0;
            String dataValue = String.Empty;
            while ((itemIndex < currentElem.ItemCount) && (dataValue.Length < 100))
            {
                if (currentElem.ValueRepresentation == enumIGMedVR.MED_DCM_VR_OW)
                {
                    dataValue += "&h" + String.Format("{0:X4}", currentElem.Long[itemIndex]) + " ";
                }
                else
                {
                    dataValue += "&h" + String.Format("{0:X2}", currentElem.Long[itemIndex]) + " ";
                }
                itemIndex = itemIndex + 1;
            }
            return dataValue;
        }

        private string GetStringVRValue(IGMedDataElem currentElem)
        {
            String dataValue = "|";
            int itemIndex = 0;
            while ((itemIndex < currentElem.ItemCount) && (dataValue.Length < 100))
            {
                if (itemIndex < (currentElem.ItemCount - 1))
                {
                    dataValue += currentElem.String[itemIndex] + "\\";
                }
                else
                {
                    dataValue += currentElem.String[itemIndex];
                }
                itemIndex = itemIndex + 1;
            }
            dataValue += "|";
            return dataValue;
        }
 
        private void CreateMedPage(IGPage currentPage)
        {
            // create new page and page display objects
            CurrentMedPage = null;
            if (IGComponentManager.getComponentManager().IGMedCtrl != null)
            {
                CurrentMedPage = IGComponentManager.getComponentManager().IGMedCtrl.CreateMedPage(currentPage);
            }
        }

        private void CreateMedDataDict()
        {
            // create new page and page display objects
            if (IGComponentManager.getComponentManager().IGMedCtrl != null)
            {
                MedDataDict = IGComponentManager.getComponentManager().IGMedCtrl.DataDict;
            }
        }

 
    }
}