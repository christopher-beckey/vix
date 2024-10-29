// -----------------------------------------------------------------------
// <copyright file="ReadingSiteSetupViewModel.cs" company="Department of Veterans Affairs">
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
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Windows;
    using GalaSoft.MvvmLight;
    using GalaSoft.MvvmLight.Command;
    using VistA.Imaging.Telepathology.Common.Model;
    using VistA.Imaging.Telepathology.Configurator.DataSource;
    using VistA.Imaging.Telepathology.Configurator.Views;
    using VistA.Imaging.Telepathology.Common.VixModels;
    using VistA.Imaging.Telepathology.Common.Exceptions;
    using VistA.Imaging.Telepathology.Logging;

    public class ReadingSiteSetupViewModel : ViewModelBase
    {
        private static MagLogger Log = new MagLogger(typeof(ReadingSiteSetupViewModel));
        
        public ReadingSiteSetupViewModel()
        {
            // create new view model with datasouce added later
            AcquisitionSites = new ObservableCollection<AcquisitionSiteInfo>();

            SelectedSiteIndex = -1;

            RemoveAcquisitionSiteCommand = new RelayCommand(RemoveAcquisitionSite, () => (this.Datasource != null) && (this.SelectedSiteIndex >= 0));
            ModifySiteCommand = new RelayCommand(ModifyAcquisitionSite, () => (this.Datasource != null) && (this.SelectedSiteIndex >= 0));
            AddAcquisitionSiteCommand = new RelayCommand(AddAcquisitionSite, () => (this.Datasource != null));
        }

        public ReadingSiteSetupViewModel(IConfiguratorDatasource source)
        {
            // create new view model with datasource initialized
            Datasource = source;

            // retrieve previously saved list of acquisition sites
            AcquisitionSiteList myAcquisitionList = Datasource.GetAcquisitionSites(UserContext.LocalSite.PrimarySiteStationNUmber);
            AcquisitionSites = new ObservableCollection<AcquisitionSiteInfo>(myAcquisitionList.Items);
            
            SelectedSiteIndex = -1;

            RemoveAcquisitionSiteCommand = new RelayCommand(RemoveAcquisitionSite, () => (this.Datasource != null) && (this.SelectedSiteIndex >= 0));
            ModifySiteCommand = new RelayCommand(ModifyAcquisitionSite, () => (this.Datasource != null) && (this.SelectedSiteIndex >= 0));
            AddAcquisitionSiteCommand = new RelayCommand(AddAcquisitionSite, () => (this.Datasource != null));
        }

        public IConfiguratorDatasource Datasource { get; set; }
        
        public RelayCommand RemoveAcquisitionSiteCommand
        {
            get;
            private set;
        }

        public RelayCommand ModifySiteCommand
        {
            get;
            private set;
        }

        public RelayCommand AddAcquisitionSiteCommand
        {
            get;
            private set;
        }

        public ObservableCollection<AcquisitionSiteInfo> AcquisitionSites { get; set; }

        public int SelectedSiteIndex { get; set; }

        private void RemoveAcquisitionSite()
        {
            if (AcquisitionSites != null)
            {
                if ((AcquisitionSites.Count > 0) && (SelectedSiteIndex >= 0))
                {
                    // try to remove from database
                    try
                    {
                        MessageBoxResult res = MessageBox.Show(string.Format("Are you sure you want to remove {0} from the list?", AcquisitionSites[SelectedSiteIndex].SiteDisplayName),
                                                                "Confirmation", MessageBoxButton.YesNo, MessageBoxImage.Question, MessageBoxResult.No);
                        if (res != MessageBoxResult.Yes)
                            return;

                        // check to see if the current site has any pending consultation at the acquisition site
                        bool pending = Datasource.CheckPendingConsultation(AcquisitionSites[SelectedSiteIndex].PrimeSiteStationNumber, UserContext.LocalSite.SiteStationNumber);
                        if (pending)
                        {
                            MessageBox.Show(AcquisitionSites[SelectedSiteIndex].SiteName + " has pending consultation(s) at your site so it cannot be removed.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                            return;
                        }

                        PathologyAcquisitionSiteType acquisitionSite = new PathologyAcquisitionSiteType()
                        {
                            Active = AcquisitionSites[SelectedSiteIndex].Active,
                            SiteStationNumber = AcquisitionSites[SelectedSiteIndex].SiteStationNumber,
                            PrimarySiteStationNumber = AcquisitionSites[SelectedSiteIndex].PrimeSiteStationNumber
                        };

                        this.Datasource.RemoveAcquisitionSite(acquisitionSite);
                        
                        Log.Info(string.Format("{0} has been removed from site {1}'s acquisition site list.",
                                       AcquisitionSites[SelectedSiteIndex].SiteDisplayName, UserContext.LocalSite.PrimarySiteStationNUmber));

                        AcquisitionSites.RemoveAt(SelectedSiteIndex);
                    }
                    catch (MagVixFailureException vfe)
                    {
                        Log.Error("Failed to remove acquisition site.", vfe);
                        MessageBox.Show("Couldn't remove acquisition site. Please try again later.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }
            }
        }

        private void ModifyAcquisitionSite()
        {
            // modify selected site in the list
            if ((AcquisitionSites.Count > 0) && (SelectedSiteIndex >= 0))
            {
                AcquisitionSiteView view = new AcquisitionSiteView(this.Datasource, AcquisitionSites[SelectedSiteIndex]);
                view.ShowDialog();
            }
        }

        private void AddAcquisitionSite()
        {
            // add new acquisition site to the list
            if (Datasource != null)
            {
                AcquisitionSiteView view = new AcquisitionSiteView(Datasource);
                view.AddedSites = GetAddedSite();
                view.ShowDialog();

                if ((view.acquisitionSite != null) && (view.IsModified))
                    AcquisitionSites.Add(view.acquisitionSite);
            }
        }

        public List<string> GetAddedSite()
        {
            List<string> result = new List<string>();
            foreach (AcquisitionSiteInfo site in AcquisitionSites)
                result.Add(site.SiteStationNumber + "^" + site.PrimeSiteStationNumber);

            return result;
        }
    }
}