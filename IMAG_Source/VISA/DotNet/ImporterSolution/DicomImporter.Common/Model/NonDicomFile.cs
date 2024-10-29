/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 05/21/2013
 * Site Name:  Washington OI Field Office, Columbia, MD
 * Developer:  Lenard Williams
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */

namespace DicomImporter.Common.Model
{
    using System;
    using System.IO;
    using System.Xml.Serialization;

    /// <summary>
    /// Contains a references to a Non-Dicom File.
    /// </summary>
    [Serializable]
    public class NonDicomFile
    {
        #region Constants and Fields

        /// <summary>
        /// The file
        /// </summary>
        private FileInfo file;
        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="NonDicomFile" /> class.
        /// </summary>
        public NonDicomFile()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="NonDicomFile" /> class.
        /// </summary>
        /// <param name="filePath">The file path.</param>
        public NonDicomFile(string filePath) : this(filePath, null) {}

        /// <summary>
        /// Initializes a new instance of the <see cref="NonDicomFile" /> class.
        /// </summary>
        /// <param name="filePath">The file path.</param>
        /// <param name="originalFileName">Name of the original file.</param>
        public NonDicomFile(string filePath, string originalFileName)
        {
            file = new FileInfo(filePath);

            this.FilePath = filePath;

            if (String.IsNullOrEmpty(originalFileName))
            {
                this.OriginalFileName = file.Name;
            }
            else
            {
                this.OriginalFileName = originalFileName;
            }

            // Set the size of the file
            Size = Convert.ToString(file.Length / 1024);
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the file path.
        /// </summary>
        public string FilePath 
        {
            get
            {
                return this.file.FullName;
            }

            set
            {
                file = new FileInfo(value);
                Name = file.Name;
            }
        }

        /// <summary>
        /// Gets or sets the name.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the name of the original file.
        /// </summary>
        public string OriginalFileName { get; set; }

        /// <summary>
        /// Gets the size.
        /// </summary>
        public string Size { get; set; }

        /// <summary>
        /// Gets or sets the import error message.
        /// </summary>
        /// <value>
        /// The import error message.
        /// </value>
        public string ImportErrorMessage { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether IsImportedSuccessfully.
        /// </summary>
        public bool IsImportedSuccessfully { get; set; }

        #endregion

        #region Private Methods

        /// <summary>
        /// Gets the name from path.
        /// </summary>
        /// <param name="filePath">The file path.</param>
        /// <returns>The name of the file.</returns>
        private string GetNameFromPath(string filePath)
        {
            string[] splitPath = filePath.Split('\\');

            // in case the file path is constructed with /'s
            if (splitPath.Length == 0)
            {
                splitPath = filePath.Split('/');
            }

            if (splitPath.Length == 0)
            {
                return String.Empty;
            }

            return splitPath[splitPath.Length - 1];
        }

        #endregion
    }
}
