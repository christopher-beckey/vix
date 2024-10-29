/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 06/19/2012
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */

namespace DicomImporter.Common.Model
{
    using System.Collections.Generic;
    using System.Collections.ObjectModel;

    /// <summary>
    /// Holds a list of UIDActionConfig objects and allows for test to determine if a 
    /// SOP Class in known or unknown.
    /// </summary>
    public class UIDActionList
    {
        #region Constants and Fields

        /// <summary>
        /// The Action code for SOP classes supported by P99
        /// </summary>
        private const string LegacySopClass = "1";

        /// <summary>
        /// The Action code for SOP classes newly supported by P34
        /// </summary>
        private const string NewlySupportedSopClass = "2";

        /// <summary>
        /// The collection of UIDActionConfig elements from the database
        /// </summary>
        private static ObservableCollection<UIDActionConfig> uidActionConfigs;

        /// <summary>
        /// The list of known sop classes (New or Existing)
        /// </summary>
        private static List<string> knownSopClasses;

        #endregion

        #region Properties

        /// <summary>
        /// Gets or sets the uid action configs, and loads the knows sopclasses list
        /// </summary>
        /// <value>
        /// The uid action configs.
        /// </value>
        public static ObservableCollection<UIDActionConfig> UidActionConfigs
        {
            get
            {
                return uidActionConfigs;
            }

            set
            {
                uidActionConfigs = value;
                LoadKnownSopClasses();
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is initialized.
        /// </summary>
        /// <value>
        ///   <c>true</c> if this instance is initialized; otherwise, <c>false</c>.
        /// </value>
        public static bool IsInitialized { get; set; }

        #endregion
        
        #region Public Methods and Operators

        /// <summary>
        /// Determines whether the sop class id is known. If so, return true, otherwise false.
        /// </summary>
        /// <param name="sopClassId">
        /// The sop class id.
        /// </param>
        /// <returns>
        /// <c>true</c> if the specified sop class is known; otherwise, <c>false</c>.
        /// </returns>
        public static bool IsKnownSopClass(string sopClassId)
        {
            return knownSopClasses.Contains(sopClassId);
        }

        #endregion

        #region Methods

        /// <summary>
        /// Loads the list of known sop classes.
        /// </summary>
        private static void LoadKnownSopClasses()
        {
            knownSopClasses = new List<string>();
            foreach (UIDActionConfig uidActionConfig in uidActionConfigs)
            {
                if (uidActionConfig.ActionCode == LegacySopClass || uidActionConfig.ActionCode == NewlySupportedSopClass)
                {
                    knownSopClasses.Add(uidActionConfig.Uid);
                }
            }

            IsInitialized = true;
        }

        #endregion
    }
}