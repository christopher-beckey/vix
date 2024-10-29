using ClearCanvas.Dicom;
using ClearCanvas.Dicom.Iod.Sequences;
using ClearCanvas.ImageViewer;
using ClearCanvas.ImageViewer.PresentationStates.Dicom;
using ClearCanvas.ImageViewer.StudyManagement;
using Hydra.Common.Entities;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class PresentationStateReader
    {
        internal static string Read(ClearCanvas.Dicom.DicomFile dicomFile)
        {
            var obj = DicomSoftcopyPresentationState.Load(dicomFile);
            if (obj == null) 
                return null;

            DicomAttributeCollection dataset = obj.DicomFile.DataSet;
            DicomAttribute dicomAttribute = dataset[DicomTags.GraphicAnnotationSequence];
            if (dicomAttribute.IsNull || dicomAttribute.Count == 0)
                return null;

            var psDataMap = new Dictionary<string, PresentationState>();
            List<GraphicObject> graphicObjects = null;
            int frameNumber = 1;
            string sopInstanceId = null;

            try
            {
                string contentDescription = obj.DicomFile.DataSet[DicomTags.ContentDescription];
                string instanceUid = obj.DicomFile.DataSet[DicomTags.SopInstanceUid];

                GraphicAnnotationSequenceItem[] annotSeq = new GraphicAnnotationSequenceItem[dicomAttribute.Count];
                DicomSequenceItem[] items = (DicomSequenceItem[])dicomAttribute.Values;
                for (int n = 0; n < items.Length; n++)
                    annotSeq[n] = new GraphicAnnotationSequenceItem(items[n]);

                for (int i = 0; i < annotSeq.Length; i++)
                {
                    graphicObjects = new List<GraphicObject>();

                    DicomSequenceItem dicomSeqItem = annotSeq[i].DicomSequenceItem;
                    // GraphicLayer
                    string graphicLayer = dicomSeqItem.GetAttribute(DicomTags.GraphicLayer);

                    // ReferenceImageSequence
                    List<Dictionary<string, string[]>> refValues = GetDicomAttribute(dicomSeqItem, DicomTags.ReferencedImageSequence);

                    // GraphicObjectSequence
                    List<Dictionary<string, string[]>> graphValues = GetDicomAttribute(dicomSeqItem, DicomTags.GraphicObjectSequence);

                    // CompoundGraphicObjectSequence
                    List<Dictionary<string, string[]>> compoundValues = GetDicomAttribute(dicomSeqItem, DicomTags.CompoundGraphicSequence);

                    // TextObjectSequence
                    List<Dictionary<string, string[]>> txtValues = GetDicomAttribute(dicomSeqItem, DicomTags.TextObjectSequence);


                    frameNumber = int.Parse(ConvertToString(refValues[0]["Referenced Frame Number"])) - 1;
                    sopInstanceId = ConvertToString(refValues[0]["Referenced SOP Instance UID"]);
                    foreach (Dictionary<string, string[]> graphSeq in graphValues)
                    {
                        if (graphSeq.ContainsKey("Compound Graphic Instance ID"))
                        {
                            string graphicInstanceId = ConvertToString(graphSeq["Compound Graphic Instance ID"]);
                            ulong instanceId;
                            ulong.TryParse(graphicInstanceId, out instanceId);
                            if (instanceId != ulong.MinValue)
                            {
                                continue;
                            }
                        }

                        var id = Guid.NewGuid().ToString();
                        int[] graphicData = ConvertToIntArray(graphSeq["Graphic Data"]);
                        int[] graphicPoints = null;
                        string graphicType = ConvertToString(graphSeq["Graphic Type"]);
                        switch (graphicType)
                        {
                            case "POLYLINE":
                                {
                                    if (graphicData.Length == 4)
                                    {
                                        graphicPoints = graphicData;
                                        graphicType = "LINE";
                                    }
                                    else
                                    {
                                        graphicPoints = new int[graphicData.Count() + (graphicData.Count() - 4)];
                                        int x = 0;
                                        for (int index = 0; index < graphicData.Count() - 2; index += 2, x += 4)
                                        {
                                            graphicPoints[x] = graphicData[index];
                                            graphicPoints[x + 1] = graphicData[index + 1];
                                            int nextIndex = (index == (graphicData.Count() - 2) ? index : index + 2);
                                            graphicPoints[x + 2] = graphicData[nextIndex];
                                            graphicPoints[x + 3] = graphicData[nextIndex + 1];
                                        }
                                        graphicType = "LINE";
                                    }
                                }
                                break;
                            case "INTERPOLATED":
                                graphicPoints = graphicData;
                                graphicType = "FREEHAND";
                                break;
                            case "ELLIPSE":
                            case "CIRCLE":
                                if (graphicData.Length == 8)
                                {
                                    graphicPoints = new int[4] { graphicData[0], graphicData[5], graphicData[2], graphicData[7] };
                                }
                                if (graphicData.Length == 4)
                                {
                                    int xDiff = graphicData[2] - graphicData[0];
                                    int yDiff = graphicData[3] - graphicData[1];

                                    graphicPoints = new int[4] { (int)(graphicData[0] - xDiff), (int)(graphicData[1] - xDiff), (int)(graphicData[2]), (int)(graphicData[1] + xDiff) };
                                    graphicType = "ELLIPSE";
                                }
                                break;
                            case "POINT":
                                if (graphicData.Length == 2)
                                {
                                    graphicPoints = new int[4] { graphicData[0], graphicData[1], graphicData[0], graphicData[1] };
                                }
                                break;
                            default:
                                graphicPoints = graphicData;
                                break;
                        }
                        var graphicObject = new GraphicObject
                        {
                            Type = graphicType,
                            Id = id,
                            Points = graphicPoints,
                            Text = "",
                            GraphicLayerIndex = i
                        };

                        graphicObjects.Add(graphicObject);
                    }

                    foreach (Dictionary<string, string[]> compSeq in compoundValues)
                    {
                        var id = Guid.NewGuid().ToString();
                        int[] graphicData = ConvertToIntArray(compSeq["Graphic Data"]);
                        int[] graphicPoints = null;
                        string graphicType = ConvertToString(compSeq["Compound Graphic Type"]);
                        switch (graphicType)
                        {
                            case "RANGELINE":
                                graphicPoints = graphicData;
                                graphicType = "LENGTH";
                                break;
                            case "RECTANGLE":
                                graphicPoints = graphicData;
                                graphicType = "RECT";
                                break;
                            default:
                                graphicPoints = graphicData;
                                break;
                        }
                        var graphicObject = new GraphicObject
                        {
                            Type = graphicType,
                            Id = id,
                            Points = graphicPoints,
                            Text = "",
                            GraphicLayerIndex = i
                        };

                        graphicObjects.Add(graphicObject);
                    }

                    foreach (Dictionary<string, string[]> txtSeq in txtValues)
                    {
                        if (txtSeq.ContainsKey("Compound Graphic Instance ID"))
                        {
                            string graphicInstanceId = ConvertToString(txtSeq["Compound Graphic Instance ID"]);
                            ulong instanceId;
                            ulong.TryParse(graphicInstanceId, out instanceId);
                            if (instanceId != ulong.MinValue)
                            {
                                continue;
                            }
                        }

                        var id = Guid.NewGuid().ToString();
                        int[] boundingPts = null;

                        if (txtSeq.ContainsKey("Bounding Box Top Left Hand Corner") &&
                            txtSeq.ContainsKey("Bounding Box Bottom Right Hand Corner"))
                        {
                            boundingPts = new int[4];
                            int[] boundingLHCPts = ConvertToIntArray(txtSeq["Bounding Box Top Left Hand Corner"]);
                            int[] boundingRHCPts = ConvertToIntArray(txtSeq["Bounding Box Bottom Right Hand Corner"]);
                            Array.Copy(boundingLHCPts, boundingPts, boundingLHCPts.Length);
                            Array.Copy(boundingRHCPts, 0, boundingPts, boundingLHCPts.Length, boundingRHCPts.Length);
                        }
                        else if(txtSeq.ContainsKey("Anchor Point"))
                        {
                            boundingPts = ConvertToIntArray(txtSeq["Anchor Point"]);
                        }

                        if (boundingPts != null)
                        {
                            var graphicObject = new GraphicObject
                            {
                                Type = "TEXT",
                                Id = id,
                                Points = boundingPts,
                                Text = String.Join("", txtSeq["Unformatted Text Value"]),
                                GraphicLayerIndex = i
                            };
                            graphicObjects.Add(graphicObject);
                        }
                    }

                    if (graphicObjects.Count > 0)
                    {
                        string imageIEN = sopInstanceId;
                        string key = string.Format("{0}:{1}", imageIEN, frameNumber);
                        PresentationState presentationState = null;
                        if (!psDataMap.TryGetValue(key, out presentationState))
                            psDataMap[key] = presentationState = new PresentationState
                            {
                                Id = Guid.NewGuid().ToString(),
                                ImageId = imageIEN,
                                FrameNumber = frameNumber.ToString()
                            };

                        if (presentationState.Objects == null)
                            presentationState.Objects = graphicObjects.ToArray();
                        else
                            presentationState.Objects = presentationState.Objects.Concat(graphicObjects.ToArray()).ToArray();
                    }
                }

                var studyPresentationState = new Hydra.Common.Entities.StudyPresentationState
                {
                    Description = "Dicom Soft Copy PS --/--/----",
                    IsEditable = false,
                    IsExternal = true,
                    Source = "Dicom Soft Copy PS",
                    Id = instanceUid,
                    Data = JsonConvert.SerializeObject(psDataMap.Values.ToArray(),
                                                        new JsonSerializerSettings
                                                        {
                                                            NullValueHandling = NullValueHandling.Ignore,
                                                            ContractResolver = new CamelCasePropertyNamesContractResolver()
                                                        })
                };

                return JsonConvert.SerializeObject(studyPresentationState,
                                Newtonsoft.Json.Formatting.None,
                                new JsonSerializerSettings
                                {
                                    NullValueHandling = NullValueHandling.Ignore
                                });
            }
            catch(Exception ex)
            {
                return ex.Message.ToString();
            }
            return null;
        }

        private static List<Dictionary<string, string[]>> GetDicomAttribute(DicomSequenceItem dicomSeqItem, uint dicomTag)
        {
            List<Dictionary<string, string[]>> seqValues = new List<Dictionary<string, string[]>>();
            DicomAttribute dicomAttribute = dicomSeqItem.GetAttribute(dicomTag);

            if (dicomAttribute.Values != null)
            {
                foreach (DicomSequenceItem seqItem in (DicomSequenceItem[])dicomAttribute.Values)
                {
                    Dictionary<string, string[]> values = new Dictionary<string, string[]>();
                    foreach (DicomAttribute attrib in seqItem)
                    {
                        values.Add(attrib.Tag.Name, ConvertToStringArray(attrib.Values));
                    }
                    seqValues.Add(values);
                }
            }

            return seqValues;
        }

        private static string[] ConvertToStringArray(object attribValues)
        {
            return ((IEnumerable)attribValues).Cast<object>()
                                 .Select(x => x.ToString())
                                 .ToArray();

        }

        private static int[] ConvertToIntArray(string[] points)
        {
            return points.Select(x => (int)Convert.ToDouble(x)).ToArray();

        }

        private static string ConvertToString(string[] array)
        {
            return new StringBuilder(array[0]).ToString();
        }

        private static DicomFile LoadDicomFile(string filePath)
        {
            DicomFile file = null;

            try
            {
                file = new DicomFile(filePath);
                file.Load(DicomReadOptions.StorePixelDataReferences);
            }
            catch (Exception ex)
            {
                file = null;
            }

            return file;
        }
    }
}
