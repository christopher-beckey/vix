// -----------------------------------------------------------------------
// <copyright file="ReportField.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Mar 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Report field for the main report
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
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Text.RegularExpressions;

    /// <summary>
    /// Field for the main report
    /// </summary>
    public class ReportField : INotifyPropertyChanged
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ReportField"/> class
        /// </summary>
        public ReportField()
        {
            this.FieldNumber = string.Empty;
            this.DisplayName = string.Empty;
            this.DisplayPosition = 0;
            this.IsRequired = false;
            this.InputType = FieldInputType.WordProcessing;
            this.BeforeValue = string.Empty;
            this.StringValue = string.Empty;
            this.ValueList = new ObservableCollection<StringWrapper>();
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
        /// Gets or sets the field location in VistA
        /// </summary>
        public string FieldNumber { get; set; }

        /// <summary>
        /// Gets or sets the display name of the field
        /// </summary>
        public string DisplayName { get; set; }

        /// <summary>
        /// Gets or sets the display position 
        /// </summary>
        public int DisplayPosition { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether or not the field is required
        /// </summary>
        public bool IsRequired { get; set; }

        /// <summary>
        /// Gets or sets the input type of the field
        /// </summary>
        public FieldInputType InputType { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether or not the field is read only
        /// </summary>
        public bool IsReadOnly { get; set; }

        /// <summary>
        /// Gets a value indicating whether or not the field is enable
        /// </summary>
        public bool IsEnable
        {
            get
            {
                return !this.IsReadOnly;
            }
        }

        public ReportListType ListType { get; set; }

        /// <summary>
        /// Gets or sets the value of the field when loaded or right after saved
        /// </summary>
        public string BeforeValue { get; set; }

        /// <summary>
        /// Gets or sets the value of the field for word processing type
        /// </summary>
        public string StringValue { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether or not the field has value
        /// </summary>
        public bool HasValue
        {
            get
            {
                if (string.IsNullOrEmpty(this.StringValue))
                {
                    return false;
                }

                return true;
            }
        }
        /// <summary>
        /// Gets or sets the values of the field for multi text type
        /// </summary>
        public ObservableCollection<StringWrapper> ValueList { get; set; }

        /// <summary>
        /// Compare the field position
        /// </summary>
        /// <param name="f1">field one</param>
        /// <param name="f2">field two</param>
        /// <returns>position of the current item compare to the second field</returns>
        public static int CompareFieldPosition(ReportField f1, ReportField f2)
        {
            return f1.DisplayPosition.CompareTo(f2.DisplayPosition);
        }

        /// <summary>
        /// Check to see if the before value and the current value are differnt
        /// </summary>
        /// <returns>true if there are changes</returns>
        public bool IsFieldDirty()
        {
            if (this.InputType == FieldInputType.MultiText)
            {
                string values = string.Empty;
                if (this.ValueList != null)
                {
                    foreach (StringWrapper val in this.ValueList)
                    {
                        values += val.Value + "\r\n";
                    }

                    values = values.Trim();
                }

                if (this.BeforeValue == values)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            else if (this.InputType == FieldInputType.WordProcessing)
            {
                if ((this.BeforeValue != null) && (this.StringValue != null))
                {
                    if (this.BeforeValue == this.StringValue)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }
                else if ((this.BeforeValue == null) && (this.StringValue == null))
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            else if (this.InputType == FieldInputType.Boolean)
            {
                if ((this.BeforeValue != null) && (this.StringValue != null))
                {
                    if (this.BeforeValue == this.StringValue)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    }
                }
                else if ((this.BeforeValue == null) && (this.StringValue == null))
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// Update the before value to be the same as current value after save
        /// </summary>
        public void SaveValue()
        {
            if (this.InputType == FieldInputType.MultiText)
            {
                this.BeforeValue = string.Empty;
                if (this.ValueList != null)
                {
                    foreach (StringWrapper val in this.ValueList)
                    {
                        this.BeforeValue += val.Value.Trim() + "\r\n";
                    }

                    this.BeforeValue = this.BeforeValue.Trim();
                }
            }
            else if (this.InputType == FieldInputType.WordProcessing)
            {
                this.BeforeValue = this.StringValue;
            }
            else if (this.InputType == FieldInputType.Boolean)
            {
                this.BeforeValue = this.StringValue;
            }
        }

        /// <summary>
        /// Common accessor to get the value of the field regardless input type
        /// </summary>
        /// <returns>list result of the field content</returns>
        public List<string> GetListContent()
        {
            List<string> result = new List<string>();

            if (this.InputType == FieldInputType.WordProcessing)
            {
                // first trim the result and remove all line break and blank line
                string[] lines = Regex.Split(this.StringValue.Trim(), "\r\n");
                if (lines != null)
                {
                    foreach (string line in lines)
                    {
                        if (line != string.Empty)
                        {
                            result.Add(line);
                        }
                    }
                }
            }
            else if (this.InputType == FieldInputType.MultiText)
            {
                // convert the string wrapper to string
                if (this.ValueList != null)
                {
                    foreach (StringWrapper value in this.ValueList)
                    {
                        if ((value != null) && (!string.IsNullOrWhiteSpace(value.Value)))
                        {
                            result.Add(value.Value);
                        }
                    }
                }
            }
            else if (this.InputType == FieldInputType.Boolean)
            {
                result.Add(this.StringValue.Trim());
            }
            return result;
        }
    }
}
