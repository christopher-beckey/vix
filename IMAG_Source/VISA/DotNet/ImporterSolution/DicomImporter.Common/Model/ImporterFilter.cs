/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 5/2/2023
 * Developer:  Budy Tjahjo
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
    using System.Collections.ObjectModel;
    using System.Linq;

    /// <summary>
    /// The origin index.
    /// </summary>
    public class ImporterFilter
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ImporterFilter"/> class.
        /// </summary>
        public ImporterFilter()
        {
            this.Code = string.Empty;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the WorkItemFilter list.
        /// </summary>
        /// <value>
        /// The WorkItemFilter list.
        /// </value>
        public static ObservableCollection<ImporterFilter> WorkItemFilterList { get; set; }

        /// <summary>
        /// Gets or sets Code.
        /// </summary>
        public string Code { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// Gets an origin index instance by code.
        /// </summary>
        /// <param name="code">
        /// The code.
        /// </param>
        /// <returns>
        /// The matching WorkItemFilter instance
        /// </returns>
        public static ImporterFilter GetWorkItemFilterByCode(string code)
        {
            if (WorkItemFilterList == null)
            {
                return null;
            }

            return WorkItemFilterList.SingleOrDefault(origin => origin.Code == code);
        }

        #endregion
    }
}