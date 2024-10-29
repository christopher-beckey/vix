using Hydra.Log;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Hydra.VistA.Parsers
{
    public class DisplayObjectParser
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static List<DisplayObjectGroup> Parse(string text)
        {
            var collection = new List<DisplayObjectGroup>();

            if (string.IsNullOrEmpty(text))
                throw new ArgumentNullException();

            int diagnosticImageQuality = VistAConfigurationSection.Instance.DiagnosticImageQuality;

            XDocument doc = XDocument.Parse(text);

            // iterate images, grouped by study
            var studies = doc.Descendants(@"study");
            if ((studies != null) && (studies.Count() > 0))
            {
                foreach (var study in studies)
                {
                    string contextId = GetSafeValue(study, "contextId");
                    if (string.IsNullOrEmpty(contextId))
                        contextId = GetSafeValue(study, "studyId");

                    DisplayObjectGroup imageGroup = new DisplayObjectGroup
                    {
                        StudyId = contextId,
                        StudyDescription = GetSafeValue(study, "description"),
                        StudyDateTime = GetSafeValue(study, "documentDate"),
                        PatientDescription = GetSafeValue(study, "patientName"),

                        // pre-caching related proeprties
                        PatientICN = GetSafeValue(study, "patientICN"),
                        PatientDFN = GetSafeValue(study, "patientDFN"),
                        SiteNumber = GetSafeValue(study, "siteNumber"),

                        Items = new List<DisplayObject>()
                    };

                    var images = study.Descendants(@"image");
                    foreach (var image in images)
                    {
                        var displayObject = new DisplayObject
                        {
                            Description = GetSafeValue(image, "description"),
                            Path = GetSafeValue(image, "diagnosticImageUri")
                        };

                        // extract image ien from image urn
                        var imageUrn = GetSafeValue(image, "imageId");
                        if (!string.IsNullOrEmpty(imageUrn))
                        {
                            // second piece is the image ien when split using '-'
                            var pieces = imageUrn.Split('-');
                            if (pieces.Length > 1)
                                displayObject.ImageIEN = pieces[1];
                        }

                        if (!string.IsNullOrEmpty(displayObject.Path))
                        {
                            var nameValueCollection = System.Web.HttpUtility.ParseQueryString(displayObject.Path);

                            // adjust image quality
                            if (!string.IsNullOrEmpty(nameValueCollection["imageQuality"]))
                            {
                                // set image quality for dicom and tga image only
                                var imageType = GetSafeValue(image, "imageType");
                                if ((imageType != null) &&
                                    ((string.Compare(imageType, "DICOM", true) == 0) ||
                                     (string.Compare(imageType, "TGA", true) == 0)))
                                {
                                    if (diagnosticImageQuality != 0)
                                    {
                                        nameValueCollection["imageQuality"] = diagnosticImageQuality.ToString();
                                    }
                                    else if (string.Compare(imageType, "TGA", true) == 0)
                                    {
                                        if (_Logger.IsInfoEnabled)
                                            _Logger.Info("Targa image detected. Requesting image quality 90");

                                        // for now, always request targa images as compressed, so that they will be returned in dicom format
                                        nameValueCollection["imageQuality"] = "90";
                                    }
                                }
                            }

                            // remove unsupported content type
                            RemoveUnsupportedContentTypes(nameValueCollection);

                            var array = (from key in nameValueCollection.AllKeys
                                         from value in nameValueCollection.GetValues(key)
                                         select string.Format("{0}={1}", key, value)).ToArray();
                            displayObject.Path = string.Join("&", array);
                        }

                        imageGroup.Items.Add(displayObject);
                    }

                    collection.Add(imageGroup);
                }
            }

            return collection;
        }

        private static void RemoveUnsupportedContentTypes(System.Collections.Specialized.NameValueCollection nameValueCollection)
        {
            var names = new string[] { "contentType", "contentTypeWithSubType" };
            var unsupportedTypes = new List<string>{"image/j2k", "image/x-targa"};

            Array.ForEach<string>(names, name =>
                {
                    var value = nameValueCollection[name];
                    if (!string.IsNullOrEmpty(value))
                    {
                        // ignore if content type does not contain application/dicom
                        if (value.Contains("application/dicom"))
                        {
                            var types = value.Split(',').ToList();
                            nameValueCollection[name] = string.Join(",", types.Except(unsupportedTypes));
                        }
                    }
                });
        }

        private static void SetDiagnosticImageQuality(DisplayObject displayObject, int diagnosticImageQuality)
        {
            var nameValueCollection =  System.Web.HttpUtility.ParseQueryString(displayObject.Path);
            if (nameValueCollection == null)
                return;

            if (string.IsNullOrEmpty(nameValueCollection["imageQuality"]))
                return;

            nameValueCollection["imageQuality"] = diagnosticImageQuality.ToString();

            var array = (from key in nameValueCollection.AllKeys
                         from value in nameValueCollection.GetValues(key)
                         select string.Format("{0}={1}", key, value)).ToArray();
            displayObject.Path = string.Join("&", array);
        }

        private static string GetSafeValue(System.Xml.Linq.XElement element, System.Xml.Linq.XName name)
        {
            System.Xml.Linq.XElement result = element.Element(name);
            return (result != null) ? result.Value : null;
        }
    }
}
