using ClearCanvas.Dicom;
using Hydra.Common.Entities;
using Hydra.Log;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.Script.Serialization;

namespace Hydra.Dicom
{
    public class ImageAttributes
    {
        public string ImageUid { get; set; }
        public string DicomXml { get; set; }
    }

    public static class SplitEnumberale
    {
        public static IEnumerable<IEnumerable<T>> Split<T>(this IEnumerable<T> list)
        {
            return list
                .Select((x, i) => new { Index = i, Value = x })
                .GroupBy(x => x.Index / 2)
                .Select(x => x.Select(v => v.Value)
                .ToList()).ToList();
        }
    }

    public class CreatePresentationState
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        private static IEnumerable<uint> MetaInfoTags
        {
            get
            {
                yield return DicomTags.MediaStorageSopClassUid;
                yield return DicomTags.MediaStorageSopInstanceUid;
                yield return DicomTags.TransferSyntaxUid;
                yield return DicomTags.ImplementationClassUid;
                yield return DicomTags.ImplementationVersionName;
                yield return DicomTags.SourceApplicationEntityTitle;
                yield return DicomTags.Manufacturer;
                yield return DicomTags.ManufacturersModelName;
            }
        }

        private static IEnumerable<uint> PatientInfoTags
        {
            get
            {
                yield return DicomTags.AccessionNumber;
                yield return DicomTags.PatientId;
                yield return DicomTags.PatientsBirthDate;
                yield return DicomTags.PatientsName;
                yield return DicomTags.PatientsSex;
                yield return DicomTags.PatientsAge;
            }
        }

        private static IEnumerable<uint> GeneralStudyInfoTags
        {
            get
            {
                yield return DicomTags.StudyDate;
                yield return DicomTags.StudyTime;
                yield return DicomTags.StudyDescription;
                yield return DicomTags.StudyId;
                yield return DicomTags.StudyInstanceUid;
                yield return DicomTags.ReferringPhysiciansName;
                yield return DicomTags.RequestingPhysician;
                yield return DicomTags.RequestedProcedureDescription;
                yield return DicomTags.RequestedProcedureId;
                yield return DicomTags.ScheduledProcedureStepDescription;
                yield return DicomTags.ScheduledProcedureStepId;
            }
        }

        private static IEnumerable<uint> GeneralSeriesInfoTags
        {
            get
            {
                yield return DicomTags.Modality;
                yield return DicomTags.PatientPosition;
                yield return DicomTags.SeriesDate;
                yield return DicomTags.SeriesTime;
                yield return DicomTags.SeriesDescription;
                yield return DicomTags.SeriesInstanceUid;
                yield return DicomTags.SeriesNumber;
                yield return DicomTags.AnatomicalOrientationType;
                yield return DicomTags.ReferencedSeriesSequence;
            }
        }

        private static IEnumerable<uint> ReferencedSeriesTags
        {
            get
            {
                yield return DicomTags.ReferencedImageSequence;
                yield return DicomTags.SeriesInstanceUid;
            }
        }

        private static IEnumerable<uint> PresentationStateInfoTags
        {
            get
            {
                yield return DicomTags.ContentLabel;
                yield return DicomTags.ContentDescription;
                yield return DicomTags.ContentCreatorsName;
                yield return DicomTags.PresentationLutShape;
                yield return DicomTags.PresentationCreationDate;
                yield return DicomTags.PresentationCreationTime;
                yield return DicomTags.DisplayedAreaSelectionSequence;
                yield return DicomTags.GraphicAnnotationSequence;
                yield return DicomTags.GraphicLayerSequence;
            }
        }

        private static IEnumerable<uint> DisplayedAreaTags
        {
            get
            {
                yield return DicomTags.ReferencedImageSequence;
                yield return DicomTags.DisplayedAreaTopLeftHandCorner;
                yield return DicomTags.DisplayedAreaBottomRightHandCorner;
                yield return DicomTags.PresentationSizeMode;
                yield return DicomTags.PresentationPixelSpacing;
            }
        }

        private static IEnumerable<uint> GraphicAnnotationTags
        {
            get
            {
                yield return DicomTags.GraphicLayer;
                yield return DicomTags.ReferencedImageSequence;
                yield return DicomTags.TextObjectSequence;
                yield return DicomTags.GraphicObjectSequence;
            }
        }

