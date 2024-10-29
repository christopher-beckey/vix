// -----------------------------------------------------------------------
// <copyright file="IHierarchicalEntryViewModelFactory.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.ViewModels.Factories
{
    using System.Collections.Generic;
    using VistA.Imaging.DataNavigator.Model;
    using System.Diagnostics.Contracts;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    [ContractClass(typeof(HierarchicalEntryViewModelFactoryContracts))]
    public interface IHierarchicalEntryViewModelFactory
    {
        /// <summary>
        /// Gets the parent pointers.
        /// </summary>
        Dictionary<FilemanFile, FilemanField> ParentPointers { get; }

        /// <summary>
        /// Gets the child pointers.
        /// </summary>
        Dictionary<FilemanFile, FilemanField> ChildPointers { get; }

        /// <summary>
        /// Creates the hierarchical entry view model.
        /// </summary>
        /// <param name="entry">The entry contained by the HierarchicalEntryViewModel.</param>
        /// <returns>The viewmodel containing the entry</returns>
        HierarchicalEntryViewModel CreateHierarchicalEntryViewModel(FilemanEntry entry);
    }
}
