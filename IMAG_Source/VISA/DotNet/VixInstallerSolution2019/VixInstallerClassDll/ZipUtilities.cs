using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using log4net;
using System.Diagnostics;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public static class ZipUtilities
    {
        public enum Overwrite
        {
            Always,
            IfNewer,
            Never
        }
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(ZipUtilities).Name);
        }

        // Number of files within zip archive
        public static int ZipFileCount(string zipFileName)
        {
            using (ZipArchive archive = System.IO.Compression.ZipFile.Open(zipFileName, ZipArchiveMode.Read))
            {
                int count = 0;

                // We count only named (i.e. that are with files) entries
                foreach (var entry in archive.Entries)
                    if (!String.IsNullOrEmpty(entry.Name))
                        count += 1;

                return count;
            }
        }

        /// <summary>
        /// Verify a zip file only contains the files specified in filelist. This method is
        /// currently case sensistive on filename. Beware.
        /// </summary>
        /// <param name="zipFileSpec">The zip file to check.</param>
        /// <param name="filelist">A dictionay containing a list of allowed files</param>
        /// <returns>true if only allowed files are in the zip, false otherwise</returns>
        public static bool VerifyZipContents(string zipFileSpec, string[] allowedFilesArray)
        {
            Debug.Assert(zipFileSpec != null);
            Debug.Assert(zipFileSpec.Length != 0);
            Debug.Assert(allowedFilesArray != null);

            Dictionary<String, String> allowedFiles = new Dictionary<string, string>();

            for (int i = 0; i < allowedFilesArray.Length; i++)
            {
                string s = allowedFilesArray[i].ToUpper();
                allowedFiles.Add(s, s);
            }

            try
            {
                //Opens the zip file up to be read
                using (ZipArchive archive = System.IO.Compression.ZipFile.OpenRead(zipFileSpec))
                {
                    //Loops through each file in the zip file
                    foreach (ZipArchiveEntry file in archive.Entries)
                    {
                        //ZipArchiveEntry propertyExternalAttributes is low order byte,
                        //cast it as FileAttributes and check the attributes if it is a "Directory" or not.
                        var lowerByte = (byte)(file.ExternalAttributes & 0x00FF);
                        var attributes = (FileAttributes)lowerByte;

                        if (attributes.HasFlag(FileAttributes.Directory))
                            continue; //ignore directories

                        string fname = file.FullName.ToUpper();
                        if (!allowedFiles.ContainsKey(fname))
                        {
                            return false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new ApplicationException("Unable to access: " + zipFileSpec + "\nIt might be password protected.", ex);
            }

            return true;
        }

        public static void CreateNewZipFile(string rootDirspecToZip, string zipFilespec)
        {
            System.IO.Compression.ZipFile.CreateFromDirectory(rootDirspecToZip, zipFilespec);
        }

        /// <summary>
        /// Unzips the specified file to the given folder in a safe
        /// manner.  This plans for missing paths and existing files
        /// and handles them gracefully.
        /// </summary>
        /// <param name="sourceArchiveFileName">
        /// The name of the zip file to be extracted
        /// </param>
        /// <param name="destinationDirectoryName">
        /// The directory to extract the zip file to
        /// </param>
        /// <param name="overwriteMethod">
        /// Specifies how we are going to handle an existing file.
        /// The default is Always.
        /// </param>
        public static void ImprovedExtractToDirectory(string sourceArchiveFileName,
                                                      string destinationDirectoryName,
                                                      Overwrite overwriteMethod = Overwrite.Always)
        {
            //Opens the zip file up to be read
            using (ZipArchive archive = System.IO.Compression.ZipFile.OpenRead(sourceArchiveFileName))
            {
                //Loops through each file in the zip file
                foreach (ZipArchiveEntry file in archive.Entries)
                {
                    //ZipArchiveEntry propertyExternalAttributes is low order byte,
                    //cast it as FileAttributes and check the attributes if it is a "Directory" or not.
                    var lowerByte = (byte)(file.ExternalAttributes & 0x00FF);
                    var attributes = (FileAttributes)lowerByte;

                    if (attributes.HasFlag(FileAttributes.Directory))
                        continue; //ignore directories

                    ImprovedExtractToFile(file, destinationDirectoryName, overwriteMethod);
                }
            }
        }

        /// <summary>
        /// Safely extracts a single file from a zip file
        /// </summary>
        /// <param name="file">
        /// The zip entry we are pulling the file from
        /// </param>
        /// <param name="destinationPath">
        /// The root of where the file is going
        /// </param>
        /// <param name="overwriteMethod">
        /// Specifies how we are going to handle an existing file.
        /// The default is Overwrite.Always.
        /// </param>
        public static void ImprovedExtractToFile(ZipArchiveEntry file,
                                                 string destinationPath,
                                                 Overwrite overwriteMethod = Overwrite.Always)
        {
            //Gets the complete path for the destination file, including any
            //relative paths that were in the zip file
            string destinationFileName = System.IO.Path.Combine(destinationPath, file.FullName);

            //Gets just the new path, minus the file name so we can create the
            //directory if it does not exist
            string destinationFilePath = System.IO.Path.GetDirectoryName(destinationFileName);

            //Creates the directory (if it doesn't exist) for the new path
            Directory.CreateDirectory(destinationFilePath);

            //Determines what to do with the file based upon the
            //method of overwriting chosen
            switch (overwriteMethod)
            {
                case Overwrite.Always:
                    //Just put the file in and overwrite anything that is found
                    file.ExtractToFile(destinationFileName, true);
                    break;
                case Overwrite.IfNewer:
                    //Checks to see if the file exists, and if so, if it should
                    //be overwritten
                    if (!File.Exists(destinationFileName) || File.GetLastWriteTime(destinationFileName) < file.LastWriteTime)
                    {
                        //Either the file didn't exist or this file is newer, so
                        //we will extract it and overwrite any existing file
                        file.ExtractToFile(destinationFileName, true);
                    }
                    break;
                case Overwrite.Never:
                    //Put the file in if it is new but ignores the 
                    //file if it already exists
                    if (!File.Exists(destinationFileName))
                    {
                        file.ExtractToFile(destinationFileName);
                    }
                    break;
                default:
                    break;
            }
        }
    }
}
