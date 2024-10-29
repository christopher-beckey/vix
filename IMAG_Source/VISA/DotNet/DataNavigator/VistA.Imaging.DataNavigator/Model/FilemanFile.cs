//-----------------------------------------------------------------------
// <copyright file="FilemanFile.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Model
{
    using System;
    using System.Diagnostics.Contracts;
    using System.Linq;
    using System.Xml.Serialization;

    /// <summary>
    /// Represents a Fileman File
    /// </summary>
    [XmlRoot("dataDictionaryFile")]
    public class FilemanFile
    {
        /// <summary>
        /// Initializes a new instance of the FilemanFile class.
        /// </summary>
        public FilemanFile()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanFile"/> class.
        /// </summary>
        /// <param name="name">The name of the file</param>
        /// <param name="number">The number of the file</param>
        /// <param name="fields">The fields which make up this file</param>
        public FilemanFile(string name, string number, params FilemanField[] fields)
            : this()
        {
            Contract.Requires(!String.IsNullOrWhiteSpace(name));
            Contract.Requires(!String.IsNullOrWhiteSpace(number));
            Contract.Requires(fields != null && fields.Length > 0);
            this.Name = name;
            this.Number = number;
            this.Fields = fields;
        }

        /// <summary>
        /// Gets or sets the name of the file.
        /// </summary>
        [XmlElement("name")]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the number of the file.
        /// </summary>
        [XmlElement("number")]
        public string Number { get; set; }

        /// <summary>
        /// Gets or sets the fields in the file.
        /// </summary>
        [XmlElement("field")]
        public FilemanField[] Fields { get; set; }

        /// <summary>
        /// Gets the <see cref="VistA.Imaging.DataNavigator.Model.FilemanField"/> with the specified id.
        /// </summary>
        /// <param name="id">The id of the <see cref="VistA.Imaging.DataNavigator.Model.FilemanField"/></param>
        public FilemanField this[string id]
        {
            get
            {
                Contract.Requires<ArgumentNullException>(!String.IsNullOrWhiteSpace(id));
                if (this.Fields == null || this.Fields.Length == 0)
                {
                    return null;
                }

                return this.Fields.Where((FilemanField f) => f != null && object.Equals(f.Number, id)).FirstOrDefault();
            }
        }

        /// <summary>
        /// Returns a System.String that represents the current FilemanFile.
        /// </summary>
        /// <returns>A System.String that represents the current FilemanFile.</returns>
        public override string ToString()
        {
            return String.Format("{0} ({1})", this.Name, this.Number);
        }
    }
}
