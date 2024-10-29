using ClearCanvas.Dicom;
using ClearCanvas.Dicom.Utilities;
using Hydra.Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class StudyReader
    {
        public static Study CreateStudy(IEnumerable<string> files)
        {
            Study study = null;
            int totalImageCount = 0;
            bool studyDetailsFound = false;
            List<string> nonDicomFiles = new List<string>();

            foreach (string filePath in files)
            {
                bool isDicomFile = false;

                // load as dicom file
                try
                {
                    DicomFile file = new DicomFile(filePath);
                    file.Load(DicomReadOptions.DoNotStorePixelDataInDataSet);
                    isDicomFile = true;

                    if (study == null)
                    {
                        study = new Study();
                    }

                    if (!studyDetailsFound)
                    {
                        study.DicomStudyId = file.DataSet[DicomTags.StudyId].ToString();
                        study.Series = new List<Series>();

                        study.Procedure = file.DataSet[DicomTags.StudyDescription].ToString();
                        study.Modality = file.DataSet[DicomTags.Modality].ToString();

                        DateTime dtStudyDate;
                        if (DateParser.Parse(file.DataSet[DicomTags.StudyDate].ToString(), out dtStudyDate))
                        {
                            DateTime dtStudyTime;
                            if (TimeParser.Parse(file.DataSet[DicomTags.StudyTime].ToString(), out dtStudyTime))
                            {
                                study.DateTime = string.Format("{0:0000}-{1:00}-{2:00}T{3:00}:{4:00}:{5:00}",
                                                               dtStudyDate.Year,
                                                               dtStudyDate.Month,
                                                               dtStudyDate.Day,
                                                               dtStudyTime.Hour, dtStudyTime.Minute, dtStudyTime.Second);
                            }
                        }

                        study.Patient = new Patient();
                        study.Patient.ICN = file.DataSet[DicomTags.PatientId].ToString();
                        study.Patient.FullName = file.DataSet[DicomTags.PatientsName].ToString();
                        study.Patient.dob = file.DataSet[DicomTags.PatientsBirthDate].ToString();
                        study.Patient.Sex = file.DataSet[DicomTags.PatientsSex].ToString();

                        studyDetailsFound = true;
                    }

                    string seriesInstanceUID = file.DataSet[DicomTags.SeriesInstanceUid].ToString();
                    Series series = study.Series.Where(p => (p.SeriesInstanceUID == seriesInstanceUID)).FirstOrDefault();
                    if (series == null)
                    {
                        series = new Series();
                        series.SeriesInstanceUID = seriesInstanceUID;
                        series.Modality = file.DataSet[DicomTags.Modality].ToString();
                        series.Description = file.DataSet[DicomTags.SeriesDescription].ToString();
                        series.Images = new List<Image>();

                        int seriesNumber = 0;
                        int.TryParse(file.DataSet[DicomTags.SeriesNumber].ToString(), out seriesNumber);
                        series.SeriesNumber = seriesNumber;
                        
                        study.Series.Add(series);
                    }

                    Image image = new Image();
                    image.FilePath = filePath;
                    image.ImageId = Path.GetFileNameWithoutExtension(filePath);
                    image.DicomStudyId = study.DicomStudyId;
                    image.SeriesNumber = series.SeriesNumber;

                    if (file.DataSet.Contains(DicomTags.ProcedureCodeSequence))
                    {
                        DicomAttribute attribute = file.DataSet[DicomTags.ProcedureCodeSequence];
                        if (!attribute.IsEmpty && !attribute.IsNull)
                        {
                            DicomSequenceItem sequence = ((DicomSequenceItem[])attribute.Values)[0];
                            image.Description = sequence[DicomTags.CodeMeaning].ToString();
                        }
                    }

                    int numberOfFrames = 0;
                    int.TryParse(file.DataSet[DicomTags.NumberOfFrames].ToString(), out numberOfFrames);
                    image.NumberOfFrames = numberOfFrames;

                    int instanceNumber = 0;
                    int.TryParse(file.DataSet[DicomTags.InstanceNumber].ToString(), out instanceNumber);
                    image.InstanceNumber = instanceNumber;

                    image.Index = totalImageCount++;
                    image.Modality = file.DataSet[DicomTags.Modality].ToString();

                    // detect image types, even if image type is already set
                    image.ImageType = Utility.GetImageType(file.DataSet[DicomTags.SopClassUid].ToString(), image.Modality, image.NumberOfFrames);

                    // calculate dicom image plane
                    image.ImagePlane = ImageProcessor.GetImagePlane(file);

                    series.Images.Add(image);
                    series.ImageCount = series.Images.Count;
                }
                catch (Exception)
                {
                    if (!isDicomFile)
                        nonDicomFiles.Add(filePath);
                }
            }

            // process non-dicom images
            foreach (string filePath in nonDicomFiles)
            {
                string extension = Path.GetExtension(filePath).ToLower();
                if ((extension == ".jpeg") || (extension == ".jpg"))
                {
                    if (study == null)
                    {
                        study = new Study();
                    }

                    if (!studyDetailsFound)
                    {
                        // use folder name for study id
                        study.DicomStudyId = Path.GetFileName(Path.GetDirectoryName(filePath));
                        study.Series = new List<Series>();
                        studyDetailsFound = true;
                    }

                    // create separate series for each image
                    Series series = new Series();
                    series.Images = new List<Image>();
                    study.Series.Add(series);

                    Image image = new Image();
                    image.FilePath = filePath;
                    image.ImageId = Path.GetFileNameWithoutExtension(filePath);
                    image.ImageType = "jpeg";
                    image.DicomStudyId = study.DicomStudyId;
                    image.SeriesNumber = series.SeriesNumber;
                    image.NumberOfFrames = 1;
                    image.Index = totalImageCount++;
                    series.Images.Add(image);
                    series.ImageCount = series.Images.Count;
                }
            }

            if (study != null)
            {
                if (study.Series != null)
                {
                    // sort series by series number
                    study.Series = study.Series.OrderBy(s => s.SeriesNumber).ToList();

                    foreach (Series series in study.Series)
                    {
                        //Sort the list by image number.
                        if (series.Images.Count() > 0)
                        {
                            series.Images = series.Images.OrderBy(o => o.InstanceNumber).ToList();
                        }
                    }

                    study.ImageCount = totalImageCount;
                    study.SeriesCount = study.Series.Count;
                }
            }

            return study;
        }
    }
}
