// -----------------------------------------------------------------------
// <copyright file="CachingDataSource.cs" company="Department of Veterans Affairs">
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
namespace VistA.Imaging.DataSources
{
    using System.Collections.Generic;
    using System.Linq;

    /// <summary>
    /// An abstract base repository which caches it's results
    /// </summary>
    /// <typeparam name="TEntity">The type of the entity.</typeparam>
    /// <typeparam name="TId">The type of the id.</typeparam>
    public abstract class CachingDataSource<TEntity, TId> : ICachingDataSource<TEntity, TId>
        where TEntity : class
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="CachingDataSource&lt;TEntity, TId&gt;"/> class.
        /// </summary>
        public CachingDataSource()
        {
            this.Cache = new Dictionary<TId, TEntity>();
        }

        /// <summary>
        /// Gets the cache.
        /// </summary>
        protected Dictionary<TId, TEntity> Cache { get; private set; }

        /// <summary>
        /// Gets the entity by id.
        /// </summary>
        /// <param name="id">The id of the entity.</param>
        /// <returns>The entity identified by the specified id</returns>
        public virtual TEntity GetById(TId id)
        {
            if (this.Cache.Keys.Contains(id))
            {
                return this.Cache[id] as TEntity;
            }
            else
            {
                return null;
            }
        }
    }
}
