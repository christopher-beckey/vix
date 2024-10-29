/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
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
namespace DicomImporter.Common.ViewModels
{
    using System.Collections.Generic;

    using DicomImporter.Common.Model;

    /// <summary>
    /// The importer work item cache.
    /// </summary>
    public class ImporterWorkItemCache
    {
        #region Constants and Fields

        /// <summary>
        /// The importer work item map.
        /// </summary>
        private static readonly Dictionary<string, ImporterWorkItem> importerWorkItemMap =
            new Dictionary<string, ImporterWorkItem>();

        #endregion

        #region Public Methods

        /// <summary>
        /// The add.
        /// </summary>
        /// <param name="workItem">
        /// The work item.
        /// </param>
        public static void Add(ImporterWorkItem workItem)
        {
            if (importerWorkItemMap.ContainsKey(workItem.Key))
            {
                importerWorkItemMap.Remove(workItem.Key);
            }

            importerWorkItemMap.Add(workItem.Key, workItem);
        }

        /// <summary>
        /// Gets an importer work item by key. Returns null if not in the dictionary
        /// </summary>
        /// <param name="workItemKey">
        /// The work item key.
        /// </param>
        /// <returns>
        /// The importer work item matching the provided key
        /// </returns>
        public static ImporterWorkItem Get(string workItemKey)
        {
            return importerWorkItemMap[workItemKey];
        }

        /// <summary>
        /// The remove.
        /// </summary>
        /// <param name="workItem">
        /// The work item.
        /// </param>
        public static void Remove(ImporterWorkItem workItem)
        {
            importerWorkItemMap.Remove(workItem.Key);
        }

        #endregion
    }
}