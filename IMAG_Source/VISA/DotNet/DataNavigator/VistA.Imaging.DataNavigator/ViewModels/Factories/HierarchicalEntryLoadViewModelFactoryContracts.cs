// -----------------------------------------------------------------------
// <copyright file="IHierarchicalEntryLoadViewModelFactory.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.ViewModels.Factories
{
    using VistA.Imaging.DataNavigator.Model;
    using System.Diagnostics.Contracts;
    using System;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    [ContractClassFor(typeof(IHierarchicalEntryLoadViewModelFactory))]
    internal abstract class HierarchicalEntryLoadViewModelFactorContracts : IHierarchicalEntryLoadViewModelFactory
    {
        /// <summary>
        /// Gets or sets the hierarchical entry view model factory.
        /// </summary>
        public IHierarchicalEntryViewModelFactory HierarchicalEntryViewModelFactory
        {
            get
            {
                throw new NotImplementedException();
            }

            set
            {
                Contract.Requires<ArgumentNullException>(value != null);
            }
        }

        /// <summary>
        /// Creates the hierarchical entry load view model.
        /// </summary>
        /// <param name="pointer">The pointer.</param>
        /// <param name="parent">The parent.</param>
        /// <returns>A HierarchicalEntryLoadViewModel containing the pointer</returns>
        public HierarchicalEntryLoadViewModel CreateHierarchicalEntryLoadViewModel(FilemanFilePointer pointer, TreeNodeViewModel parent)
        {
            Contract.Requires<ArgumentNullException>(pointer != null);
            Contract.Requires<ArgumentNullException>(parent != null);
            Contract.Ensures(Contract.Result<HierarchicalEntryLoadViewModel>() != null);
            throw new NotImplementedException();
        }
    }
}
