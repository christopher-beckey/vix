using Hydra.Common.Exceptions;
using Hydra.IX.Common;
using Hydra.IX.Database.Common;
using Nancy.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Core
{
    internal class ImageGroupUtil
    {
        internal static void CreateImageGroupDetails(IHixDbContextFactory ctxFactory, ImageGroupDetails imageGroupDetails)
        {
            using (var ctx = ctxFactory.Create())
            {
                var imageGroup = ctx.ImageGroups.Where(x => (x.GroupUid == imageGroupDetails.GroupUid)).FirstOrDefault();
                if (imageGroup == null)
                    throw new BadRequestException("Image group {0} not found", imageGroupDetails.GroupUid);

                FillNonDicomImages(ctx, imageGroupDetails);
                FillDicomStudies(ctx, imageGroupDetails);

                imageGroupDetails.Tags = TagUtil.GetTags(ctx, imageGroup);

                var childImageGroups = ctx.ImageGroups.Where(x => (x.ParentGroupUid == imageGroupDetails.GroupUid)).ToList();
                foreach (var childImageGroup in childImageGroups)
                {
                    var childImageGroupDetails = new ImageGroupDetails
                    {
                        GroupUid = childImageGroup.GroupUid
                    };

                    CreateImageGroupDetails(ctxFactory, childImageGroupDetails);

                    if (imageGroupDetails.Children == null)
                        imageGroupDetails.Children = new List<ImageGroupDetails>();

                    imageGroupDetails.Children.Add(childImageGroupDetails);
                }
            }
        }

        private static void FillNonDicomImages(IHixDbContext ctx, ImageGroupDetails imageGroupDetails)
        {
            List<Hydra.Entities.Image> images = null;
            List<Hydra.Entities.Blob> blobs = null;

            JavaScriptSerializer serializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };

            var imageFiles = ctx.Images.Where(x => ((x.GroupUid == imageGroupDetails.GroupUid) &&
                                                            x.IsProcessed &&
                                                            (x.IsSucceeded.HasValue ? x.IsSucceeded.Value : false) &&
                                                            (x.IsDicom.HasValue ? !x.IsDicom.Value : true)))
                                       .ToList();
            foreach (var imageFile in imageFiles)
            {
                if (string.IsNullOrEmpty(imageFile.ImageXml))
                    continue;

                bool isTiff = false;
                if (imageFile.ImageType == Hydra.Common.ImageType.Tiff)
                {
                    imageFile.ImageType = Hydra.Common.ImageType.Jpeg; //VAI-307 Tiff are displayed as JPEG
                    isTiff = true;
                }
                // ignore dicom PR
                if (imageFile.ImageType == Hydra.Common.ImageType.RadPR)
                    continue;

                if (imageFile.ImageType.IsBlob())
                {
                    var blob = serializer.Deserialize<Hydra.Entities.Blob>(imageFile.ImageXml);

                    if (blobs == null)
                        blobs = new List<Entities.Blob>();

                    blob.Tags = TagUtil.GetTags(ctx, imageFile);
                    blob.RefImageUid = imageFile.RefImageUid;
                    blob.CacheLocator = string.Format("{0};{1}", imageFile.ImageType, imageFile.RelativePath);
                    blobs.Add(blob);
                }
                else
                {
                    var image = serializer.Deserialize<Hydra.Entities.Image>(imageFile.ImageXml);

                    if (images == null)
                        images = new List<Entities.Image>();

                    image.Tags = TagUtil.GetTags(ctx, imageFile);
                    image.RefImageUid = imageFile.RefImageUid;
                    if (isTiff) //VAI-307 Tiff are saved as JPEG, with Tiff type 
                        image.CacheLocator = string.Format("{0};{1}", Hydra.Common.ImageType.Tiff, imageFile.RelativePath);
                    else
                        image.CacheLocator = string.Format("{0};{1}", imageFile.ImageType, imageFile.RelativePath);

                    images.Add(image);
                }
            }

            imageGroupDetails.Images = images;
            imageGroupDetails.Blobs = blobs;
        }

        private static void FillDicomStudies(IHixDbContext ctx, ImageGroupDetails imageGroupDetails)
        {
            List<Hydra.Entities.Study> studies = null;

            // get all processed images belonging to the image group , group by study
            var studyImageGroups = ctx.Images.Where(x => ((x.GroupUid == imageGroupDetails.GroupUid) &&
                                                            x.IsProcessed &&
                                                            (x.IsSucceeded.HasValue ? x.IsSucceeded.Value : false) &&
                                                            (x.IsDicom.HasValue ? x.IsDicom.Value : false)))
                                        .GroupBy(y => y.StudyInstanceUid)
                                        .Select(z => z.ToList())
                                        .ToList();

            JavaScriptSerializer serializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
            foreach (var studyImageGroup in studyImageGroups)
            {
                // get study
                var studyInstanceUid = studyImageGroup[0].StudyInstanceUid;
                var studyRecord = ctx.StudyRecords.Where(x => (x.GroupUid == imageGroupDetails.GroupUid) &&
                                                                    (x.StudyInstanceUid == studyInstanceUid))
                                                  .FirstOrDefault();
                if (studyRecord == null)
                    continue;

                var study = HipaaUtil.Decrypt<Entities.Study>(studyRecord.StudyXml);
                study.Series = new List<Entities.Series>();

                // group by series
                var seriesImageGroups = studyImageGroup.GroupBy(x => x.SeriesInstanceUid)
                                                        .Select(x => x.ToList())
                                                        .ToList();
                foreach (var seriesImageGroup in seriesImageGroups)
                {
                    var seriesInstanceUid = seriesImageGroup[0].SeriesInstanceUid;
                    var seriesRecord = ctx.SeriesRecords.Where(x => (x.GroupUid == imageGroupDetails.GroupUid) &&
                                                                        (x.SeriesInstanceUid == seriesInstanceUid))
                                                        .FirstOrDefault();
                    if (seriesRecord == null)
                        continue;

                    var series = serializer.Deserialize<Hydra.Entities.Series>(seriesRecord.SeriesXml);
                    series.Images = new List<Entities.Image>();

                    int imageIndex = 0;
                    foreach (var imageFile in seriesImageGroup)
                    {
                        // ignore dicom PR
                        if (imageFile.ImageType == Hydra.Common.ImageType.RadPR)
                            continue;

                        var image = serializer.Deserialize<Hydra.Entities.Image>(imageFile.ImageXml);
                        image.Index = imageIndex++;

                        image.Tags = TagUtil.GetTags(ctx, imageFile);
                        image.RefImageUid = imageFile.RefImageUid;
                        image.CacheLocator = string.Format("{0};{1}", imageFile.ImageType, imageFile.RelativePath);
                        
                        series.Images.Add(image);
                    }

                    // order images by instanceNumber
                    series.Images.Sort((x, y) => x.InstanceNumber.CompareTo(y.InstanceNumber));
                    series.ImageCount = series.Images.Count();
                    study.Series.Add(series);
                }

                // sort series
                study.Series.Sort((x, y) => x.SeriesNumber.CompareTo(y.SeriesNumber));
                study.SeriesCount = study.Series.Count();

                if (studies == null)
                    studies = new List<Entities.Study>();
                studies.Add(study);
            }

            if (studies != null)
            {
                if (imageGroupDetails.Studies == null)
                    imageGroupDetails.Studies = new List<Entities.Study>();
                imageGroupDetails.Studies.AddRange(studies);
            }
        }


    }
}
