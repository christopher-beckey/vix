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


using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ImagingClient.Infrastructure.Utilities
{
    public class StringUtilities
    {
        public static String GetHashForStringArray(String[] array)
        {
            // First sort the array
            Array.Sort(array);

            // Then join it into a single string
            String value = String.Join(",", array);

            // Finally return the hash))
            return GetHashValue(value);
        }

        public static string GetHashValue(string value)
        {
            System.Security.Cryptography.MD5CryptoServiceProvider x = new System.Security.Cryptography.MD5CryptoServiceProvider();
            byte[] data = Encoding.ASCII.GetBytes(value);
            data = x.ComputeHash(data);
            string ret = "";
            for (int i = 0; i < data.Length; i++)
                ret += data[i].ToString("x2");
            return ret;
        }

        public static string ConvertDicomName(string dicomName)
        {
            if (dicomName != null && dicomName.Contains("^"))
            {
                // It is a DICOM-Formatted name.
                // Convert to remove carats
                String[] nameParts = dicomName.Split(new char[] { '^' }, StringSplitOptions.None);

                String firstName = String.Empty;
                String lastName = String.Empty;
                String middleName = String.Empty;
                String prefix = String.Empty;
                String suffix = String.Empty;

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
                bool hasPrefix = !String.IsNullOrEmpty(prefix);
                bool hasFirstName = !String.IsNullOrEmpty(firstName);
                bool hasMiddleName = !String.IsNullOrEmpty(middleName);
                bool hasSuffix = !String.IsNullOrEmpty(suffix);
                bool hasPrefixFirstOrMiddleName = hasPrefix || hasFirstName || hasMiddleName;

                dicomName = lastName;


                // If we've already got a last name, and there is something that will be "between the commas", i.e.
                // a prefix, first or middle name, then add the comma after the last name now.
                if (!String.IsNullOrEmpty(dicomName) & hasPrefixFirstOrMiddleName)
                {
                    dicomName += ",";
                }

                // Add the prefix, first name, and middle name, if present, each preceded by a space.
                if (hasPrefixFirstOrMiddleName)
                {
                    if (hasPrefix)
                    {
                        if (!String.IsNullOrEmpty(dicomName))
                        {
                            dicomName += " ";
                        }
                        dicomName += prefix;
                    }

                    if (hasFirstName)
                    {
                        if (!String.IsNullOrEmpty(dicomName))
                        {
                            dicomName += " ";
                        }

                        dicomName += firstName;
                    }

                    if (hasMiddleName)
                    {
                        if (!String.IsNullOrEmpty(dicomName))
                        {
                            dicomName += " ";
                        }

                        dicomName += middleName;
                    }
                }

                // If we have any prior name parts (first, last, middle, or prefix), and we have a suffix, 
                // we need to add the comma prior and space prior to the suffix. If a suffix is the only
                // part we have (which would be weird), then we won't have the comma and space...
                if (!String.IsNullOrEmpty(dicomName) & hasSuffix)
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
    }
}