        private static IEnumerable<uint> TextObjectTags
        {
            get
            {
                yield return DicomTags.AnchorPointAnnotationUnits;
                yield return DicomTags.BoundingBoxAnnotationUnits;
                yield return DicomTags.UnformattedTextValue;
                yield return DicomTags.BoundingBoxTopLeftHandCorner;
                yield return DicomTags.BoundingBoxBottomRightHandCorner;
                yield return DicomTags.BoundingBoxTextHorizontalJustification;
                yield return DicomTags.UnformattedTextValue;
                yield return DicomTags.AnchorPoint;
                yield return DicomTags.AnchorPointVisibility;
            }
        }

        private static IEnumerable<uint> GraphicObjectTags
        {
            get
            {
                yield return DicomTags.GraphicAnnotationUnits;
                yield return DicomTags.GraphicDimensions;
                yield return DicomTags.NumberOfGraphicPoints;
                yield return DicomTags.GraphicData;
                yield return DicomTags.GraphicType;
                yield return DicomTags.GraphicFilled;
            }
        }

        private static IEnumerable<uint> GraphicLayerTags
        {
            get
            {
                yield return DicomTags.GraphicLayer;
                yield return DicomTags.GraphicLayerOrder;
                yield return DicomTags.RecommendedDisplayGrayscaleValue;
            }
        }

        public static IEnumerable<uint> SopTags
        {
            get
            {
                yield return DicomTags.SopClassUid;
                yield return DicomTags.SopInstanceUid;
                yield return DicomTags.SpecificCharacterSet;
                yield return DicomTags.TimezoneOffsetFromUtc;
            }
        }

        public static IEnumerable<uint> SpatialInfoTags
        {
            get
            {
                yield return DicomTags.ImageHorizontalFlip;
                yield return DicomTags.ImageRotation;
            }
        }

        public static IEnumerable<uint> ImageInfoTags
        {
            get
            {
                yield return DicomTags.ImageType;
                yield return DicomTags.InstanceNumber;
                yield return DicomTags.RescaleIntercept;
                yield return DicomTags.RescaleSlope;
                yield return DicomTags.RescaleType;
                yield return DicomTags.SoftcopyVoiLutSequence;
            }
        }

        public static IEnumerable<uint> VoiLutTags
        {
            get
            {
                yield return DicomTags.ReferencedImageSequence;
                yield return DicomTags.WindowCenter;
                yield return DicomTags.WindowWidth;
            }
        }

        public static IEnumerable<uint> ReferencedImageTags
        {
            get
            {
                yield return DicomTags.ReferencedSopClassUid;
                yield return DicomTags.ReferencedSopInstanceUid;
                yield return DicomTags.ReferencedFrameNumber;
            }
        }

        private static List<Hydra.Entities.DicomTag> dicomTags = new List<Entities.DicomTag>();

        public static void CreatePRFile(StudyPresentationState pstate, object imageFiles, string tempStorePath, out string psFilePath)
        {
            psFilePath = null;
            try
            {
                List<ImageAttributes> imageAttributes = imageFiles as List<ImageAttributes>;
                PresentationState[] prStateArr = JsonConvert.DeserializeObject<PresentationState[]>(pstate.Data,
                                                                            new JsonSerializerSettings
                                                                            {
                                                                                NullValueHandling = NullValueHandling.Ignore,
                                                                                ContractResolver = new CamelCasePropertyNamesContractResolver()
                                                                            });

                psFilePath = tempStorePath + "\\" + pstate.Id + ".dcm";

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Creating PR file.", "FilePath", psFilePath);

                DicomFile dicomFile = new DicomFile();
                foreach (PresentationState prState in prStateArr)
                {
                    var imageAttribute = imageAttributes.FirstOrDefault(x => x.ImageUid == prState.ImageId);
                    if (imageAttribute == null)
                    {
                        continue;
                    }

                    dicomTags = JsonConvert.DeserializeObject<List<Hydra.Entities.DicomTag>>(imageAttribute.DicomXml);

                    foreach (uint tag in MetaInfoTags)
                        SetDicomAttribute(tag, dicomFile);

                    foreach (uint tag in PatientInfoTags)
                        SetDicomAttribute(tag, dicomFile);

                    foreach (uint tag in GeneralStudyInfoTags)
                        SetDicomAttribute(tag, dicomFile);

                    foreach (uint tag in GeneralSeriesInfoTags)
                        SetDicomAttribute(tag, dicomFile);

                    foreach (uint tag in SopTags)
                        SetDicomAttribute(tag, dicomFile);

                    foreach (uint tag in SpatialInfoTags)
                        SetDicomAttribute(tag, dicomFile);

                    foreach (uint tag in ImageInfoTags)
                        SetDicomAttribute(tag, dicomFile);

                    SavePresentationStateInfo(dicomFile, pstate.DateTime, pstate.Description, pstate.Source, prState);
                }
                dicomFile.DataSet[DicomTags.Modality].SetStringValue("PR");
                dicomFile.DataSet[DicomTags.SopInstanceUid].SetStringValue(pstate.Id);
                dicomFile.MetaInfo[DicomTags.MediaStorageSopInstanceUid].SetStringValue(pstate.Id);

                dicomFile.Save(psFilePath);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error in CreatePRFile", "Exception", ex.ToString());
            }
        }

