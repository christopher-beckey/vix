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
    using System.Security.Cryptography;
    using System.Text;
   using System.Text.RegularExpressions;

   /// <summary>
   /// The string utilities.
   /// </summary>
   public class StringUtilities
    {
      /// <summary>
      /// Gary Pham(oitlonphamg) (based on secondary code review meeting)
      /// P332
      /// Encapsulate regex parameter in a utility class.
      /// Validate the filepath.
      /// </summary>
      public static string RegexFilePath
      {
         get
         {
            return "^[A-Za-z0-9 _.,\\\\!'/$;:%-]+$";
         }
      }

      /// <summary>
      /// Gary Pham(oitlonphamg) (based on secondary code review meeting)
      /// P332
      /// Encapsulate regex parameter in a utility class.
      /// Validate the log.
      /// </summary>
      public static string RegexLog
      {
         get
         {
            return "^[A-Za-z0-9 _.,!\"'/$;@:%]+$";
         }
      }

      /// <summary>
      /// Gary Pham(oitlonphamg) (based on secondary code review meeting)
      /// P332
      /// Encapsulate regex parameter in a utility class.
      /// Validate the filepath filter.
      /// </summary>
      public static string RegexFilePathFilter
      {
         get
         {
            return "^[A-Za-z0-9 _.,\\\\!'/$;:%-*]+$";
         }
      }

      #region Public Methods

      /// <summary>
      /// Converts the name of the dicom.
      /// </summary>
      /// <param name="dicomName">Name of the dicom.</param>
      /// <returns>The converted name</returns>
      public static string ConvertDicomName(string dicomName)
     {
         if (dicomName != null && dicomName.Contains("^"))
         {
             // It is a DICOM-Formatted name.
             // Convert to remove carats
             string[] nameParts = dicomName.Split(new[] { '^' }, StringSplitOptions.None);

             string firstName = string.Empty;
             string lastName = string.Empty;
             string middleName = string.Empty;
             string prefix = string.Empty;
             string suffix = string.Empty;

             if (nameParts.Length > 0)
             {
                 lastName = nameParts[0];
             }

             if (nameParts.Length > 1)
             {
                 firstName = nameParts[1];
             }

             if (nameParts.Length > 2)
             {
                 middleName = nameParts[2];
             }

             if (nameParts.Length > 3)
             {
                 prefix = nameParts[3];
             }

             if (nameParts.Length > 4)
             {
                 suffix = nameParts[4];
             }

             // Now that we have the pieces, build a full string
             bool hasPrefix = !string.IsNullOrEmpty(prefix);
             bool hasFirstName = !string.IsNullOrEmpty(firstName);
             bool hasMiddleName = !string.IsNullOrEmpty(middleName);
             bool hasSuffix = !string.IsNullOrEmpty(suffix);
             bool hasPrefixFirstOrMiddleName = hasPrefix || hasFirstName || hasMiddleName;

             dicomName = lastName;

             // If we've already got a last name, and there is something that will be "between the commas", i.e.
             // a prefix, first or middle name, then add the comma after the last name now.
             if (!string.IsNullOrEmpty(dicomName) & hasPrefixFirstOrMiddleName)
             {
                 dicomName += ",";
             }

             // Add the prefix, first name, and middle name, if present, each preceded by a space.
             if (hasPrefixFirstOrMiddleName)
             {
                 if (hasPrefix)
                 {
                     if (!string.IsNullOrEmpty(dicomName))
                     {
                         dicomName += " ";
                     }

                     dicomName += prefix;
                 }

                 if (hasFirstName)
                 {
                     if (!string.IsNullOrEmpty(dicomName))
                     {
                         dicomName += " ";
                     }

                     dicomName += firstName;
                 }

                 if (hasMiddleName)
                 {
                     if (!string.IsNullOrEmpty(dicomName))
                     {
                         dicomName += " ";
                     }

                     dicomName += middleName;
                 }
             }

             // If we have any prior name parts (first, last, middle, or prefix), and we have a suffix, 
             // we need to add the comma prior and space prior to the suffix. If a suffix is the only
             // part we have (which would be weird), then we won't have the comma and space...
             if (!string.IsNullOrEmpty(dicomName) & hasSuffix)
             {
                 dicomName += ", ";
             }

             // Add the suffix if necessary...
             if (hasSuffix)
             {
                 dicomName += suffix;
             }
         }

         return dicomName;
     }

     /// <summary>
     /// Takes an array of strings, concatenates it into one long string, and hashes it.
     /// </summary>
     /// <param name="array">The array.</param>
     /// <returns>The hash</returns>
     public static string GetHashForStringArray(string[] array)
     {
         // First sort the array
         Array.Sort(array);

         // Then join it into a single string
         string value = string.Join(",", array);

         // Finally return the hash))
         return GetHashValue(value);
     }

     /// <summary>
     /// Gets the hash value.
     /// </summary>
     /// <param name="value">The value.</param>
     /// <returns>Returns a hash for a value</returns>
     public static string GetHashValue(string value)
     {
         // P217 - MD5CryptoServiceProvider is not part of the Windows Platform FIPS validated cryptographic algorithms. 
         //Hence MD5CryptoServiceProvider replaced with SHA512CryptoServiceProvider- Pramod Kumar Chikkappaiah - VHAISHCHIKKP

         //Commented for (p289-OITCOPondiS)
         //var x = new SHA512CryptoServiceProvider();
         //byte[] data = Encoding.ASCII.GetBytes(value);
         //data = x.ComputeHash(data);
         //string ret = string.Empty;
         //for (int i = 0; i < data.Length; i++)
         //{
         //    ret += data[i].ToString("x2");
         //}
         //return ret;

         //BEGIN-Fortify Mitigation recommendation for Privacy Violation : Heap inspection. Added try/catch to handle code not to store sensitive data in an insecure manner and cleared it from memory.(p289-OITCOPondiS)
         SHA512CryptoServiceProvider oSHA512CryptoServiceProvider = new SHA512CryptoServiceProvider();

         try
         {
             byte[] data = Encoding.ASCII.GetBytes(value);
             data = oSHA512CryptoServiceProvider.ComputeHash(data);
             string ret = string.Empty;
             for (int i = 0; i < data.Length; i++)
             {
                 ret += data[i].ToString("x2");
             }

             return ret;
         }
         finally
         {
             oSHA512CryptoServiceProvider.Clear();
         }
         //END(p289-OITCOPondiS)
     }

     /// <summary>
     /// Determines whether the specified the value is an integer.
     /// </summary>
     /// <param name="theValue">The value.</param>
     /// <returns>
     ///   <c>true</c> if the specified the value is an integer; otherwise, <c>false</c>.
     /// </returns>
     public static bool IsInteger(string theValue)
     {
         try
         {
             int result = Convert.ToInt32(theValue);
             return true;
         }
         catch
         {
             return false;
         }
     }

      /// <summary>
      /// P332 - Gary Pham (oitlonphamg) (based on secondary code review meeting)
      /// Encapsulate Regex parameter in a utility class.
      /// This regex function is used to validating the string variable.
      /// </summary>
      /// <param name="theValue"></param>
      /// <param name="regex"></param>
      /// <returns></returns>
      public static bool IsRegexValidFilePath(string theValue)
      {
         bool bTemp = Regex.IsMatch(theValue, RegexFilePath);
         return bTemp;
      }

      /// <summary>
      /// P332 - Gary Pham (oitlonphamg) (based on secondary code review meeting)
      /// Encapsulate regex parameter in a utility class.
      /// This regex function is used to log the data after validating the string variable.
      /// </summary>
      /// <param name="theValue"></param>
      /// <param name="regex"></param>
      /// <returns></returns>
      public static bool IsRegexValidLog(string theValue)
      {
         bool bTemp = Regex.IsMatch(theValue, RegexLog);
         return bTemp;
      }

      /// <summary>
      /// P332 - Gary Pham (oitlonphamg) (based on secondary code review meeting)
      /// Encapsulate Regex parameter in a utility class.
      /// This regex function is used to validating the string variable.
      /// </summary>
      /// <param name="theValue"></param>
      /// <param name="regex"></param>
      /// <returns></returns>
      public static bool IsRegexValidFilePathFilter(string theValue)
      {
         bool bTemp = Regex.IsMatch(theValue, RegexFilePathFilter);
         return bTemp;
      }
      #endregion
   }
}