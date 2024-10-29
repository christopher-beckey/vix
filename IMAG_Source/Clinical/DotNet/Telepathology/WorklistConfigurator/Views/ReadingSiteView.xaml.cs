using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Windows;
using VistA.Imaging.Telepathology.Common.Exceptions;
using VistA.Imaging.Telepathology.Common.Model;
using VistA.Imaging.Telepathology.Common.VixModels;
using VistA.Imaging.Telepathology.Logging;
using VistA.Imaging.Telepathology.Configurator.DataSource;

namespace VistA.Imaging.Telepathology.Configurator.Views
{
    public partial class ReadingSiteView : Window, INotifyPropertyChanged
    {
        private static MagLogger Log = new MagLogger(typeof(ReadingSiteView));

        private IConfiguratorDatasource DataSource;

        public ReadingSiteView()
        {
            IsModified = false;
            InitializeComponent();
        }

        public ReadingSiteView(IConfiguratorDatasource datasource)
        {
            //dmmn 5/9/12 - create a new view with data popuplated for adding new site
            IsModified = false;

            this.DataSource = datasource;
            //retrieve list of institutions from the local database
            if (this.DataSource != null)
                InstitutionList = datasource.GetInstitutionList();
            else
                InstitutionList = new ObservableCollection<SiteInfo>();

            //initialize binding information
            SelectedTypeIndex = -1;

            // preselect site list
            if (InstitutionList.Count < 1)
                SelectedInstitution = null;
            else
                SelectedInstitution = InstitutionList[0];

            InitializeComponent();
            
            //determine what view to be intialized
            SetEntryType(true);
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

        public ReadingSiteView(IConfiguratorDatasource datasource, ReadingSiteInfo readSite)
        {
            //dmmn 5/9/12 - create a new view with data popuplated for modifying old site
            IsModified = false;
            this.DataSource = datasource;
            readingSite = readSite;
            InstitutionList = new ObservableCollection<SiteInfo>();
            InstitutionList.Add(readingSite);
            SelectedInstitution = readingSite;

            switch (readingSite.SiteType)
            {
                case ReadingSiteType.interpretation:
                    SelectedTypeIndex = 0;
                    break;
                case ReadingSiteType.consultation:
                    SelectedTypeIndex = 1;
                    break;
                case ReadingSiteType.both:
                    SelectedTypeIndex = 2;
                    break;
            }
            IsSiteActive = readingSite.Active;

            InitializeComponent();
            SetEntryType(false);
        }

        private void SetEntryType(bool isAdding)
        {
            // change the view depends on adding or modifying a site
            if (isAdding)
            {
                btnAdd.Visibility = Visibility.Visible;
                btnUpdate.Visibility = Visibility.Collapsed;
                cmbSiteList.IsEnabled = true;
                IsSiteActive = true;
            }
            else
            {
                btnAdd.Visibility = Visibility.Collapsed;
                btnUpdate.Visibility = Visibility.Visible;
                cmbSiteList.IsEnabled = false;
            }
        }

        private void AddReadingSiteClick(object sender, RoutedEventArgs e)
        {
            // add new reading site to the site list

            // if user hasn't selected an institution or type yet then have them do it
            if (SelectedInstitution == null)
            {
                MessageBox.Show("Please select a reading site.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            if (SelectedTypeIndex < 0)
            {
                MessageBox.Show("Please select the site type.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            // check if the site is the same as the user's site
            if (SelectedInstitution.SiteStationNumber == UserContext.LocalSite.SiteStationNumber)
            {
                MessageBox.Show("You have selected your own site. This list is for remote reading sites only.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            // check if the site is already added
            foreach (string StationNumber in AddedSites)
            {
                if (StationNumber == SelectedInstitution.SiteStationNumber)
                {
                    MessageBox.Show("Site has already been added to the list. Please choose a different one.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                    return;
                }
            }

            // otherwise, add new site to database first
            PathologyReadingSiteType readSite = new PathologyReadingSiteType()
            {
                Active = IsSiteActive,
                SiteStationNumber = SelectedInstitution.SiteStationNumber
            };

            readingSite = new ReadingSiteInfo() 
            { 
                SiteIEN = SelectedInstitution.SiteIEN, 
                SiteStationNumber = SelectedInstitution.SiteStationNumber, 
                SiteAbr = SelectedInstitution.SiteAbr, 
                SiteName = SelectedInstitution.SiteName,
                Active = IsSiteActive
            };

            switch (SelectedTypeIndex)
            {
                case 0:
                    readingSite.SiteType = ReadingSiteType.interpretation;
                    readSite.SiteType = ReadingSiteType.interpretation;
                    break;
                case 1:
                    readingSite.SiteType = ReadingSiteType.consultation;
                    readSite.SiteType = ReadingSiteType.consultation;
                    break;
                case 2:
                    readingSite.SiteType = ReadingSiteType.both;
                    readSite.SiteType = ReadingSiteType.both;
                    break;
                default:
                    readingSite.SiteType = ReadingSiteType.interpretation;
                    readSite.SiteType = ReadingSiteType.interpretation;
                    break;
            }

            // try to save to database
            try
            {
                this.DataSource.SaveReadingSite(readSite);

                Log.Info(string.Format("{0} has been added to site {1}'s reading site list.",
                                       SelectedInstitution.SiteDisplayName, UserContext.LocalSite.PrimarySiteStationNUmber));
            }
            catch (MagVixFailureException vfe)
            {
                Log.Error("Failed to save reading site data.", vfe);
                MessageBox.Show("Couldn't save reading site. Please try again later.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                readSite = null;
                return;
            }
            
            IsModified = true;
            Close();
        }

        private void UpdateReadingSiteClick(object sender, RoutedEventArgs e)
        {
            // modify the selected site and update it to the site list
            PathologyReadingSiteType readSite = new PathologyReadingSiteType()
            {
                Active = IsSiteActive, 
                SiteStationNumber = readingSite.SiteStationNumber
            };
            
            switch (SelectedTypeIndex)
            {
                case 0:
                    readSite.SiteType = ReadingSiteType.interpretation;
                    break;
                case 1:
                    readSite.SiteType = ReadingSiteType.consultation;
                    break;
                case 2:
                    readSite.SiteType = ReadingSiteType.both;
                    break;
                default:
                    readSite.SiteType = ReadingSiteType.interpretation;
                    break;
            }

            // try to save to database
            try
            {
                this.DataSource.SaveReadingSite(readSite);
                readingSite.Active = readSite.Active;
                readingSite.SiteType = readSite.SiteType;

                Log.Info(string.Format("Changes to {0} has been saved to site {1}'s reading site list.",
                                       SelectedInstitution.SiteDisplayName, UserContext.LocalSite.PrimarySiteStationNUmber));
            }
            catch (MagVixFailureException vfe)
            {
                Log.Error("Failed to update reading site information.", vfe);
                MessageBox.Show("Couldn't update reading site. Please try again later.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            IsModified = true;
            Close();
        }

        private void CancelClick(object sender, RoutedEventArgs e)
        {
            readingSite = null;
            IsModified = false;
            Close();
        }

        public ObservableCollection<SiteInfo> InstitutionList
        {
            get;
            set;
        }

        public SiteInfo SelectedInstitution
        {
            get;
            set;
        }

        public int SelectedTypeIndex
        {
            get;
            set;
        }

        public bool IsSiteActive
        {
            get;
            set;
        }

        public ReadingSiteInfo readingSite 
        { 
            get;
            set;
        }

        public bool IsModified { get; set; }

        public List<string> AddedSites { get; set; }
    }
}