        private static void SetDicomAttribute(uint tag, DicomFile dicomFile)
        {
            Hydra.Entities.DicomTag dicomAttribute = null;
            var hexTag = String.Format("({0:x4},{1:x4})", tag >> 16, tag & 0xFFFF);
            dicomAttribute = dicomTags.Find(item => (item.Tag == hexTag));
            if (dicomAttribute != null)
            {
                if (dicomAttribute.VrType != "SQ")
                {
                    dicomFile.DataSet[tag].SetStringValue(dicomAttribute.TagValue);
                }
                else
                {
                    dicomFile.DataSet[tag].AddSequenceItem(AddSequenceItemAttributes(tag));
                }
            }
            else
            {
                Console.Write(tag);
            }
        }

        private static DicomSequenceItem AddSequenceItemAttributes(uint tag)
        {
            
            switch (tag)
            {
                case DicomTags.DisplayedAreaSelectionSequence:
                    return GetDicomSequcenceItem(DisplayedAreaTags);
                case DicomTags.GraphicAnnotationSequence:
                    return GetDicomSequcenceItem(GraphicAnnotationTags);
                case DicomTags.TextObjectSequence:
                    return GetDicomSequcenceItem(TextObjectTags);
                case DicomTags.GraphicObjectSequence:
                    return GetDicomSequcenceItem(GraphicObjectTags);
                case DicomTags.GraphicLayerSequence:
                    return GetDicomSequcenceItem(GraphicLayerTags);
                case DicomTags.VoiLutSequence:
                    return GetDicomSequcenceItem(VoiLutTags);
                case DicomTags.ReferencedImageSequence:
                    return GetDicomSequcenceItem(ReferencedImageTags);
                case DicomTags.ReferencedSeriesSequence:
                    return GetDicomSequcenceItem(ReferencedSeriesTags);
                default:
                    return null;
            }
        }

        private static uint ConvertTag(string tag)
        {
            string[] tagValues = tag.Split(',');
            ushort group = Convert.ToUInt16(tagValues[0].TrimStart('('), 16);
            ushort element = Convert.ToUInt16(tagValues[1].TrimEnd(')'), 16);
            return (uint)group << 16 | element;
        }

        private static DicomSequenceItem GetDicomSequcenceItem(IEnumerable<uint> sequenceTags)
        {
            DicomSequenceItem seqItem = new DicomSequenceItem();
            Hydra.Entities.DicomTag dicomAttribute = null;
            foreach (uint refTag in sequenceTags)
            {
                var hexTag = String.Format("({0:x4},{1:x4})", refTag >> 16, refTag & 0xFFFF);
                dicomAttribute = dicomTags.Find(item => (item.Tag == hexTag));
                if (dicomAttribute != null)
                {
                    if (dicomAttribute.VrType != "SQ")
                    {
                        seqItem[refTag].SetStringValue(dicomAttribute.TagValue);
                    }
                    else
                    {
                        seqItem[refTag].AddSequenceItem(AddSequenceItemAttributes(refTag));
                    }
                }
                else
                {
                    Console.Write(refTag);
                }
            }
            return seqItem;
        }

