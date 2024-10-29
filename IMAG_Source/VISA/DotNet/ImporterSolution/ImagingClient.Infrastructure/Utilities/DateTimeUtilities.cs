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
    using System.Globalization;

    using log4net;

    /// <summary>
    /// The date time utilities.
    /// </summary>
    public class DateTimeUtilities
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(DateTimeUtilities));

        /// <summary>
        /// The provider.
        /// </summary>
        private static readonly CultureInfo provider = CultureInfo.CurrentCulture;

        #endregion

        #region Public Methods

        /// <summary>
        /// Reformats the dicom date as short date.
        /// </summary>
        /// <param name="dicomDate">The dicom date.</param>
        /// <returns>The reformatted date string</returns>
        public static string ReformatDicomDateAsShortDate(string dicomDate)
        {
            try
            {
                DateTime dateTime = DateTime.ParseExact(dicomDate, "yyyyMMdd", provider);
                return dateTime.ToString("MM/dd/yyyy");
            }
            catch (Exception)
            {
                Logger.Debug("Unable to reformat DICOM date with a value of: " + dicomDate);
            }

            // If we got down here, the date was either null or already in a non-DICOM format, 
            // so just return the input value (plus an empty string to eliminate nulls).
            return dicomDate + string.Empty;
        }

        /// <summary>
        /// Reformats the dicom time as short time.
        /// </summary>
        /// <param name="inputTime">The input time.</param>
        /// <returns>The reformatted time</returns>
        public static string ReformatDicomTimeAsShortTime(string inputTime)
        {
            // Store in temp variable so we can return unparsable data as is...
            string dicomTime = inputTime + string.Empty;

            // Remove fractions of a second if present
            if (dicomTime.Contains("."))
            {
                dicomTime = dicomTime.Split('.')[0];
            }

            // If empty, set to one minute after midnight
            if (string.IsNullOrEmpty(dicomTime))
            {
                dicomTime = "000100";
            }

            if (StringUtilities.IsInteger(dicomTime)
                && (dicomTime.Length == 2 || dicomTime.Length == 4 || dicomTime.Length == 6))
            {
                if (dicomTime.Length == 2)
                {
                    dicomTime += "0000";
                }
                else if (dicomTime.Length == 4)
                {
                    dicomTime += "00";
                }

                // If all zeros, set to 1 minute after midnight
                if (dicomTime.Equals("000000"))
                {
                    dicomTime = "000100";
                }

                DateTime dateTime = DateTime.ParseExact(dicomTime, "HHmmss", provider);
                return dateTime.ToString("h:mm:ss tt");
            }

            // If we made it here, the string was either empty or formatted incorrectly. Log it and return 
            // back what was originally sent in (but convert null input to empty string)...

            //Commented for (p289-OITCOPondiS)
            //Logger.Debug("Unable to reformat DICOM time with a value of: " + inputTime);

            //Fortify Mitigation recommendation for Log Forging.Code removed unvalidated user input to the log.(p289-OITCOPondiS)
            Logger.Debug("Unable to reformat DICOM time " );

            return inputTime;
        }

        #endregion
    }
}