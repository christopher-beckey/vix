/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 11/15/2011
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
    using System.Collections.ObjectModel;
    using System.Linq;

    /// <summary>
    /// The origin index.
    /// </summary>
    public class OriginIndex
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="OriginIndex"/> class.
        /// </summary>
        public OriginIndex()
        {
            this.Code = string.Empty;
            this.Description = string.Empty;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the origin index list.
        /// </summary>
        /// <value>
        /// The origin index list.
        /// </value>
        public static ObservableCollection<OriginIndex> OriginIndexList { get; set; }

        /// <summary>
        /// Gets or sets Code.
        /// </summary>
        public string Code { get; set; }

        /// <summary>
        /// Gets or sets Description.
        /// </summary>
        public string Description { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// Gets an origin index instance by code.
        /// </summary>
        /// <param name="code">
        /// The code.
        /// </param>
        /// <returns>
        /// The matching OriginIndex instance
        /// </returns>
        public static OriginIndex GetOriginIndexByCode(string code)
        {
            if (OriginIndexList == null)
            {
                return null;
            }

            return OriginIndexList.SingleOrDefault(origin => origin.Code == code);
        }

        #endregion
    }
}