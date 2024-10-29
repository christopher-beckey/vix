// -----------------------------------------------------------------------
// <copyright file="SearchFilemanFieldViewModel.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.DataNavigator.ViewModels
{
    using ImagingClient.Infrastructure.Prism.Mvvm;
    using VistA.Imaging.DataNavigator.Model;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class FilemanFieldViewModel : ViewModel
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanFieldViewModel"/> class.
        /// </summary>
        /// <param name="field">The field this ViewModel contains</param>
        public FilemanFieldViewModel(FilemanField field = null)
        {
            this.Field = field;
        }

        /// <summary>
        /// Gets or sets the field.
        /// </summary>
        public FilemanField Field { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is selected.
        /// </summary>
        public virtual bool IsSelected { get; set; }

        /// <summary>
        /// Returns a <see cref="System.String"/> that represents this instance.
        /// </summary>
        /// <returns>
        /// A <see cref="System.String"/> that represents this instance.
        /// </returns>
        public override string ToString()
        {
            if (Field == null)
                return "IEN";
            return Field.Number + ": " + Field.Name;
        }
    }
}