        private static void SavePresentationStateInfo(DicomFile dicomFile, string psDateTime, string psDescription, string psSource, PresentationState prState)
        {
            string[] strDateTime = new string[2];
            DateTime createdDateTime = (psDateTime == null) ? DateTime.Now : DateTime.Parse(psDateTime);
            strDateTime[0] = string.Format("{0}{1}{2}", createdDateTime.Year, createdDateTime.Month.ToString("D2"), createdDateTime.Day.ToString("D2"));
            strDateTime[1] = string.Format("{0}{1}{2}", createdDateTime.Hour.ToString("D2"), createdDateTime.Minute.ToString("D2"), createdDateTime.Second.ToString("D2"));

            dicomFile.DataSet[DicomTags.ContentLabel].SetStringValue("UNNAMED");
            dicomFile.DataSet[DicomTags.ContentDescription].SetStringValue(psDescription);
            dicomFile.DataSet[DicomTags.PresentationCreationDate].SetStringValue(strDateTime[0]);
            dicomFile.DataSet[DicomTags.PresentationCreationTime].SetStringValue(strDateTime[1]);
            dicomFile.DataSet[DicomTags.ContentCreatorsName].SetStringValue(psSource);
            dicomFile.DataSet[DicomTags.PresentationLutShape].SetStringValue("IDENTITY");
            dicomFile.DataSet[DicomTags.SopClassUid].SetStringValue(DicomUids.GrayscaleSoftcopyPresentationStateStorage.UID);
            dicomFile.MetaInfo[DicomTags.MediaStorageSopClassUid].SetStringValue(DicomUids.GrayscaleSoftcopyPresentationStateStorage.UID);

            var tag = DicomTags.ImageType;
            var hexTag = String.Format("({0:x4},{1:x4})", tag >> 16, tag & 0xFFFF);
            var imageType = dicomTags.Where(item => item.Tag == hexTag).Select(x => x.TagValue).FirstOrDefault();
            dicomFile.DataSet[DicomTags.ImageType].SetStringValue(imageType);

            tag = DicomTags.SopClassUid;
            hexTag = String.Format("({0:x4},{1:x4})", tag >> 16, tag & 0xFFFF);
            var sopClassUid = dicomTags.Where(item => item.Tag == hexTag).Select(x => x.TagValue).FirstOrDefault();

            tag = DicomTags.SopInstanceUid;
            hexTag = String.Format("({0:x4},{1:x4})", tag >> 16, tag & 0xFFFF);
            var sopInstanceUid = dicomTags.Where(item => item.Tag == hexTag).Select(x => x.TagValue).FirstOrDefault();
            //var instanceUid = DicomUid.GenerateUid().UID;
            //dicomFile.DataSet[DicomTags.SopInstanceUid].SetStringValue(instanceUid);
            //dicomFile.MetaInfo[DicomTags.MediaStorageSopInstanceUid].SetStringValue(instanceUid);

            int frameNumber = 0;
            int.TryParse(prState.FrameNumber, out frameNumber);
            DicomSequenceItem referenceImageSeqItem = AddReferencedImageSequence((++frameNumber).ToString(), sopClassUid, sopInstanceUid);

            tag = DicomTags.SeriesInstanceUid;
            hexTag = String.Format("({0:x4},{1:x4})", tag >> 16, tag & 0xFFFF);
            var seriesInstanceUid = dicomTags.Where(item => item.Tag == hexTag).Select(x => x.TagValue).FirstOrDefault();

            tag = DicomTags.Modality;
            hexTag = String.Format("({0:x4},{1:x4})", tag >> 16, tag & 0xFFFF);
            var modality = dicomTags.Where(item => item.Tag == hexTag).Select(x => x.TagValue).FirstOrDefault();

            tag = DicomTags.NumberOfFrames;
            hexTag = String.Format("({0:x4},{1:x4})", tag >> 16, tag & 0xFFFF);
            var numberOfFrames = dicomTags.Where(item => item.Tag == hexTag).Select(x => x.TagValue).FirstOrDefault();

            if (string.Compare(modality, "CT") == 0 && numberOfFrames == null)
            {
                dicomFile.DataSet[DicomTags.RescaleType].SetStringValue("US");
            }
            else
            {
                dicomFile.DataSet.RemoveAttribute(DicomTags.RescaleIntercept);
                dicomFile.DataSet.RemoveAttribute(DicomTags.RescaleSlope);
                dicomFile.DataSet.RemoveAttribute(DicomTags.RescaleType);
            }

            DicomSequenceItem seqItem = new DicomSequenceItem();
            seqItem[DicomTags.SeriesInstanceUid].SetStringValue(seriesInstanceUid);
            seqItem[DicomTags.ReferencedImageSequence].AddSequenceItem(referenceImageSeqItem);
            dicomFile.DataSet[DicomTags.ReferencedSeriesSequence].AddSequenceItem(seqItem);

            seqItem = AddDisplayArea(prState);
            seqItem[DicomTags.ReferencedImageSequence].AddSequenceItem(referenceImageSeqItem);
            dicomFile.DataSet[DicomTags.DisplayedAreaSelectionSequence].AddSequenceItem(seqItem);

            AddGraphicAnnotation(prState, referenceImageSeqItem, dicomFile);
        }

