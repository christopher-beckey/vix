using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class DSRUtils
    {
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string getCurrentDate(string dateString)
        {
            return getISOFormattedDate();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="showDelimiter"></param>
        /// <returns></returns>
        public static string getISOFormattedDate(bool showDelimiter = false)
        {
            if (showDelimiter)
            {
                return string.Format("{0:yyyy-MM-dd}", DateTime.Now);
            }

            return string.Format("{0:yyyyMMdd}", DateTime.Now);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="showDelimiter"></param>
        /// <returns></returns>
        public static string getISOFormattedDate(DateTime dateTime, bool showDelimiter = false)
        {
            if (showDelimiter)
            {
                return string.Format("{0:yyyy-MM-dd}", dateTime);
            }

            return string.Format("{0:yyyyMMdd}", dateTime);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dicomTime"></param>
        /// <param name="seconds"></param>
        /// <param name="fraction"></param>
        /// <returns></returns>
        public static string getCurrentTime(string dicomTime)
        {
            return getISOFormattedTime();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="formattedTime"></param>
        /// <param name="showSeconds"></param>
        /// <param name="showFraction"></param>
        /// <param name="showTimeZone"></param>
        /// <param name="showDelimiter"></param>
        /// <returns></returns>
        public static string getISOFormattedTime(bool showDelimiter = false)
        {
            if (showDelimiter)
            {
                return string.Format("{0:HH-mm-ss}", DateTime.Now);
            }

            return string.Format("{0:HHmmss}", DateTime.Now);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="formattedTime"></param>
        /// <param name="showSeconds"></param>
        /// <param name="showFraction"></param>
        /// <param name="showTimeZone"></param>
        /// <param name="showDelimiter"></param>
        /// <returns></returns>
        public static string getISOFormattedTime(DateTime dateTime, bool showDelimiter = false)
        {
            if (showDelimiter)
            {
                return string.Format("{0:HH:mm:ss}", dateTime);
            }

            return string.Format("{0:HHmmss}", dateTime);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="formattedTime"></param>
        /// <returns></returns>
        public static string getCurrentDateTime(string formattedTime)
        {
            return getISOFormattedTime();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="showDelimiter"></param>
        /// <returns></returns>
        public static string getISOFormattedDateTime(bool showDelimiter = false)
        {
            if (showDelimiter)
            {
                return string.Format("{0:yyyy-MM-dd HH-mm-ss}", DateTime.Now);
            }

            return string.Format("{0:yyyyMMdd HHmmss}", DateTime.Now);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="showDelimiter"></param>
        /// <returns></returns>
        public static string getISOFormattedDateTime(DateTime dateTime, bool showDelimiter = false)
        {
            if (showDelimiter)
            {
                return string.Format("{0:yyyy-MM-dd HH:mm:ss}", dateTime);
            }

            return string.Format("{0:yyyyMMdd HHmmss}", dateTime);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dicomDateTime"></param>
        /// <param name="formattedDateTime"></param>
        /// <param name="seconds"></param>
        /// <param name="fraction"></param>
        /// <param name="timeZone"></param>
        /// <param name="createMissingPart"></param>
        /// <param name="dateTimeSeparator"></param>
        /// <returns></returns>
        public static string getISOFormattedDateTimeFromString(ref string dicomDateTime, ref string formattedDateTime, bool seconds, bool fraction,
                                                           bool timeZone, bool createMissingPart, string dateTimeSeparator)
        {
            return null;
        }

        public static bool getFormattedNameFromComponents(string lastName, string firstName, string middleName, string namePrefix, string nameSuffix, ref string formattedName)
        {
            formattedName = string.Empty;
            /* concatenate name components */
            if (string.IsNullOrEmpty(namePrefix) == false && namePrefix.Length > 0)
            {
                formattedName += namePrefix;
            }
            if (string.IsNullOrEmpty(firstName) == false && firstName.Length > 0)
            {
                if (formattedName.Length > 0)
                {
                    formattedName += ' ';
                }
                formattedName += firstName;
            }
            if (string.IsNullOrEmpty(middleName) == false && middleName.Length > 0)
            {
                if (formattedName.Length > 0)
                {
                    formattedName += ' ';
                }
                formattedName += middleName;
            }
            if (string.IsNullOrEmpty(lastName) == false && lastName.Length > 0)
            {
                if (formattedName.Length > 0)
                {
                    formattedName += ' ';
                }
                formattedName += lastName;
            }
            if (string.IsNullOrEmpty(nameSuffix) == false && nameSuffix.Length > 0)
            {
                if (formattedName.Length > 0)
                {
                    formattedName += ", ";
                }
                formattedName += nameSuffix;
            }
            return true;
        }

        public static string convertToMarkupString(string sourceString, string markupString, bool convertNonASCII, E_MarkupMode markupMode, bool newlineAllowed)
        {
            StringBuilder stream = new StringBuilder();
            /* call stream variant of convert to markup */
            if (convertToMarkupStream(ref stream, sourceString, convertNonASCII, markupMode, newlineAllowed))
            {
                stream.Append("");
                /* convert string stream into a character string */
                markupString = stream.ToString();
            }
            else
            {
                markupString = string.Empty;
            }
            return markupString;
        }

        static bool convertToMarkupStream(ref StringBuilder outstring, string sourceString, bool convertNonASCII, E_MarkupMode markupMode, bool newlineAllowed)
        {
            try
            {
                /* char pointer allows faster access to the string */
                string str = sourceString;
                /* replace HTML/XHTML/XML reserved characters */
                int i = 0;
                while (i < str.Length)
                //while (str[i] != null)
                {
                    /* less than */
                    if (str[i] == '<')
                    {
                        outstring.Append("&lt;");
                    }
                    /* greater than */
                    else if (str[i] == '>')
                    {
                        outstring.Append("&gt;");
                    }
                    /* ampers and */
                    else if (str[i] == '&')
                    {
                        outstring.Append("&amp;");
                    }
                    /* quotation mark */
                    else if (str[i] == '"')
                    {
                        /* entity "&quot;" is not defined in HTML 3.2 */
                        if (markupMode == E_MarkupMode.MM_HTML32)
                        {
                            outstring.Append("&#34;");
                        }
                        else
                        {
                            outstring.Append("&quot;");
                        }
                    }
                    /* apostrophe */
                    else if (str[i] == '\'')
                    {
                        /* entity "&apos;" is not defined in HTML */
                        if ((markupMode == E_MarkupMode.MM_HTML) || (markupMode == E_MarkupMode.MM_HTML32))
                        {
                            outstring.Append("&#39;");
                        }
                        else
                        {
                            outstring.Append("&apos;");
                        }
                    }
                    /* newline: LF, CR, LF CR, CR LF */
                    else if ((str[i] == '\r') || (str[i] == '\n'))
                    {
                        if (markupMode == E_MarkupMode.MM_XML)
                        {
                            /* encode CR and LF exactly as specified */
                            if (str[i] == '\r')
                            {
                                outstring.Append("&#10;");    // '\n'
                            }
                            else
                            {
                                outstring.Append("&#13;");    // '\r'
                            }
                        }
                        else
                        {
                            /* HTML/XHTML mode */
                            /* skip next character if it belongs to the newline sequence */
                            if (((str[i] == '\n') && (str[i + 1] == '\r')) || ((str[i] == '\r') && (str[i + 1]) == '\n'))
                            {
                                i++;
                            }
                            if (newlineAllowed)
                            {
                                if (markupMode == E_MarkupMode.MM_XHTML)
                                {
                                    outstring.Append("<br />\n");
                                }
                                else
                                {
                                    outstring.Append("<br>\n");
                                }
                            }
                            else
                            {
                                outstring.Append("&para;");
                            }
                        }
                    }
                    else
                    {
                        /* other character: ... */
                        //int charValue = Encoding.ASCII.GetBytes(str[i]);
                        int charValue = Convert.ToInt32(str[i]);
                        if ((convertNonASCII || (markupMode == E_MarkupMode.MM_HTML32)) && ((charValue < 32) || (charValue >= 127)))
                        {
                            /* convert < #32 and >= #127 to Unicode (ISO Latin-1) */
                            outstring.Append("&#");
                            outstring.Append(charValue);
                            outstring.Append(";");
                        }
                        else
                        {
                            /* just append */
                            outstring.Append(str[i]);
                        }
                    }
                    ++i;
                }
            }
            catch (Exception)
            { }
            return true;
        }
        
    }
}
