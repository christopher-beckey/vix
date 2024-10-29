// -----------------------------------------------------------------------
// <copyright file="IHierarchicalEntryLoadViewModelFactory.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.DataNavigator.ViewModels
{
    using VistA.Imaging.DataNavigator.Model;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public interface IHierarchicalEntryLoadViewModelFactory
    {
        /// <summary>
        /// Gets or sets the hierarchical entry view model factory.
        /// </summary>
        IHierarchicalEntryViewModelFactory HierarchicalEntryViewModelFactory { get; set; }

        /// <summary>
        /// Creates the hierarchical entry load view model.
        /// </summary>
        /// <param name="pointer">The pointer.</param>
        /// <param name="parent">The parent.</param>
        /// <returns>A HierarchicalEntryLoadViewModel containing the pointer</returns>
        HierarchicalEntryLoadViewModel CreateHierarchicalEntryLoadViewModel(FilemanFilePointer pointer, TreeNodeViewModel parent);
    }
}
