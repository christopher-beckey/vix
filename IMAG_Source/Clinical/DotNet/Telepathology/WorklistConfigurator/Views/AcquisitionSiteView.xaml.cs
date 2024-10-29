

namespace VistA.Imaging.Telepathology.Configurator.Views
{
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Windows;
    using VistA.Imaging.Telepathology.Common.Exceptions;
    using VistA.Imaging.Telepathology.Common.Model;
    using VistA.Imaging.Telepathology.Common.VixModels;
    using VistA.Imaging.Telepathology.Logging;
    using VistA.Imaging.Telepathology.Configurator.DataSource;

    public partial class AcquisitionSiteView : Window, INotifyPropertyChanged
    {
        private static MagLogger Log = new MagLogger(typeof(AcquisitionSiteView));

        private IConfiguratorDatasource DataSource;

        public AcquisitionSiteView()
        {
            // create new view with no data initiation
            IsModified = false;
            InitializeComponent();
        }

        public AcquisitionSiteView(IConfiguratorDatasource datasource)
        {
            // create new view with datasouce for adding new site
            IsModified = false;

            // try to retrieve a list of selectable institutions
            this.DataSource = datasource;
            if (datasource != null)
            {
                InstitutionList = datasource.GetInstitutionList();
            }
            else
            {
                InstitutionList = new ObservableCollection<SiteInfo>();
            }

            if (InstitutionList.Count < 1)
            {
                SelectedInstitution = null;
                SelectedPrimeInstitution = null;
            }
            else
            {
                SelectedInstitution = InstitutionList[0];
                SelectedPrimeInstitution = InstitutionList[0];
            }

            InitializeComponent();

            // determine the view 
            SetEntryType(true);
        }