        private static DicomSequenceItem AddReferencedImageSequence(string frameNumber, string sopClassUid, string sopInstanceUid)
        {
            DicomSequenceItem seqItem = new DicomSequenceItem();
            seqItem[DicomTags.ReferencedSopClassUid].SetStringValue(sopClassUid);
            seqItem[DicomTags.ReferencedSopInstanceUid].SetStringValue(sopInstanceUid);
            seqItem[DicomTags.ReferencedFrameNumber].SetStringValue(frameNumber);
            return seqItem;
        }

        private static DicomSequenceItem AddDisplayArea(PresentationState prState)
        {
            DicomSequenceItem seqItem = new DicomSequenceItem();
            IEnumerable<int> ptList = new List<int>() { 0, 0 };
            seqItem[DicomTags.DisplayedAreaTopLeftHandCorner].Values = ptList.ToArray<int>();
            seqItem[DicomTags.DisplayedAreaBottomRightHandCorner].Values = ptList.ToArray<int>();
            seqItem[DicomTags.PresentationSizeMode].SetStringValue("SCALE TO FIT");

            var tag = DicomTags.PixelSpacing;
            string hexTag = String.Format("({0:x4},{1:x4})", tag >> 16, tag & 0xFFFF);
            var pixelSpacing = dicomTags.Where(item => item.Tag == hexTag).Select(x => x.TagValue).FirstOrDefault();
            pixelSpacing = (pixelSpacing == null) ? "1.0\\1.0" : pixelSpacing;
            seqItem[DicomTags.PresentationPixelSpacing].SetStringValue(pixelSpacing);

            return seqItem;
        }

