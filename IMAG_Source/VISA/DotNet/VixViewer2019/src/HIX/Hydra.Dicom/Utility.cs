using ClearCanvas.Dicom;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class Utility
    {
        public static bool IsPdf(DicomFile file)
        {
            return (file.SopClass == SopClass.EncapsulatedPdfStorage);
        }

        public static bool IsECG(DicomFile file)
        {
            if ((file.SopClass == SopClass.WaveformStorageTrialRetired) ||
                (file.SopClass == SopClass.HemodynamicWaveformStorage) ||
                (file.SopClass == SopClass.Sop12LeadEcgWaveformStorage) ||
                (file.SopClass == SopClass.GeneralEcgWaveformStorage))
                return (file.DataSet[DicomTags.Modality].ToString() == "ECG");

            return false;
        }

        public static bool IsSR(DicomFile file)
        {
            return (file.DataSet[DicomTags.Modality].ToString() == "SR");

            //return ((file.SopClass == SopClass.BasicTextSrStorage) ||
            //        (file.SopClass == SopClass.ComprehensiveSrStorage));
        }

        public static bool IsPR(DicomFile file)
        {
            return (file.SopClass == SopClass.GrayscaleSoftcopyPresentationStateStorageSopClass);
        }

        public static string GetGeneralImageType()
        {
            return "jpeg";
        }

        public static string GetImageType(string sopClass, string modality, int numberOfFrames)
        {
            if ((modality == "US") && (numberOfFrames > 1))
                return "radecho";

            if (sopClass == ClearCanvas.Dicom.SopClass.EncapsulatedPdfStorageUid)
                return "radpdf";

            if ((sopClass == ClearCanvas.Dicom.SopClass.BasicTextSrStorageUid) ||
                (sopClass == ClearCanvas.Dicom.SopClass.ComprehensiveSrStorageUid) ||
                (sopClass == ClearCanvas.Dicom.SopClass.EnhancedSrStorageUid) ||
                (sopClass == ClearCanvas.Dicom.SopClass.MammographyCadSrStorageUid) ||
                (sopClass == ClearCanvas.Dicom.SopClass.ChestCadSrStorageUid) ||
                (sopClass == ClearCanvas.Dicom.SopClass.XRayRadiationDoseSrStorageUid))
                return "radsr";

            if ((modality == "ECG") &&
                ((sopClass == ClearCanvas.Dicom.SopClass.WaveformStorageTrialRetiredUid) ||
                 (sopClass == ClearCanvas.Dicom.SopClass.HemodynamicWaveformStorageUid) ||
                 (sopClass == ClearCanvas.Dicom.SopClass.Sop12LeadEcgWaveformStorageUid) ||
                 (sopClass == ClearCanvas.Dicom.SopClass.GeneralEcgWaveformStorageUid)))
                return "radecg";

            if (sopClass == null && modality == null && numberOfFrames == 1)
                return GetGeneralImageType();

            return "rad";
        }

        public static void WaitForFileAccess(string filePath, int timeoutMilliseconds)
        {
            var started = DateTime.UtcNow;
            while ((DateTime.UtcNow - started).TotalMilliseconds < timeoutMilliseconds)
            {
                try
                {
                    // Attempt to open the file exclusively.
                    using (FileStream fs = new FileStream(filePath, FileMode.Open, FileAccess.ReadWrite, FileShare.None, 100))
                    {
                        fs.ReadByte();
                        break; // file is ready
                    }
                }
                catch (Exception)
                {
                    System.Threading.Thread.Sleep(500);
                }
            }

            System.Threading.Thread.Sleep(500);
        }
    }
}
