// -----------------------------------------------------------------------
// <copyright file="Report.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Mar 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Report Model
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
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Linq;
    using System.Text.RegularExpressions;

    /// <summary>
    /// Report states
    /// </summary>
    public enum ReportState
    {
        /// <summary>
        /// From creation to completion
        /// </summary>
        InProgress,

        /// <summary>
        /// From completion to released
        /// </summary>
        Pending,

        /// <summary>
        /// Verified and released
        /// </summary>
        Verified
    }

    /// <summary>
    /// Report model
    /// </summary>
    public class Report : INotifyPropertyChanged
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="Report"/> class
        /// </summary>
        public Report()
        {
            //SiteCode = "";
            //AccessionNumber = "";
            this.State = ReportState.InProgress;
            this.DateSpecTaken = string.Empty;
            this.DateSpecReceived = string.Empty;
            this.DateCompleted = string.Empty;
            this.Pathologist = string.Empty;
            this.Resident = string.Empty;
            this.Practitioner = string.Empty;
            this.Submitter = string.Empty;
            this.ReleasedBy = string.Empty;
            this.ReleasedDate = string.Empty;
            this.ReportTemplate = new ReportTemplate();
            this.FieldList = new ObservableCollection<ReportField>();
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
        /// Generate a list of fields to be retrieved from database
        /// </summary>
        /// <returns>a list of field for the report</returns>
        public List<string> GetFieldList()
        {
            List<string> Result = new List<string>();

            // Report Information always need to be retrieve
            //Result.Add(".06");      // Accession number
            Result.Add(".01");      // Date specimen taken
            Result.Add(".1");       // Date specimen received
            Result.Add(".03");      // Date report completed
            Result.Add(".02");      // pathologist
            Result.Add(".021");     // resident
            Result.Add(".07");      // practitioner
            Result.Add(".011");     // submitter
            Result.Add(".11");      // report released date
            Result.Add(".13");      // report released by

            // Report fields that are being displayed
            if (this.ReportTemplate != null)
            {
                List<ReportField> temp = new List<ReportField>();
                foreach (ReportFieldTemplate field in ReportTemplate.ReportFields)
                {
                    if (field.TemplateList == ReportListType.Display)
                    {
                        Result.Add(field.FieldNumber);

                        // also make an object in the field list
                        ReportField repField = new ReportField()
                        {
                            FieldNumber = field.FieldNumber,
                            DisplayName = field.DisplayName,
                            DisplayPosition = field.DisplayPosition,
                            InputType = field.InputType,
                            //IsSR = false,
                            IsRequired = field.IsRequired, 
                            IsReadOnly = false,
                            //IsDirty = false
                        };
                        // add * to required fields
                        if (repField.IsRequired)
                            repField.DisplayName += "*";

                        temp.Add(repField);
                    }
                }
                // sort the list of field based on display position
                Comparison<ReportField> compPos = new Comparison<ReportField>(ReportField.CompareFieldPosition);
                temp.Sort(compPos);
                foreach (ReportField field in temp)
                    FieldList.Add(field);
            }

            return Result;
        }

        public List<string> GetAllFieldList()
        {
            List<string> Result = new List<string>();

            // Report Information always need to be retrieve
            //Result.Add(".06");      // Accession number
            Result.Add(".01");      // Date specimen taken
            Result.Add(".1");       // Date specimen received
            Result.Add(".03");      // Date report completed
            Result.Add(".02");      // pathologist
            Result.Add(".021");     // resident
            Result.Add(".07");      // practitioner
            Result.Add(".011");     // submitter
            Result.Add(".11");      // report released date
            Result.Add(".13");      // report released by

            // All the report fields
            if (this.ReportTemplate != null)
            {
                List<ReportField> temp = new List<ReportField>();
                foreach (ReportFieldTemplate field in ReportTemplate.ReportFields)
                {
                    Result.Add(field.FieldNumber);

                    // also make an object in the field list
                    ReportField repField = new ReportField()
                    {
                        FieldNumber = field.FieldNumber,
                        DisplayName = field.DisplayName,
                        DisplayPosition = field.DisplayPosition,
                        InputType = field.InputType,
                        //IsSR = false,
                        IsRequired = field.IsRequired,
                        IsReadOnly = false,
                        //IsDirty = false
                        ListType = field.TemplateList
                    };
                    // add * to required fields
                    if (repField.IsRequired)
                        repField.DisplayName += "*";

                    temp.Add(repField);
                }

                // sort the list of field based on display position
                Comparison<ReportField> compPos = new Comparison<ReportField>(ReportField.CompareFieldPosition);
                temp.Sort(compPos);
                foreach (ReportField field in temp)
                    FieldList.Add(field);
            }

            return Result;
        }

        public void LoadReportData(PathologyCaseTemplateType rawData)
        {
            foreach (PathologyCaseTemplateFieldType field in rawData.Fields)
            {
                // update report information        
                if (field.FieldNumber == ".01")
                    DateSpecTaken = field.Content;
                else if (field.FieldNumber == ".1")
                    DateSpecReceived = field.Content;
                else if (field.FieldNumber == ".03")
                    DateCompleted = field.Content;
                else if (field.FieldNumber == ".02")
                    Pathologist = field.Content;
                else if (field.FieldNumber == ".021")
                    Resident = field.Content;
                else if (field.FieldNumber == ".07")
                    Practitioner = field.Content;
                else if (field.FieldNumber == ".011")
                    Submitter = field.Content;
                else if (field.FieldNumber == ".11")
                    ReleasedDate = field.Content;
                else if (field.FieldNumber == ".13")
                    ReleasedBy = field.Content;
                else
                {
                   // update other fields
                    var repfield = FieldList.FirstOrDefault(f => f.FieldNumber == field.FieldNumber);
                    repfield.BeforeValue = field.Content.Trim();
                    repfield.StringValue = field.Content.Trim();
                    string[] vals = Regex.Split(field.Content.Trim(), "\r\n");
                    if (vals != null)
                    {
                        foreach (string val in vals)
                            repfield.ValueList.Add(new StringWrapper() { Value = val });
                    }

                    // remove empty non displayable fields
                    if ((repfield.ListType != ReportListType.Display) && (string.IsNullOrWhiteSpace(repfield.StringValue)))
                        FieldList.Remove(repfield);
                }
            }

            // get the state of the report
            if (!string.IsNullOrEmpty(this.ReleasedDate))
            {
                this.ChangeState(ReportState.Verified);
            }
            else if (!string.IsNullOrEmpty(this.DateCompleted))
            {
                this.ChangeState(ReportState.Pending);
            }
            else
            {
                this.ChangeState(ReportState.InProgress);
            }
        }

        public void SetReadOnly(bool readOnly)
        {
            if (this.FieldList != null)
            {
                if (this.State != ReportState.Verified)
                {
                    // if the state is either pending or in progress, user can set 
                    // the read only flag
                    foreach (ReportField field in this.FieldList)
                    {
                        field.IsReadOnly = readOnly;
                    }
                }
                else
                {
                    // otherwise for verified state, everything is readonly
                    foreach (ReportField field in this.FieldList)
                    {
                        field.IsReadOnly = true;
                    }
                }
            }
        }

        public void ChangeState(ReportState newState)
        {
            this.State = newState;
            if (newState == ReportState.Verified)
            {
                SetReadOnly(true);
            }
            else
            {
                SetReadOnly(false);
            }
        }

        //public string SiteCode { get; set; }
        //public string AccessionNumber { get; set; }
        public ReportState State { get; set; }

        public string DateSpecTaken { get; set; }
        public string DateSpecReceived { get; set; }
        public string DateCompleted { get; set; }
        public string Pathologist { get; set; }
        public string Resident { get; set; }
        public string Practitioner { get; set; }
        public string Submitter { get; set; }
        public string ReleasedDate { get; set; }
        public string ReleasedBy { get; set; }

        /// <summary>
        /// Gets or sets the template of the report
        /// </summary>
        public ReportTemplate ReportTemplate { get; set; }

        /// <summary>
        /// Gets or sets the list of fields data based on the template
        /// </summary>
        public ObservableCollection<ReportField> FieldList { get; set; }
    }
}
