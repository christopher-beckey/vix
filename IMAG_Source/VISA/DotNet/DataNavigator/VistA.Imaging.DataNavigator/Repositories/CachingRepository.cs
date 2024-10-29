// -----------------------------------------------------------------------
// <copyright file="CachingRepository.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.DataNavigator.Repositories
{
    using System.Runtime.Caching;

    /// <summary>
    /// An abstract base repository which caches it's results
    /// </summary>
    /// <typeparam name="TEntity">The type of the entity.</typeparam>
    /// <typeparam name="TId">The type of the id.</typeparam>
    public abstract class CachingRepository<TEntity, TId> : ICachingRepository<TEntity, TId>
        where TEntity : class
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="CachingRepository&lt;TEntity, TId&gt;"/> class.
        /// </summary>
        /// <param name="cache">The cache.</param>
        public CachingRepository(ObjectCache cache)
        {
            this.Cache = cache;
        }

        /// <summary>
        /// Gets the cache.
        /// </summary>
        protected ObjectCache Cache { get; private set; }

        /// <summary>
        /// Gets the entity by id.
        /// </summary>
        /// <param name="id">The id of the entity.</param>
        /// <returns>The entity identified by the specified id</returns>
        public virtual TEntity GetById(TId id)
        {
            if (this.Cache.Contains(id.ToString()))
            {
                return this.Cache[id.ToString()] as TEntity;
            }
            else
            {
                return null;
            }
        }
    }
}
