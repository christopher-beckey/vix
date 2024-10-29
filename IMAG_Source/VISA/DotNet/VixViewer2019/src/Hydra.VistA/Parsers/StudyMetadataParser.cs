using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Xml.XPath;

namespace Hydra.VistA.Parsers
{
    public static class StudyMetadataParser
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static string XPathGetText(this XNode node, string expression, string defaultValue = null)
        {
            var element = node.XPathSelectElement(expression);
            return (element != null) ? element.Value : defaultValue;
        }

        public static int XPathGetInt(this XNode node, string expression, int defaultValue = 0)
        {
            var element = node.XPathSelectElement(expression);
            int value = 0;
            return ((element != null) && int.TryParse(element.Value, out value)) ? value : defaultValue;
        }

        public static string XPathGetFirstElementText(this XElement node, string expression, string defaultValue = null)
        {
            var element = node.Elements(expression).FirstOrDefault();
            return (element != null) ? element.Value : defaultValue;
        }

        public static int XPathGetFirstElementInt(this XElement node, string expression, int defaultValue = 0)
        {
            var element = node.Elements(expression).FirstOrDefault();
            int value = 0;
            return ((element != null) && int.TryParse(node.Value, out value)) ? value : defaultValue;
        }

        public static bool XPathGetBool(this XNode node, string expression, bool defaultValue = false)
        {
            var element = node.XPathSelectElement(expression);
            return (element != null) ? ((string.Compare(element.Value, "true", true) == 0)) : defaultValue;
        }

        public static void FillBasic(string text, StudyItem studyItem)
        {
            if (string.IsNullOrEmpty(text))
            {
                studyItem.StatusCode = VixStatusCode.NoContent;
                studyItem.Status = "Study metadata is empty";
                return;
            }

            XDocument doc = XDocument.Parse(text);
            var studies = doc.Descendants(@"study");
            if ((studies == null) || (studies.Count() == 0))
            {
                studyItem.StatusCode = VixStatusCode.NoContent;
                studyItem.Status = "Study metadata does not contain any studies";
                return;
            }

            // get thumbnail for the first study
            var study = studies.First();
            FillBasic(study, studyItem);
        }

        public static void FillBasic(XElement study, StudyItem studyItem)
        {
            if (study == null)
            {
                studyItem.StatusCode = VixStatusCode.NoContent;
                studyItem.Status = "Study metadata is empty";
                return;
            }

            //var images = study.Descendants(@"image");
            //studyItem.ImageCount = (images != null) ? images.Count() : 0;
            studyItem.ImageCount = study.XPathGetInt(@"imageCount");

            studyItem.ThumbnailUri = study.XPathGetText(@"firstImage/thumbnailImageUri");
            studyItem.IsSensitive = study.XPathGetBool(@"firstImage/sensitive");
            studyItem.GroupIEN = study.XPathGetText(@"groupIen");
            studyItem.ExternalContextId = study.XPathGetText(@"alternateExamNumber");

            // abstract study item
            studyItem.StudyDescription = study.XPathGetText(@"description");
            studyItem.StudyId = study.XPathGetText(@"studyId");
            studyItem.StudyDate = study.XPathGetText(@"procedureDate");
            studyItem.AcquisitionDate = study.XPathGetText(@"firstImage/captureDate");
            studyItem.IsSensitive = study.XPathGetBool(@"sensitive");
            studyItem.Package = study.XPathGetText(@"package");
            studyItem.Type = study.XPathGetText(@"type");
            studyItem.Origin = study.XPathGetText(@"origin");
            studyItem.Event = study.XPathGetText(@"event");
            studyItem.SiteName = study.XPathGetText(@"siteName");
            studyItem.StudyClass = study.XPathGetText(@"studyClass");
            studyItem.StudyType = study.XPathGetText(@"studyType");
            studyItem.SpecialtyDescription = study.XPathGetText(@"specialtyDescription");
            studyItem.ProcedureDescription = study.XPathGetText(@"procedureDescription");

            studyItem.StatusCode = VixStatusCode.OK;
        }

