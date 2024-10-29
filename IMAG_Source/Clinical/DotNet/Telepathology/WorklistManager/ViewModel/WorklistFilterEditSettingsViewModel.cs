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
using VistA.Imaging.Telepathology.Common.Model;
using GalaSoft.MvvmLight.Command;
using VistA.Imaging.Telepathology.Worklist.Messages;
using System.Windows;
using VistA.Imaging.Telepathology.Logging;

namespace VistA.Imaging.Telepathology.Worklist.ViewModel
{
    public class WorklistFilterEditSettingsViewModel : ViewModelBase
    {
        private static MagLogger Log = new MagLogger(typeof(WorklistFilterEditSettingsViewModel));

        WorklistFilterDetailsViewModel _worklistFilterDetailsViewModel = null;
        public WorklistFilterDetailsViewModel ChildViewModel { get { return _worklistFilterDetailsViewModel; } }

        public enum EditState
        {
            None,
            New,
            Edit
        }

        public WorkListFilter Filter { get; set; }
        public bool IsDeletable { get; set; }
        public EditState State { get; set; }
        public string FilterName { get; set; }

        bool _isEditable = false;
        public bool IsEditable
        {
            get
            {
                return _isEditable;
            }

            set
            {
                _isEditable = value;

                if (_worklistFilterDetailsViewModel != null)
                {
                    _worklistFilterDetailsViewModel.IsEditable = _isEditable;
                }
            }
        }

        public bool IsFilterNameReadOnly
        {
            get
            {
                if (State == EditState.Edit)
                    return true;
                return false;
            }
        }

        public bool IsFilterNameEnable
        {
            get
            {
                if (State != EditState.New)
                    return false;
                return true;
            }
        }

        public WorklistFilterEditSettingsViewModel(WorkListFilter filter)
        {
            this.IsDeletable = true;
            this.IsEditable = true;
            this.Filter = filter;
            this.State = EditState.None;
            this.FilterName = filter.Name;

            _worklistFilterDetailsViewModel = new WorklistFilterDetailsViewModel(filter);

            NewCommand = new RelayCommand(OnNew,
                () => ((State == EditState.None) && (string.IsNullOrEmpty(this.FilterName))));

            EditCommand = new RelayCommand(OnEdit,
                () => (IsDeletable && (State == EditState.None)));

            SaveCommand = new RelayCommand(OnSave,
                () => ((State != EditState.None)));

            CancelCommand = new RelayCommand(OnCancel,
                () => ((State != EditState.None)));

            DeleteCommand = new RelayCommand(OnDelete,
                () => (IsDeletable && (State == EditState.None)));
        }

        public RelayCommand NewCommand
        {
            get;
            private set;
        }

        public RelayCommand EditCommand
        {
            get;
            private set;
        }

        public RelayCommand SaveCommand
        {
            get;
            private set;
        }

        public RelayCommand CancelCommand
        {
            get;
            private set;
        }

        public RelayCommand DeleteCommand
        {
            get;
            private set;
        }

        void OnNew()
        {
            // broadcast event, so that the parent will display blank form
            AppMessages.WorklistFilterNewMessage.Send(this);
        }

        public void SetNewMode()
        {
            // clear current filter
            this.Filter.Name = "";

            // set as stored filter
            this.Filter.Kind = WorkListFilter.WorkListFilterKind.Stored;

            _worklistFilterDetailsViewModel.Clear();

            IsEditable = true;
            State = EditState.New;
            //RaisePropertyChanged("IsFilterNameReadOnly");
        }

        void OnEdit()
        {
            IsEditable = true;
            State = EditState.Edit;
            //RaisePropertyChanged("IsFilterNameReadOnly");
        }

