// -----------------------------------------------------------------------
// <copyright file="ReportSettings.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Mar 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Model for changing the main report templates
//        ;; +--------------------------------------------------------------------+
//        ;; Property of the US Government.
//        ;; No permission to copy or redistribute this software is given.
//        ;; Use of unreleased versions of this software requires the user
//        ;;  to execute a written test agreement with the VistA Imaging
//        ;;  Development Office of the Department of Veterans Affairs,
//        ;;  telephone (301) 734-0100.
//        ;;
//        ;; The Food and Drug Administration classifies this software as
//        ;; a Class II medical device.  As such, it may not be changed
//        ;; in any way.  Modifications to this software may result in an
//        ;; adulterated medical device under 21CFR820, the use of which
//        ;; is considered to be a violation of US Federal Statutes.
//        ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Common.Model
{
    using System.Collections.ObjectModel;

    /// <summary>
    /// Modeling the report templates
    /// </summary>
    public class ReportSettings
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ReportSettings"/> class
        /// </summary>
        public ReportSettings()
        {
            this.RepTemplate = new ReportTemplate();
            this.Templates = new ObservableCollection<ReportTemplate>();
        }

        /// <summary>
        /// Gets or sets the current selected template for the report
        /// </summary>
        public ReportTemplate RepTemplate { get; set; }

        /// <summary>
        /// Gets or sets a list of available templates
        /// </summary>
        public ObservableCollection<ReportTemplate> Templates { get; set; }

        /// <summary>
        /// Get templates from an xml files at default location
        /// </summary>
        //public void GetTemplates()
        //{
        //    this.Templates.Clear();

        //    string folderPath = Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData);
        //    string templateLocation = Path.Combine(folderPath, "VistA\\Imaging\\Telepathology\\RepTemplates");

        //    // make sure the path is valid
        //    if (Directory.Exists(templateLocation))
        //    {
        //        string[] templatePaths = Directory.GetFiles(templateLocation);
        //        foreach (string path in templatePaths)
        //        {
        //            ReportTemplate templt = new ReportTemplate();
        //            templt.DeserializeTemplate(path);
        //            this.Templates.Add(templt);
        //        }
        //    }
        //}

        /// <summary>
        /// Load the template list from a list of xml sources
        /// </summary>
        /// <param name="templatePaths">list contains a path to the source of the xml</param>
        //public void LoadTemplates(List<string> templatePaths)
        //{
        //    this.Templates.Clear();
        //    foreach (string path in templatePaths)
        //    {
        //        if (File.Exists(path))
        //        {
        //            ReportTemplate templt = new ReportTemplate();
        //            templt.DeserializeTemplate(path);
        //            this.Templates.Add(templt);
        //        }
        //    }
        //}
    }
}
