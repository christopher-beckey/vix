using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ClearCanvas.Dicom;
using ClearCanvas.Dicom.Utilities;
using Hydra.Entities;

namespace Hydra.Dicom
{
    static class MeasurementReader
    {
        private static readonly IList<string> _crossSectionalSopClasses = new List<string>
		                                                                  	{
		                                                                  		// classic cross sectional modalities and their multiframe versions
		                                                                  		SopClass.CtImageStorageUid,
		                                                                  		SopClass.EnhancedCtImageStorageUid,
		                                                                  		SopClass.MrImageStorageUid,
		                                                                  		SopClass.EnhancedMrImageStorageUid,
		                                                                  		SopClass.PositronEmissionTomographyImageStorageUid,
		                                                                  		SopClass.EnhancedPetImageStorageUid,
		                                                                  		SopClass.NuclearMedicineImageStorageUid,
		                                                                  		// for 3D X-Ray types, Imager Pixel Spacing applies to the acquisition sources, but not the reconstruction
		                                                                  		SopClass.BreastTomosynthesisImageStorageUid,
		                                                                  		SopClass.XRay3dAngiographicImageStorageUid,
		                                                                  		SopClass.XRay3dCraniofacialImageStorageUid
		                                                                  	}.AsReadOnly();

        public static ClearCanvas.Dicom.Iod.PixelSpacing FromString(string multiValuedString)
        {
            if (string.IsNullOrEmpty(multiValuedString)) return null;

            double[] values;
            return DicomStringHelper.TryGetDoubleArray(multiValuedString, out values) && values.Length == 2 ? new ClearCanvas.Dicom.Iod.PixelSpacing(values[0], values[1]) : null;
        }

        private static Hydra.Entities.PixelSpacing GetPixelSpacing(DicomAttributeCollection dataset)
        {
            // since DICOM 2006, projection image SOP classes are now allowed to use both Pixel Spacing and Imager Pixel Spacing
            // (there are some particulars about what is required and optional based on SOP class, but that's what it boils down to)
            // * Imager Pixel Spacing (0018,1164) *ALWAYS* refers to the spacing at the detector plane
            // * Pixel Spacing (0028,0030) may refer to a number of different spacing values:
            //   1. spacing at the detector plane (due to past ubiquitous misuse of this attribute)
            //   2. spacing calibrated against an assumed geometry or fiducials of known size (with details provided in other attributes)
            // since both of these attributes may or may not be present, we now select values by applying logic suggested by David Clunie
            // for more details, please refer to ticket #9031

            var pixelSpacing = ClearCanvas.Dicom.Iod.PixelSpacing.FromString(dataset[DicomTags.PixelSpacing].ToString()) ?? new ClearCanvas.Dicom.Iod.PixelSpacing(0, 0);
            var imagerPixelSpacing = ClearCanvas.Dicom.Iod.PixelSpacing.FromString(dataset[DicomTags.ImagerPixelSpacing].ToString()) ?? new ClearCanvas.Dicom.Iod.PixelSpacing(0, 0);

            if (IsCrossSectionalModality(dataset))
            {
                // cross-sectional images use Pixel Spacing (0028,0030)
                if (!pixelSpacing.IsNull)
                {
                    return new Hydra.Entities.PixelSpacing
                    {
                        Row = pixelSpacing.Row,
                        Column = pixelSpacing.Column,
                        CalibrationType = Hydra.Entities.PixelSpacing.PixelSpacingCalibrationType.CrossSectionalSpacing
                    };
                }
            }
            else
            {
                // get modality
                string modality = dataset[DicomTags.Modality].GetString(0, string.Empty);
                if (modality == "US")
                {

                }

                // other modalities
                if (pixelSpacing.IsNull || pixelSpacing.Equals(imagerPixelSpacing))
                {
                    // projection images using Imager Pixel Spacing (0018,1164) alone or with same value in Pixel Spacing (0028,0030)
                    return new Hydra.Entities.PixelSpacing
                    {
                        Row = imagerPixelSpacing.Row,
                        Column = imagerPixelSpacing.Column,
                        CalibrationType = Hydra.Entities.PixelSpacing.PixelSpacingCalibrationType.Detector
                    };
                }
                else
                {
                    // projection images using a calibrated value in Pixel Spacing (0028,0030)
                    if (!pixelSpacing.IsNull)
                    {
                        return new Hydra.Entities.PixelSpacing
                        {
                            Row = pixelSpacing.Row,
                            Column = pixelSpacing.Column,
                            CalibrationType = Hydra.Entities.PixelSpacing.PixelSpacingCalibrationType.CrossSectionalSpacing
                        };
                    }
                }
            }

            return null;
        }

