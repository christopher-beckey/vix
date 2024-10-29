/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/21/2013
 * Site Name:  Washington OI Field Office, Silver Spring, MD
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

using System.Collections.ObjectModel;

namespace DicomImporter.Common.Model
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Xml.Serialization;

    /// <summary>
    /// The Status Change Details
    /// </summary>
    [Serializable] 
    public class StatusChangeDetails
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="StatusChangeDetails"/> class.
        /// </summary>
        public StatusChangeDetails()
        {
            this.SecondaryDiagnosticCodeCount = 0;
            this.StandardReportName = "";
            this.StandardReportNumber = "";
            this.ManuallyEnteredText = "";
            this.ReportText = "";
            this.Impression = "";
        }

        #endregion

        #region Public Methods


        /// <summary>
        /// Calculates the next status.
        /// </summary>
        /// <param name="currentStatus">The current status.</param>
        /// <returns></returns>
        public static string CalculateNextStatus(string currentStatus)
        {
            // need to determine how to caclulate the next exam status can use ids since they go in order of priority

            if (ExamStatuses.IsCompletedStatus(currentStatus))
            {
                return ExamStatuses.Complete;
            }
            else if (string.IsNullOrEmpty(currentStatus))
            {
                return ExamStatuses.Examined;
            }

            return currentStatus;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the primary diagnostic code.
        /// </summary>
        public DiagnosticCode PrimaryDiagnosticCode { get; set; }

        /// <summary>
        /// Gets or sets the Requested Status
        /// </summary>
        public string RequestedStatus { get; set; }

        /// <summary>
        /// Gets or sets the secondary diagnostic codes.
        /// </summary>
        public ObservableCollection<SecondaryDiagnosticCode> SecondaryDiagnosticCodes { get; set; }
        
        /// <summary>
        /// Gets or sets the standard report name.
        /// </summary>
        [XmlIgnore()]
        public string StandardReportName { get; set; }

        /// <summary>
        /// Gets or sets the standard report number.
        /// To display the work item element StandardReportNumber if not dirty (p289-OITCOPondiS)
        /// </summary>        
        [System.Xml.Serialization.XmlElement(IsNullable = true)]//To display the work item element StandardReportNumber if not dirty (p289-OITCOPondiS)
        public string StandardReportNumber { get; set; }

        /// <summary>
        /// Gets or sets the secondary diagnostic code count.
        /// </summary>
        [XmlIgnore()]
        public int SecondaryDiagnosticCodeCount{ get; set;}

        /// <summary>
        /// Gets or sets the Manually Entered Report and Impression Texts
        /// </summary>        
        [System.Xml.Serialization.XmlElement(IsNullable = true)]
        public string ManuallyEnteredText { get; set; }

        /// <summary>
        /// Gets or sets the standard report ReportText.
        /// </summary>        
        [System.Xml.Serialization.XmlElement(IsNullable = true)]
        public string ReportText { get; set; }

        /// <summary>
        /// Gets or sets the standard report Impression.
        /// </summary>        
        [System.Xml.Serialization.XmlElement(IsNullable = true)]
        public string Impression { get; set; }

        /// <summary>
        /// Gets or sets the CurrentStudy.
        /// </summary>
        [XmlIgnore()]
        public Study CurrentStudy { get; set; }

        /// <summary>
        /// Gets or sets the WorkItemId.
        /// </summary>
        [XmlIgnore()]
        public int WorkItemId { get; set; }

        #endregion
    }
}
