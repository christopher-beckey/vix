//-----------------------------------------------------------------------
// <copyright file="ViewerContext.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 4/5/2012
//   Site Name:  Washington OI Field Office, Silver Spring, MD
//   Developer: vhaiswlouthj
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
    using System;
    using System.Collections.Generic;
    using System.Threading;

    using VistA.Imaging.Models;

    /// <summary>
    /// Bundles up all the data and state needed by an AWIV 2 Viewer instance
    /// </summary>
    public class ViewerContext : ObservableObject
    {
        /// <summary>
        /// A private cache of ViewerContext instances
        /// </summary>
        private static readonly Dictionary<string, ViewerContext> viewerContextCache = new Dictionary<string, ViewerContext>();

        /// <summary>
        /// An integer used to generate a running unique key for ViewerContext instances
        /// </summary>
        private static int currentIntegerKey;

        /// <summary>
        /// Initializes a new instance of the ViewerContext class.
        /// </summary>
        /// <param name="patient">The patient.</param>
        /// <param name="artifactSet">The artifact set.</param>
        private ViewerContext(Patient patient, ArtifactSet artifactSet)
        {
            // Set the patient and artifact set data
            this.Patient = patient;
            this.ArtifactSet = artifactSet;

            // Generate and set the key for this instance
            this.Key = this.GetNextKeyValue();
        }

        /// <summary>
        /// Gets or sets the key.
        /// </summary>
        /// <value>
        /// The key.
        /// </value>
        public string Key { get; set; }

        /// <summary>
        /// Gets or sets the patient.
        /// </summary>
        /// <value>
        /// The patient.
        /// </value>
        public Patient Patient { get; set; }

        /// <summary>
        /// Gets or sets the artifact set.
        /// </summary>
        /// <value>
        /// The artifact set.
        /// </value>
        public ArtifactSet ArtifactSet { get; set; }

        /// <summary>
        /// Creates a new ViewerContext instance with the provided parameters, adds it to the cache,
        /// and returns the key for subsequent retrieval.
        /// </summary>
        /// <param name="patient">The patient.</param>
        /// <param name="artifactSet">The artifact set.</param>
        /// <returns>The ViewerContext object, with the key to retrieve it again in the future populated</returns>
        public ViewerContext CreateViewerContext(Patient patient, ArtifactSet artifactSet)
        {
            // Create a ViewerContext instance with the provided data
            ViewerContext viewerContext = new ViewerContext(patient, artifactSet);

            // Add the ViewerContext to the cache
            viewerContextCache.Add(viewerContext.Key, viewerContext);

            // Return the ViewerContext instance
            return viewerContext;
        }

        /// <summary>
        /// Gets the viewer context from the cache by key. Throws an ArgumentException
        /// if a ViewerContext with the specified key is not found
        /// </summary>
        /// <param name="key">The key for the viewer context instance.</param>
        /// <returns>the matching ViewerContext instance</returns>
        public ViewerContext GetViewerContext(string key)
        {
            if (viewerContextCache.ContainsKey(key))
            {
                return viewerContextCache[key];
            }
            else
            {
                throw new ArgumentException("Could not find a ViewerContext object with key=[" + key + "]");
            }
        }

        /// <summary>
        /// Removes the viewer context with the specified key from the cache. Should be called when closing 
        /// an AWIV 2 view.
        /// </summary>
        /// <param name="key">The key.</param>
        public void RemoveViewerContext(string key)
        {
            if (viewerContextCache.ContainsKey(key))
            {
                viewerContextCache.Remove(key);
            }
        }

        /// <summary>
        /// Increments the static currentIntegerKey field, and returns the value as a string.
        /// </summary>
        /// <returns>A new key as a string</returns>
        private string GetNextKeyValue()
        {
            // Increment the key
            Interlocked.Increment(ref currentIntegerKey);

            // return it as a string
            return Convert.ToString(currentIntegerKey);
        }
    }
}
