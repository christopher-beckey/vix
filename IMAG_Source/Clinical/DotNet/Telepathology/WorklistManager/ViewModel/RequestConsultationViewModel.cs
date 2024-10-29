// -----------------------------------------------------------------------
// <copyright file="RequestConsultationViewModel.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: May 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Paul Pentapaty, Duc Nguyen
//  Description: Basic acquisition site information
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

namespace VistA.Imaging.Telepathology.Worklist.ViewModel
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using GalaSoft.MvvmLight;
    using System.Collections.ObjectModel;
    using VistA.Imaging.Telepathology.Common.Model;
    using GalaSoft.MvvmLight.Command;

    /// <summary>
    /// View model for requesting new consultations
    /// </summary>
    public class RequestConsultationViewModel : WorkspaceViewModel
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="RequestConsultationViewModel"/> class with known reading sites
        /// </summary>
        /// <param name="readSites">list of know reading site</param>
        public RequestConsultationViewModel(ReadingSiteList readSites)
        {
            this.ReadingSites = new ObservableCollection<ReadingSiteInfo>(readSites.Items);
            this.SelectedReadingSites = new ObservableCollection<ReadingSiteInfo>();
            RequestConsultationCommand = new RelayCommand(OnRequestConsultation);
        }

        /// <summary>
        /// Requesting action
        /// </summary>
        public event Action RequestConsultation;

        /// <summary>
        /// Gets or sets a list of available reading sites
        /// </summary>
        public ObservableCollection<ReadingSiteInfo> ReadingSites { get; set; }

        /// <summary>
        /// Gets or sets a list of selected reading sites
        /// </summary>
        public ObservableCollection<ReadingSiteInfo> SelectedReadingSites { get; set; }

        /// <summary>
        /// Gets or sets a single selected reading site
        /// </summary>
        public ReadingSiteInfo SelectedSite { get; set; }
        
        /// <summary>
        /// Gets the command for requesting consultation with the selected site
        /// </summary>
        public RelayCommand RequestConsultationCommand
        {
            get;
            private set;
        }

        /// <summary>
        /// Gets a list of selected reading sites
        /// </summary>
        public List<ReadingSiteInfo> SelectedSites
        {
            get
            {
                List<ReadingSiteInfo> sites = new List<ReadingSiteInfo>();
                foreach (ReadingSiteInfo item in this.SelectedReadingSites)
                {
                    sites.Add(item);
                }

                return sites;
            }
        }

        /// <summary>
        /// Request consultation handler
        /// </summary>
        void OnRequestConsultation()
        {
            if (this.RequestConsultation != null)
            {
                this.RequestConsultation();
            }
        }

    }
}
