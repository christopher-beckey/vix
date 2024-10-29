//-----------------------------------------------------------------------
// <copyright file="DataNavigationViewModel.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.ViewModels
{
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.Diagnostics.Contracts;
    using System.Linq;
    using System.Threading.Tasks;
    using System.Windows;
    using System.Windows.Input;
    using System.Xml;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Prism.Commands;
    using ImagingClient.Infrastructure.Prism.Mvvm;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Events;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Unity;
    using Microsoft.Win32;
    using VistA.Imaging.DataNavigator.Events;
    using VistA.Imaging.DataNavigator.Model;
    using VistA.Imaging.DataNavigator.Repositories;
    using VistA.Imaging.DataNavigator.ViewModels.Factories;

    /// <summary>
    /// This class contains properties that the main View can data bind to.
    /// </summary>
    public class DataNavigationViewModel : ViewModel
    {
        #region Fields

        /// <summary>
        /// The dialog service
        /// </summary>
        private IDialogService dialogService;

        /// <summary>
        /// The module containing this ViewModel
        /// </summary>
        private DataNavigatorModule module;

        /// <summary>
        /// The IFilemanFileRepository this ViewModel uses
        /// </summary>
        private IFilemanFileRepository filemanFileRepository;

        /// <summary>
        /// The IFilemanEntryRepository this ViewModel uses
        /// </summary>
        private IFilemanEntryRepository filemanEntryRepository;

        /// <summary>
        /// The IHierarchicalEntryViewModelFactory the ViewModel uses
        /// </summary>
        private IHierarchicalEntryViewModelFactory hierarchicalEntryViewModelFactory;

        /// <summary>
        /// The selected node in the TreeView
        /// </summary>
        private TreeNodeViewModel SelectedNodeBackingField;

        /// <summary>
        /// Backing field for the IsShowingAncestors property
        /// </summary>
        private bool IsShowingAncestorsBackingField;

        /// <summary>
        /// The XML Document is used to generate an XML version 
        /// of the tree hiearchy.
        /// </summary>
        private XmlDocument xmlDocument;

        #endregion

        #region Constructor(s)

        /// <summary>
        /// Initializes a new instance of the <see cref="DataNavigationViewModel"/> class.
        /// </summary>
        public DataNavigationViewModel()
        {
            this.SearchCommand = new DelegateCommandProp(() => this.ExecuteSearch());
            this.CheckFileCommand = new DelegateCommand(() => this.CheckFile());
            this.ExpandAllTreeNodesCommand = new DelegateCommand(() => this.ExpandAllTreeNodes());
            this.CollapseAllTreeNodesCommand = new DelegateCommand(() => this.CollapseAllTreeNodes());
            this.SaveAsXMLFileCommand = new DelegateCommand(() => this.SaveAsXMLFile(), () => this.CanExecuteTask);
            this.EntryViewModels = new ObservableCollection<TreeNodeViewModel>();
            this.SearchFiles = new ObservableCollection<FilemanFileViewModel>();
            this.EntryViewModelTrail = new ObservableCollection<HierarchicalEntryViewModel>();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="DataNavigationViewModel"/> class.
        /// </summary>
        /// <param name="regionManager">The region manager.</param>
        /// <param name="filemanFileRepository">The fileman file repository.</param>
        /// <param name="entryRepository">The entry repository.</param>
        /// <param name="hierarchicalEntryViewModelFactory">The hierarchical entry view model factory.</param>
        /// <param name="module">The module.</param>
        [InjectionConstructor]
        public DataNavigationViewModel(
            IRegionManager regionManager,
            IDialogService dialogService,
            IFilemanFileRepository filemanFileRepository,
            IFilemanEntryRepository entryRepository,
            IHierarchicalEntryViewModelFactory hierarchicalEntryViewModelFactory,
            DataNavigatorModule module,
            IEventAggregator eventAgregator)
            : base(regionManager)
        {
            Contract.Requires(regionManager != null);
            Contract.Requires(filemanFileRepository != null);
            Contract.Requires(entryRepository != null);
            Contract.Requires(hierarchicalEntryViewModelFactory != null);
            Contract.Requires(module != null);
            this.dialogService = dialogService;
            this.filemanFileRepository = filemanFileRepository;
            this.filemanEntryRepository = entryRepository;
            this.hierarchicalEntryViewModelFactory = hierarchicalEntryViewModelFactory;
            this.SearchCommand = new DelegateCommandProp(() => this.ExecuteSearch(), () => this.CanSearch);
            this.CheckFileCommand = new DelegateCommand(() => this.CheckFile(), () => this.CanExecuteTask);
            this.ExpandAllTreeNodesCommand = new DelegateCommand(() => this.ExpandAllTreeNodes(), () => this.CanExecuteTask);
            this.CollapseAllTreeNodesCommand = new DelegateCommand(() => this.CollapseAllTreeNodes(), () => this.CanExecuteTask);
            this.ExpandAllTrailGridsCommand = new DelegateCommand(() => this.ExpandAllTrailGrids(), () => this.CanExecuteTask);
            this.CollapseAllTrailGridsCommand = new DelegateCommand(() => this.CollapseAllTrailGrids(), () => this.CanExecuteTask);
            this.FollowPointerCommand = new DelegateCommand<FilemanFieldValue>((value) => this.FollowPointer(value));
            this.SaveAsXMLFileCommand = new DelegateCommand(() => this.SaveAsXMLFile(), () => this.CanExecuteTask); // && this.EntryViewModels.Count > 0);
            this.EntryViewModels = new ObservableCollection<TreeNodeViewModel>();
            this.SearchFiles = new ObservableCollection<FilemanFileViewModel>();
            this.EntryViewModelTrail = new ObservableCollection<HierarchicalEntryViewModel>();
            this.module = module;
            this.xmlDocument = new XmlDocument();
            eventAgregator.GetEvent<NavigatePointerEvent>().Subscribe(fieldValue => NavigatePointer(fieldValue), ThreadOption.UIThread, false);
        }

        #endregion

        #region Commands

        /// <summary>
        /// Gets the SearchCommand
        /// </summary>
        public DelegateCommand SearchCommand { get; private set; }

        /// <summary>
        /// Gets the check file command.
        /// </summary>
        public DelegateCommand CheckFileCommand { get; private set; }

        /// <summary>
        /// Gets the expand all tree nodes command.
        /// </summary>
        public DelegateCommand ExpandAllTreeNodesCommand { get; private set; }

        /// <summary>
        /// Gets the collapse all tree nodes command.
        /// </summary>
        public DelegateCommand CollapseAllTreeNodesCommand { get; private set; }

        /// <summary>
        /// Gets the expand all tree nodes command.
        /// </summary>
        public DelegateCommand ExpandAllTrailGridsCommand { get; private set; }

        /// <summary>
        /// Gets the collapse all tree nodes command.
        /// </summary>
        public DelegateCommand CollapseAllTrailGridsCommand { get; private set; }

        /// <summary>
        /// Gets the follow pointer command.
        /// </summary>
        public DelegateCommand<FilemanFieldValue> FollowPointerCommand { get; private set; }

        /// <summary>
        /// Gets the save as XML file command.
        /// </summary>
        public DelegateCommand SaveAsXMLFileCommand { get; private set; }

        #endregion

        #region Properties

        /// <summary>
        /// Gets the search files.
        /// </summary>
        public ObservableCollection<FilemanFileViewModel> SearchFiles { get; private set; }

        /// <summary>
        /// Gets or sets the search file text.
        /// </summary>
        public string SearchFileText { get; set; }

        /// <summary>
        /// Gets the entries to display.
        /// </summary>
        public ObservableCollection<TreeNodeViewModel> EntryViewModels { get; private set; }

        /// <summary>
        /// Gets the entry view model trail.
        /// </summary>
        public ObservableCollection<HierarchicalEntryViewModel> EntryViewModelTrail { get; private set; }

        /// <summary>
        /// Gets or sets the selected search file.
        /// </summary>
        public FilemanFileViewModel SelectedSearchFile { get; set; }

        /// <summary>
        /// Gets or sets the search text.
        /// </summary>
        public string SearchText { get; set; }

        /// <summary>
        /// Gets a value indicating whether the search option is available.
        /// </summary>
        public bool CanSearch
        {
            get
            {
                return this.SelectedSearchFile != null
                    && this.SelectedSearchFile.SelectedIndexedField != null
                    && !String.IsNullOrWhiteSpace(this.SearchText)
                    && this.CanExecuteTask;
            }
        }

        /// <summary>
        /// Gets a value indicating whether a task can be executed now.
        /// </summary>
        public bool CanExecuteTask
        {
            get { return ExecutingTask == null; }
        }

        /// <summary>
        /// Gets or sets the selected entry.
        /// </summary>
        public TreeNodeViewModel SelectedNode
        {
            get { return this.SelectedNodeBackingField; }

            set
            {
                this.SelectedNodeBackingField = value;
                if (value == null || !(value is HierarchicalEntryViewModel))
                {
                    this.EntryViewModelTrail.Clear();
                }
                else
                {
                    if (this.IsShowingAncestors)
                    {
                        IEnumerable<HierarchicalEntryViewModel> lineage = from n in value.Lineage
                                                                          where n is HierarchicalEntryViewModel
                                                                          select n as HierarchicalEntryViewModel;
                        HierarchicalEntryViewModel last = this.EntryViewModelTrail.LastOrDefault(e => lineage.Contains(e))
                            as HierarchicalEntryViewModel;
                        if (last == null)
                        {
                            this.EntryViewModelTrail.Clear();
                        }
                        else
                        {
                            int index = this.EntryViewModelTrail.IndexOf(last);
                            lineage = lineage.Skip(index + 1);
                            while (this.EntryViewModelTrail.Count > index + 1)
                            {
                                this.EntryViewModelTrail.RemoveAt(index + 1);
                            }
                        }

                        foreach (HierarchicalEntryViewModel newNode in lineage)
                        {
                            this.EntryViewModelTrail.Add(newNode);
                        }
                    }
                    else
                    {
                        this.EntryViewModelTrail.Clear();
                        this.EntryViewModelTrail.Add(value as HierarchicalEntryViewModel);
                    }

                    this.EntryViewModelTrail.Last().IsGridVisible = true;
                }
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is showing ancestors.
        /// </summary>
        public bool IsShowingAncestors
        {
            get
            {
                return this.IsShowingAncestorsBackingField;
            }

            set
            {
                if (value != this.IsShowingAncestorsBackingField)
                {
                    this.IsShowingAncestorsBackingField = value;
                    TreeNodeViewModel temp = this.SelectedNode;
                    this.SelectedNode = null;
                    this.SelectedNode = temp;
                }
            }
        }

        /// <summary>
        /// Gets or sets the executing task.
        /// </summary>
        protected Task ExecutingTask { get; set; }

        #endregion

        /// <summary>
        /// Initialzes this instance.
        /// </summary>
        public override void Initialze()
        {
            TaskScheduler context = TaskScheduler.FromCurrentSynchronizationContext();
            Task.Factory.StartNew(() =>
            {
                this.InitializeSearchFiles(context);
                this.InitializeIndexedFields(context);
                this.InitializeSpecialPointers(context);
                this.InitializeParentPointers(context);
            }).ContinueWith((task) => HandleInitializationError(context, task),
                TaskContinuationOptions.OnlyOnFaulted);
        }

        #region Private Methods

        /// <summary>
        /// Display any initialization errors and then shuts down the application.
        /// </summary>
        /// <param name="context">The context.</param>
        /// <param name="task">The task.</param>
        private void HandleInitializationError(TaskScheduler context, Task task)
        {
            this.dialogService.ShowExceptionWindow(context, task.Exception);
            this.dialogService.ShowAlertBox(context, "The Data Navigator has encountered an error and will shut down now.",
                                            "Data Navigator Shutdown", MessageTypes.Warning);

            // Shutsdown the application.
            Task.Factory.StartNew(() =>
            {
                Application.Current.Shutdown();
            },
            Task.Factory.CancellationToken,
            TaskCreationOptions.None,
            context).Wait();
        }

        /// <summary>
        /// Display any file saving errors
        /// </summary>
        /// <param name="context">The context.</param>
        /// <param name="task">The task.</param>
        private void HandleFileSavingErrors(TaskScheduler context, Task task)
        {
            this.dialogService.ShowExceptionWindow(context, task.Exception);
  
            Task.Factory.StartNew(() =>
            {
                this.ExecutingTask = null;
                Mouse.OverrideCursor = null;
            }, Task.Factory.CancellationToken, TaskCreationOptions.None, context).Wait();
        }

        /// <summary>
        /// Initializes the search files.
        /// </summary>
        private void InitializeSearchFiles(TaskScheduler context)
        {
            string fileIds = this.module.Configuration.AppSettings.Settings["FilemanFiles"].Value;
            FilemanFile file;
            foreach (string fileId in fileIds.Split(','))
            {
                file = this.filemanFileRepository.GetById(fileId);
                Task.Factory.StartNew(() =>
                {
                    this.SearchFiles.Add(new FilemanFileViewModel(file));
                }, Task.Factory.CancellationToken, TaskCreationOptions.None, context).Wait();
            }
        }

        /// <summary>
        /// Initializes the indexed fields.
        /// </summary>
        private void InitializeIndexedFields(TaskScheduler context)
        {
            FilemanFile file;
            string indexedFieldIds = this.module.Configuration.AppSettings.Settings["IndexedFields"].Value;
            string[] fieldIdParts;
            foreach (string fileIdfieldId in indexedFieldIds.Split(','))
            {
                fieldIdParts = fileIdfieldId.Split(':');
                file = this.filemanFileRepository.GetById(fieldIdParts[0]);
                Task.Factory.StartNew(() =>
                {
                    file[fieldIdParts[1]].IsIndexed = true;
                }, Task.Factory.CancellationToken, TaskCreationOptions.None, context).Wait();
            }
        }

        /// <summary>
        /// Initializes the special pointers.
        /// </summary>
        private void InitializeSpecialPointers(TaskScheduler context)
        {
            string[] specialPointerParts, sourceParts, targetParts;
            string specialPointers = this.module.Configuration.AppSettings.Settings["SpecialPointers"].Value;
            FilemanFile sourceFile;
            FilemanField sourceField;
            foreach (string specialPointerText in specialPointers.Split(','))
            {
                specialPointerParts = specialPointerText.Split('=');
                sourceParts = specialPointerParts[0].Split(':');
                targetParts = specialPointerParts[1].Split(':');
                sourceFile = this.filemanFileRepository.GetById(sourceParts[0]);
                sourceField = sourceFile[sourceParts[1]];
                Task.Factory.StartNew(() =>
                {
                    if (targetParts.Length == 1)
                    {
                        sourceField.Pointer = new FilemanFilePointer(this.filemanFileRepository, sourceField, targetParts[0]);
                    }
                    else
                    {
                        sourceField.Pointer = new FilemanFieldPointer(this.filemanFileRepository, sourceField, targetParts[0], targetParts[1]);
                    }
                }, Task.Factory.CancellationToken, TaskCreationOptions.None, context).Wait();
            }
        }

        /// <summary>
        /// Initializes the parent pointers.
        /// </summary>
        private void InitializeParentPointers(TaskScheduler context)
        {
            string[] parentPointerParts;
            FilemanFile childFile, parentFile;
            FilemanField pointerField;
            string parentPointers = this.module.Configuration.AppSettings.Settings["ParentPointers"].Value;
            foreach (string parentPointerText in parentPointers.Split(','))
            {
                parentPointerParts = parentPointerText.Split(':');
                childFile = this.filemanFileRepository.GetById(parentPointerParts[0]);
                pointerField = childFile[parentPointerParts[1]];
                parentFile = pointerField.Pointer.TargetFile;
                Task.Factory.StartNew(() =>
                {
                    this.hierarchicalEntryViewModelFactory.ChildPointers.Add(childFile, pointerField);
                    this.hierarchicalEntryViewModelFactory.ParentPointers.Add(parentFile, pointerField);
                }, Task.Factory.CancellationToken, TaskCreationOptions.None, context).Wait();
            }
        }

        /// <summary>
        /// Executes the search.
        /// </summary>
        private void ExecuteSearch()
        {
            this.EntryViewModels.Clear();
            HierarchicalEntryViewModel entryVm = null;
            TaskScheduler context = TaskScheduler.FromCurrentSynchronizationContext();
            this.ExecutingTask = Task.Factory.StartNew(() =>
            {
                if (this.SelectedSearchFile.SelectedIndexedField.Field == null)
                {
                    FilemanEntry entry =
                        this.filemanEntryRepository.GetById(this.SelectedSearchFile.File, this.SearchText);
                    if (entry != null)
                    {
                        Task.Factory.StartNew(() =>
                        {
                            entryVm = this.AddEntryToTree(entry);
                            entryVm.IsSelected = true;
                        }, Task.Factory.CancellationToken, TaskCreationOptions.None, context).Wait();
                    }
                    else
                    {
                        this.dialogService.ShowAlertBox(
                            context,
                            "No entry was found in File " + this.SelectedSearchFile.File + " with the IEN " + this.SearchText,
                            "Entry not found",
                            MessageTypes.Error);
                    }
                }
                else
                {
                    FilemanEntrySearchResult results =
                        this.filemanEntryRepository.FindByIndexedField(this.SelectedSearchFile.SelectedIndexedField.Field, this.SearchText);
                    if (results != null && results.Entries != null && results.Entries.Length > 0)
                    {
                        Task.Factory.StartNew(() =>
                        {
                            foreach (FilemanEntry entry in results.Entries)
                            {
                                entryVm = this.AddEntryToTree(entry);
                            }
                            entryVm.IsSelected = true;
                        }, Task.Factory.CancellationToken, TaskCreationOptions.None, context).Wait();
                    }
                    else
                    {
                        this.dialogService.ShowAlertBox(
                            context,
                            "No entries found",
                            "No entries found",
                            MessageTypes.Error);
                    }
                }

                this.ExecutingTask = null;
            }).ContinueWith((task) => this.dialogService.ShowExceptionWindow(context, task.Exception),
                            TaskContinuationOptions.OnlyOnFaulted);
        }

        /// <summary>
        /// Checks the file.
        /// </summary>
        private void CheckFile()
        {
            if (!string.IsNullOrEmpty(this.SearchFileText))
            {
                string fileNumber = this.SearchFileText.Split(':')[0];
                if (!string.IsNullOrWhiteSpace(fileNumber)
                    && (this.SelectedSearchFile == null || (this.SelectedSearchFile.File != null
                    && !object.Equals(fileNumber, this.SelectedSearchFile.File.Number))))
                {
                    TaskScheduler context = TaskScheduler.FromCurrentSynchronizationContext();
                    this.ExecutingTask = Task.Factory.StartNew(() =>
                    {
                        FilemanFile file = this.filemanFileRepository.GetById(this.SearchFileText);
                        if (file != null)
                        {
                            FilemanFileViewModel fileVm = new FilemanFileViewModel(file);
                            Task.Factory.StartNew(() =>
                            {
                                this.SearchFiles.Add(fileVm);
                                this.SelectedSearchFile = fileVm;
                            }, Task.Factory.CancellationToken, TaskCreationOptions.None, context).Wait();
                        }

                        this.ExecutingTask = null;
                    }).ContinueWith((task) => this.dialogService.ShowExceptionWindow(context, task.Exception),
                                TaskContinuationOptions.OnlyOnFaulted);
                }
            }
        }

        /// <summary>
        /// Expands all nodes in the tree.
        /// </summary>
        private void ExpandAllTreeNodes()
        {
            TaskScheduler context = TaskScheduler.FromCurrentSynchronizationContext();
            this.ExecutingTask = Task.Factory.StartNew(() =>
            {
                foreach (HierarchicalEntryViewModel child in this.EntryViewModels)
                {
                    child.LoadDescendents(context, true);
                }

                this.ExecutingTask = null;
            })
            .ContinueWith((task) => this.dialogService.ShowExceptionWindow(context, task.Exception),
                            TaskContinuationOptions.OnlyOnFaulted);
        }

        /// <summary>
        /// Collapses all nodes in the tree.
        /// </summary>
        private void CollapseAllTreeNodes()
        {
            foreach (HierarchicalEntryViewModel child in this.EntryViewModels)
            {
                child.IsExpanded = false;
                child.SetIsExpandedOnDescendents(false);
            }
        }

        /// <summary>
        /// Expands all trail grids.
        /// </summary>
        /// <returns></returns>
        private void ExpandAllTrailGrids()
        {
            foreach (HierarchicalEntryViewModel vm in this.EntryViewModelTrail)
            {
                vm.IsGridVisible = true;
            }
        }

        /// <summary>
        /// Collapses all trail grids.
        /// </summary>
        /// <returns></returns>
        private void CollapseAllTrailGrids()
        {
            foreach (HierarchicalEntryViewModel vm in this.EntryViewModelTrail)
            {
                vm.IsGridVisible = false;
            }
        }

        /// <summary>
        /// Follows the pointer.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        private object FollowPointer(FilemanFieldValue value)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Function used to convert and save the selected 
        /// </summary>
        private void SaveAsXMLFile()
        {
            if (this.SelectedNode == null)
            {
                this.dialogService.ShowAlertBox(TaskScheduler.FromCurrentSynchronizationContext(),
                                                "Please select a file to convert to XML. You must perform a search before " +
                                                "they are displayed.", "Unable to convert file to XML", MessageTypes.Warning);
                return;
            }

            // retrieves the location and file name from the user
            string fileName = this.dialogService.ShowSaveFileDialog("Entry.xml", ".xml");
            if (string.IsNullOrWhiteSpace(fileName))
            {
                return;
            }

            TaskScheduler context = TaskScheduler.FromCurrentSynchronizationContext();
            this.dialogService.ShowAlertBox(context, "Generating XML", "Converting to XML", MessageTypes.Info);
            Mouse.OverrideCursor = Cursors.Wait;
            this.ExecutingTask = Task.Factory.StartNew(() =>
            {
                List<HierarchicalEntryViewModel> lineage = new List<HierarchicalEntryViewModel>();

                // copies lineage over to a temporary list 
                foreach (HierarchicalEntryViewModel entry in this.SelectedNode.Lineage)
                {
                    lineage.Add(entry);
                }

                // generates the XML and saves it to the file
                this.xmlDocument.AppendChild(this.GenerateXML(lineage, context));
                this.xmlDocument.Save(fileName);
                this.xmlDocument.RemoveAll();

                this.dialogService.ShowAlertBox(context, "The XML was saved to " + fileName,
                                                "Conversion Complete", MessageTypes.Info);

                // displays completion message using the main process
                Task.Factory.StartNew(() =>
                {
                    Mouse.OverrideCursor = null;
                }, Task.Factory.CancellationToken, TaskCreationOptions.None, context).Wait();

                this.ExecutingTask = null;

            }).ContinueWith((task) => this.HandleFileSavingErrors(context, task),
                            TaskContinuationOptions.OnlyOnFaulted);
        }

        /// <summary>
        /// Generates the XML for the selected node using its lineage.
        /// </summary>
        /// <param name="lineage">The file lineage.</param>
        /// <param name="context">The context.</param>
        /// <returns></returns>
        private XmlNode GenerateXML(List<HierarchicalEntryViewModel> lineage, TaskScheduler context)
        {
            // tests for ending cases
            if (lineage == null || lineage.Count == 0)
            {
                return null;
            }

            HierarchicalEntryViewModel hiearchicalEntry = lineage.ElementAt(0);
            XmlNode xmlFileElement =  this.GenerateFileXML(hiearchicalEntry);
           
            lineage.RemoveAt(0);

            // if there are no more files then the current is the selected node and its children need to be added
            if (lineage.Count == 0)
            {
                hiearchicalEntry.LoadDescendents(context, false);
                xmlFileElement = GenerateDescendantsXML(xmlFileElement, hiearchicalEntry.Children);
            }
            else
            {
                xmlFileElement.AppendChild(GenerateXML(lineage, context));
            }

            return xmlFileElement;
        }

        /// <summary>
        /// Generates the descendants XML from the parent node.
        /// </summary>
        /// <param name="parentNode">The parent XML node.</param>
        /// <param name="children">The children of the current parent node.</param>
        /// <returns></returns>
        private XmlNode GenerateDescendantsXML(XmlNode parentNode, ObservableCollection<TreeNodeViewModel> children)
        {
            if(children == null)
            {
                return null;
            }

            foreach (TreeNodeViewModel node in children)
            {
                HierarchicalEntryViewModel hiearchicalEntry = (node as HierarchicalEntryViewModel);
    
                XmlNode xmlChildFileElement = this.GenerateFileXML(hiearchicalEntry);
                xmlChildFileElement = this.GenerateDescendantsXML(xmlChildFileElement, hiearchicalEntry.Children);

                parentNode.AppendChild(xmlChildFileElement);
            }
        
            return parentNode;
        }

        /// <summary>
        /// Generates xml for a File.
        /// </summary>
        /// <param name="hiearchicalEntry">The hiearchical entry of the file.</param>
        /// <returns></returns>
        private XmlNode GenerateFileXML(HierarchicalEntryViewModel hiearchicalEntry)
        {
            if (hiearchicalEntry == null)
            {
                return null;
            }

            XmlNode xmlFileElement = this.xmlDocument.CreateElement(this.ScrubForCharacters(hiearchicalEntry.File.Name));

            // adds the file number as an attribute
            XmlAttribute xmlAttribute = this.xmlDocument.CreateAttribute("file_number");
            xmlAttribute.Value = hiearchicalEntry.File.Number;
            xmlFileElement.Attributes.Append(xmlAttribute);

            // adds the IEN as an attribute
            xmlAttribute = this.xmlDocument.CreateAttribute("ien");
            xmlAttribute.Value = hiearchicalEntry.Entry.Ien;
            xmlFileElement.Attributes.Append(xmlAttribute);

            // adds all of the file field values as children elements
            foreach (FilemanFieldValue value in hiearchicalEntry.Entry.Values)
            {
                XmlNode xmlFileFieldElement = this.xmlDocument.CreateElement(this.ScrubForCharacters(value.Field.Name));

                XmlElement xmlNumberElement = this.xmlDocument.CreateElement("number");
                xmlNumberElement.InnerText = value.Field.Number;

                XmlElement xmlInternalElement = this.xmlDocument.CreateElement("internal");
                xmlInternalElement.InnerText = value.InternalValue;

                XmlElement xmlExternalElement = this.xmlDocument.CreateElement("external");
                xmlExternalElement.InnerText = value.ExternalValue;

                xmlFileFieldElement.AppendChild(xmlNumberElement);
                xmlFileFieldElement.AppendChild(xmlInternalElement);
                xmlFileFieldElement.AppendChild(xmlExternalElement);

                xmlFileElement.AppendChild(xmlFileFieldElement);
            }

            return xmlFileElement;
        }

        /// <summary>
        /// Adds the entry to tree.
        /// </summary>
        /// <param name="entry">The entry.</param>
        /// <returns>The HierarchicalEntryViewModel containing the entry</returns>
        private HierarchicalEntryViewModel AddEntryToTree(FilemanEntry entry)
        {
            HierarchicalEntryViewModel entryVm = this.hierarchicalEntryViewModelFactory.CreateHierarchicalEntryViewModel(entry);
            if (entryVm.ParentPointerField == null)
            {
                this.EntryViewModels.Add(entryVm);
            }
            else
            {
                FilemanFieldValue parentPointerFieldValue = entry[entryVm.ParentPointerField.Number];
                HierarchicalEntryViewModel parentVm = this.FindNode(parentPointerFieldValue, this.EntryViewModels);
                if (parentVm != null)
                {
                    parentVm.Children.Add(entryVm);
                }
                else
                {
                    TreeNodeViewModel rootAncestor = entryVm;
                    while (rootAncestor.Parent != null)
                    {
                        rootAncestor = rootAncestor.Parent;
                    }

                    this.EntryViewModels.Add(rootAncestor);
                }
            }

            return entryVm;
        }

        /// <summary>
        /// Scrubs for characters and replaces a null instace with the empty string.
        /// </summary>
        /// <param name="value">The value.</param>
        /// <returns></returns>
        private string ScrubForCharacters(String value)
        {
            if (value == null)
            {
                value = String.Empty;
            }
            else
            {
                value = value.Replace(" ", "_");
                value = value.Replace("/", "_");
                value = value.Replace("\\", "_");
                value = value.Replace("(", "_");
                value = value.Replace(")", "_");
            }

            return value;
        }

        /// <summary>
        /// Finds the node.
        /// </summary>
        /// <param name="parentPointerFieldValue">The parent pointer field value.</param>
        /// <param name="viewmodels">The viewmodels</param>
        /// <returns>The HierarchicalEntryViewModel </returns>
        private HierarchicalEntryViewModel FindNode(FilemanFieldValue parentPointerFieldValue, IEnumerable<TreeNodeViewModel> viewmodels)
        {
            if (parentPointerFieldValue == null || parentPointerFieldValue.Field == null || parentPointerFieldValue.Field.Pointer == null)
            {
                return null;
            }

            HierarchicalEntryViewModel result = null;

            foreach (TreeNodeViewModel vm in viewmodels)
            {
                if (vm is HierarchicalEntryViewModel)
                {
                    FilemanEntry entry = (vm as HierarchicalEntryViewModel).Entry;
                    string currentValue = string.Empty;
                    if (parentPointerFieldValue.Field.Pointer is FilemanFieldPointer)
                    {
                        FilemanFieldPointer fieldPointer = parentPointerFieldValue.Field.Pointer as FilemanFieldPointer;
                        if (fieldPointer.TargetField.File.Equals(entry.File))
                        {
                            currentValue = entry[fieldPointer.TargetField.Number].ExternalValue;
                        }
                    }
                    else
                    {
                        if ((parentPointerFieldValue.Field.Pointer as FilemanFilePointer).TargetFile.Equals(entry.File))
                        {
                            currentValue = entry.Ien;
                        }
                    }

                    if (parentPointerFieldValue.InternalValue.Equals(currentValue))
                    {
                        result = vm as HierarchicalEntryViewModel;
                        break;
                    }
                    else
                    {
                        result = this.FindNode(parentPointerFieldValue, vm.Children);
                        if (result != null)
                        {
                            break;
                        }
                    }
                }
            }

            return result;
        }

        private void NavigatePointer(FilemanFieldValue field)
        {

        }

        #endregion
    }
}
