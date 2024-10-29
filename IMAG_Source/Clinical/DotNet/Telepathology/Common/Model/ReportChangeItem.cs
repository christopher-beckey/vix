// -----------------------------------------------------------------------
// <copyright file="ReportChangeItem.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Mar 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: A structure to store the changes for report fields
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
    using System.ComponentModel;

    /// <summary>
    /// Store the changes for a field in the main report to be stored to the database
    /// </summary>
    public class ReportChangeItem : INotifyPropertyChanged
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ReportChangeItem"/> class
        /// </summary>
        public ReportChangeItem()
        {
            this.Field = string.Empty;
            this.Value = string.Empty;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ReportChangeItem"/> class with data
        /// </summary>
        /// <param name="fld">field destination</param>
        /// <param name="val">field value</param>
        public ReportChangeItem(string fld, string val)
        {
            this.Field = fld;
            this.Value = val;
        }

        /// <remarks>
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </remarks>
        /// <summary>
        /// Event to be raised when a property is changed
        /// </summary>
#pragma warning disable 0067
        // Warning disabled because the event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 0067

        /// <summary>
        /// Gets or sets the location of the field in the LAB package in VistA
        /// </summary>
        public string Field { get; set; }

        /// <summary>
        /// Gets or sets the value of the field
        /// </summary>
        public string Value { get; set; }
    }
}
