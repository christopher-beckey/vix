// -----------------------------------------------------------------------
// <copyright file="HierarchicalEntryLoadViewModel.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.DataNavigator.ViewModels
{
    using System.Collections.ObjectModel;
    using System.Linq;
    using VistA.Imaging.DataNavigator.Model;
    using VistA.Imaging.DataNavigator.Repositories;
    using System.Diagnostics.Contracts;
    using System;
    using VistA.Imaging.DataNavigator.ViewModels.Factories;
    using System.Threading.Tasks;
    using ImagingClient.Infrastructure.DialogService;
    using System.Collections.Generic;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class HierarchicalEntryLoadViewModel : TreeNodeViewModel
    {
        /// <summary>
        /// The dialog service
        /// </summary>
        private IDialogService dialogService;

        /// <summary>
        /// The IFilemanEntryRepository
        /// </summary>
        private Repositories.IFilemanEntryRepository filemanEntryRepository;

        /// <summary>
        /// The IHierarchicalEntryViewModelFactory
        /// </summary>
        private IHierarchicalEntryViewModelFactory hierarchicalEntryViewModelFactory;

        /// <summary>
        /// Initializes a new instance of the <see cref="HierarchicalEntryLoadViewModel"/> class.
        /// </summary>
        /// <param name="pointer">The pointer.</param>
        /// <param name="parent">The parent.</param>
        /// <param name="filemanEntryRepository">The fileman entry repository.</param>
        /// <param name="hierarchicalEntryViewModelFactory">The hierarchical entry view model factory.</param>
        public HierarchicalEntryLoadViewModel(
            IDialogService dialogService,
            FilemanFilePointer pointer,
            TreeNodeViewModel parent,
            IFilemanEntryRepository filemanEntryRepository,
            IHierarchicalEntryViewModelFactory hierarchicalEntryViewModelFactory)
        {
            Contract.Requires<ArgumentNullException>(pointer != null);
            Contract.Requires<ArgumentNullException>(parent != null);
            Contract.Requires<ArgumentNullException>(filemanEntryRepository != null);
            Contract.Requires<ArgumentNullException>(hierarchicalEntryViewModelFactory != null);
            this.dialogService = dialogService;
            this.Pointer = pointer;
            this.Parent = parent;
            this.filemanEntryRepository = filemanEntryRepository;
            this.hierarchicalEntryViewModelFactory = hierarchicalEntryViewModelFactory;
        }

        /// <summary>
        /// Gets the pointer.
        /// </summary>
        public FilemanFilePointer Pointer { get; private set; }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is selected.
        /// </summary>
        public override bool IsSelected
        {
            get
            {
                return base.IsSelected;
            }

            set
            {
                base.IsSelected = value;
                if (value == true)
                {
                    TaskScheduler context = TaskScheduler.FromCurrentSynchronizationContext();
                    Task.Factory.StartNew(() => (this.Parent as HierarchicalEntryViewModel).LoadChildren(context))
                        .ContinueWith((task) => this.dialogService.ShowExceptionWindow(context, task.Exception),
                            TaskContinuationOptions.OnlyOnFaulted);
                }
            }
        }

        /// <summary>
        /// Returns a <see cref="System.String"/> that represents this instance.
        /// </summary>
        /// <returns>
        /// A <see cref="System.String"/> that represents this instance.
        /// </returns>
        public override string ToString()
        {
            if (this.Pointer != null)
            {
                return "..." + this.Pointer.SourceField.File.Name;
            }

            return base.ToString();
        }
    }
}
