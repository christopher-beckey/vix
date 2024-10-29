// <copyright file="ArtifactSelectionViewModel.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 11/30/2011
//   Site Name:  Washington OI Field Office, Silver Spring, MD
//   Developer: vhaiswgraver
//   Description: 
//         ;; +--------------------------------------------------------------------+
//         ;; Property of the US Government.
//         ;; No permission to copy or redistribute this software is given.
//         ;; Use of unreleased versions of this software requires the user
//         ;;  to execute a written test agreement with the VistA Imaging
//         ;;  Development Office of the Department of Veterans Affairs,
//         ;;  telephone (301) 734-0100.
//         ;;
//         ;; The Food and Drug Administration classifies this software as
//         ;; a Class II medical device.  As such, it may not be changed
//         ;; in any way.  Modifications to this software may result in an
//         ;; adulterated medical device under 21CFR820, the use of which
//         ;; is considered to be a violation of US Federal Statutes.
//         ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Viewer.ViewModels
{
    using System;
    using System.Collections.ObjectModel;
    using System.Net;
    using System.Windows.Media.Imaging;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Unity;
    using VistA.Imaging.Models;
    using VistA.Imaging.Net.Web;
    using VistA.Imaging.Prism;
    using VistA.Imaging.Viewer.Models;
    using System.Windows.Controls;

    /// <summary>
    /// The ViewModel for the MainView
    /// </summary>
    public class ArtifactSelectionViewModel : ViewModel
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ArtifactSelectionViewModel"/> class.
        /// </summary>
        public ArtifactSelectionViewModel()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ArtifactSelectionViewModel"/> class.
        /// </summary>
        /// <param name="regionManager">The region manager.</param>
        [InjectionConstructor]
        public ArtifactSelectionViewModel(IRegionManager regionManager)
            : base(regionManager)
        {
            this.ArtifactSets = new ObservableCollection<ArtifactSet>();
            this.ViewerArtifacts = new ObservableCollection<Artifact>();
        }

        #region Properties

        /// <summary>
        /// Gets or sets the Artifact Sets which are for the current patient.
        /// </summary>
        public ObservableCollection <ArtifactSet> ArtifactSets { get; set; }

        /// <summary>
        /// Gets or sets the Artifacts that are displayed to the viewer.
        /// These Artifacts are set as a result of its parent, grandparent, etc...
        /// Artifact Set being selected. 
        /// </summary>
        public ObservableCollection<Artifact> ViewerArtifacts { get; set; }

        /// <summary>
        /// Gets or sets the patient.
        /// </summary>
        public Patient Patient { get; set; }

        
        /// <summary>
        /// Gets or sets the photo of the patient.
        /// </summary>
        public BitmapImage Photo { get; set; }

        #endregion

        /// <summary>
        /// Loads the patient photo.
        /// </summary>
        public void LoadPhoto()
        {
            WebClient webClient = new WebClient();
            webClient.SetXxxHeaders(Guid.NewGuid().ToString());
            webClient.SetCredentials();
            webClient.OpenReadCompleted += new OpenReadCompletedEventHandler(this.LoadPhoto_OpenReadCompleted);
            webClient.OpenReadAsync(Patient.PhotoUri);
        }

        public void UpdateThumbnailViewer(ArtifactSet set)
        {
            this.ViewerArtifacts.Clear();

            //foreach (ArtifactSet set in ArtifactSets)
            //{
                this.UpdateViewerArtifacts(set, true);
           // }
        }

        private void UpdateViewerArtifacts(ArtifactSet set, bool parentSelected)
        {
            if (set == null) 
            {
                return;
            }

            if (!set.IsSelected && !parentSelected)
            {
                return;
            }
    
            foreach (Artifact artifact in set.Artifacts)
            {
                this.ViewerArtifacts.Add(artifact);
            }

            if (set.IsSelected)
            {
                parentSelected = true;
            }

            foreach (ArtifactSet childSet in set.ArtifactSets)
            {
                this.UpdateViewerArtifacts(childSet, parentSelected);
            }
        }


        /// <summary>
        /// Handles the OpenReadCompleted event of LoadPhoto.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Net.OpenReadCompletedEventArgs"/> instance containing the event data.</param>
        private void LoadPhoto_OpenReadCompleted(object sender, OpenReadCompletedEventArgs e)
        {
            if (!e.Cancelled && e.Error == null)
            {
                BitmapImage image = new BitmapImage();
#if SILVERLIGHT
                image.SetSource(e.Result);
#else
                image.BeginInit();
                image.CacheOption = BitmapCacheOption.OnLoad;
                image.StreamSource = e.Result;
                image.EndInit();
#endif
                this.Photo = image;
            }
        }
    }
}
