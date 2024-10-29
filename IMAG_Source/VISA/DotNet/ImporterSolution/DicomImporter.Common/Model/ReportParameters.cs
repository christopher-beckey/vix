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
namespace DicomImporter.Common.Model
{
    using System;
    using System.Xml.Serialization;

    /// <summary>
    /// The report parameters.
    /// </summary>
    public class ReportParameters
    {
        /// <summary>
        /// The start date
        /// </summary>
        private string startDate;

        /// <summary>
        /// The end date
        /// </summary>
        private string endDate;

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ReportParameters"/> class.
        /// </summary>
        public ReportParameters()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ReportParameters"/> class.
        /// </summary>
        /// <param name="reportTypeCode">
        /// The report type code.
        /// </param>
        /// <param name="reportStyleCode">
        /// The report style code.
        /// </param>
        /// <param name="startDate">
        /// The start date.
        /// </param>
        /// <param name="endDate">
        /// The end date.
        /// </param>
        public ReportParameters(string reportTypeCode, string reportStyleCode, DateTime startDate, DateTime endDate)
        {
            this.ReportTypeCode = reportTypeCode;
            this.ReportStyleCode = reportStyleCode;
            this.StartDateAsDate = startDate;
            this.EndDateAsDate = endDate;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the end date.
        /// </summary>
        /// <value>
        /// The end date.
        /// </value>
        public string EndDate
        {
            get
            {
                return string.Format("{0:yyyyMMdd}", this.EndDateAsDate);
            }

            set
            {
                this.endDate = value;
            }
        }

        /// <summary>
        /// Gets or sets EndDateAsDate.
        /// </summary>
        [XmlIgnore]
        public DateTime EndDateAsDate { get; set; }

        /// <summary>
        /// Gets or sets ReportStyleCode.
        /// </summary>
        public string ReportStyleCode { get; set; }

        /// <summary>
        /// Gets or sets ReportTypeCode.
        /// </summary>
        public string ReportTypeCode { get; set; }

        /// <summary>
        /// Gets or sets the start date.
        /// </summary>
        /// <value>
        /// The start date.
        /// </value>
        public string StartDate
        {
            get
            {
                return string.Format("{0:yyyyMMdd}", this.StartDateAsDate);
            }

            set
            {
                this.startDate = value;
            }
        }

        /// <summary>
        /// Gets or sets StartDateAsDate.
        /// </summary>
        [XmlIgnore]
        public DateTime StartDateAsDate { get; set; }

        #endregion
    }
}