        public AcquisitionSiteView(IConfiguratorDatasource datasource, AcquisitionSiteInfo acSite)
        {
            // create new view with existing data for modifying old site

            IsModified = false;
            this.DataSource = datasource;

            // initialize the list
            acquisitionSite = acSite;
            SiteInfo tPrime = new SiteInfo() { SiteName = acSite.PrimeSiteName, SiteStationNumber = acSite.PrimeSiteStationNumber};
            InstitutionList = new ObservableCollection<SiteInfo>();
            InstitutionList.Add(acSite);
            InstitutionList.Add(tPrime);

            SelectedInstitution = acSite;
            SelectedPrimeInstitution = tPrime;
            IsSiteActive = acquisitionSite.Active;

            InitializeComponent();

            // determine the view
            SetEntryType(false);
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

        private void SetEntryType(bool isAdding)
        {
            // change the view depends on adding or modifying a site
            if (isAdding)
            {
                btnAdd.Visibility = Visibility.Visible;
                btnUpdate.Visibility = Visibility.Collapsed;
                cmbSiteList.IsEnabled = true;
                cmbPrimeSiteList.IsEnabled = true;
                
                IsSiteActive = true;
            }
            else
            {
                btnAdd.Visibility = Visibility.Collapsed;
                btnUpdate.Visibility = Visibility.Visible;
                cmbSiteList.IsEnabled = false;
                cmbPrimeSiteList.IsEnabled = false;
            }
        }

        private void AddAcquisitionSiteClick(object sender, RoutedEventArgs e)
        {
            // add new acquisition site to the list

            // if user hasn't selected institution or prim site yet then have them do it
            if (SelectedInstitution == null)
            {
                MessageBox.Show("Please select an acquisition site.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }
            if (SelectedPrimeInstitution == null)
            {
                MessageBox.Show("Please select a primary acquisition site.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            // if acquisition site or primary acquisition site is the same as local primary then no
            if ((SelectedInstitution.SiteStationNumber == UserContext.LocalSite.SiteStationNumber)
                || (SelectedPrimeInstitution.SiteStationNumber == UserContext.LocalSite.PrimarySiteStationNUmber))
            {
                MessageBox.Show("You have selected your own site. This list is for remote acquisition sites only.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            // check if the site is already added
            foreach (string StationNumberCombo in AddedSites)
            {
                string[] pieces = StationNumberCombo.Split('^');
                if (pieces != null)
                {
                    // if the acquisition combo is the same then no or if the primary is the same then no
                    // multiple instances of the primary is acceptable, the worklist will have to filter this duplication out
                    if ((SelectedInstitution.SiteStationNumber == pieces[0])
                        && (SelectedPrimeInstitution.SiteStationNumber == pieces[1]))
                    {
                        MessageBox.Show("Site combination has already been added to the list. Please choose a different one.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                        return;
                    }
                }
            }

            // check if the primary site is valid
            bool isPrimeValid = DataSource.IsPrimarySiteValid(SelectedPrimeInstitution.SiteStationNumber);
            if (!isPrimeValid)
            {
                MessageBox.Show(SelectedPrimeInstitution.SiteName + " is not a valid primary site.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            bool is138Supported = DataSource.IsSiteSupportTelepathology(SelectedPrimeInstitution.SiteStationNumber);
            if (!is138Supported)
            {
                MessageBox.Show(SelectedPrimeInstitution.SiteName + " does not support Telepathology.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                return;
            }

            // add site to the database first
            PathologyAcquisitionSiteType acquiSite = new PathologyAcquisitionSiteType()
            {
                Active = IsSiteActive,
                SiteStationNumber = SelectedInstitution.SiteStationNumber,
                PrimarySiteStationNumber = SelectedPrimeInstitution.SiteStationNumber
            };

            try
            {
                this.DataSource.SaveAcquisitionSite(acquiSite);

                // if success then continue as normal to add the site to the list
                acquisitionSite = new AcquisitionSiteInfo()
                {
                    SiteIEN = SelectedInstitution.SiteIEN,
                    SiteStationNumber = SelectedInstitution.SiteStationNumber,
                    SiteAbr = SelectedInstitution.SiteAbr,
                    SiteName = SelectedInstitution.SiteName,

                    PrimeSiteIEN = SelectedPrimeInstitution.SiteIEN,
                    PrimeSiteStationNumber = SelectedPrimeInstitution.SiteStationNumber,
                    PrimeSiteAbr = SelectedPrimeInstitution.SiteAbr,
                    PrimeSiteName = SelectedPrimeInstitution.SiteName,
                    Active = IsSiteActive
                };

                Log.Info(string.Format("{0} has been added to site {1}'s acquisition site list.",
                                       acquisitionSite.SiteDisplayName, UserContext.LocalSite.PrimarySiteStationNUmber));
            }
            catch (MagVixFailureException vfe)
            {
                Log.Error("Failed to save acquisition site.", vfe);
                MessageBox.Show("Couldn't save acquisition site. Please try again later.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                acquisitionSite = null;
                return;
            }

            IsModified = true;
            Close();
        }

        private void UpdateAcquisitionSiteClick(object sender, RoutedEventArgs e)
        {
            // check to see if the current site has any pending consultation at the acquisition site

            PathologyAcquisitionSiteType acquiSite = new PathologyAcquisitionSiteType()
            {
                Active = IsSiteActive,
                SiteStationNumber = acquisitionSite.SiteStationNumber,
                PrimarySiteStationNumber = acquisitionSite.PrimeSiteStationNumber
            };

            // try to save to database
            try
            {
                // if the status is inactive, check if the site has any pending consultation at the acquisition site
                if (!IsSiteActive)
                {
                    bool pending = DataSource.CheckPendingConsultation(acquisitionSite.SiteStationNumber, UserContext.LocalSite.PrimarySiteStationNUmber);
                    if (pending)
                    {
                        MessageBox.Show(acquisitionSite.SiteName + " has pending consultation(s) at your site so it cannot be deactivated.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                        return;
                    }
                }

                // if everything is good, continue updating
                this.DataSource.SaveAcquisitionSite(acquiSite);
                acquisitionSite.Active = acquiSite.Active;

                Log.Info(string.Format("Changes to {0} has been saved to site {1}'s acquisition site list.",
                                       acquisitionSite.SiteDisplayName, UserContext.LocalSite.PrimarySiteStationNUmber));
            }
            catch (MagVixFailureException)
            {
                MessageBox.Show("Couldn't update acquisition site. Please try again later.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }

            IsModified = true;
            Close();
        }

        private void CancelClick(object sender, RoutedEventArgs e)
        {
            acquisitionSite = null;
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

        public SiteInfo SelectedPrimeInstitution
        {
            get;
            set;
        }

        public bool IsSiteActive
        {
            get;
            set;
        }

        public AcquisitionSiteInfo acquisitionSite
        {
            get;
            set;
        }

        public bool IsModified { get; set; }

        public List<string> AddedSites { get; set; }
    }
}
