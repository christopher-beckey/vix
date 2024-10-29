// -----------------------------------------------------------------------
// <copyright file="IHierarchicalEntryLoadViewModelFactory.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.ViewModels.Factories
{
    using VistA.Imaging.DataNavigator.Model;
    using System.Diagnostics.Contracts;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    [ContractClass(typeof(HierarchicalEntryLoadViewModelFactorContracts))]
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
