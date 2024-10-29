using Hydra.Common.Entities;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Serialization;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;
using System.Xml.XPath;

namespace Hydra.VistA.Parsers
{
    public static class PStateParser
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static List<Hydra.Common.Entities.StudyPresentationState> Parse(string text)
        {
            try
            {
                VixStudyPStateRecord records = new VixStudyPStateRecord();

                // the text can be an object or an array
                var token = JToken.Parse(text);
                var childToken = token["pStateRecords"];
                if (childToken == null)
                    return null;

                if (childToken is JObject)
                {
                    var item = childToken.ToObject<VixPStateRecord>();
                    records.PStateRecords = new VixPStateRecord[] { item };
                }
                else if (childToken is JArray)
                {
                    records.PStateRecords = childToken.ToObject<VixPStateRecord[]>();
                }

                if ((records == null) || (records.PStateRecords == null))
                    return null;

                var items = new List<StudyPresentationState>();

                Array.ForEach<VixPStateRecord>(records.PStateRecords, pStateRecord =>
                    {
                        var item = new StudyPresentationState
                        {
                            ContextId = pStateRecord.StudyId,
                            Description = pStateRecord.Name,
                            UserId = pStateRecord.DUZ,
                            Id = pStateRecord.PStateUid,
                            IsEditable = false,
                            IsExternal = false
                        };

                        DateTime timeStamp;
                        if (DateTime.TryParse(pStateRecord.TimeStamp.Replace('@', ' '), out timeStamp))
                            item.DateTime = timeStamp.ToString();
                        else
                            item.DateTime = pStateRecord.TimeStamp;

                        item.Data = pStateRecord.Data;

                        items.Add(item);
                    });

                return items;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error parsing presentation record data", "Exception", ex.ToString());
                throw;
            }
        }

        public static bool HasOtherAnnotations(string text)
        {
            // for VRAD, check for presence of '*IMAGE'
            // for Clin, check for presence of 'NEXT_IMAGE'
            return text.Contains("*IMAGE") || text.Contains("NEXT_IMAGE");
        }

        public static void ParseOther(string contextId, string text, List<Hydra.Common.Entities.StudyPresentationState> psList, Dictionary<string, string> externalIdMap, string userId)
        {
            if (string.IsNullOrEmpty(text))
                return;

            XDocument doc = XDocument.Parse(text);
            var values = doc.XPathSelectElements(@"//value");
            if (values == null)
                return;

            // convert to lines
            string[] lines = values.Select(a => System.Web.HttpUtility.HtmlDecode(a.Value)).ToArray();

            int i = lines.Length - 1;
            int contextIdEnd = lines.Length;
            while (i >= 0)
            {
                if (lines[i].StartsWith("NEXT_CONTEXTID"))
                {
                    // copy from current location to end
                    int count = contextIdEnd - i;
                    contextIdEnd = i;

                    if (lines[i].EndsWith("RAD"))
                        ParseVRad(contextId, lines, i, count, psList, externalIdMap, userId);
                    else if (lines[i].EndsWith("CLN"))
                        ParseClinicalDisplay(contextId, lines, i, count, psList, externalIdMap, userId);
                }

                i--;
            }
        }

        private static void ParseClinicalDisplay(string contextId, string[] lines, int startIndex, int lineCount, List<StudyPresentationState> psList, Dictionary<string, string> externalIdMap, string userId)
        {
            int index = startIndex;
            int endIndex = startIndex + lineCount - 1;

            string currentImageIEN = null;
            string imageHeader = null;
            StringBuilder psData = null;
            var psDataMap = new Dictionary<string, PresentationState>();
            string tooltip = null;

            while (index <= endIndex)
            {
                var line = lines[index];

                if (line.StartsWith("NEXT_IMAGE")) // beginning of image
                {
                    // handle previous image
                    if (psData != null)
                        ParseClinXml(currentImageIEN, psData.ToString(), psDataMap, ref tooltip);

                    currentImageIEN = line.Split('|')[1]; // second piece is the image IEN
                    imageHeader = null;
                    psData = new StringBuilder();
                }
                else if (psData != null)
                {
                    // ignore first line after NEXT_IMAGE
                    if (imageHeader == null)
                        imageHeader = line;
                    else
                        psData.Append(line);
                }

                index++;
            }

            if (psData != null)
                ParseClinXml(currentImageIEN, psData.ToString(), psDataMap, ref tooltip);

            if (psDataMap.Count > 0)
            {
                if (externalIdMap != null)
                {
                    foreach (var item in psDataMap.Values)
                        if (externalIdMap.ContainsKey(item.ImageId))
                            item.ImageId = externalIdMap[item.ImageId];
                }

                DateTime timeStamp;
                String dateTime = null;
                if (!String.IsNullOrEmpty(imageHeader))
                {
                    String[] headerArr = imageHeader.Split('^');
                    if (headerArr.Length >= 3)
                    {
                        if (DateTime.TryParse(headerArr[2].Replace('@', ' '), out timeStamp))
                            dateTime = timeStamp.ToString();
                        else
                            dateTime = headerArr[2];
                    }
                        
                }

                // create one study presentation state for all vrad annotations
                var studyPS = new StudyPresentationState
                {
                    Id = Guid.NewGuid().ToString(),
                    Source = "Clinical Display",
                    IsEditable = false,
                    UserId = userId,
                    ContextId = contextId,
                    Data = JsonConvert.SerializeObject(psDataMap.Values.ToArray(),
                                                        new JsonSerializerSettings
                                                        {
                                                            NullValueHandling = NullValueHandling.Ignore,
                                                            ContractResolver = new CamelCasePropertyNamesContractResolver()
                                                        }),
                    IsExternal = true,
                    DateTime = dateTime,
                    Tooltip = tooltip
                };

                psList.Add(studyPS);
            }
        }