        public static StudyItem[] ParsePatientStudyQueryReponse(string text, string patientICN, string patientDFN)
        {
            StudyItem[] studies = null;

            XDocument doc = XDocument.Parse(text);
            var studyNodes = doc.Descendants(@"study");
            if (studyNodes != null)
            {
                studies = new StudyItem[studyNodes.Count()];

                int studyIndex = 0;
                foreach (var study in studyNodes)
                {
                    var studyItem = new StudyItem();
                    studies[studyIndex++] = studyItem;

                    studyItem.ImageCount = study.XPathGetInt(@"imageCount");
                    studyItem.ContextId = study.XPathGetText(@"contextId");
                    if (string.IsNullOrEmpty(studyItem.ContextId))
                        studyItem.ContextId = study.XPathGetText(@"studyId");
                    studyItem.SiteNumber = study.XPathGetText(@"siteNumber");
                    studyItem.ThumbnailUri = study.XPathGetText(@"firstImage/thumbnailImageUri");
                    studyItem.IsSensitive = study.XPathGetBool(@"firstImage/sensitive");
                    studyItem.GroupIEN = study.XPathGetText(@"groupIen");
                    studyItem.ExternalContextId = study.XPathGetText(@"alternateExamNumber");

                    // abstract study item
                    studyItem.StudyDescription = study.XPathGetText(@"description");
                    studyItem.StudyId = study.XPathGetText(@"studyId");
                    studyItem.StudyDate = study.XPathGetText(@"procedureDate");
                    studyItem.AcquisitionDate = study.XPathGetText(@"firstImage/captureDate");
                    studyItem.IsSensitive = study.XPathGetBool(@"sensitive");
                    studyItem.Package = study.XPathGetText(@"package");
                    studyItem.Type = study.XPathGetText(@"type");
                    studyItem.Origin = study.XPathGetText(@"origin");
                    studyItem.Event = study.XPathGetText(@"event");
                    studyItem.SiteName = study.XPathGetText(@"siteName");
                    studyItem.StudyClass = study.XPathGetText(@"studyClass");
                    studyItem.StudyType = study.XPathGetText(@"studyType");
                    studyItem.SpecialtyDescription = study.XPathGetText(@"specialtyDescription");
                    studyItem.ProcedureDescription = study.XPathGetText(@"procedureDescription");

                    // adjusted properties
                    studyItem.ContextId = System.Web.HttpUtility.UrlDecode(studyItem.ContextId);
                    studyItem.PatientICN = patientICN;
                    studyItem.PatientDFN = patientDFN;
                    studyItem.StatusCode = null;
                }
            }

            return studies;
        }


