//-----------------------------------------------------------------------
// <copyright file="FilemanEntry.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Model
{
    using System;
    using System.Linq;
    using System.Text;
    using System.Xml.Serialization;
    using System.Diagnostics.Contracts;

    /// <summary>
    /// Represents an entry in a Fileman File
    /// </summary>
    [Serializable]
    [XmlRoot("dataDictionaryResultEntry")]
    public class FilemanEntry
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanEntry"/> class.
        /// </summary>
        public FilemanEntry()
        {
        }

        /// <summary>
        /// Initializes a new instance of the FilemanEntry class.
        /// </summary>
        /// <param name="file">The FilemanFile to which this entry belongs.</param>
        public FilemanEntry(FilemanFile file)
        {
            Contract.Requires<ArgumentNullException>(file != null);
            this.File = file;
            if (file.Fields != null && file.Fields.Length > 0)
            {
                this.Values = new FilemanFieldValue[file.Fields.Length];
            }
        }

        /// <summary>
        /// Gets or sets the internal entry number of this entry.
        /// </summary>
        [XmlElement("ien")]
        public string Ien { get; set; }

        /// <summary>
        /// Gets or sets the FilemanFile to which this entry belongs.
        /// </summary>
        [XmlIgnore]
        public FilemanFile File { get; set; }

        /// <summary>
        /// Gets or sets the values of the fields of this entry
        /// </summary>
        [XmlElement("field")]
        public FilemanFieldValue[] Values { get; set; }

        /// <summary>
        /// Gets the <see cref="VistA.Imaging.DataNavigator.Model.FilemanFieldValue"/> with the specified id.
        /// </summary>
        /// <param name="id">The id of the <see cref="VistA.Imaging.DataNavigator.Model.FilemanFieldValue"/></param>
        [XmlIgnore]
        public FilemanFieldValue this[string id]
        {
            get
            {
                if (this.Values == null)
                {
                    return null;
                }

                return this.Values.Where((FilemanFieldValue fv) => fv != null && object.Equals(fv.FieldNumber, id)).FirstOrDefault();
            }
        }

        /// <summary>
        /// Returns a System.String that represents the current FilemanFile.
        /// </summary>
        /// <returns>A System.String that represents the current FilemanFile.</returns>
        public override string ToString()
        {
            StringBuilder builder = new StringBuilder();
            if (this.File != null && !String.IsNullOrEmpty(this.File.Name))
            {
                builder.Append(this.File.ToString());
            }

            if (this.Values != null && this.Values.Length > 0)
            {
                builder.Append("[");
                builder.Append(this.Ien);
                for (int i = 0; i < this.Values.Length; i++)
                {
                    builder.Append(", ");
                    if (this.Values[i] != null)
                    {
                        builder.Append(this.Values[i].ToString());
                    }
                }

                builder.Append("]");
            }

            return builder.ToString();
        }
    }
}