        internal static void ParseVRad(string contextId, string[] lines, int startIndex, int lineCount, List<StudyPresentationState> psList, Dictionary<string, string> externalIdMap, string userId)
        {
            int index = startIndex;
            int endIndex = startIndex + lineCount - 1;

            bool inImage = false;
            string currentImageIEN = null;
            string currentPSUid = null;
            bool inPS = false;
            StringBuilder psData = null;
            var psDataMap = new Dictionary<string, PresentationState>();

            while (index <= endIndex)
            {
                var line = lines[index];

                if (!inImage && (line == "*IMAGE")) // beginning of image
                {
                    inImage = true;
                }
                else if (inImage && (line == "*END_IMAGE"))
                {
                    inImage = false;
                    currentImageIEN = null;
                }
                else
                {
                    if (inImage)
                    {
                        if (currentImageIEN == null)
                            currentImageIEN = line.Split('^')[0];
                        else
                        {
                            if (!inPS && (line == "*PS"))
                            {
                                inPS = true;
                            }
                            else if (inPS)
                            {
                                if (currentPSUid == null)
                                {
                                    currentPSUid = line.Split('^')[0];
                                    psData = new StringBuilder();
                                }
                                else if (line == "*END_PS")
                                {
                                    if (psData != null)
                                        ParseVRADXml(currentImageIEN, psData.ToString(), psDataMap);

                                    inPS = false;
                                    psData = null;
                                    currentPSUid = null;
                                }
                                else if (psData != null)
                                {
                                    psData.Append(line);
                                }
                            }
                        }
                    }
                }

                index++;
            }

            if (externalIdMap != null)
            {
                foreach (var item in psDataMap.Values)
                    if (externalIdMap.ContainsKey(item.ImageId))
                        item.ImageId = externalIdMap[item.ImageId];
            }

            // create one study presentation state for all vrad annotations
            var studyPS = new StudyPresentationState
            {
                Id = Guid.NewGuid().ToString(),
                Source = "VistARad",
                IsEditable = false,
                UserId = userId,
                ContextId = contextId,
                Data = JsonConvert.SerializeObject(psDataMap.Values.ToArray(),
                                                    new JsonSerializerSettings
                                                    {
                                                        NullValueHandling = NullValueHandling.Ignore,
                                                        ContractResolver = new CamelCasePropertyNamesContractResolver()
                                                    }),
                IsExternal = true
            };

            psList.Add(studyPS);
        }

        private static string GetSafeValue(System.Xml.Linq.XElement element, System.Xml.Linq.XName name)
        {
            System.Xml.Linq.XElement result = element.Element(name);
            return (result != null) ? result.Value : null;
        }