        private bool ValidateFilterParameters()
        {
            // go through each parameter and check for values
            foreach (WorklistFilterParameterViewModel param in _worklistFilterDetailsViewModel.FilterParameters)
            {
                // only check if both values are not null.
                if ((param.Value1 != null) || (param.Value2 != null))
                {
                    // if parameter is date type
                    if (param.IsDate)
                    {
                        switch (param.Operator)
                        {
                            case WorkListFilterParameter.OperatorType.IsEqualTo:
                                if (param.Value1 == null)
                                {
                                    MessageBox.Show("Please enter value for the first date entry.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                                    return false;
                                }

                                // check to see if future date is being used
                                if (DateTime.Compare(DateTime.Parse(param.Value1), DateTime.Today) > 0)
                                {
                                    MessageBox.Show("You cannot use future date.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                                    return false;
                                }
                                break;
                            case WorkListFilterParameter.OperatorType.IsBetween:
                                // check to see both dates are entered
                                if ((param.Value1 == null) || (param.Value2 == null))
                                {
                                    MessageBox.Show("Please enter value for both date entries.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                                    return false;
                                }

                                // check to see if date1 is before date2
                                DateTime date1 = DateTime.Parse(param.Value1);
                                DateTime date2 = DateTime.Parse(param.Value2);

                                // check to see if future date is being used
                                if ((DateTime.Compare(date1, DateTime.Today) > 0) || (DateTime.Compare(date2, DateTime.Today)) > 0)
                                {
                                    MessageBox.Show("You cannot use future date.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                                    return false;
                                }

                                if (DateTime.Compare(date1, date2) >= 0)
                                {
                                    MessageBox.Show("The first date must be before the second date.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                                    return false;
                                }

                                break;
                            case WorkListFilterParameter.OperatorType.IsEarlierThan:
                            case WorkListFilterParameter.OperatorType.IsLaterThan:
                                if (param.Value1 == null)
                                {
                                    MessageBox.Show("Please enter value for the first date entry.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                                    return false;
                                }

                                // check to see if future date is being used
                                if (DateTime.Compare(DateTime.Parse(param.Value1), DateTime.Today) > 0)
                                {
                                    MessageBox.Show("You cannot use future date.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                                    return false;
                                }

                                break;
                            default:
                                break;
                        }
                    }
                    else if (param.IsBoolean)
                    {
                        if ((!string.IsNullOrWhiteSpace(param.Value1))
                                && (param.Value1 != "Yes") && (param.Value1 != "No"))
                        {
                            MessageBox.Show("Value must match value in the dropdown options or leave blank.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                            return false;
                        }
                    }
                    else if (param.IsReportStatus)
                    {
                        if ((!string.IsNullOrWhiteSpace(param.Value1))
                                && (param.Value1 != "In Progress") 
                                        && (param.Value1 != "Pending Verification") 
                                        && (param.Value1 != "Released"))
                        {
                            MessageBox.Show("Value must match value in the dropdown options or leave blank.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                            return false;
                        }
                    }
                    else if (param.IsNumber)
                    {
                        if (!string.IsNullOrWhiteSpace(param.Value1))
                        {
                            int val1;
                            bool isNumber = Int32.TryParse(param.Value1, out val1);
                            if ((!isNumber) || (val1 < 0))
                            {
                                MessageBox.Show("Value must be a valid number greater than or equal to 0.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                                return false;
                            }
                        }
                    }
                }
            }
            return true;
        }

        void OnSave()
        {
            // validate parameters before saving
            if (!ValidateFilterParameters())
            {
                return;
            }

            // check for unique name
            if (string.IsNullOrWhiteSpace(FilterName))
            {
                MessageBox.Show("Please enter a name for the filter.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            FilterName = FilterName.Trim();
            try
            {
                var filter = UserPreferences.Instance.WorklistPreferences.WorklistFilters.Where(f => f.Name == FilterName).FirstOrDefault();
                if ((filter != null) && (State == EditState.New))
                {
                    MessageBox.Show("The name is already used by a different filter. Please choose a different one.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                    return;
                }
            }
            finally { }
            

            // save current filter
            this.Filter.Name = FilterName;
            _worklistFilterDetailsViewModel.Save();

            // update settings 
            UserPreferences.Instance.WorklistPreferences.AddUpdateWorklistFilter((this.State == EditState.New) ? (WorkListFilter)this.Filter.Clone() : this.Filter);

            IsEditable = false;
            if (State == EditState.New)
                _worklistFilterDetailsViewModel.Clear();
            State = EditState.None;
            //_worklistFilterDetailsViewModel.Clear();
            this.FilterName = "";
            //RaisePropertyChanged("IsFilterNameReadOnly");

            Log.Info("Saved changes to the filter preferences.");
        }

        void OnCancel()
        {
            if (State == EditState.New)
            {
                _worklistFilterDetailsViewModel.Clear();
                this.FilterName = "";
            }
            IsEditable = false;
            State = EditState.None;
            
            //RaisePropertyChanged("IsFilterNameReadOnly");
        }

        void OnDelete()
        {
            MessageBoxResult result = MessageBox.Show("Are you sure you want to delete the selected filter?", "Information",
                                                        MessageBoxButton.OKCancel, MessageBoxImage.Question, MessageBoxResult.Cancel);
            if (result == MessageBoxResult.Cancel)
                return;

            IsEditable = false;
            State = EditState.None;
            //RaisePropertyChanged("IsFilterNameReadOnly");
            // update settings 
            Log.Info("Removed " + this.Filter.Name + " from the filter list.");
            UserPreferences.Instance.WorklistPreferences.DeleteWorklistFilter(this.Filter);
        }
    }
}
