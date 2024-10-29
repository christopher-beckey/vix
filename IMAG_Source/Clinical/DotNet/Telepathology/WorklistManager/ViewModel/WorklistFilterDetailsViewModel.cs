/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 1/9/2012
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Paul Pentapaty
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
 * 
 */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using GalaSoft.MvvmLight;
using System.Collections.ObjectModel;
using VistA.Imaging.Telepathology.Common.Model;

namespace VistA.Imaging.Telepathology.Worklist.ViewModel
{
    public class WorklistFilterParameterViewModel : ViewModelBase
    {
        public string FieldName { get; set; }
        public Boolean IsDate { get; set; }
        public Boolean IsMultiValued { get; set; }
        public Boolean IsSingleValued { get; set; }
        public Boolean IsBoolean { get; set; }
        public Boolean IsReportStatus { get; set; }
        public Boolean IsNumber { get; set; }

        public ObservableCollection<string> Values { get; set; }
        public string Value1 { get; set; }
        public string Value2 { get; set; }

        public ObservableCollection<WorkListFilterParameter.OperatorType> Operators { get; set; }
        public WorkListFilterParameter.OperatorType Operator { get; set; }

        WorkListFilterParameter _filterParameter = null;

        public WorklistFilterParameterViewModel(WorkListFilterParameter filterParameter)
        {
            Operators = new ObservableCollection<WorkListFilterParameter.OperatorType>();
            Values = new ObservableCollection<string>();

            _filterParameter = filterParameter;

            FieldName = WorkListFilterParameter.ConvertEnumToString(_filterParameter.Field);
            Operator = _filterParameter.Operator;
            
            if (_filterParameter.Type == WorkListFilterParameter.ValueType.Date)
            {
                IsDate = true;
                Operators.Add(WorkListFilterParameter.OperatorType.IsEqualTo);
                Operators.Add(WorkListFilterParameter.OperatorType.IsToday);
                Operators.Add(WorkListFilterParameter.OperatorType.IsBetween);
                Operators.Add(WorkListFilterParameter.OperatorType.IsEarlierThan);
                Operators.Add(WorkListFilterParameter.OperatorType.IsLaterThan);

                if (Operator == WorkListFilterParameter.OperatorType.None)
                {
                    Operator = WorkListFilterParameter.OperatorType.IsBetween;
                }
            }
            else if (_filterParameter.Type == WorkListFilterParameter.ValueType.SingleValueText)
            {
                IsSingleValued = true;
                Operators.Add(WorkListFilterParameter.OperatorType.IsEqualTo);
                Operators.Add(WorkListFilterParameter.OperatorType.IsNotEqualTo);
                Operators.Add(WorkListFilterParameter.OperatorType.Contains);
                Operators.Add(WorkListFilterParameter.OperatorType.DoesNotContain);
                //Operators.Add(WorkListFilterParameter.OperatorType.IsOneOf);
                //Operators.Add(WorkListFilterParameter.OperatorType.IsNoneOf);

                if (Operator == WorkListFilterParameter.OperatorType.None)
                {
                    Operator = WorkListFilterParameter.OperatorType.Contains;
                }
            }
            else if (_filterParameter.Type == WorkListFilterParameter.ValueType.SingleValueNumber)
            {
                IsNumber = true;
                IsSingleValued = true;
                Operators.Add(WorkListFilterParameter.OperatorType.IsEqualTo);
                Operators.Add(WorkListFilterParameter.OperatorType.IsNotEqualTo);
                Operators.Add(WorkListFilterParameter.OperatorType.IsGreaterThan);
                Operators.Add(WorkListFilterParameter.OperatorType.IsLessThan);

                if (Operator == WorkListFilterParameter.OperatorType.None)
                    Operator = WorkListFilterParameter.OperatorType.IsEqualTo;
            }
            else if (_filterParameter.Type == WorkListFilterParameter.ValueType.YesNo)
            {
                this.IsMultiValued = true;
                this.IsBoolean = true;
                Operators.Add(WorkListFilterParameter.OperatorType.IsEqualTo);

                if (Operator == WorkListFilterParameter.OperatorType.None)
                {
                    Operator = WorkListFilterParameter.OperatorType.IsEqualTo;
                }

                Values.Add("");
                Values.Add("Yes");
                Values.Add("No");
            }
            else if (_filterParameter.Type == WorkListFilterParameter.ValueType.ReportStatus)
            {
                this.IsMultiValued = true;
                this.IsReportStatus = true;
                Operators.Add(WorkListFilterParameter.OperatorType.IsEqualTo);

                if (Operator == WorkListFilterParameter.OperatorType.None)
                {
                    Operator = WorkListFilterParameter.OperatorType.IsEqualTo;
                }

                Values.Add("");
                Values.Add("In Progress");
                Values.Add("Pending Verification");
                Values.Add("Released");

            }

            Value1 = _filterParameter.Value1;
            Value2 = _filterParameter.Value2;
        }

        public void Save()
        {
            _filterParameter.Operator = Operator;
            _filterParameter.Value1 = Value1;
            _filterParameter.Value2 = Value2;
        }
    }


    public class WorklistFilterDetailsViewModel : ViewModelBase
    {
        WorkListFilter _worklistFilter = null;

        ObservableCollection<WorklistFilterParameterViewModel> _filterParameters = new ObservableCollection<WorklistFilterParameterViewModel>();
        public ObservableCollection<WorklistFilterParameterViewModel> FilterParameters
        {
            get
            {
                return _filterParameters;
            }
        }

        public WorklistFilterDetailsViewModel(WorkListFilter worklistFilter)
        {
            IsEditable = true;
            _worklistFilter = worklistFilter;

            foreach (WorkListFilterParameter item in _worklistFilter.Parameters)
            {
                FilterParameters.Add(new WorklistFilterParameterViewModel(item));
            }
        }

        public bool IsEditable { get; set; }

        public void Save()
        {
            // update the model
            foreach (WorklistFilterParameterViewModel item in FilterParameters)
            {
                item.Save();
            }
        }

        public void Clear()
        {
            _worklistFilter.SetDefaultParameters();
            FilterParameters.Clear();

            foreach (WorkListFilterParameter item in _worklistFilter.Parameters)
            {
                FilterParameters.Add(new WorklistFilterParameterViewModel(item));
            }
        }
    }
}