        private static bool IsCrossSectionalModality(DicomAttributeCollection dataSet)
        {
            // get modality
            string modality = dataSet[DicomTags.Modality].GetString(0, string.Empty);

            // Imager Pixel Spacing definitely does not apply to these modalities
            switch (modality)
            {
                case "CT":
                case "MR":
                case "PT":
                case "NM":
                    return true;
            }

            // get sop class uid
            string sopClassUid = dataSet[DicomTags.SopClassUid].GetString(0, string.Empty);

            // for safety reasons, we assume everything else might be projectional
            return _crossSectionalSopClasses.Contains(sopClassUid);
        }

        public static Measurement Read(DicomAttributeCollection dataset, int imageWidth, int imageHeight)
        {
            var pixelSpacing = ClearCanvas.Dicom.Iod.PixelSpacing.FromString(dataset[DicomTags.PixelSpacing].ToString()) ?? new ClearCanvas.Dicom.Iod.PixelSpacing(0, 0);
            var imagerPixelSpacing = ClearCanvas.Dicom.Iod.PixelSpacing.FromString(dataset[DicomTags.ImagerPixelSpacing].ToString()) ?? new ClearCanvas.Dicom.Iod.PixelSpacing(0, 0);

            if (IsCrossSectionalModality(dataset))
            {
                // cross-sectional images use Pixel Spacing (0028,0030)
                if (!pixelSpacing.IsNull)
                {
                    return new Measurement
                    {
                        PixelSpacing = new Hydra.Entities.PixelSpacing
                        {
                            Row = pixelSpacing.Row,
                            Column = pixelSpacing.Column,
                            CalibrationType = Hydra.Entities.PixelSpacing.PixelSpacingCalibrationType.CrossSectionalSpacing
                        },
                    };
                }
            }
            else
            {
                // get modality
                string modality = dataset[DicomTags.Modality].GetString(0, string.Empty);
                if (modality == "US")
                {
                    return CreateUSMeasurementRegions(dataset);
                }

                // other modalities
                if (pixelSpacing.IsNull || pixelSpacing.Equals(imagerPixelSpacing))
                {
                    // projection images using Imager Pixel Spacing (0018,1164) alone or with same value in Pixel Spacing (0028,0030)
                    return new Measurement
                    {
                        PixelSpacing = new Hydra.Entities.PixelSpacing
                        {
                            Row = imagerPixelSpacing.Row,
                            Column = imagerPixelSpacing.Column,
                            CalibrationType = Hydra.Entities.PixelSpacing.PixelSpacingCalibrationType.Detector
                        },
                    };
                }
                else
                {
                    // projection images using a calibrated value in Pixel Spacing (0028,0030)
                    if (!pixelSpacing.IsNull)
                    {
                        return new Measurement
                        {
                            PixelSpacing = new Hydra.Entities.PixelSpacing
                            {
                                Row = pixelSpacing.Row,
                                Column = pixelSpacing.Column,
                                CalibrationType = Hydra.Entities.PixelSpacing.PixelSpacingCalibrationType.CrossSectionalSpacing
                            },
                        };
                    }
                }
            }

            return null;
        }

        private static Measurement CreateMeasurementRegion(ClearCanvas.Dicom.Iod.PixelSpacing pixelSpacing,
                                                           Hydra.Entities.PixelSpacing.PixelSpacingCalibrationType calibrationType)
        {
            return new Measurement
            {
                PixelSpacing = new Hydra.Entities.PixelSpacing
                {
                    Row = pixelSpacing.Row,
                    Column = pixelSpacing.Column,
                    CalibrationType = Hydra.Entities.PixelSpacing.PixelSpacingCalibrationType.CrossSectionalSpacing
                },
            };
        }

