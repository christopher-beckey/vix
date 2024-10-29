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
using GalaSoft.MvvmLight.Command;
using System.Windows;

namespace VistA.Imaging.Telepathology.Worklist.ViewModel
{
    public class WorklistFilterEditViewModel : WorkspaceViewModel
    {
        public event Action RequestApply;

        WorklistFilterDetailsViewModel _worklistFilterDetailsViewModel = null;
        public WorklistFilterDetailsViewModel ChildViewModel { get { return _worklistFilterDetailsViewModel; } }

        public WorkListFilter Filter { get; set; }

        public WorklistFilterEditViewModel(WorkListFilter filter)
        {
            this.Filter = filter;

            _worklistFilterDetailsViewModel = new WorklistFilterDetailsViewModel(filter);

            ApplyCommand = new RelayCommand(OnApply);
            ClearCommand = new RelayCommand(() => { _worklistFilterDetailsViewModel.Clear(); });
        }

        public RelayCommand ApplyCommand
        {
            get;
            private set;
        }

        public RelayCommand ClearCommand
        {
            get;
            private set;
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
                                if ((DateTime.Compare(date1, DateTime.Today) > 0) || (DateTime.Compare(date2, DateTime.Today) > 0))
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

        void OnApply()
        {
            if (!ValidateFilterParameters())
            {
                return;
            }

            // save filter details
            _worklistFilterDetailsViewModel.Save();

            if (RequestApply != null)
            {
                RequestApply();
            }
        }
    }
}