        private static void AddGraphicAnnotation(PresentationState prState, DicomSequenceItem referenceImageSeqItem, DicomFile dicomFile)
        {
           
            ulong compoundInstanceId = 0;
            foreach(GraphicObject graphicObj in prState.Objects)
            {
                compoundInstanceId++;
                DicomSequenceItem seqItem = new DicomSequenceItem();
                seqItem[DicomTags.GraphicLayer].SetStringValue(string.Format("LAYER {0}", compoundInstanceId));

                var graphicType = GetGraphicType(graphicObj);
                if (graphicType.CompareTo("LABEL") == 0)
                {
                    seqItem[DicomTags.TextObjectSequence].AddSequenceItem(AddTextObject(graphicObj, compoundInstanceId));
                }
                else if (graphicType.CompareTo("TEXT") == 0)
                {
                    seqItem[DicomTags.TextObjectSequence].AddSequenceItem(AddTextObject(graphicObj, ulong.MinValue));
                }
                else if ((graphicType.CompareTo("POLYLINE") == 0) || (graphicType.CompareTo("INTERPOLATED") == 0)
                    || (graphicType.CompareTo("ELLIPSE") == 0) || (graphicType.CompareTo("POINT") == 0))
                {
                    if (graphicType.CompareTo("ELLIPSE") == 0)
                    {
                        var points = graphicObj.Points;
                        int x = (points[0] + points[2]) / 2;
                        int y = (points[1] + points[3]) / 2;
                        int[] objPoints = new int[] { points[0], y, points[2], y, x, points[1], x, points[3] };
                        graphicObj.Points = objPoints;
                    }

                    seqItem[DicomTags.GraphicObjectSequence].AddSequenceItem(AddGraphicObject(graphicObj, false, ulong.MinValue, null));
                }
                else
                {
                    int index = 0;
                    var points = graphicObj.Points;
                    float[][] objPoints = null;

                    switch (graphicType)
                    {
                        case "RECTANGLE":
                            index = 4;
                            objPoints = new float[index][];                          
                            objPoints[0] = new float[4] { points[0], points[1], points[2], points[1] };
                            objPoints[1] = new float[4] { points[2], points[1], points[2], points[3] };
                            objPoints[2] = new float[4] { points[2], points[3], points[0], points[3] };
                            objPoints[3] = new float[4] { points[0], points[3], points[0], points[1] };
                            break;
                        case "ANGLE":
                            index = 2;
                            objPoints = new float[index][];
                            objPoints[0] = new float[4] { points[0], points[1], points[2], points[3] };
                            objPoints[1] = new float[4] { points[4], points[5], points[6], points[7] };
                            break;
                        case "ARROW":
                        case "RANGELINE":
                            index = (graphicType.CompareTo("ARROW") == 0) ? 3 : 1 ;
                            objPoints = new float[index][];
                            objPoints[0] = new float[4] { points[0], points[1], points[2], points[3] };

                            if (graphicType.CompareTo("ARROW") == 0)
                            {
                                double px = (1 - 0.1) * points[0] + 0.1 * points[2];
                                double py = (1 - 0.1) * points[1] + 0.1 * points[3];

                                double cos = Math.Cos(45);
                                double sin = Math.Sin(45);
                                double x = (cos * (px - points[0])) + (sin * (py - points[1])) + points[0];
                                double y = (cos * (py - points[1])) - (sin * (px - points[0])) + points[1];
                                objPoints[1] = new float[4] { points[0], points[1], (int)x, (int)y };

                                cos = Math.Cos(-45);
                                sin = Math.Sin(-45);
                                x = (cos * (px - points[0])) + (sin * (py - points[1])) + points[0];
                                y = (cos * (py - points[1])) - (sin * (px - points[0])) + points[1];
                                objPoints[2] = new float[4] { points[0], points[1], (int)x, (int)y };
                            }
                            break;
                    }

                    if(index > 0)
                    {
                        for(int i = 0 ; i < index ; i++)
                        {
                            seqItem[DicomTags.GraphicObjectSequence].AddSequenceItem(AddGraphicObject(graphicObj, true, compoundInstanceId, objPoints[i]));
                        }
                    }
                   
                    seqItem[DicomTags.CompoundGraphicSequence].AddSequenceItem(AddCompundGraphicObject(graphicObj, compoundInstanceId));
                }
                seqItem[DicomTags.ReferencedImageSequence].AddSequenceItem(referenceImageSeqItem);
                dicomFile.DataSet[DicomTags.GraphicAnnotationSequence].AddSequenceItem(seqItem);

                if (graphicType.CompareTo("POINT") == 0)
                {
                    GraphicObject pointObj = graphicObj;
                    pointObj.Type = "LABEL";
                    pointObj.Text = string.Format("{0} pix, {1} pix", pointObj.Points[0], pointObj.Points[1]);
                    DicomSequenceItem pointseqItem = new DicomSequenceItem();
                    pointseqItem[DicomTags.GraphicLayer].SetStringValue(string.Format("LAYER {0}", ++compoundInstanceId));
                    pointseqItem[DicomTags.TextObjectSequence].AddSequenceItem(AddTextObject(pointObj, compoundInstanceId));
                    pointseqItem[DicomTags.ReferencedImageSequence].AddSequenceItem(referenceImageSeqItem);
                    dicomFile.DataSet[DicomTags.GraphicAnnotationSequence].AddSequenceItem(pointseqItem);
                }
            }
        }

        private static DicomSequenceItem AddTextObject(GraphicObject graphicObj, ulong compoundInstanceId)
        {
            DicomSequenceItem seqItem = new DicomSequenceItem();
            seqItem[DicomTags.CompoundGraphicInstanceId].SetStringValue(compoundInstanceId.ToString());
            seqItem[DicomTags.BoundingBoxAnnotationUnits].SetStringValue("PIXEL");
            seqItem[DicomTags.UnformattedTextValue].SetStringValue(graphicObj.Text);
            seqItem[DicomTags.BoundingBoxTextHorizontalJustification].SetStringValue("CENTER");
            IEnumerable<float> ptList = (graphicObj.Points.Select(x => (float)x));
            IEnumerable<float>[] splits = SplitEnumberale.Split<float>(ptList).ToArray<IEnumerable<float>>();
            seqItem[DicomTags.BoundingBoxTopLeftHandCorner].Values = splits[0].ToArray<float>();
            seqItem[DicomTags.BoundingBoxBottomRightHandCorner].Values = splits[1].ToArray<float>();
            seqItem[DicomTags.AnchorPoint].Values = splits[0].ToArray<float>();
            seqItem[DicomTags.AnchorPointAnnotationUnits].SetStringValue("PIXEL");
            seqItem[DicomTags.AnchorPointVisibility].SetStringValue("N");
            return seqItem;
        }

