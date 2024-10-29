// -----------------------------------------------------------------------
// <copyright file="Patient.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Models
{
    using System;
    using System.ComponentModel;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class Patient : INotifyPropertyChanged
    {
        /// <summary>
        /// Occurs when a property value changes.
        /// </summary>
        /// <remarks>
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </remarks>
#pragma warning disable 0067
        // Warning disabled because the event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 0067

        /// <summary>
        /// Gets or sets the current patient.
        /// </summary>
        public static Patient Current { get; set; }

        /// <summary>
        /// Gets or sets the full name.
        /// </summary>
        public string FullName { get; set; }

        /// <summary>
        /// Gets or sets the Social Security Number.
        /// </summary>
        public string SSN { get; set; }

        /// <summary>
        /// Gets or sets the Integration Control Number.
        /// </summary>
        public string ICN { get; set; }

        /// <summary>
        /// Gets or sets the photo URI.
        /// </summary>
        public Uri PhotoUri { get; set; }
    }
}
