/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
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
namespace ImagingClient.Infrastructure.Utilities
{
    using System;
    using System.IO;

    /// <summary>
    /// Converts a file's contents to a base 64 string
    /// </summary>
    public class BinaryFileToBase64StringConverter
    {
        #region Public Methods

        /// <summary>
        /// Converts the file contents to a base 64 string.
        /// </summary>
        /// <param name="filePath">
        /// The file path.
        /// </param>
        /// <returns>
        /// The base64 representation of the file
        /// </returns>
        public static string ConvertFile(string filePath)
        {
            // Prepare a place holder for our image file
            byte[] imageBytes;

            // Read the content of image file and store each byte in the 
            // imagesBytes.
            var fs = new FileStream(filePath, FileMode.Open, FileAccess.Read);
            var reader = new BinaryReader(fs);

            try
            {
                long size = reader.BaseStream.Length;
                imageBytes = new byte[size];
                for (long i = 0; i < size; i++)
                {
                    imageBytes[i] = reader.ReadByte();
                }
            }
            finally
            {
                reader.Close();
                fs.Close();
            }

            // Convert the images bytes into its equivalent string representation
            // encoded with base 64 digit.
            return Convert.ToBase64String(imageBytes);
        }

        #endregion
    }
}