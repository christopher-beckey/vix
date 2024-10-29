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
using System.ComponentModel;
using System.Collections.ObjectModel;
using VistA.Imaging.Telepathology.Common.Model;
using VistA.Imaging.Telepathology.Worklist.Messages;
using GalaSoft.MvvmLight.Command;

namespace VistA.Imaging.Telepathology.Worklist.ViewModel
{
    public class SettingsViewModel : WorkspaceViewModel
    {
        SettingsCategory _worklistFiltersSettingsCategory = null;

        private readonly ObservableCollection<SettingsCategory> _categories = new ObservableCollection<SettingsCategory>();
        public ObservableCollection<SettingsCategory> Categories
        {
            get { return _categories; }
        }

        public SettingsViewModel()
        {
            //GeneralSettingsViewModel generalSettingsViewModel = new GeneralSettingsViewModel();
            //SettingsCategory settingsCategory = new SettingsCategory { Title = "General", Data = generalSettingsViewModel };
            //Categories.Add(settingsCategory);

            // create placeholder for new filter
            WorkListFilter worklistFilter = new WorkListFilter();
            worklistFilter.SetDefaultParameters();
            WorklistFilterEditSettingsViewModel worklistFilterEditSettingsViewModel = new WorklistFilterEditSettingsViewModel(worklistFilter);
            worklistFilterEditSettingsViewModel.IsDeletable = false;
            worklistFilterEditSettingsViewModel.IsEditable = false;
            SettingsCategory settingsCategory = new SettingsCategory { Title = "Worklist Filters", Data = worklistFilterEditSettingsViewModel };
            Categories.Add(settingsCategory);
            _worklistFiltersSettingsCategory = settingsCategory;

            RefreshWorklistFilters(null);

            AppMessages.WorklistFilterListChangedMessage.Register(
                    this,
                    (action) => this.OnWorklistFilterListChanged(action));

            AppMessages.WorklistFilterNewMessage.Register(
                    this,
                    (action) => this.OnNewWorklist());

            //ApplyCommand = new RelayCommand(OnApply,
            //        () => (generalSettingsViewModel.IsChanged));

            this.SelectedItem = settingsCategory;
        }

        public SettingsCategory SelectedItem { get; set; }

        void OnNewWorklist()
        {
            // clear the blank filter form
            ((WorklistFilterEditSettingsViewModel)_worklistFiltersSettingsCategory.Data).SetNewMode();

            // make it current
            _worklistFiltersSettingsCategory.IsSelected = true;
        }

        void OnWorklistFilterListChanged(WorkListFilter filter)
        {
            RefreshWorklistFilters(filter);
        }

        public void RefreshWorklistFilters(WorkListFilter currentFilter)
        {
            _worklistFiltersSettingsCategory.Children.Clear();

            // add worklist filters
            foreach (WorkListFilter item in UserPreferences.Instance.WorklistPreferences.WorklistFilters)
            {
                // ignore adhoc filter
                if (item.Kind != WorkListFilter.WorkListFilterKind.AdHoc)
                {
                    WorklistFilterEditSettingsViewModel worklistFilterEditSettingsViewModel = new WorklistFilterEditSettingsViewModel(item);
                    worklistFilterEditSettingsViewModel.IsDeletable = true;
                    worklistFilterEditSettingsViewModel.IsEditable = false;

                    _worklistFiltersSettingsCategory.Children.Add(new SettingsCategory { Title = item.Name, Data = worklistFilterEditSettingsViewModel });
                }
            }
        }

        public RelayCommand ApplyCommand
        {
            get;
            private set;
        }

        public bool CanSave { get; set; }

        void OnApply()
        {
        }
    }
}
