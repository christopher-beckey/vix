/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */
namespace DicomImporter.Common.Model
{
    using System;
    using System.Collections.ObjectModel;
    using System.ComponentModel;

    /// <summary>
    /// The importer work item subtype.
    /// </summary>
    [Serializable]
    public class ImporterWorkItemSubtype : INotifyPropertyChanged
    {
        #region Constants and Fields

        /// <summary>
        /// The all subtypes.
        /// </summary>
        public static readonly ImporterWorkItemSubtype AllSubtypes = new ImporterWorkItemSubtype(
            "AllTypes", "All Types");

        /// <summary>
        /// The dicom correct.
        /// </summary>
        public static readonly ImporterWorkItemSubtype DicomCorrect = new ImporterWorkItemSubtype(
            "DicomCorrect", "DICOM Correct");

        /// <summary>
        /// The direct import.
        /// </summary>
        public static readonly ImporterWorkItemSubtype DirectImport = new ImporterWorkItemSubtype(
            "DirectImport", "Direct Import");

        /// <summary>
        /// The network import.
        /// </summary>
        public static readonly ImporterWorkItemSubtype NetworkImport = new ImporterWorkItemSubtype(
            "NetworkImport", "Network Import");

        /// <summary>
        /// The staged media.
        /// </summary>
        public static readonly ImporterWorkItemSubtype StagedMedia = new ImporterWorkItemSubtype(
            "StagedMedia", "Staged Media");

        /// <summary>
        /// The Community Care.
        /// </summary>
        public static readonly ImporterWorkItemSubtype CommunityCare = new ImporterWorkItemSubtype(
            "CommunityCare", "Community Care");

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ImporterWorkItemSubtype"/> class.
        /// </summary>
        /// <param name="code">
        /// The code.
        /// </param>
        /// <param name="value">
        /// The value.
        /// </param>
        public ImporterWorkItemSubtype(string code, string value)
        {
            this.Code = code;
            this.Value = value;
        }

        #endregion

        #region Public Events

        /// <summary>
        /// The property changed event.
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </summary>
        [field: NonSerialized]//P237 - Critical fix - Avoid  arbitrary code execution vulnerability on or after the deserialization of this class.
        public event PropertyChangedEventHandler PropertyChanged;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets Code.
        /// </summary>
        public string Code { get; set; }

        /// <summary>
        /// Gets or sets Value.
        /// </summary>
        public string Value { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// Gets all subtypes.
        /// </summary>
        /// <returns>
        /// Returns a collection of importer work item subtypes
        /// </returns>
        public static ObservableCollection<ImporterWorkItemSubtype> GetAllSubtypes()
        {
            return new ObservableCollection<ImporterWorkItemSubtype> { AllSubtypes, DirectImport, StagedMedia, DicomCorrect, NetworkImport, CommunityCare };
        }

        public static ImporterWorkItemSubtype GetImporterWorkItemSubtype(string code)
        {
            if (code.Equals("CommunityCare"))
            {
                return ImporterWorkItemSubtype.CommunityCare;
            }

            if (code.Equals("DicomCorrect"))
            {
                return ImporterWorkItemSubtype.DicomCorrect;
            }

            if (code.Equals("DirectImport"))
            {
                return ImporterWorkItemSubtype.DirectImport;
            }

            if (code.Equals("NetworkImport"))
            {
                return ImporterWorkItemSubtype.NetworkImport;
            }

            if (code.Equals("StagedMedia"))
            {
                return ImporterWorkItemSubtype.StagedMedia;
            }

            return ImporterWorkItemSubtype.AllSubtypes;
        }
        #endregion
    }

}