        public static void ParseClinXml(string imageIEN, string psXmlData, Dictionary<string, PresentationState> psDataMap, ref string tooltip)
        {
            if (string.IsNullOrWhiteSpace(psXmlData))
                return;

            // strip out ^\r\n^
            psXmlData = psXmlData.Replace("^\\r\\n^", "");
            var doc = XDocument.Parse(psXmlData);
            var graphicObjects = new List<GraphicObject>();

            var sitenumber = doc.Root.Attribute("primesitenumber");
            var service = doc.Root.Attribute("service");

            if (sitenumber != null && service != null)
            {
                tooltip = "Site: " + sitenumber.Value;
                tooltip += "\nService: " + service.Value;
            }

            // query for objects by ignoring namespace
            var objects = doc.Root.WithoutNamespaces().Descendants(@"Objects");
            if ((objects == null) || (objects.Count() == 0))
                return;

            foreach (var item in objects)
            {
                foreach (var child in item.Elements())
                {
                    string type = null;
                    if (child.Name == "LINE")
                        type = "LINE";
                    else if (child.Name == "RECTANGLE")
                        type = "RECT";
                    else if (child.Name == "ELLIPSE")
                        type = "ELLIPSE";
                    else if (child.Name == "POLYLINE")
                        type = "FREEHAND";
                    else if (child.Name == "TEXT")
                        type = "TEXT";
                    else if (child.Name == "PROTRACTOR")
                        type = "ANGLE";
                    else
                        continue;

                    GraphicObject graphicObject = new GraphicObject
                    {
                        Id = Guid.NewGuid().ToString(),
                        Type = type
                    };

                    var text = child.XPathSelectElement(@"Text");
                    if (text != null)
                        graphicObject.Text = child.XPathSelectElement(@"Text").Value;

                    // some objects have points others have bounds
                    var points = child.Elements(@"Points");
                    if ((points != null) && (points.Count() > 0))
                    {
                        bool isFreeHand = (type.CompareTo("FREEHAND") == 0 ? true : false);
                        bool isAngle = (type.CompareTo("ANGLE") == 0 ? true : false);
                        int arraySize = points.Count();
                        if (isFreeHand || isAngle)
                        {
                            arraySize = arraySize * 4;
                        }
                        else
                        {
                            arraySize *= 2;
                        }
                        graphicObject.Points = new int[arraySize];
                        XElement[] pointArray = points.ToArray();

                        int i = 0;
                        for (int index = 0; index < points.Count(); index++)
                        {
                            graphicObject.Points[i++] = Convert.ToInt32(pointArray[index].Element(@"X").Value);
                            graphicObject.Points[i++] = Convert.ToInt32(pointArray[index].Element(@"Y").Value);
                            if(isFreeHand)
                            {
                                int nextIndex = (index == (points.Count() - 1) ? index : index + 1);
                                graphicObject.Points[i++] = Convert.ToInt32(pointArray[nextIndex].Element(@"X").Value);
                                graphicObject.Points[i++] = Convert.ToInt32(pointArray[nextIndex].Element(@"Y").Value);
                            }
                            if (isAngle && (index == 1 || index == 2))
                            {
                                graphicObject.Points[i++] = Convert.ToInt32(pointArray[index].Element(@"X").Value);
                                graphicObject.Points[i++] = Convert.ToInt32(pointArray[index].Element(@"Y").Value);
                                if (index == 2)
                                {
                                    graphicObject.Points[i++] = Convert.ToInt32(pointArray[index].Element(@"X").Value);
                                    graphicObject.Points[i++] = Convert.ToInt32(pointArray[index].Element(@"Y").Value);
                                }
                            }
                        }
                    }
                    else if (child.XPathSelectElement(@"Bounds") != null)
                    {
                        graphicObject.Points = new int[4];
                        graphicObject.Points[0] = Convert.ToInt32(child.XPathSelectElement(@"Bounds/X").Value);
                        graphicObject.Points[1] = Convert.ToInt32(child.XPathSelectElement(@"Bounds/Y").Value);
                        graphicObject.Points[2] = graphicObject.Points[0] + Convert.ToInt32(child.XPathSelectElement(@"Bounds/Width").Value);
                        graphicObject.Points[3] = graphicObject.Points[1] + Convert.ToInt32(child.XPathSelectElement(@"Bounds/Height").Value);
                    }

                    graphicObjects.Add(graphicObject);
                }
            }

            if (graphicObjects.Count > 0)
            {
                int frameNumber = 0;
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

        private static void ParseVRADXml(string imageIEN, string psXmlData, Dictionary<string, PresentationState> psDataMap)
        {
            // first handle vrad quirks.
            // xmldata has '[<DEG>]', while will mess up xml parsing - so xml encode it
            string unsafeText = "[<DEG>]";
            string safeText = System.Web.HttpUtility.HtmlEncode(unsafeText);
            psXmlData = psXmlData.Replace(unsafeText, safeText);


            var doc = XDocument.Parse(psXmlData);
            var graphicObjects = new List<GraphicObject>();
            int frameNumber = 0;
            if (int.TryParse(GetSafeValue(doc.Root, @"Frame"), out frameNumber))
                frameNumber -= 1; // VRad frame number is 1 based

            var elements = doc.Descendants(@"Element");
            if ((elements != null) && (elements.Count() > 0))
            {
                foreach (var element in elements)
                {
                    string graphicId = null;
                    var graphicIdAttrib = element.Attribute(@"uid");
                    if (graphicIdAttrib != null)
                        graphicId = graphicIdAttrib.Value;
                    graphicId = string.IsNullOrEmpty(graphicId) ? Guid.NewGuid().ToString() : graphicId;

                    int vradType = 0;
                    var vradTypeAttrib = element.Attribute(@"type");
                    int.TryParse((vradTypeAttrib != null)? vradTypeAttrib.Value : null, out vradType);

                    string graphicType = null;
                    switch (vradType)
                    {
                        case 17: graphicType = "LENGTH"; break;
                        case 18: graphicType = "HOUNSFIELDELLIPSE"; break;
                        case 19: graphicType = "ANGLE"; break;
                        case 20: graphicType = "HOUNSFIELDFREEHAND"; break;
                        case 21: graphicType = "HOUNSFIELDRECT"; break;
                        case 23: graphicType = "TEXT"; break;
                        case 24: graphicType = "ARROW"; break;
                        case 27: graphicType = "LINE"; break;
                        case 28: graphicType = "RECT"; break;
                        case 29: graphicType = "ELLIPSE"; break;
                        case 31: graphicType = "FREEHAND"; break;
                        case 32: graphicType = "COBBANGLE"; break;
                        case 34: graphicType = "POINT"; break;
                        default: continue;
                    }

                    int[] points = null;
                    int[] extra = null;
                    var dataElement = element.Element("data");
                    if ((dataElement != null) && (dataElement.Value != null))
                    {
                        points = dataElement.Value.Split(',').Select(n => (int)Math.Floor(Convert.ToDouble(n))).ToArray();
                        if (vradType == 18 && points.Count() == 12)
                        {
                            int[] tempPoints = new int[12];
                            tempPoints[0] = points[0];
                            tempPoints[1] = points[1];
                            tempPoints[2] = points[2];
                            tempPoints[3] = points[3];
                            tempPoints[4] = points[6];
                            tempPoints[5] = points[7];
                            tempPoints[6] = points[4];
                            tempPoints[7] = points[5];
                            tempPoints[8] = points[8];
                            tempPoints[9] = points[9];
                            tempPoints[10] = points[10];
                            tempPoints[11] = points[11];
                            points = tempPoints;
                        }
                        if (vradType == 29 && points.Count() == 10)
                        {
                            int[] tempPoints = new int[10];
                            tempPoints[0] = points[0];
                            tempPoints[1] = points[1];
                            tempPoints[2] = points[2];
                            tempPoints[3] = points[3];
                            tempPoints[4] = points[6];
                            tempPoints[5] = points[7];
                            tempPoints[6] = points[4];
                            tempPoints[7] = points[5];
                            tempPoints[8] = points[8];
                            tempPoints[9] = points[9];
                            points = tempPoints;
                        }
                        if ((vradType == 17 || vradType == 24) && points.Count() == 8)
                        {
                            int[] tempPoints = new int[4];
                            tempPoints[0] = points[0];
                            tempPoints[1] = points[1];
                            tempPoints[2] = points[2];
                            tempPoints[3] = points[3];
                            points = tempPoints;
                        }
                        if (vradType == 19 && points.Count() == 10)
                        {
                            int[] tempPoints = new int[10];
                            tempPoints[0] = points[2];
                            tempPoints[1] = points[3];
                            tempPoints[2] = points[0];
                            tempPoints[3] = points[1];
                            tempPoints[4] = points[0];
                            tempPoints[5] = points[1];
                            tempPoints[6] = points[4];
                            tempPoints[7] = points[5];
                            tempPoints[8] = 0;
                            tempPoints[9] = 0;
                            points = tempPoints;
                        }
                        var extraAttrib = dataElement.Attribute("extra");
                        if ((extraAttrib != null) && (extraAttrib.Value != null))
                            extra = extraAttrib.Value.Split(',').Select(n => (int) Math.Floor(Convert.ToDouble(n))).ToArray();
                    }

                    string text = null;
                    var textpartElements = element.Descendants("textpart");
                    if (textpartElements != null)
                        text = string.Join("<BR>", textpartElements.Select(x => x.Value));

                    var graphicObject = new GraphicObject
                    {
                        Type = graphicType,
                        Id = graphicId,
                        Points = points,
                        Text = text,
                        GraphicLayerIndex = 0
                    };

                    graphicObjects.Add(graphicObject);
                }
            }

            if (graphicObjects.Count > 0)
            {
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

        public static XElement WithoutNamespaces(this XElement element)
        {
            if (element == null) 
                return null;

            Func<XNode, XNode> getChildNode = e => (e.NodeType == XmlNodeType.Element) ? (e as XElement).WithoutNamespaces() : e;

            Func<XElement, IEnumerable<XAttribute>> getAttributes = e => (e.HasAttributes) ?
                e.Attributes()
                    .Where(a => !a.IsNamespaceDeclaration)
                    .Select(a => new XAttribute(a.Name.LocalName, a.Value))
                :
                Enumerable.Empty<XAttribute>();

            return new XElement(element.Name.LocalName,
                element.Nodes().Select(getChildNode),
                getAttributes(element));
        }
    }
}