        public static StudyDetails GetStudyDetails(string text, string contextId, bool includeImageDetails)
        {
            if (string.IsNullOrEmpty(text))
            {
                return null;
            }

            XDocument doc = XDocument.Parse(text);
            var studyDetails = new StudyDetails();

            var images = doc.Descendants(@"image");
            studyDetails.TotalImageCount = (images != null)? images.Count() : 0;

            var studies = doc.Descendants(@"study");
            if (studies != null)
            {
                studyDetails.Studies = new StudyItemDetails[studies.Count()];

                int studyIndex = 0;
                foreach (var study in studies)
                {
                    var studyItemDetails = new StudyItemDetails()
                    {
                        ContextId = contextId
                    };

                    studyDetails.Studies[studyIndex++] = studyItemDetails;

                    var seriesList = study.Descendants(@"series");
                    if ((seriesList == null) || (seriesList.Count() == 0))
                        continue;

                    images = study.Descendants(@"image");
                    studyItemDetails.ImageCount = (images != null) ? images.Count() : 0;

                    // abstract study item
                    studyItemDetails.StudyDescription = study.XPathGetText(@"description");
                    studyItemDetails.StudyId = study.XPathGetText(@"studyId");
                    studyItemDetails.StudyDate = study.XPathGetText(@"procedureDate");
                    studyItemDetails.AcquisitionDate = study.XPathGetText(@"firstImage/captureDate");
                    studyItemDetails.IsSensitive = study.XPathGetBool(@"sensitive");
                    studyItemDetails.Package = study.XPathGetText(@"package");
                    studyItemDetails.Type = study.XPathGetText(@"type");
                    studyItemDetails.Origin = study.XPathGetText(@"origin");
                    studyItemDetails.Event = study.XPathGetText(@"event");
                    studyItemDetails.SiteName = study.XPathGetText(@"siteName");
                    studyItemDetails.StudyClass = study.XPathGetText(@"studyClass");
                    studyItemDetails.StudyType = study.XPathGetText(@"studyType");
                    studyItemDetails.SpecialtyDescription = study.XPathGetText(@"specialtyDescription");
                    studyItemDetails.ProcedureDescription = study.XPathGetText(@"procedureDescription");

                    // series details
                    studyItemDetails.Series = new SeriesItemDetails[seriesList.Count()];
                    int seriesIndex = 0;
                    foreach (var series in seriesList)
                    {
                        var seriesItemDetails = new SeriesItemDetails();
                        studyItemDetails.Series[seriesIndex++] = seriesItemDetails;

                        images = series.Descendants(@"image");
                        if ((images == null) || (images.Count() == 0))
                            continue;

                        seriesItemDetails.ImageCount = images.Count();

                        var image = images.FirstOrDefault();
                        seriesItemDetails.Caption = image.XPathGetText(@"description");

                        var node = images.Elements(@"thumbnailImageUri").FirstOrDefault();
                        if (node != null)
                        {
                            seriesItemDetails.ImageUri = node.Value;

                            if (node.Parent != null)
                            {
                                node = node.Parent.Elements(@"sensitive").FirstOrDefault();
                                if (node != null)
                                    seriesItemDetails.IsSensitive = (string.Compare(node.Value, "true", true) == 0);
                            }
                        }

                        if (includeImageDetails)
                        {
                            seriesItemDetails.Images = new ImageItemDetails[images.Count()];

                            int imageIndex = 0;
                            foreach (var imageItem in images)
                            {
                                var imageItemDetails = new ImageItemDetails
                                {
                                    ImageUrn = imageItem.XPathGetText(@"imageId"),
                                    ImageStatus = imageItem.XPathGetText(@"imageStatus"),
                                    ImageViewStatus = imageItem.XPathGetText(@"imageViewStatus"),
                                    ImageType = imageItem.XPathGetText(@"imageType")
                                };

                                var tokens = imageItemDetails.ImageUrn.Split(new [] {'-'});
                                if ((tokens != null) && (tokens.Length >= 2))
                                    imageItemDetails.ImageIEN = tokens[1];

                                seriesItemDetails.Images[imageIndex++] = imageItemDetails;
                            }
                        }
                    }
                }
            }

            return studyDetails;
        }

        internal static void FillBasic(string text, IEnumerable<StudyItem> studyItems)
        {
            if (string.IsNullOrEmpty(text))
                return;

            XDocument doc = XDocument.Parse(text);
            var studies = doc.Descendants(@"study");
            if ((studies == null) || (studies.Count() == 0))
                return;

            foreach (var study in studies)
            {
                // perform lookup using either contextId or studyId
                var contextId = study.XPathGetText(@"contextId");
                if (string.IsNullOrEmpty(contextId))
                    contextId = study.XPathGetText(@"studyId");
                
                var studyItem = studyItems.Where(x => (string.Compare(contextId, x.ContextId) == 0)).FirstOrDefault();
                if (studyItem != null)
                    FillBasic(study, studyItem);
                else
                {
                    // did not find a match. unusual behaviour
                    if (_Logger.IsWarnEnabled)
                        _Logger.Warn("No matching study found in query result", "ContextId", study.XPathGetText(@"contextId"), "StudyId", study.XPathGetText(@"studyId"));
                }
            }
        }

