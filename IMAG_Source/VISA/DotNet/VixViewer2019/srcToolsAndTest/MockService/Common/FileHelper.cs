using System;
using System.IO;

using GLOB = MockService.Common.Globals;

namespace MockService.Common
{
    public class FileHelper
    {
        /// <summary>
        /// Copy a source file to a destination file
        /// </summary>
        /// <param name="sourceFile">The source file path</param>
        /// <param name="destFile">The destination file path</param>
        /// <param name="msg">An error message on failure</param>
        /// <returns>True on success, false on failure and sets msg</returns>
        public static bool CopyFile(string sourceFile, string destFile, out string msg)
        {
            msg = "";
            try
            {
                if (!System.IO.File.Exists(sourceFile))
                {
                    msg = $"Source file not found {sourceFile}";
                    return (false);
                }
                System.IO.File.Copy(sourceFile, destFile, true);
            }
            catch (Exception ex)
            {
                msg = ex.ToString();
                return false;
            }
            return true;
        }

        /// <summary>
        /// Copy the ImagesToImport files to the VixCache folder for the hard-coded study
        /// </summary>
        /// <param name="msg">An error message on failure</param>
        /// <returns>True on success, false on failure and sets msg</returns>
        public static bool CopyImageFolders(out string msg)
        {
            msg = "";
            var dir = new DirectoryInfo(GLOB.imageUploadFolder);
            try
            {
                if (!Directory.Exists(GLOB.defaultImageCacheFolder)) Directory.CreateDirectory(GLOB.defaultImageCacheFolder);
                foreach (FileInfo file in dir.GetFiles())
                {
                    string targetFilePath = Path.Combine(GLOB.defaultImageCacheFolder, file.Name);
                    file.CopyTo(targetFilePath, true);
                }
            }
            catch (Exception ex)
            {
                msg = $"Error in folder copy. Please confirm your configuration. {ex.ToString()}";
                return false;
            }
            return true;
        }
    }
}