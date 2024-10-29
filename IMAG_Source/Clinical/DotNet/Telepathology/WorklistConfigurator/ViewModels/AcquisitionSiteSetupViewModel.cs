// -----------------------------------------------------------------------
// <copyright file="AcquisitionSiteSetupViewModel.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: April 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: View model for acquisition site setup
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

namespace VistA.Imaging.Telepathology.Configurator.ViewModels
{
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using GalaSoft.MvvmLight;
    using GalaSoft.MvvmLight.Command;
    using VistA.Imaging.Telepathology.Common.Model;
    using VistA.Imaging.Telepathology.Configurator.DataSource;
    using VistA.Imaging.Telepathology.Configurator.Views;
    using System.Windows;
    using VistA.Imaging.Telepathology.Common.VixModels;
    using VistA.Imaging.Telepathology.Common.Exceptions;
    using VistA.Imaging.Telepathology.Logging;

    /// <summary>
    /// View model for acquisition site setup
    /// </summary>
    public class AcquisitionSiteSetupViewModel : ViewModelBase
    {
        private static MagLogger Log = new MagLogger(typeof(AcquisitionSiteSetupViewModel));

        public AcquisitionSiteSetupViewModel()
        {
            // create new view model with the datasource added later
            ReadingSites = new ObservableCollection<ReadingSiteInfo>();

            SelectedSiteIndex = -1;

            RemoveReadingSiteCommand = new RelayCommand(RemoveReadingSite, () => (this.Datasource != null) && (this.SelectedSiteIndex >= 0));
            ModifyReadingSiteCommand = new RelayCommand(ModifyReadingSite, () => (this.Datasource != null) && (this.SelectedSiteIndex >= 0));
            AddReadingSiteCommand = new RelayCommand(AddReadingSite, () => (this.Datasource != null));
        }

        public AcquisitionSiteSetupViewModel(IConfiguratorDatasource source)
        {
            // create new view model with datasource included
            Datasource = source;

            // retrieve list of reading site saved in database
            ReadingSiteList myList = Datasource.GetReadingSites(UserContext.LocalSite.PrimarySiteStationNUmber);
            ReadingSites = new ObservableCollection<ReadingSiteInfo>(myList.Items);

            SelectedSiteIndex = -1;

            RemoveReadingSiteCommand = new RelayCommand(RemoveReadingSite, () => (this.Datasource != null) && (this.SelectedSiteIndex >= 0));
            ModifyReadingSiteCommand = new RelayCommand(ModifyReadingSite, () => (this.Datasource != null) && (this.SelectedSiteIndex >= 0));
            AddReadingSiteCommand = new RelayCommand(AddReadingSite, () => (this.Datasource != null));
        }

        public IConfiguratorDatasource Datasource { get; set; }

        public RelayCommand RemoveReadingSiteCommand
        {
            get;
            private set;
        }

        public RelayCommand ModifyReadingSiteCommand
        {
            get;
            private set;
        }

        public RelayCommand AddReadingSiteCommand
        {
            get;
            private set;
        }

        public ObservableCollection<ReadingSiteInfo> ReadingSites { get; set; }

        public int SelectedSiteIndex { get; set; }

        private void RemoveReadingSite()
        {
            if (ReadingSites != null)
            {
                if ((ReadingSites.Count > 0) && (SelectedSiteIndex >= 0))
                {
                    try
                    {
                        MessageBoxResult res = MessageBox.Show(string.Format("Are you sure you want to remove {0} from the list?", ReadingSites[SelectedSiteIndex].SiteDisplayName),
                                                                "Confirmation", MessageBoxButton.YesNo, MessageBoxImage.Question, MessageBoxResult.No);
                        if (res != MessageBoxResult.Yes)
                            return;

                        // check to see if the selected site has any pending consultation
                        bool consultPending = Datasource.CheckPendingConsultation(UserContext.LocalSite.PrimarySiteStationNUmber, ReadingSites[SelectedSiteIndex].SiteStationNumber);
                        if (consultPending)
                        {
                            MessageBox.Show(ReadingSites[SelectedSiteIndex].SiteName + " has pending consultation(s) and cannot be removed.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                            return;
                        }

                        // try to remove from database
                        PathologyReadingSiteType readSite = new PathologyReadingSiteType()
                        {
                            Active = ReadingSites[SelectedSiteIndex].Active,
                            SiteStationNumber = ReadingSites[SelectedSiteIndex].SiteStationNumber,
                            SiteType = ReadingSites[SelectedSiteIndex].SiteType
                        };

                        this.Datasource.RemoveReadingSite(readSite);
                        
                        Log.Info(string.Format("{0} has been removed from site {1}'s reading site list.",
                                       ReadingSites[SelectedSiteIndex].SiteDisplayName, UserContext.LocalSite.PrimarySiteStationNUmber));

                        ReadingSites.RemoveAt(SelectedSiteIndex);
                    }
                    catch (MagVixFailureException vfe)
                    {
                        Log.Error("Failed to remove reading site.", vfe);
                        MessageBox.Show("Couldn't remove reading site. Please try again later.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                        return;
                    }
                }
            }
        }

        private void ModifyReadingSite()
        {
            // modify the selected site in the list
            if ((ReadingSites.Count > 0) && (SelectedSiteIndex >= 0))
            {
                ReadingSiteView view = new ReadingSiteView(this.Datasource,ReadingSites[SelectedSiteIndex]);
                view.ShowDialog();
            }
        }

        private void AddReadingSite()
        {
            // add new site to the list
            if (Datasource != null)
            {
                ReadingSiteView view = new ReadingSiteView(Datasource);
                view.AddedSites = GetAddedSite();
                view.ShowDialog();

                if ((view.readingSite != null) && (view.IsModified))
                    ReadingSites.Add(view.readingSite);
            }
        }

        public List<string> GetAddedSite()
        {
            List<string> result = new List<string>();
            foreach (ReadingSiteInfo site in ReadingSites)
                result.Add(site.SiteStationNumber);

            return result;
        }
    }
}