        private static DicomSequenceItem AddGraphicObject(GraphicObject graphicObj, bool isOverride, ulong compoundInstanceId,  float[] graphicPoints)
        {
            DicomSequenceItem seqItem = new DicomSequenceItem();
            seqItem[DicomTags.CompoundGraphicInstanceId].SetStringValue(compoundInstanceId.ToString());
            seqItem[DicomTags.GraphicAnnotationUnits].SetStringValue("PIXEL");
            seqItem[DicomTags.GraphicDimensions].SetStringValue("2");

            if (isOverride)
            {
                seqItem[DicomTags.NumberOfGraphicPoints].SetStringValue((graphicPoints.Length / 2).ToString());
                seqItem[DicomTags.GraphicData].Values = graphicPoints;
            }
            else
            {
                seqItem[DicomTags.NumberOfGraphicPoints].SetStringValue((graphicObj.Points.Count() / 2).ToString());
                IEnumerable<float> ptList = (graphicObj.Points.Select(x => (float)x));
                seqItem[DicomTags.GraphicData].Values = ptList.ToArray<float>();
            }

            seqItem[DicomTags.GraphicType].SetStringValue(isOverride ? "POLYLINE" : GetGraphicType(graphicObj));
            seqItem[DicomTags.GraphicFilled].SetStringValue("N");
            return seqItem;
        }

        private static DicomSequenceItem AddCompundGraphicObject(GraphicObject graphicObj, ulong compoundInstanceId)
        {
            DicomSequenceItem seqItem = new DicomSequenceItem();
            seqItem[DicomTags.CompoundGraphicInstanceId].SetStringValue(compoundInstanceId.ToString());
            seqItem[DicomTags.CompoundGraphicUnits].SetStringValue("PIXEL");
            seqItem[DicomTags.GraphicDimensions].SetStringValue("2");
            seqItem[DicomTags.NumberOfGraphicPoints].SetStringValue((graphicObj.Points.Count() / 2).ToString());
            IEnumerable<float> ptList = (graphicObj.Points.Select(x => (float)x));
            seqItem[DicomTags.GraphicData].Values = ptList.ToArray<float>();
            seqItem[DicomTags.CompoundGraphicType].SetStringValue(GetGraphicType(graphicObj));
            seqItem[DicomTags.GraphicFilled].SetStringValue("N");
            return seqItem;
        }

        private static DicomSequenceItem AddGraphicLayer(PresentationState prState)
        {
            DicomSequenceItem seqItem = new DicomSequenceItem();
            seqItem[DicomTags.GraphicLayer].SetStringValue("LAYER 1");
            seqItem[DicomTags.GraphicLayerOrder].SetStringValue("1");
            return seqItem;
        }

        private static string GetGraphicType(GraphicObject graphicObject)
        {
            string graphicType = graphicObject.Type;
            try
            {
                switch (graphicType)
                {
                    case "POINT":
                        graphicType = "POINT";
                        break;
                    case "ANGLE":
                        graphicType = "ANGLE";
                        break;
                    case "LINE":
                        graphicType = "POLYLINE";
                        break;
                    case "LENGTH":
                        graphicType = "RANGELINE";
                        break;
                    case "ARROW":
                        graphicType = "ARROW";
                        break;
                    case "RECT":
                    case "HOUNSFIELDRECT":
                        graphicType = "RECTANGLE";
                        break;
                    case "ELLIPSE":
                    case "HOUNSFIELDELLIPSE":
                        graphicType = "ELLIPSE";
                        break;
                    case "PEN":
                    case "FREEHAND":
                        graphicType = "INTERPOLATED";
                        break;
                    case "TRACE":
                        graphicType = "POLYLINE";
                        break;
                    case "LABEL":
                        graphicType = "LABEL";
                        break;
                    case "TEXT":
                        graphicType = "TEXT";
                        break;
                    default:
                        graphicType = "POLYLINE";
                        break;
                }

                return graphicType;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error in GetGraphicType", "Exception", ex.ToString());
            }

            return graphicType;
        }
    }
}