        private static Measurement CreateUSMeasurementRegions(DicomAttributeCollection dataset)
        {
            Measurement measurement = null;

            if (dataset.Contains(DicomTags.SequenceOfUltrasoundRegions))
            {
                DicomAttributeSQ sq = dataset[DicomTags.SequenceOfUltrasoundRegions] as DicomAttributeSQ;
                foreach (DicomSequenceItem item in sq.Values as DicomSequenceItem[])
                {
                    int regionSpatialFormat = 0;
                    item[DicomTags.RegionSpatialFormat].TryGetInt32(0, out regionSpatialFormat);

                    int regionDataType = 0;
                    item[DicomTags.RegionDataType].TryGetInt32(0, out regionDataType);

                    int regionFlags = 0;
                    item[DicomTags.RegionFlags].TryGetInt32(0, out regionFlags);

                    int regionLocationMinX0 = 0;
                    item[DicomTags.RegionLocationMinX0].TryGetInt32(0, out regionLocationMinX0);

                    int regionLocationMinY0 = 0;
                    item[DicomTags.RegionLocationMinY0].TryGetInt32(0, out regionLocationMinY0);

                    int regionLocationMaxX1 = 0;
                    item[DicomTags.RegionLocationMaxX1].TryGetInt32(0, out regionLocationMaxX1);

                    int regionLocationMaxY1 = 0;
                    item[DicomTags.RegionLocationMaxY1].TryGetInt32(0, out regionLocationMaxY1);

                    int referencePixelX0 = 0;
                    bool isReferencePixelX0Present = item[DicomTags.ReferencePixelX0].TryGetInt32(0, out referencePixelX0);

                    int referencePixelY0 = 0;
                    bool isReferencePixelY0Present = item[DicomTags.ReferencePixelY0].TryGetInt32(0, out referencePixelY0);

                    int physicalUnitsXDirection = 0;
                    item[DicomTags.PhysicalUnitsXDirection].TryGetInt32(0, out physicalUnitsXDirection);

                    int physicalUnitsYDirection = 0;
                    item[DicomTags.PhysicalUnitsYDirection].TryGetInt32(0, out physicalUnitsYDirection);

                    float referencePixelPhysicalValueX = 0;
                    item[DicomTags.ReferencePixelPhysicalValueX].TryGetFloat32(0, out referencePixelPhysicalValueX);

                    float referencePixelPhysicalValueY = 0;
                    item[DicomTags.ReferencePixelPhysicalValueY].TryGetFloat32(0, out referencePixelPhysicalValueY);

                    float physicalDeltaX = 0;
                    item[DicomTags.PhysicalDeltaX].TryGetFloat32(0, out physicalDeltaX);

                    float physicalDeltaY = 0;
                    item[DicomTags.PhysicalDeltaY].TryGetFloat32(0, out physicalDeltaY);

                    float dopplerCorrectionAngle = 0;
                    item[DicomTags.DopplerCorrectionAngle].TryGetFloat32(0, out dopplerCorrectionAngle);

                    Hydra.Entities.PixelSpacing pixelSpacing = null;
                    if ((physicalUnitsXDirection == 3) && (physicalUnitsYDirection == 3) && (regionSpatialFormat == 1)) 
                    {
                        // We want only cm, for 2D images
                        if ((physicalDeltaX > 0) && (physicalDeltaY > 0))
                        {
                            pixelSpacing = new Hydra.Entities.PixelSpacing();

                            pixelSpacing.Column = physicalDeltaX * 10.0;	// These are in cm !
                            pixelSpacing.Row = physicalDeltaY * 10.0;
                        }
                    }

                    USRegion region = new USRegion
                    {
                        PixelSpacing = pixelSpacing,
                        RegionSpatialFormat = regionSpatialFormat,
                        RegionDataType = regionDataType,
                        RegionFlags = regionFlags,
                        RegionLocationMinX0 = regionLocationMinX0,
                        RegionLocationMinY0 = regionLocationMinY0,
                        RegionLocationMaxX1 = regionLocationMaxX1,
                        RegionLocationMaxY1 = regionLocationMaxY1,
                        ReferencePixelX0 = referencePixelX0,
                        ReferencePixelY0 = referencePixelY0,
                        IsReferencePixelX0Present = isReferencePixelX0Present,
                        IsReferencePixelY0Present = isReferencePixelY0Present,
                        PhysicalUnitsXDirection = physicalUnitsXDirection,
                        PhysicalUnitsYDirection = physicalUnitsYDirection,
                        ReferencePixelPhysicalValueX = referencePixelPhysicalValueX,
                        ReferencePixelPhysicalValueY = referencePixelPhysicalValueY,
                        PhysicalDeltaX = physicalDeltaX,
                        PhysicalDeltaY = physicalDeltaY,
                        DopplerCorrectionAngle = dopplerCorrectionAngle
                    };

                    if (measurement == null)
                    {
                        measurement = new Measurement
                        {
                            UsRegions = new List<USRegion>()
                        };
                    }

                    measurement.UsRegions.Add(region);
                }
            }

            return measurement;
        }

    }
}
