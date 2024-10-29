// -----------------------------------------------------------------------
// <copyright file="FilemanEntrySearchResult.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.DataNavigator.Model
{
    using System;
    using System.Xml.Serialization;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    [Serializable]
    [XmlRoot("dataDictionaryResult")]
    public class FilemanEntrySearchResult
    {
        /// <summary>
        /// Gets or sets the id to request more records.
        /// </summary>
        [XmlElement("more")]
        public string MoreId { get; set; }

        /// <summary>
        /// Gets or sets the entries returned by the search.
        /// </summary>
        [XmlElement("result")]
        public FilemanEntry[] Entries { get; set; }
    }
}
