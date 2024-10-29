namespace VistA.Imaging.Telepathology.Configurator.ViewModels
{
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Linq;
    using System.Windows;
    using System.Windows.Threading;
    using GalaSoft.MvvmLight;
    using GalaSoft.MvvmLight.Command;
    using VistA.Imaging.Telepathology.Common.Exceptions;
    using VistA.Imaging.Telepathology.Common.Model;
    using VistA.Imaging.Telepathology.Logging;
    using VistA.Imaging.Telepathology.Configurator.DataSource;

    public class ReportTemplateViewModel : ViewModelBase, INotifyPropertyChanged
    {
        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(string info)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(info));
            }
        }

        private static MagLogger Log = new MagLogger(typeof(ReportTemplateViewModel));

        private ReportSettings repModel = new ReportSettings();

        private ReportTemplate selectedTemplate;

        public bool IsChanged { get; set; }

        public ReportTemplateViewModel()
        {
            AvailableList = new ObservableCollection<ReportFieldTemplate>();
            DisplayList = new BindingList<ReportFieldTemplate>();
            RequireList = new ObservableCollection<ReportFieldTemplate>();
            
            selectedTemplate = null;

            MoveFieldToDisplayListCommand = new RelayCommand(MoveFieldToDisplayList, () => (SelectedAvailableField != null));
            MoveFieldOffDisplayListCommand = new RelayCommand(MoveFieldOffDisplayList, () => (SelectedDisplayField != null));
            MoveFieldToRequireListCommand = new RelayCommand(MoveFieldToRequireList, () => (SelectedDisplayField != null));
            MoveFieldOffRequireListCommand = new RelayCommand(MoveFieldOffRequiredList, () => (SelectedRequiredField != null));
            MoveFieldUpDisplayListCommand = new RelayCommand(MoveFieldUpDisplayList, () => (SelectedDisplayField != null));
            MoveFieldDownDisplayListCommand = new RelayCommand(MoveFieldDownDisplayList, () => (SelectedDisplayField != null));

            SaveSelectedReportTemplateCommand = new RelayCommand(SaveSelectedReportTemplate, () => (this.DataSource != null));
        }

        public ReportTemplateViewModel(IConfiguratorDatasource source)
        {
            DataSource = source;

            repModel.Templates = DataSource.GetReportTemplates(UserContext.LocalSite.PrimarySiteStationNUmber);

            AvailableList = new ObservableCollection<ReportFieldTemplate>();
            DisplayList = new BindingList<ReportFieldTemplate>();
            RequireList = new ObservableCollection<ReportFieldTemplate>();
            
            selectedTemplate = null;

            MoveFieldToDisplayListCommand = new RelayCommand(MoveFieldToDisplayList, () => (SelectedAvailableField != null));
            MoveFieldOffDisplayListCommand = new RelayCommand(MoveFieldOffDisplayList, () => (SelectedDisplayField != null));
            MoveFieldToRequireListCommand = new RelayCommand(MoveFieldToRequireList, () => (SelectedDisplayField != null));
            MoveFieldOffRequireListCommand = new RelayCommand(MoveFieldOffRequiredList, () => (SelectedRequiredField != null));
            MoveFieldUpDisplayListCommand = new RelayCommand(MoveFieldUpDisplayList, () => (SelectedDisplayField != null));
            MoveFieldDownDisplayListCommand = new RelayCommand(MoveFieldDownDisplayList, () => (SelectedDisplayField != null));

            SaveSelectedReportTemplateCommand = new RelayCommand(SaveSelectedReportTemplate, () => (this.DataSource != null) && (this.IsChanged));
            ResetTemplateChangesCommand = new RelayCommand(ResetTemplateChanges, () => (this.DataSource != null) && (this.IsChanged));
        }

        public IConfiguratorDatasource DataSource { get; set; }

        public ObservableCollection<ReportFieldTemplate> AvailableList { get; set; }

        public BindingList<ReportFieldTemplate> DisplayList { get; set; }

        public ObservableCollection<ReportFieldTemplate> RequireList { get; set; }

        public ReportFieldTemplate SelectedAvailableField { get; set; }

        public ReportFieldTemplate SelectedDisplayField { get; set; }

        public ReportFieldTemplate SelectedRequiredField { get; set; }

        public ObservableCollection<ReportTemplate> Templates
        {
            get
            {
                return repModel.Templates;
            }
        }
        
        public ReportTemplate SelectedTemplate
        {
            get
            {
                return selectedTemplate;
            }
            set
            {
                var origTemplate = this.selectedTemplate;

                if (selectedTemplate == value)
                    return;

                // change the value for now for WPF to query the value after the change
                selectedTemplate = value;

                if (this.IsChanged)
                {
                    MessageBox.Show("Changes to the current template must be saved first.", "Information",
                                    MessageBoxButton.OK, MessageBoxImage.Information);
                    if (Application.Current != null)
                    {
                        Application.Current.Dispatcher.BeginInvoke(new Action(() => { selectedTemplate = origTemplate; 
                                                                                      NotifyPropertyChanged("SelectedTemplate");}),
                                                                                  DispatcherPriority.Normal, null);
                        return;
                    }
                }

                // else continue change template
                ChangeReportTemplate();
                NotifyPropertyChanged("SelectedTemplate");
            }
        }

        public RelayCommand MoveFieldToDisplayListCommand
        {
            get;
            private set;
        }
        public RelayCommand MoveFieldOffDisplayListCommand
        {
            get;
            private set;
        }
        public RelayCommand MoveFieldToRequireListCommand
        {
            get;
            private set;
        }
        public RelayCommand MoveFieldOffRequireListCommand
        {
            get;
            private set;
        }
        public RelayCommand MoveFieldUpDisplayListCommand
        {
            get;
            private set;
        }
        public RelayCommand MoveFieldDownDisplayListCommand
        {
            get;
            private set;
        }

        public RelayCommand SaveSelectedReportTemplateCommand
        {
            get;
            private set;
        }
        public RelayCommand ResetTemplateChangesCommand
        {
            get;
            private set;
        }

        public void ChangeReportTemplate()
        {
            AvailableList.Clear();
            DisplayList.Clear();
            RequireList.Clear();

            if (selectedTemplate == null)
            {
                return;
            }

            List<ReportFieldTemplate> tempDisplay = new List<ReportFieldTemplate>();
            foreach (ReportFieldTemplate field in selectedTemplate.ReportFields)
            {
                switch (field.TemplateList)
                {
                    case ReportListType.Available:
                        AvailableList.Add(field);
                        break;
                    case ReportListType.Display:
                        tempDisplay.Add(field);
                        if ((field.IsRequired) || (field.AlwaysRequired))
                            RequireList.Add(field);
                        break;
                }
            }
            // sort the list of field based on display position
            Comparison<ReportFieldTemplate> compPos = new Comparison<ReportFieldTemplate>(ReportFieldTemplate.CompareFieldPosition);
            tempDisplay.Sort(compPos);
            foreach (ReportFieldTemplate field in tempDisplay)
                DisplayList.Add(field);
        }

        public void SaveSelectedReportTemplate()
        {
            if (selectedTemplate == null)
            {
                MessageBox.Show("Please select a template that you want to save.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            // save template to data base
            VixReportTemplateObject templateObj = new VixReportTemplateObject()
            {
                TemplateSite = UserContext.LocalSite.PrimarySiteStationNUmber,
                TemplateType = this.SelectedTemplate.ReportTypeShort,
                TemplateXML = this.SelectedTemplate.SerializeToXML()
            };

            try
            {
                this.DataSource.SaveReportTemplate(templateObj);
                this.IsChanged = false;
                Log.Info(string.Format("Changes to the {0} template has been saved to site {1}.",
                                       this.SelectedTemplate.TemplateLabel, UserContext.LocalSite.PrimarySiteStationNUmber));
            }
            catch (MagVixFailureException vfe)
            {
                Log.Error("Failed to save report template.", vfe);
                MessageBox.Show("Could not save report template. Please try again at a later time.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        public void ResetTemplateChanges()
        {
            var prevSelectedTemplate = this.SelectedTemplate;

            // reset the changes here
            if (DataSource != null)
            {
                repModel.Templates = DataSource.GetReportTemplates(UserContext.LocalSite.PrimarySiteStationNUmber);
                this.IsChanged = false;
                NotifyPropertyChanged("Templates");

                // reselect
                var newSelectedTemplate = this.Templates.Where(t => t.TemplateLabel == prevSelectedTemplate.TemplateLabel).FirstOrDefault();
                this.SelectedTemplate = newSelectedTemplate;
            }
        }

        public void MoveFieldToDisplayList()
        {
            if (SelectedAvailableField != null)
            {
                ReportFieldTemplate tempField = SelectedAvailableField;
                tempField.TemplateList = ReportListType.Display;
                tempField.DisplayPosition = DisplayList.Count + 1;
                AvailableList.Remove(SelectedAvailableField);
                DisplayList.Add(tempField);

                this.IsChanged = true;
            }
        }

        public void MoveFieldOffDisplayList()
        {
            if (SelectedDisplayField != null)
            {
                ReportFieldTemplate tempField = SelectedDisplayField;

                // check if the field is always required
                if (tempField.AlwaysRequired)
                {
                    MessageBox.Show(tempField.DisplayName + "is always required. You cannot remove it from the required list.",
                                   "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                    return;
                }

                tempField.TemplateList = ReportListType.Available;
                for (int i = DisplayList.IndexOf(SelectedDisplayField); i < DisplayList.Count; i++)
                    DisplayList[i].DisplayPosition--;

                tempField.DisplayPosition = 0;
                DisplayList.Remove(SelectedDisplayField);
                if (tempField.IsRequired)
                {
                    tempField.IsRequired = false;
                    RequireList.Remove(tempField);
                }

                AvailableList.Add(tempField);

                this.IsChanged = true;
            }
        }

        public void MoveFieldToRequireList()
        {
            if (SelectedDisplayField != null)
            {
                if (!SelectedDisplayField.IsRequired)
                {
                    SelectedDisplayField.IsRequired = true;
                    RequireList.Add(SelectedDisplayField);

                    this.IsChanged = true;
                }
            }
        }

        public void MoveFieldOffRequiredList()
        {
            if (SelectedRequiredField != null)
            {
                // check if the field is always required
                if (SelectedRequiredField.AlwaysRequired)
                {
                    MessageBox.Show(SelectedRequiredField.DisplayName + "is always required. You cannot remove it from the required list.",
                                    "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                    return;
                }

                SelectedRequiredField.IsRequired = false;
                RequireList.Remove(SelectedRequiredField);

                this.IsChanged = true;
            }
        }

        public void MoveFieldUpDisplayList()
        {
            // only apply to item at index 1 and later
            if (SelectedDisplayField != null)
            {
                int ind = DisplayList.IndexOf(SelectedDisplayField);
                if (ind > 0)
                {
                    ReportFieldTemplate prev = DisplayList[ind - 1];
                    ReportFieldTemplate curr = DisplayList[ind];
                    prev.DisplayPosition++;
                    curr.DisplayPosition--;

                    DisplayList[ind - 1] = curr;
                    DisplayList[ind] = prev;

                    this.IsChanged = true;
                }
            }
        }

        public void MoveFieldDownDisplayList()
        {
            // only apply to item at any except last one
            if (SelectedDisplayField != null)
            {
                int ind = DisplayList.IndexOf(SelectedDisplayField);
                if ((ind > -1) && (ind < DisplayList.Count - 1))
                {
                    ReportFieldTemplate next = DisplayList[ind + 1];
                    ReportFieldTemplate curr = DisplayList[ind];
                    next.DisplayPosition--;
                    curr.DisplayPosition++;

                    DisplayList[ind + 1] = curr;
                    DisplayList[ind] = next;

                    this.IsChanged = true;
                }
            }
        }
    }
}