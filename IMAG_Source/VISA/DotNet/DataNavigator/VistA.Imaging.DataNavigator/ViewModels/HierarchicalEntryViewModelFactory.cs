// -----------------------------------------------------------------------
// <copyright file="HierarchicalEntryViewModelFactory.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.DataNavigator.ViewModels
{
    using System.Collections.Generic;
    using System.Linq;
    using VistA.Imaging.DataNavigator.Model;
    using VistA.Imaging.DataNavigator.Repositories;
    using System.Diagnostics.Contracts;
    using System;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class HierarchicalEntryViewModelFactory : IHierarchicalEntryViewModelFactory
    {
        #region Private Fields

        /// <summary>
        /// The IFilemanFileRepository
        /// </summary>
        private IFilemanFileRepository fileRepository;

        /// <summary>
        /// The IFilemanEntryRepository
        /// </summary>
        private IFilemanEntryRepository entryRepository;

        /// <summary>
        /// The IHierarchicalEntryLoadViewModelFactory
        /// </summary>
        private IHierarchicalEntryLoadViewModelFactory hierarchicalEntryLoadViewModelFactory; 

        #endregion

        /// <summary>
        /// Initializes a new instance of the <see cref="HierarchicalEntryViewModelFactory"/> class.
        /// </summary>
        /// <param name="fileRepository">The file repository.</param>
        /// <param name="entryRepository">The entry repository.</param>
        /// <param name="hierarchicalEntryLoadViewModelFactory">The hierarchical entry load view model factory.</param>
        public HierarchicalEntryViewModelFactory(
            IFilemanFileRepository fileRepository,
            IFilemanEntryRepository entryRepository,
            IHierarchicalEntryLoadViewModelFactory hierarchicalEntryLoadViewModelFactory)
        {
            Contract.Requires<ArgumentNullException>(fileRepository != null);
            Contract.Requires<ArgumentNullException>(entryRepository != null);
            Contract.Requires<ArgumentNullException>(hierarchicalEntryLoadViewModelFactory != null);
            this.fileRepository = fileRepository;
            this.entryRepository = entryRepository;
            this.hierarchicalEntryLoadViewModelFactory = hierarchicalEntryLoadViewModelFactory;
            this.ParentPointers = new Dictionary<FilemanFile, FilemanField>();
            this.ChildPointers = new Dictionary<FilemanFile, FilemanField>();
            hierarchicalEntryLoadViewModelFactory.HierarchicalEntryViewModelFactory = this;
        }

        /// <summary>
        /// Gets the parent pointers.
        /// </summary>
        public Dictionary<FilemanFile, FilemanField> ParentPointers { get; private set; }

        /// <summary>
        /// Gets the child pointers.
        /// </summary>
        public Dictionary<FilemanFile, FilemanField> ChildPointers { get; private set; }

        /// <summary>
        /// Creates the hierarchical entry view model.
        /// </summary>
        /// <param name="entry">The entry.</param>
        /// <returns>The viewmodel containing the entry</returns>
        public HierarchicalEntryViewModel CreateHierarchicalEntryViewModel(FilemanEntry entry)
        {
            Contract.Requires<ArgumentNullException>(entry != null);
            Contract.Requires(entry.File != null);
            FilemanField parentPointerField = this.ChildPointers.Keys.Contains(entry.File)
                ? this.ChildPointers[entry.File] : null;
            FilemanField childPointerField = this.ParentPointers.Keys.Contains(entry.File)
                ? this.ParentPointers[entry.File] : null;
            return new HierarchicalEntryViewModel(
                entry,
                childPointerField,
                parentPointerField,
                this.entryRepository,
                this,
                this.hierarchicalEntryLoadViewModelFactory);
        }
    }
}
