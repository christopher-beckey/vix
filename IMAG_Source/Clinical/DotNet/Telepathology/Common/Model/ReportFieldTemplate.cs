// -----------------------------------------------------------------------
// <copyright file="ReportFieldTemplate.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Mar 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Template for a report field in the main report
//        ;; +--------------------------------------------------------------------+
//        ;; Property of the US Government.
//        ;; No permission to copy or redistribute this software is given.
//        ;; Use of unreleased versions of this software requires the user
//        ;;  to execute a written test agreement with the VistA Imaging
//        ;;  Development Office of the Department of Veterans Affairs,
//        ;;  telephone (301) 734-0100.
//        ;;
//        ;; The Food and Drug Administration classifies this software as
//        ;; a Class II medical device.  As such, it may not be changed
//        ;; in any way.  Modifications to this software may result in an
//        ;; adulterated medical device under 21CFR820, the use of which
//        ;; is considered to be a violation of US Federal Statutes.
//        ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Common.Model
{
    using System.Xml.Serialization;

    /// <summary>
    /// List type for the report field
    /// </summary>
    public enum ReportListType
    {
        /// <summary>
        /// The field will be on the available list
        /// </summary>
        Available,

        /// <summary>
        /// Thie field will be on the display list and displayed in the report gui
        /// </summary>
        Display
    }

    /// <summary>
    /// Input type of the field
    /// </summary>
    public enum FieldInputType
    {
        /// <summary>
        /// True or false kind
        /// </summary>
        Boolean,

        /// <summary>
        /// Date and time
        /// </summary>
        DateTime,

        /// <summary>
        /// Mutiline text
        /// </summary>
        MultiText,

        /// <summary>
        /// Word processing
        /// </summary>
        WordProcessing
    }

    /// <summary>
    /// Skeleton of a report field
    /// </summary>
    public class ReportFieldTemplate
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ReportFieldTemplate"/> class
        /// </summary>
        public ReportFieldTemplate()
        {
            this.DatabaseName = string.Empty;
            this.DisplayName = string.Empty;
            this.FieldNumber = string.Empty;
            this.InputType = FieldInputType.WordProcessing;
            this.DisplayPosition = -1;
            this.IsRequired = false;
            this.AlwaysRequired = false;
            this.TemplateList = ReportListType.Available;
        }

        /// <summary>
        /// Gets or sets the name of the field in the database
        /// </summary>
        [XmlElement("DatabaseName")]
        public string DatabaseName { get; set; }

        /// <summary>
        /// Gets or sets the desired display name
        /// </summary>
        [XmlElement("DisplayName")]
        public string DisplayName { get; set; }

        /// <summary>
        /// Gets or sets the field number/location of the field in the LAB package
        /// </summary>
        [XmlElement("FieldNumber")]
        public string FieldNumber { get; set; }

        /// <summary>
        /// Gets or sets the input type of the field
        /// </summary>
        [XmlElement("InputType")]
        public FieldInputType InputType { get; set; }

        /// <summary>
        /// Gets or sets the position of the field on the GUI
        /// </summary>
        [XmlElement("DisplayPosition")]
        public int DisplayPosition { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether or not the field is required
        /// </summary>
        [XmlElement("IsRequired")]
        public bool IsRequired { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether or not the field is always required
        /// </summary>
        [XmlElement("AlwaysRequired")]
        public bool AlwaysRequired { get; set; }

        /// <summary>
        /// Gets or sets the display list type
        /// </summary>
        [XmlElement("TemplateList")]
        public ReportListType TemplateList { get; set; }

        /// <summary>
        /// Compare the display position of two report fields 
        /// </summary>
        /// <param name="f1">first field</param>
        /// <param name="f2">second field</param>
        /// <returns>return whethe or not the current instance precedes, same, or follow the second object</returns>
        public static int CompareFieldPosition(ReportFieldTemplate f1, ReportFieldTemplate f2)
        {
            return f1.DisplayPosition.CompareTo(f2.DisplayPosition);
        }
    }
}
