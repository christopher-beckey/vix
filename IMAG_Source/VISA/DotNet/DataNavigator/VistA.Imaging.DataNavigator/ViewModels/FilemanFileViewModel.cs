// -----------------------------------------------------------------------
// <copyright file="FilemanFileViewModel.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.DataNavigator.ViewModels
{
    using System.Collections.ObjectModel;
    using System.Linq;
    using VistA.Imaging.DataNavigator.Model;
    using System.Diagnostics.Contracts;
    using ImagingClient.Infrastructure.Prism.Mvvm;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class FilemanFileViewModel : ViewModel
    {
        /// <summary>
        /// The backing field for the IndexedFieldViewModels property.
        /// </summary>
        private ObservableCollection<FilemanFieldViewModel> indexedFieldViewModelsBackingField;

        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanFileViewModel"/> class.
        /// </summary>
        /// <param name="file">The file contained by this ViewModel</param>
        public FilemanFileViewModel(FilemanFile file)
        {
            Contract.Requires(file != null);
            this.File = file;
        }

        /// <summary>
        /// Gets the indexed field view models.
        /// </summary>
        public virtual ObservableCollection<FilemanFieldViewModel> IndexedFieldViewModels
        {
            get
            {
                if (this.indexedFieldViewModelsBackingField == null)
                {
                    this.indexedFieldViewModelsBackingField = new ObservableCollection<FilemanFieldViewModel>();
                    this.IndexedFieldViewModels.Add(new FilemanFieldViewModel() { IsSelected = true });  // IEN "field" vm
                    this.SelectedIndexedField = IndexedFieldViewModels[0];
                    if (this.File.Fields != null)
                    {
                        foreach (FilemanField field in this.File.Fields.Where(f => f != null && f.IsIndexed))
                        {
                            this.IndexedFieldViewModels.Add(new FilemanFieldViewModel(field));
                        }
                    }
                }

                return this.indexedFieldViewModelsBackingField;
            }
        }

        /// <summary>
        /// Gets or sets the Fileman file.
        /// </summary>
        public virtual FilemanFile File { get; protected set; }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is selected.
        /// </summary>
        public virtual bool IsSelected { get; set; }

        /// <summary>
        /// Gets or sets the selected indexed field.
        /// </summary>
        public FilemanFieldViewModel SelectedIndexedField { get; set; }

        /// <summary>
        /// Returns a <see cref="System.String"/> that represents this instance.
        /// </summary>
        /// <returns>
        /// A <see cref="System.String"/> that represents this instance.
        /// </returns>
        public override string ToString()
        {
            return this.File.Number + ": " + this.File.Name;
        }
    }
}
