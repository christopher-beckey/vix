// <copyright file="ArtifactSet.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 03/22/2012
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
namespace VistA.Imaging.Viewer.Models
{
    using System.Collections.ObjectModel;
    using System;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class ArtifactSet
    {
        #region Constructors
        
        /// <summary>
        /// Initializes a new instance of the <see cref="ArtifactSet"/> class.
        /// </summary>
        public ArtifactSet()
        {
            this.InitializeProperties(String.Empty, String.Empty, String.Empty, 
                                      null, null);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ArtifactSet"/> class.
        /// </summary>
        /// <param name="displayName">The display name.</param>
        public ArtifactSet(string displayName)
        {
            this.InitializeProperties(String.Empty, String.Empty, displayName, null, null);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ArtifactSet"/> class.
        /// </summary>
        /// <param name="urn">The urn.</param>
        /// <param name="siteId">The site id.</param>
        /// <param name="displayName">The display name.</param>
        public ArtifactSet(string urn, string siteId, string displayName)
        {
            this.InitializeProperties(urn, siteId, displayName, null, null);
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ArtifactSet"/> class.
        /// </summary>
        /// <param name="urn">The urn.</param>
        /// <param name="siteId">The site id.</param>
        /// <param name="displayName">The display name.</param>
        /// <param name="artifcats">The artifcats.</param>
        /// <param name="artifactSet">The artifact set.</param>
        public ArtifactSet(string urn, string siteId, string displayName, 
                           ObservableCollection<Artifact> artifcats, 
                           ObservableCollection<ArtifactSet> artifactSet)
        {
            this.InitializeProperties(urn, siteId, displayName, artifcats, artifactSet);
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the artifacts.
        /// </summary>
        public ObservableCollection<Artifact> Artifacts { get; set; }

        /// <summary>
        /// Gets or sets the artifact sets.
        /// </summary>
        public ObservableCollection<ArtifactSet> ArtifactSets { get; set; }

        /// <summary>
        /// Gets or sets the display name.
        /// </summary>
        public string DisplayName { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this Artifact Set is selected.
        /// </summary>
        /// <value>
        /// 	<c>true</c> if this Artifact Set is selected; otherwise, <c>false</c>.
        /// </value>
        public bool IsSelected { get; set; }

        /// <summary>
        /// Gets or sets the site id.
        /// </summary>
        public string SiteId { get; set; }

        /// <summary>
        /// Gets or sets the urn.
        /// </summary>
        public string Urn { get; set; }

        #endregion

        #region Private Methods

        /// <summary>
        /// Initializes the <see cref="ArtifactSet"/> class properties.
        /// All properties with null values will be saved as empty strings
        /// and collections.
        /// </summary>
        /// <param name="urn">The urn.</param>
        /// <param name="siteId">The site id.</param>
        /// <param name="displayName">The display name.</param>
        /// <param name="artifcats">The artifcats.</param>
        /// <param name="artifactSet">The artifact set.</param>
        private void InitializeProperties(string urn, string siteId, string displayName,
                                          ObservableCollection<Artifact> artifcats, 
                                          ObservableCollection<ArtifactSet> artifactSet)
        {
            this.Urn = urn;
            this.SiteId = siteId;
            this.DisplayName = displayName;
            this.Artifacts = artifcats;
            this.ArtifactSets = artifactSet;
            this.IsSelected = false;

            if (urn == null)
            {
                this.Urn = String.Empty;
            }

            if (siteId == null)
            {
                this.SiteId = String.Empty;
            }

            if (displayName == null)
            {
                this.DisplayName = String.Empty;
            }

            if (artifcats == null)
            {
                this.Artifacts = new ObservableCollection<Artifact>();
            }

            if (artifactSet == null)
            {
                this.ArtifactSets = new ObservableCollection<ArtifactSet>();
            }
        }

        #endregion
    }
}