        internal static void ParseDisplayContextMetadata(string text, Hydra.Web.Common.DisplayContextMetadata displayContextMetadata)
        {
            var studyMetadataList = new List<Hydra.Web.Common.ImageGroupMetadata>();

            XDocument doc = XDocument.Parse(text);

            var images = doc.Descendants(@"image");
            displayContextMetadata.TotalImageCount = (images != null) ? images.Count() : 0;

            var studies = doc.Descendants(@"study");
            if (studies != null)
            {
                foreach (var study in studies)
                {
                    var studyMetadata = new Hydra.Web.Common.ImageGroupMetadata()
                    {
                        GroupType = Web.Common.ImageGroupMetadataType.DicomStudy
                    };

                    var seriesList = study.Descendants(@"series");
                    if ((seriesList == null) || (seriesList.Count() == 0))
                        continue;

                    images = study.Descendants(@"image");
                    studyMetadata.TotalImageCount = (images != null) ? images.Count() : 0;

                    studyMetadata.Caption = study.XPathGetText(@"description");

                    var firstImage = study.Element(@"firstImage");
                    if (firstImage != null)
                    {
                        studyMetadata.ThumbnailUri = string.Format("{0}&isSensitive={1}", 
                                                     firstImage.XPathGetText(@"thumbnailImageUri", "").TrimEnd('&'),
                                                     firstImage.XPathGetBool(@"sensitive"));
                    }

                    // patient
                    if (displayContextMetadata.Patient == null)
                    {
                        string patientId = study.XPathGetText(@"patientId");
                        if (!string.IsNullOrEmpty(patientId))
                        {
                            displayContextMetadata.Patient = new Entities.Patient
                            {
                                ICN = patientId,
                                FullName = study.XPathGetText(@"patientName")
                            };
                        }
                    }


                    // abstract study item
                    studyMetadata.StudyDescription = study.XPathGetText(@"description");
                    studyMetadata.StudyId = study.XPathGetText(@"studyId");
                    studyMetadata.StudyDate = study.XPathGetText(@"procedureDate");
                    studyMetadata.AcquisitionDate = study.XPathGetText(@"firstImage/captureDate");
                    studyMetadata.IsSensitive = study.XPathGetBool(@"sensitive");
                    studyMetadata.Package = study.XPathGetText(@"package");
                    studyMetadata.Type = study.XPathGetText(@"type");
                    studyMetadata.Origin = study.XPathGetText(@"origin");
                    studyMetadata.Event = study.XPathGetText(@"event");
                    studyMetadata.SiteName = study.XPathGetText(@"siteName");
                    studyMetadata.StudyClass = study.XPathGetText(@"studyClass");
                    studyMetadata.StudyType = study.XPathGetText(@"studyType");
                    studyMetadata.SpecialtyDescription = study.XPathGetText(@"specialtyDescription");
                    studyMetadata.ProcedureDescription = study.XPathGetText(@"procedureDescription");

                    // series details
                    var seriesMetadataList = new List<Web.Common.ImageGroupMetadata>(); 
                    foreach (var series in seriesList)
                    {
                        var seriesMetadata = new Hydra.Web.Common.ImageGroupMetadata()
                        {
                            GroupType = Web.Common.ImageGroupMetadataType.DicomSeries,
                            Caption = series.XPathGetText(@"seriesNumber")
                        };

                        var imageMetadataList = new List<Hydra.Web.Common.ImageMetadata>();
                        images = series.Descendants(@"image");
                        foreach (var image in images)
                        {
                            var imageMetadata = new Web.Common.ImageMetadata()
                            {
                                ImageUri = XPathGetText(image, @"diagnosticImageUri"),
                                Description = XPathGetText(image, @"description"),
                                Caption = XPathGetText(image, @"imageNumber"),
                                ImageId = XPathGetText(image, @"imageId"),
                                IsSensitive = XPathGetBool(image, @"sensitive"),
                                CaptureDate = XPathGetText(image, @"captureDate"),
                                DocumentDate = XPathGetText(image, @"documentDate"),
                                ImageType = XPathGetText(image, @"imageType"),
                                ImageStatus = XPathGetText(image, @"imageStatus"),
                                ImageViewStatus = XPathGetText(image, @"imageViewStatus"),
                            };

                            imageMetadata.ThumbnailUri = string.Format("{0}&isSensitive={1}",
                                                         image.XPathGetText(@"thumbnailImageUri", "").TrimEnd('&'),
                                                         imageMetadata.IsSensitive);

                            imageMetadata.FileType = VixServiceUtil.DetectFileType(imageMetadata.ImageUri);
                            imageMetadataList.Add(imageMetadata);
                        }

                        if (imageMetadataList.Count > 0)
                        {
                            seriesMetadata.ThumbnailUri = imageMetadataList[0].ThumbnailUri;
                            seriesMetadata.Images = imageMetadataList.ToArray();
                        }

                        seriesMetadataList.Add(seriesMetadata);
                    }

                    studyMetadata.ImageGroups = seriesMetadataList.ToArray();

                    studyMetadataList.Add(studyMetadata);
                }
            }

            if (studyMetadataList.Count > 0)
                displayContextMetadata.ImageGroups = studyMetadataList.ToArray();
        }

