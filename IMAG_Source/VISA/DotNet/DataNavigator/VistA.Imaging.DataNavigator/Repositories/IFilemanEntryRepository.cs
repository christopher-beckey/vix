// -----------------------------------------------------------------------
// <copyright file="IFilemanEntryRepository.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Repositories
{
    using VistA.Imaging.DataNavigator.Model;

    /// <summary>
    /// Repository for FilemanEntry data access
    /// </summary>
    public interface IFilemanEntryRepository
    {
        /// <summary>
        /// Gets the entry by id.
        /// </summary>
        /// <param name="file">The file containing the entry.</param>
        /// <param name="id">The id of the entry.</param>
        /// <returns>The entry with the specified id</returns>
        FilemanEntry GetById(FilemanFile file, string id);

        /// <summary>
        /// Gets the entry by pointer.
        /// </summary>
        /// <param name="pointerFieldValue">The pointer field value.</param>
        /// <returns>The entry pointed to by the specified pointerFiledValue</returns>
        FilemanEntry GetByPointer(FilemanFieldValue pointerFieldValue);

        /// <summary>
        /// Finds the entry by the specified indexed field.
        /// </summary>
        /// <param name="searchField">The search field.</param>
        /// <param name="value">The value.</param>
        /// <returns>The results of the search</returns>
        FilemanEntrySearchResult FindByIndexedField(FilemanField searchField, string value);

        /// <summary>
        /// Finds the by reverse pointer.
        /// </summary>
        /// <param name="entry">The entry.</param>
        /// <param name="pointer">The pointer.</param>
        /// <returns>The results of the search</returns>
        FilemanEntrySearchResult FindByReversePointer(FilemanEntry entry, FilemanFilePointer pointer);
    }
}
