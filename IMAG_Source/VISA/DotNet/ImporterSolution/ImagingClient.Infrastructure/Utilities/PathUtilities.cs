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
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
   using System.Text.RegularExpressions;
   using log4net;

    /// <summary>
    /// The path utilities.
    /// </summary>
    public class PathUtilities
    {
        #region Public Methods


        /* original

        /// <summary>
        /// The add files.
        /// </summary>
        /// <param name="path">
        /// The path.
        /// </param>
        /// <param name="filter">
        /// The filter.
        /// </param>
        /// <param name="files">
        /// The files.
        /// </param>
        public static void AddFiles(string path, string filter, IList<string> files)
        {
            try
            {
                Directory.GetFiles(path, filter).ToList().ForEach(files.Add);

                Directory.GetDirectories(path).ToList().ForEach(s => AddFiles(s, filter, files));
            }
            catch (UnauthorizedAccessException)
            {
                // ok, so we are not allowed to dig into that directory. Move on.
            }
        }

             /// <summary>
        /// Combines the path.
        /// </summary>
        /// <param name="part1">Path part 1.</param>
        /// <param name="part2">Path part 2.</param>
        /// <returns>The combined path</returns>
        public static string CombinePath(string part1, string part2)
        {
            if (part1.EndsWith(":"))
            {
                part1 = part1 + "\\";
            }

            if (part2.StartsWith("\\") || part2.StartsWith("/"))
            {
                part2 = part2.Substring(1);
            }

            return Path.Combine(part1, part2);
        }

        */



        /// <summary>
        /// The add files.
        /// </summary>
        /// <param name="path">
        /// The path.
        /// </param>
        /// <param name="filter">
        /// The filter.
        /// </param>
        /// <param name="files">
        /// The files.
        /// </param>
        public static void AddFiles(string path, string filter, IList<string> files)
        {
            //BEGIN-Fortify Mitigation recommendation for Path manipulation. Modified code to well-formed the path validation by calling method {SantizeFilePathStatus} in try/catch block  before getting files structures and directory structue.(p289-OITCOPondiS)

            bool isAllowedFiles = true;

            try
            {
                bool isValidatePath = SantizeFilePathStatus(path);
                bool isValidatefilter = SantizeFilePathStatus(filter);

            //Old code commented by Gary Pham
            //if (isValidatePath && isValidatefilter
            /*
            Gary Pham (oitlonphamg)
            P332
            Validate string for nonprintable characters based on Fortify software recommendation.
            */
            //if (Regex.IsMatch(destinationPath, "^[A-Za-z0-9 _.,\\\\!'/$;:%-]+$"))
            //Begin - New code added by Gary Pham
            if (isValidatePath && isValidatefilter && 
                   StringUtilities.IsRegexValidFilePath(path) &&
                   StringUtilities.IsRegexValidFilePathFilter(filter))
            //End - New code added by Gary Pham
                {
                    foreach (string file in files)
                    {
                        bool isValidatefile = SantizeFilePathStatus(file);
                        if (!isValidatefile)
                            isAllowedFiles = false;
                    }
                                
	                if(isAllowedFiles)
	                {
	                    try
	                    {
	                        Directory.GetFiles(path, filter).ToList().ForEach(files.Add);
	
	                        Directory.GetDirectories(path).ToList().ForEach(s => AddFiles(s, filter, files));
	                    }
	                    catch (UnauthorizedAccessException)
	                    {
	                        // ok, so we are not allowed to dig into that directory. Move on.
	                    }
	                }
				}
            }
            catch(Exception e)
            {

            }
            //END(p289-OITCOPondiS)

        }

        /// <summary>
        /// Combines the path.
        /// </summary>
        /// <param name="part1">Path part 1.</param>
        /// <param name="part2">Path part 2.</param>
        /// <returns>The combined path</returns>
        public static string CombinePath(string part1, string part2)
        {
            //BEGIN-Fortify Mitigation recommendation for Base path overriding. Added code to well-formed the path validation by calling method {SantizeFilePathStatus} before getting absolute path string .(p289-OITCOPondiS)
            bool isValidatePath1 = false;
            bool isValidatePath2 = false;
            isValidatePath1 = SantizeFilePathStatus(part1);
            isValidatePath2 = SantizeFilePathStatus(part2);
            //END(p289-OITCOPondiS)

            //Added IF condition and process code only if condition teturn true.(p289-OITCOPondiS)
            if (isValidatePath1 && isValidatePath2)
            {
                if (part1.EndsWith(":"))
                {
                    //part1 = part1 + "\\"; // commented on 03/17/21
                    part1 = part1  + Path.DirectorySeparatorChar.ToString(); // commented on 03/17/21
                }

                if (part2.StartsWith("\\") || part2.StartsWith("/"))
                {
                    part2 = part2.Substring(1);
                }
				
				String strTemp = Path.Combine(part1, part2);

            /*
    			Gary Pham (oitlonphamg)
    			P332
    			Validate string for nonprintable characters based on Fortify software recommendation.
    			*/
            //if (!Regex.IsMatch(strTemp, "^[A-Za-z0-9 _.,\\\\!'/$;:%-]+$"))
            //Begin - New code added by Gary Pham
            if (!StringUtilities.IsRegexValidFilePath(strTemp))
            //End - New code added by Gary Pham
               strTemp = String.Empty;
						
                return strTemp;
            }

            return string.Empty;
            
        }

        /// <summary>
        /// Given a root path and a full path, gets the relative path off of the root.
        /// </summary>
        /// <param name="rootPath">The root path.</param>
        /// <param name="fullPath">The full path.</param>
        /// <returns>The relative path</returns>
        public static string GetRelativePath(string rootPath, string fullPath)
        {
            if (rootPath.EndsWith("\\") || rootPath.EndsWith("/"))
            {
                rootPath = rootPath.Substring(0, rootPath.Length - 1);
            }

            string relativePath = fullPath.Substring(rootPath.Length);

            return relativePath;
        }


        /// <summary>
        /// Validate file and path characters
        /// The Following characters are invalid in a path : ",<,>,|
        /// The Following characters are invalid in a file : ",<,>,|,:,*,?,\,/
        /// </summary>
        /// <param name="charArray"></param>
        /// <param name="oPath"></param>
        /// <returns></returns>
        public static bool IsValidFilePath(char[] charArray, string oPath)
        {
            if (oPath.Contains("..") || Path.IsPathRooted(oPath))
            {
                return false;
            }

            foreach (char someChar in charArray)
            {
                if (!System.Char.IsWhiteSpace(someChar))
                {
                    foreach (char ch in oPath)
                    {
                        if (ch == someChar)
                            return false;
                    }
                }
            }
            return true;
        }

        /// <summary>
        /// Sanitize file path
        /// The Following characters are invalid in a path : ",<,>,|,..
        /// </summary>
        /// <param name="oPath"></param>
        /// <returns></returns>
        public static bool SantizeFilePathStatus(string oPath)
        {
            //if (oPath.Contains("..") || Path.IsPathRooted(oPath))
            //{
            //    return false;
            //}
            if (oPath.Contains("..") )
            {
                return false;
            }
            char[] invalidPathChars = System.IO.Path.GetInvalidPathChars();
            foreach (char someChar in invalidPathChars)
            {
                if (!System.Char.IsWhiteSpace(someChar))
                {
                    foreach (char ch in oPath)
                    {
                        if (ch == someChar)
                            return false;
                    }
                }
            }
            return true;
        }



        /// <summary>
        /// Sanitize file name characters
        /// The Following characters are invalid in a file : ",<,>,|,:,*,?,\,/,..
        /// </summary>
        /// <param name="oPath"></param>
        /// <returns></returns>
        public static  bool SantizeFileNameStatus(string oPath)
        {
            if (oPath.Contains(".."))
            {
                return false;
            }
            char[] invalidFileChars = System.IO.Path.GetInvalidFileNameChars();
            foreach (char someChar in invalidFileChars)
            {
                if (!System.Char.IsWhiteSpace(someChar))
                {
                    foreach (char ch in oPath)
                    {
                        if (ch == someChar)
                            return false;
                    }
                }
            }
            return true;
        }



        /// <summary>
        /// Sanitize the path
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public static  string MakeValidFileName(string fname)
        {
            if (fname.Contains(".."))
            {
                return string.Empty;
            }

            string invalidChars = System.Text.RegularExpressions.Regex.Escape(new string(System.IO.Path.GetInvalidFileNameChars()));
            string invalidRegStr = string.Format(@"([{0}]*\.+$)|([{0}]+)", invalidChars);

            return System.Text.RegularExpressions.Regex.Replace(fname, invalidRegStr, "_");
        }



        /// <summary>
        /// Sanitize the windows file name value
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public static string ValidateWindowsFileName(string fname)
        {
            System.Text.RegularExpressions.Regex illegalInFileName = new System.Text.RegularExpressions.Regex(string.Format("[{0}]", 
                System.Text.RegularExpressions.Regex.Escape(new string(Path.GetInvalidFileNameChars()))), System.Text.RegularExpressions.RegexOptions.Compiled);
            string myString = @"A\\B/C:D?E*F""G<H>I|";
            myString = illegalInFileName.Replace(myString, "");

            return myString;
        }


        //private string RemoveExtraNewLines(string text)
        //{
        //    text = text.Replace("\n \n", "#$%HGU*&&*JE@FFE^ht45");
        //    text = text.Replace("\n", "");
        //    text = text.Replace("#$%HGU*&&*JE@FFE^ht45", Environment.NewLine + Environment.NewLine);

        //    return text.Replace("     ", " ");
        //}
        #endregion
    }
}