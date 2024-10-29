using Hydra.Security;
using System;
using System.IO;

namespace SCIP_Tool
{
    /// <summary>
    /// Provides utilities across the board for the SCIP_Tool
    /// </summary>
    public class Common
    {
        /// <summary>
        /// Decrypt a given string based on the way the Java source code does it.
        /// </summary>
        /// <param name="givenString">The Java string.</param>
        /// <returns></returns>
        public static string DecryptJavaString(string givenString)
        {
            string realBase64String = SecurityUtil.DecodeEncodedBase64(givenString);
            string result = "";
            try
            {
                //fullName||duz||ssn||siteName||siteNumber||brokerSecurityToken||accessCode||verifyCode||securityTokenApplicationName
                //IMAGPROVIDERONETWOSIX,ONETWOSIX||126||843924956||CVIX||2001||VISTA IMAGING VIX^XUSBSE472-40750_2^200^9300||||
                string fields = SecurityUtil.FromVixJava("decrypt", realBase64String, out string errorMessage); //VAI-903
                if (string.IsNullOrWhiteSpace(fields))
                {
                    result = errorMessage;
                }
                else
                {
                    result = fields;
                }
            }
            catch (Exception ex)
            {
                result = ex.ToString();
            }
            return result;
        }

        //TOD - Fix this up with detection from file contents instead of name
        /// <summary>
        /// Get the approved file type.
        /// </summary>
        /// <param name="fileName">the name of the file</param>
        /// <returns>The Hydra.Common.FileType if known, or Hydra.Common.FileType.Unknown if not known</returns>
        /// <remarks>The real production code detects the file type by the URN (see VixServiceUtil.DetectFileType), but we do not have that for this test.
        /// Example imageURN=urn:vaimage:660-8504-8503-1006167324V385420&imageQuality=90&contentType=application/dicom&contentTypeWithSubType=application/dicom</remarks>
        public static Hydra.Common.FileType GetFileType(string fileName)
        {
            if (fileName.Substring(fileName.Length - 3) == "org") return RtfOrTxt(fileName); //if we copy the .org that is RTF or TXT, we can test it here
            if (fileName.Substring(fileName.Length - 3) == "dcm") return Hydra.Common.FileType.Dicom;
            if (fileName.Substring(fileName.Length - 5) == "dicom") return Hydra.Common.FileType.Dicom;
            if (fileName.Substring(fileName.Length - 3) == "doc") return Hydra.Common.FileType.Document_Word;
            if (fileName.Substring(fileName.Length - 5) == "mpeg3") return Hydra.Common.FileType.Video_Avi;
            if (fileName.Substring(fileName.Length - 3) == "pdf") return Hydra.Common.FileType.Document_Pdf;
            //TODO: PNG?
            if (fileName.Substring(fileName.Length - 3) == "rtf") return Hydra.Common.FileType.RTF;
            if (fileName.Substring(fileName.Length - 3) == "wav") return Hydra.Common.FileType.Audio_Wav;
            if (fileName.Substring(fileName.Length - 1) == "x") return Hydra.Common.FileType.TXT;
            if (fileName.Substring(fileName.Length - 3) == "xml") return Hydra.Common.FileType.Document_CDA;
            if (fileName.Substring(fileName.Length - 3) == "mp3") return Hydra.Common.FileType.Audio_Mp3;
            if (fileName.Substring(fileName.Length - 3) == "*****TODO*****") return Hydra.Common.FileType.Blob;
            if (fileName.Substring(fileName.Length - 3) == "mp4") return Hydra.Common.FileType.Video_Mp4;

            if ((fileName.Substring(fileName.Length - 4) == "tiff") ||
                (fileName.Substring(fileName.Length - 3) == "tif") ||
                (fileName.Substring(fileName.Length - 4) == "j2k") ||
                (fileName.Substring(fileName.Length - 4) == "jpeg") ||
                (fileName.Substring(fileName.Length - 4) == "bmp")) return Hydra.Common.FileType.Image;

            return Hydra.Common.FileType.Unknown;
        }

        private static Hydra.Common.FileType RtfOrTxt(string fileName)
        {
            using (StreamReader readTxt = new StreamReader(fileName))
            {
                string myLine = readTxt.ReadLine();
                if (myLine.StartsWith("{\rtf1"))
                    return Hydra.Common.FileType.RTF;
                return Hydra.Common.FileType.TXT;
            }
        }
    }
}
