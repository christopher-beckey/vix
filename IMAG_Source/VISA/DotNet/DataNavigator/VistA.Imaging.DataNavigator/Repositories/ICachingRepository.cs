// -----------------------------------------------------------------------
// <copyright file="ICachingRepository.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Repositories
{
    /// <summary>
    /// A repository which caches it's results
    /// </summary>
    /// <typeparam name="TEntity">The type of the entity.</typeparam>
    /// <typeparam name="TId">The type of the id.</typeparam>
    public interface ICachingRepository<TEntity, TId> where TEntity : class
    {
        /// <summary>
        /// Gets the entity by id.
        /// </summary>
        /// <param name="id">The id of the entity.</param>
        /// <returns>The entity with the specified id</returns>
        TEntity GetById(TId id);
    }
}
