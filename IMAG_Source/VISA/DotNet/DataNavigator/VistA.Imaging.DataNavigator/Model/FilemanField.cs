//-----------------------------------------------------------------------
// <copyright file="FilemanField.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Model
{
    using System;
    using System.Xml.Serialization;
    using System.Diagnostics.Contracts;

    /// <summary>
    /// Represents a Field in a Fileman File
    /// </summary>
    public class FilemanField
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanField"/> class.
        /// </summary>
        public FilemanField()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanField"/> class.
        /// </summary>
        /// <param name="name">The name of the field.</param>
        /// <param name="number">The number of the field.</param>
        /// <param name="isIndexed">if set to <c>true</c> the field is indexed.</param>
        /// <param name="pointer">The pointer of the field.</param>
        public FilemanField(string name, string number, bool isIndexed = false, FilemanFilePointer pointer = null)
        {
            Contract.Requires(!String.IsNullOrWhiteSpace(name));
            Contract.Requires(!String.IsNullOrWhiteSpace(number));
            this.Name = name;
            this.Number = number;
            this.IsIndexed = isIndexed;
            this.Pointer = Pointer;
        }

        /// <summary>
        /// Gets or sets the data type of the field.
        /// </summary>
        [XmlIgnore]
        public string DataType { get; set; }

        /// <summary>
        /// Gets or sets the file to which this field belongs.
        /// </summary>
        [XmlIgnore]
        public FilemanFile File { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether this instance is indexed.
        /// </summary>
        /// <value>
        /// 	<c>true</c> if this instance is indexed; otherwise, <c>false</c>.
        /// </value>
        [XmlIgnore]
        public bool IsIndexed { get; set; }

        /// <summary>
        /// Gets or sets the name of the field.
        /// </summary>
        [XmlElement("name")]
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the number of the field.
        /// </summary>
        [XmlElement("number")]
        public string Number { get; set; }

        /// <summary>
        /// Gets or sets the pointer of the field.
        /// </summary>
        [XmlIgnore]
        public FilemanFilePointer Pointer { get; set; }

        /// <summary>
        /// Gets or sets the file number to which the files points.
        /// </summary>
        [XmlElement("pointerFileNumber")]
        public String PointerFileNumber { get; set; }

        /// <summary>
        /// Returns a System.String that represents the current FilemanField.
        /// </summary>
        /// <returns>A System.String that represents the current FilemanField.</returns>
        public override string ToString()
        {
            base.ToString();
            return String.Format("{0} ({1})", this.Name, this.Number);
        }
    }
}
