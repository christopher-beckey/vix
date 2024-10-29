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
using VistA.Imaging.Telepathology.Common.Model;
using System.Collections.ObjectModel;
using System.ComponentModel;
using GalaSoft.MvvmLight;
using VistA.Imaging.Telepathology.Worklist.Messages;
using GalaSoft.MvvmLight.Command;

namespace VistA.Imaging.Telepathology.Worklist.ViewModel
{
    public class WorklistFilterViewModel : ViewModelBase
    {
        public WorkListFilter _adhocFilter = null;
        public WorkListFilter _currentFilter = null;
        public WorkListFilter CurrentFilter
        {
            get { return _currentFilter; }

            set
            {
                //if (_currentFilter != value)
                {
                    _currentFilter = value;

                    // broadcast change in current filter
                    //AppMessages.WorklistFilterChangeMessage.Send(_currentFilter);

                    this.UpdateDescription();

                    RaisePropertyChanged("CurrentFilter");
                    RaisePropertyChanged("FilterDescription");
                }
            }
        }

        ObservableCollection<WorkListFilter> _filters = null;
        public ObservableCollection<WorkListFilter> Filters { get { return _filters; } }

        public ExamListViewType ExamlistType { get; set; }

        public WorklistFilterViewModel(ExamListViewType examlistType)
        {
            this.ExamlistType = examlistType;

            this.UpdateDescription();

            EditFilterCommand = new RelayCommand(OnEditFilter,
                () => (CurrentFilter != null));

            ClearFilterCommand = new RelayCommand(OnClearFilter,
                () => (CurrentFilter != null));

            // initialize when application is initialized
            AppMessages.ApplicationInitializedMessage.Register(
                    this,
                    (action) => Initialize());

            // re-initialize when worklist filter list has changed
            AppMessages.WorklistFilterListChangedMessage.Register(
                    this,
                    (action) => Initialize());
        }

        public void Initialize()
        {
            this._filters = new ObservableCollection<WorkListFilter>();
            foreach (WorkListFilter item in UserPreferences.Instance.WorklistPreferences.WorklistFilters)
            {
                this._filters.Add((WorkListFilter)item.Clone());
            }

            _adhocFilter = _filters.FirstOrDefault(x => x.Kind == WorkListFilter.WorkListFilterKind.AdHoc);
            if (_adhocFilter == null)
            {
                _adhocFilter = new WorkListFilter { Kind = WorkListFilter.WorkListFilterKind.AdHoc, Name = "None" };

                if (_filters != null)
                {
                    _filters.Insert(0, _adhocFilter);
                }
            }

            _adhocFilter.SetDefaultParameters();
            CurrentFilter = _adhocFilter;

            RaisePropertyChanged("Filters");
            RaisePropertyChanged("CurrentFilter");
            RaisePropertyChanged("FilterDescription");

        }

        private void UpdateDescription()
        {
            string text;

            switch (this.ExamlistType)
            {
                case ExamListViewType.Unread: text = "Unread Cases"; break;
                case ExamListViewType.Patient: text = "Patient Cases"; break;
                case ExamListViewType.Read: text = "Read Cases"; break;
                default: text = "All Cases"; break;
            }

            if (_currentFilter != null)
            {
                foreach (WorkListFilterParameter param in _currentFilter.Parameters)
                {
                    if (param.IsValid)
                    {
                        switch (param.Operator)
                        {
                            case WorkListFilterParameter.OperatorType.IsToday:
                                text = text + string.Format(" -> {0} : Today", WorkListFilterParameter.ConvertEnumToString(param.Field));
                                break;
                            case WorkListFilterParameter.OperatorType.IsEqualTo:
                                text = text + string.Format(" -> {0} : {1}", WorkListFilterParameter.ConvertEnumToString(param.Field), param.Value1);
                                break;
                            case WorkListFilterParameter.OperatorType.IsNotEqualTo:
                                text = text + string.Format(" -> {0} : Not {1}", WorkListFilterParameter.ConvertEnumToString(param.Field), param.Value1);
                                break;
                            case WorkListFilterParameter.OperatorType.IsBetween:
                                text = text + string.Format(" -> {0} : {1} - {2}", WorkListFilterParameter.ConvertEnumToString(param.Field), param.Value1, param.Value2);
                                break;
                            case WorkListFilterParameter.OperatorType.IsEarlierThan:
                            case WorkListFilterParameter.OperatorType.IsLessThan:
                                text = text + string.Format(" -> {0} : < {1}", WorkListFilterParameter.ConvertEnumToString(param.Field), param.Value1);
                                break;
                            case WorkListFilterParameter.OperatorType.IsLaterThan:
                            case WorkListFilterParameter.OperatorType.IsGreaterThan:
                                text = text + string.Format(" -> {0} : > {1}", WorkListFilterParameter.ConvertEnumToString(param.Field), param.Value1);
                                break;
                            case WorkListFilterParameter.OperatorType.Contains:
                                text = text + string.Format(" -> {0} : *{1}*", WorkListFilterParameter.ConvertEnumToString(param.Field), param.Value1);
                                break;
                            case WorkListFilterParameter.OperatorType.DoesNotContain:
                                text = text + string.Format(" -> {0} : Not *{1}*", WorkListFilterParameter.ConvertEnumToString(param.Field), param.Value1);
                                break;
                            case WorkListFilterParameter.OperatorType.StartsWith:
                                text = text + string.Format(" -> {0} : {1}*", WorkListFilterParameter.ConvertEnumToString(param.Field), param.Value1);
                                break;
                            case WorkListFilterParameter.OperatorType.IsNotNull:
                                text = text + string.Format(" -> {0} : Not Empty", WorkListFilterParameter.ConvertEnumToString(param.Field), param.Value1);
                                break;
                        }
                    }
                }
            }

            this.FilterDescription = text;
        }

        public string FilterDescription { get; set; }

        public RelayCommand EditFilterCommand
        {
            get;
            private set;
        }

        void OnEditFilter()
        {
            WorkListFilter filter = (WorkListFilter) CurrentFilter.Clone();

            if (AppMessages.ActiveWorklistFilterEditMessage.Send(filter))
            {
                // when a filter is edited it becomes and adhoc filter.
                filter.CopyTo(_adhocFilter);
                _adhocFilter.Kind = WorkListFilter.WorkListFilterKind.AdHoc;
                _adhocFilter.Name = "None";

                CurrentFilter = _adhocFilter;
            }
        }

        public RelayCommand ClearFilterCommand
        {
            get;
            private set;
        }

        void OnClearFilter()
        {
            _adhocFilter.Kind = WorkListFilter.WorkListFilterKind.AdHoc;
            _adhocFilter.Name = "None";
            _adhocFilter.SetDefaultParameters();

            CurrentFilter = _adhocFilter;
        }
    }
}
