﻿// -----------------------------------------------------------------------
// <copyright file="HierarchicalEntryLoadViewModelFactory.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.ViewModels.Factories
{
    using VistA.Imaging.DataNavigator.Model;
    using VistA.Imaging.DataNavigator.Repositories;
    using System.Diagnostics.Contracts;
    using System;
    using ImagingClient.Infrastructure.DialogService;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class HierarchicalEntryLoadViewModelFactory : IHierarchicalEntryLoadViewModelFactory
    {
        /// <summary>
        /// The dialog service
        /// </summary>
        private IDialogService dialogService;

        /// <summary>
        /// The IFilemanEntryRepository
        /// </summary>
        private IFilemanEntryRepository entryRepository;

        /// <summary>
        /// Initializes a new instance of the <see cref="HierarchicalEntryLoadViewModelFactory"/> class.
        /// </summary>
        /// <param name="entryRepository">The entry repository.</param>
        public HierarchicalEntryLoadViewModelFactory(
            IDialogService dialogService,
            IFilemanEntryRepository entryRepository)
        {
            Contract.Requires<ArgumentNullException>(entryRepository != null);
            this.dialogService = dialogService;
            this.entryRepository = entryRepository;
        }

        /// <summary>
        /// Gets or sets the hierarchical entry view model factory.
        /// </summary>
        /// <remarks>Can't use constructor injection because it would create a circular dependency.</remarks>
        public IHierarchicalEntryViewModelFactory HierarchicalEntryViewModelFactory { get; set; }

        /// <summary>
        /// Creates the hierarchical entry load view model.
        /// </summary>
        /// <param name="pointer">The pointer.</param>
        /// <param name="parent">The parent.</param>
        /// <returns>A HierarchicalEntryLoadViewModel containing the pointer</returns>
        public HierarchicalEntryLoadViewModel CreateHierarchicalEntryLoadViewModel(FilemanFilePointer pointer, TreeNodeViewModel parent)
        {
            return new HierarchicalEntryLoadViewModel(
                this.dialogService,
                pointer,
                parent,
                this.entryRepository,
                this.HierarchicalEntryViewModelFactory);
        }
    }
}