        internal static void ParseUserDetails(string text, Hydra.Web.Common.UserDetails userDetails)
        {
            if (string.IsNullOrWhiteSpace(text))
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("ParseUserDetails started with empty text.");
                userDetails.CanDelete = false;
                userDetails.CanEdit = false;
                userDetails.CanPrint = PolicyUtil.IsPolicyEnabled("Viewer.OverrideExportKeys", false);
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("ParseUserDetails complete (with empty text).", "userDetails.CanDelete", userDetails.CanDelete, "userDetails.CanEdit", userDetails.CanEdit, "userDetails.CanPrint", userDetails.CanPrint);
                return;
            }

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("ParseUserDetails started.", "text", text);

            XDocument doc = XDocument.Parse(text);
            var securityKeys = doc.Descendants(@"securityKey");
            if ((securityKeys == null) || (securityKeys.Count() == 0))
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("securityKeys is empty");
            }
            else
            {
                bool hasMagDelete = false;
                bool hasMagEdit = false;
                bool hasMagSystem = false;
                bool hasMagRoi = false;

                foreach (var securityKey in securityKeys)
                {
                    if (string.Compare(securityKey.Value, "MAG DELETE", true) == 0)
                        hasMagDelete = true;
                    else if (string.Compare(securityKey.Value, "MAG EDIT", true) == 0)
                        hasMagEdit = true;
                    else if (string.Compare(securityKey.Value, "MAG SYSTEM", true) == 0)
                        hasMagSystem = true;
                    else if (string.Compare(securityKey.Value, "MAG ROI", true) == 0)
                        hasMagRoi = true;
                }

                userDetails.CanDelete = hasMagDelete || hasMagSystem;
                userDetails.CanEdit = hasMagEdit || hasMagSystem;
                userDetails.CanPrint = hasMagSystem || hasMagRoi;
                userDetails.IsAdmin = hasMagSystem;

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("ParseUserDetails almost done.", "userDetails.CanDelete", userDetails.CanDelete, "userDetails.CanEdit", userDetails.CanEdit, "userDetails.CanPrint", userDetails.CanPrint, "userDetails.IsAdmin", userDetails.IsAdmin);
            }

            if (PolicyUtil.IsPolicyEnabled("Viewer.OverrideExportKeys"))
            {
                userDetails.CanPrint = true;
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Viewer.OverrideExportKeys is true.", "userDetails.CanPrint", userDetails.CanPrint);
            }

            userDetails.Initials = doc.Root.XPathGetText(@"userInitials");
            userDetails.Name = doc.Root.XPathGetText(@"userName");
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("ParseUserDetails complete.", "userDetails.Initials", userDetails.Initials, "userDetails.Name", userDetails.Name);
        }

        internal static Hydra.Web.Common.ImageDeleteResponse[] ParseImageDeleteResponse(string text)
        {
            var response = new List<Hydra.Web.Common.ImageDeleteResponse>();

            if (!string.IsNullOrWhiteSpace(text))
            {
                XDocument doc = XDocument.Parse(text);
                var failedImages = doc.XPathSelectElements(@"//imageUrn[deleteResult = 'ERROR']");
                if (failedImages != null)
                {
                    foreach (var failedImage in failedImages)
                    {
                        var item = new Hydra.Web.Common.ImageDeleteResponse
                        {
                            IsSucceeded = false,
                            ImageId = failedImage.XPathGetText(@"value"),
                            Message = failedImage.XPathGetText(@"deleteResultMsg")
                        };

                        response.Add(item);
                    }
                }
            }

            return response.ToArray();
        }
    }
}
