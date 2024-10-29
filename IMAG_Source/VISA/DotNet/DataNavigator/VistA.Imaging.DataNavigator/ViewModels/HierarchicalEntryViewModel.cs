//-----------------------------------------------------------------------
// <copyright file="HierarchicalEntryViewModel.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.ViewModels
{
    using System.Diagnostics.Contracts;
    using System.Linq;
    using System.Threading.Tasks;
    using ImagingClient.Infrastructure.DialogService;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Events;
    using VistA.Imaging.DataNavigator.Events;
    using VistA.Imaging.DataNavigator.Model;
    using VistA.Imaging.DataNavigator.Repositories;
    using VistA.Imaging.DataNavigator.ViewModels.Factories;

    /// <summary>
    /// TODO: Provide summary section in the documentation header.
    /// </summary>
    public class HierarchicalEntryViewModel : TreeNodeViewModel
    {
        #region Private Fields

        /// <summary>
        /// The parent of this instance
        /// </summary>
        private TreeNodeViewModel parent;

        /// <summary>
        /// Indicates whether or not an attempt has already been made to get the parent
        /// </summary>
        private bool attemptedToGetParent;

        /// <summary>
        /// The FilemanField to identify children
        /// </summary>
        private FilemanField childPointerField;

        /// <summary>
        /// The IFilemanEntryRepository
        /// </summary>
        private IFilemanEntryRepository entryRepository;

        /// <summary>
        /// The IHierarchicalEntryViewModelFactory
        /// </summary>
        private IHierarchicalEntryViewModelFactory hierarchicalEntryViewModelFactory;

        /// <summary>
        /// The IHierarchicalEntryLoadViewModelFactory
        /// </summary>
        private IHierarchicalEntryLoadViewModelFactory hierarchicalEntryLoadViewModelFactory;

        /// <summary>
        /// The Prism event agregator.
        /// </summary>
        public IEventAggregator eventAgregator;

        #endregion

        #region Constructor(s)

        /// <summary>
        /// Initializes a new instance of the <see cref="HierarchicalEntryViewModel"/> class.
        /// </summary>
        public HierarchicalEntryViewModel()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="HierarchicalEntryViewModel"/> class.
        /// </summary>
        /// <param name="entry">The entry.</param>
        /// <param name="childPointerField">The child pointer field.</param>
        /// <param name="parentPointerField">The parent pointer field.</param>
        /// <param name="entryRepository">The entry repository.</param>
        /// <param name="hierarchicalEntryViewModelFactory">The hierarchical entry view model factory.</param>
        /// <param name="hierarchicalEntryLoadViewModelFactory">The hierarchical entry load view model factory.</param>
        public HierarchicalEntryViewModel(
            FilemanEntry entry,
            FilemanField childPointerField,
            FilemanField parentPointerField,
            IFilemanEntryRepository entryRepository,
            IDialogService dialogService,
            IHierarchicalEntryViewModelFactory hierarchicalEntryViewModelFactory,
            IHierarchicalEntryLoadViewModelFactory hierarchicalEntryLoadViewModelFactory,
            IEventAggregator eventAgregator)
        {
            Contract.Requires(entry != null);
            Contract.Requires(entry.File != null);
            Contract.Requires(entryRepository != null);
            Contract.Requires(hierarchicalEntryViewModelFactory != null);
            Contract.Requires(hierarchicalEntryLoadViewModelFactory != null);
            this.Entry = entry;
            this.File = entry.File;
            this.childPointerField = childPointerField;
            this.ParentPointerField = parentPointerField;
            this.entryRepository = entryRepository;
            this.hierarchicalEntryViewModelFactory = hierarchicalEntryViewModelFactory;
            this.hierarchicalEntryLoadViewModelFactory = hierarchicalEntryLoadViewModelFactory;
            this.eventAgregator = eventAgregator;
            this.PointerNavigateCommand = new DelegateCommand<FilemanFieldValue>(field => NavigatePointer(field));
            if (childPointerField != null)
            {
                this.Children.Add(
                    hierarchicalEntryLoadViewModelFactory.CreateHierarchicalEntryLoadViewModel(childPointerField.Pointer, this));
            }
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the file.
        /// </summary>
        public FilemanFile File { get; set; }

        /// <summary>
        /// Gets or sets the entry.
        /// </summary>
        public FilemanEntry Entry { get; set; }

        /// <summary>
        /// Gets or sets the parent.
        /// </summary>
        public override TreeNodeViewModel Parent
        {
            get
            {
                if (this.attemptedToGetParent)
                {
                    return this.parent;
                }

                this.attemptedToGetParent = true;
                if (this.ParentPointerField != null)
                {
                    FilemanFieldValue pfv = this.Entry[this.ParentPointerField.Number];
                    FilemanEntry entry = this.entryRepository.GetByPointer(pfv);
                    if (entry != null)
                    {
                        this.parent = this.hierarchicalEntryViewModelFactory.CreateHierarchicalEntryViewModel(entry);
                        this.parent.Children.Add(this);
                        this.parent.IsExpanded = true;
                    }
                }

                return this.parent;
            }

            set
            {
                this.attemptedToGetParent = true;
                this.parent = value;
            }
        }

        /// <summary>
        /// Gets or sets the parent pointer field.
        /// </summary>
        public FilemanField ParentPointerField { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether the grid is visible.
        /// </summary>
        public bool IsGridVisible { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is expanded.
        /// </summary>
        public override bool IsExpanded
        {
            get
            {
                return base.IsExpanded;
            }

            set
            {
                base.IsExpanded = value;
                if (value == true && this.Children.Count == 1 && !AreChildrenLoaded)
                {
                    this.Children.First().IsSelected = true;
                }
            }
        }

        public override bool AreChildrenLoaded
        {
            get
            {
                return this.Children.Count == 0 || !(this.Children[0] is HierarchicalEntryLoadViewModel);
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Gets the SearchCommand
        /// </summary>
        public DelegateCommand<FilemanFieldValue> PointerNavigateCommand { get; private set; }

        /// <summary>
        /// Loads the children.
        /// </summary>
        /// <param name="context">The UI context.</param>
        public void LoadChildren(TaskScheduler context)
        {
            if (!AreChildrenLoaded)
            {
                HierarchicalEntryLoadViewModel loadNode = this.Children[0] as HierarchicalEntryLoadViewModel;
                Task.Factory.StartNew(() => this.Children.Remove(loadNode),
                    Task.Factory.CancellationToken,
                    TaskCreationOptions.None,
                    context).Wait();
                FilemanEntrySearchResult results = this.entryRepository.FindByReversePointer(this.Entry, loadNode.Pointer);
                if (results.Entries != null)
                {

                    foreach (FilemanEntry entry in results.Entries)
                    {
                        if (!this.Children.Any((TreeNodeViewModel sibling)
                            => (sibling as HierarchicalEntryViewModel).Entry.Ien.Equals(entry.Ien)))
                        {
                            HierarchicalEntryViewModel entryVm = this.hierarchicalEntryViewModelFactory.CreateHierarchicalEntryViewModel(entry);
                            entryVm.Parent = this;
                            Task.Factory.StartNew(() => this.Children.Add(entryVm),
                                Task.Factory.CancellationToken,
                                TaskCreationOptions.None,
                                context).Wait();
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Loads the descendents.
        /// </summary>
        /// <param name="context">The UI context.</param>
        /// <param name="expand">if set to <c>true</c> [expand].</param>
        public void LoadDescendents(TaskScheduler context, bool expand)
        {
            LoadChildren(context);
            if (expand)
            {
                Task.Factory.StartNew(() => this.IsExpanded = true,
                    Task.Factory.CancellationToken,
                    TaskCreationOptions.None,
                    context).Wait();
            }
            foreach (TreeNodeViewModel child in Children)
            {
                (child as HierarchicalEntryViewModel).LoadDescendents(context, expand);
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
            return this.Entry.File.ToString() + ":" + this.Entry.Ien;
        }

        #endregion

        private void NavigatePointer(FilemanFieldValue field)
        {
            this.eventAgregator.GetEvent<NavigatePointerEvent>().Publish(field);
        }
    }
}
