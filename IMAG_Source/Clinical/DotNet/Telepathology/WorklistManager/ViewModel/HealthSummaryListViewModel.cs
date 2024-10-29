// -----------------------------------------------------------------------
// <copyright file="HealthSummaryListViewModel.cs" company="Patriot Technologies">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Worklist.ViewModel
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
using System.Collections.ObjectModel;
    using VistA.Imaging.Telepathology.Common.Model;
    using GalaSoft.MvvmLight.Command;
    using VistA.Imaging.Telepathology.Worklist.Messages;
    using System.Windows;
    using VistA.Imaging.Telepathology.Logging;

    public class HealthSummaryTypeViewModel : WorkspaceViewModel
    {
        public HealthSummaryType Type { get; set; }

        public bool IsDefault { get; set; }

        public bool IsSelected { get; set; }

        public string DisplayName
        {
            get
            {
                if (this.Type == null)
                    return string.Empty;
                else
                {
                    if (this.IsDefault)
                        return string.Format("[{0}] {1} [DEFAULT]", this.Type.SiteID, this.Type.Name);
                    else
                        return string.Format("[{0}] {1}", this.Type.SiteID, this.Type.Name);
                }
            }
        }
    }

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class HealthSummaryListViewModel : WorkspaceViewModel
    {
        private static MagLogger Log = new MagLogger(typeof(HealthSummaryListViewModel));

        public ObservableCollection<HealthSummaryTypeViewModel> SelectedTypes { get; set; }

        public ObservableCollection<HealthSummaryTypeViewModel> AvailableTypes { get; set; }

        public HealthSummaryTypeViewModel SelectedSelType { get; set; }

        public HealthSummaryTypeViewModel SelectedAvlType { get; set; }

        public string PatientID { get; set; }

        public string PatientName { get; set; }

        public string PatientICN { get; set; }

        public string SiteName { get; set; }

        public Window Owner { get; set; }

        public bool IsModified = false;

        public HealthSummaryListViewModel(HealthSummaryTypeList availableTypes)
        {
            this.SelectedTypes = new ObservableCollection<HealthSummaryTypeViewModel>();
            HealthSummaryTypeList selectedTypes = UserPreferences.Instance.HealthSummaryPreferences.SelectedHealthSummaryTypeList;
            foreach (HealthSummaryType item in selectedTypes.Items)
            {
                this.SelectedTypes.Add(new HealthSummaryTypeViewModel
                {
                    Type = item,
                    IsDefault = (UserPreferences.Instance.HealthSummaryPreferences.DefaultHealthSummaryTypeID == item.ID)
                });
            }

            this.AvailableTypes = new ObservableCollection<HealthSummaryTypeViewModel>();
            foreach (HealthSummaryType item in availableTypes.Items)
            {
                this.AvailableTypes.Add(new HealthSummaryTypeViewModel 
                { 
                    Type = item,
                    IsSelected = (selectedTypes.Items.Where(x => (x.ID == item.ID)).FirstOrDefault() != null)
                });
            }

            this.ViewSelectedHealthSummaryCommand = new RelayCommand(ViewSelectedHealthSummary, () => CanViewSelectedHealthSummary());
            this.ViewAvailableHealthSummaryCommand = new RelayCommand(ViewAvailableHealthSummary, () => CanViewAvailableHealthSummary());
            this.RemoveSelectedHealthSummaryCommand = new RelayCommand(RemoveSelectedHealthSummary, () => CanRemoveSelectedHealthSummary());
            this.AddAvailableHealthSummaryCommand = new RelayCommand(AddAvailableHealthSummary, () => CanAddAvailableHealthSummary());
            this.SetDefaultHealthSummaryCommand = new RelayCommand(SetDefaultHealthSummary, () => CanSetDefaultHealthSummary());
            this.SaveCommand = new RelayCommand(SaveSettings, () => IsModified);
        }

        #region Commands

        #region View Selected Health Summary Command

        public RelayCommand ViewSelectedHealthSummaryCommand { get; private set; }

        public void ViewSelectedHealthSummary()
        {
            if (this.SelectedSelType != null)
            {
                ViewHealthSummary(this.SelectedSelType);
            }
        }

        public bool CanViewSelectedHealthSummary()
        {
            return (this.SelectedSelType != null);
        }

        #endregion

        #region View Available Health Summary Command

        public RelayCommand ViewAvailableHealthSummaryCommand { get; private set; }

        public void ViewAvailableHealthSummary()
        {
            if (this.SelectedAvlType != null)
            {
                ViewHealthSummary(this.SelectedAvlType);
            }
        }

        public bool CanViewAvailableHealthSummary()
        {
            return (this.SelectedAvlType != null);
        }

        #endregion

        #region Remove Selected Health Summary Command

        public RelayCommand RemoveSelectedHealthSummaryCommand { get; private set; }

        public void RemoveSelectedHealthSummary()
        {
            // remove from selected list
            if (this.SelectedSelType != null)
            {
                HealthSummaryTypeViewModel itemVM = this.SelectedSelType;

                this.SelectedTypes.Remove(this.SelectedSelType);
                this.SelectedSelType = null;

                // set as not selected
                HealthSummaryTypeViewModel itemAvlVM = this.AvailableTypes.Where(x => (x.Type.ID == itemVM.Type.ID)).FirstOrDefault();
                if (itemAvlVM != null)
                {
                    itemAvlVM.IsSelected = false;
                }

                // set the session has changed
                IsModified = true;
            }
        }

        public bool CanRemoveSelectedHealthSummary()
        {
            return (this.SelectedSelType != null);
        }

        #endregion

        #region Add Available Health Summary Command

        public RelayCommand AddAvailableHealthSummaryCommand { get; private set; }

        public void AddAvailableHealthSummary()
        {
            if ((this.SelectedAvlType != null) && (!this.SelectedAvlType.IsSelected))
            {
                this.SelectedTypes.Add(new HealthSummaryTypeViewModel 
                {
                    IsSelected = true,
                    Type = this.SelectedAvlType.Type
                });

                this.SelectedAvlType.IsSelected = true;

                IsModified = true;
            }
        }

        public bool CanAddAvailableHealthSummary()
        {
            return ((this.SelectedAvlType != null) && (!this.SelectedAvlType.IsSelected));
        }

        #endregion

        #region Set Default Health Summary Command

        public RelayCommand SetDefaultHealthSummaryCommand { get; private set; }

        public void SetDefaultHealthSummary()
        {
            if (this.SelectedSelType != null)
            {
                // clear existing default
                HealthSummaryTypeViewModel itemVM = this.SelectedTypes.Where(x => x.IsDefault).FirstOrDefault();
                if (itemVM != null)
                {
                    itemVM.IsDefault = false;
                }

                this.SelectedSelType.IsDefault = true;
            }

            IsModified = true;
        }

        public bool CanSetDefaultHealthSummary()
        {
            return ((this.SelectedSelType != null) && (!this.SelectedSelType.IsDefault));
        }

        #endregion

        #region Save Command

        public RelayCommand SaveCommand { get; private set; }

        private void SaveSettings()
        {
            // save selected items
            HealthSummaryTypeList selectedTypes = UserPreferences.Instance.HealthSummaryPreferences.SelectedHealthSummaryTypeList;
            selectedTypes.Items.Clear();

            foreach (HealthSummaryTypeViewModel itemVM in this.SelectedTypes)
            {
                selectedTypes.Items.Add(itemVM.Type);

                // set default
                if (itemVM.IsDefault)
                {
                    UserPreferences.Instance.HealthSummaryPreferences.DefaultHealthSummaryTypeID = itemVM.Type.ID;
                }
            }

            IsModified = false;

            Log.Info("Saved changes to health summary preferences.");
        }

        #endregion

        #endregion

        private void ViewHealthSummary(HealthSummaryTypeViewModel itemVM)
        {
            AppMessages.ViewHealthSummaryMessage.Send(new AppMessages.ViewHealthSummaryMessage.MessageData
            {
                HealthSummaryType = itemVM.Type,
                SiteName = this.SiteName,
                PatientICN = this.PatientICN,
                PatientID = this.PatientID,
                PatientName = this.PatientName,
                Owner = this.Owner
            });
        }

        public override void Close()
        {
            //if (IsModified)
            //{
            //    MessageBoxResult result = MessageBox.Show("The health summary settings has been modified. Do you want to save the changes?",
            //                                                "Confirmation", MessageBoxButton.YesNoCancel, MessageBoxImage.Question, MessageBoxResult.Cancel);
            //    if (result == MessageBoxResult.Yes)
            //    {
            //        SaveSettings();
            //    }
            //    else if (result == MessageBoxResult.Cancel)
            //    {
            //        return;
            //    }
            //}

            base.Close();
        }

    }
}
