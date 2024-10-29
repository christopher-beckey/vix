//-----------------------------------------------------------------------
// <copyright file="FilemanFieldValue.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Model
{
    using System;
    using System.Text;
    using System.Xml.Serialization;

    /// <summary>
    /// TODO: Provide summary section in the documentation header.
    /// </summary>
    [Serializable]
    public class FilemanFieldValue
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanFieldValue"/> class.
        /// </summary>
        public FilemanFieldValue()
        {
        }

        /// <summary>
        /// Gets or sets the FilemanField of this value.
        /// </summary>
        [XmlIgnore]
        public FilemanField Field { get; set; }

        /// <summary>
        /// Gets or sets the field number.
        /// </summary>
        [XmlElement("number")]
        public string FieldNumber { get; set; }

        /// <summary>
        /// Gets or sets the internal value.
        /// </summary>
        [XmlElement("internalValue")]
        public string InternalValue { get; set; }

        /// <summary>
        /// Gets or sets the external value.
        /// </summary>
        [XmlElement("externalValue")]
        public string ExternalValue { get; set; }

        /// <summary>
        /// Returns a <see cref="System.String"/> that represents this instance.
        /// </summary>
        /// <returns>
        /// A <see cref="System.String"/> that represents this instance.
        /// </returns>
        public override string ToString()
        {
            StringBuilder builder = new StringBuilder();
            if (this.Field != null)
            {
                builder.Append(this.Field.Name);
            }

            builder.Append("=");
            if (!String.IsNullOrEmpty(this.ExternalValue))
            {
                builder.Append(this.ExternalValue);
            }

            if (!String.IsNullOrEmpty(this.InternalValue))
            {
                builder.Append("(");
                builder.Append(this.InternalValue);
                builder.Append(")");
            }

            return builder.ToString();
        }
    }
}
