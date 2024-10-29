//-----------------------------------------------------------------------
// <copyright file="SearchType.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Model
{
    /// <summary>
    /// Represents the types of searches which can be performed by this application.
    /// </summary>
    public class SearchType
    {
        /// <summary>
        /// Gets or sets the field.
        /// </summary>
        public FilemanField Field { get; set; }

        /// <summary>
        /// Returns a System.String that represents the current SearchType.
        /// </summary>
        /// <returns>A System.String that represents the current SearchType.</returns>
        public override string ToString()
        {
            if (this.Field == null || this.Field.File == null)
            {
                return base.ToString();
            }
            return string.Format("{0}({1}) {2}({3})", this.Field.File.Name, this.Field.File.Number, this.Field.Name, this.Field.Number);
        }
    }
}
