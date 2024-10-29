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
    using System;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    [ContractClassFor(typeof(IHierarchicalEntryViewModelFactory))]
    public abstract class HierarchicalEntryViewModelFactoryContracts : IHierarchicalEntryViewModelFactory
    {
        /// <summary>
        /// Gets the parent pointers.
        /// </summary>
        public Dictionary<FilemanFile, FilemanField> ParentPointers
        {
            get
            {
                Contract.Ensures(Contract.Result<Dictionary<FilemanFile, FilemanField>>() != null);
                throw new NotImplementedException();
            }
        }

        /// <summary>
        /// Gets the child pointers.
        /// </summary>
        public Dictionary<FilemanFile, FilemanField> ChildPointers
        {
            get
            {
                Contract.Ensures(Contract.Result<Dictionary<FilemanFile, FilemanField>>() != null);
                throw new NotImplementedException();
            }
        }

        /// <summary>
        /// Creates the hierarchical entry view model.
        /// </summary>
        /// <param name="entry">The entry contained by the HierarchicalEntryViewModel.</param>
        /// <returns>The viewmodel containing the entry</returns>
        public HierarchicalEntryViewModel CreateHierarchicalEntryViewModel(FilemanEntry entry)
        {
            Contract.Requires<ArgumentNullException>(entry != null);
            Contract.Requires<ArgumentNullException>(entry.File != null);
            Contract.Ensures(Contract.Result<HierarchicalEntryViewModel>() != null);
            throw new NotImplementedException();
        }
    }
}
