// -----------------------------------------------------------------------
// <copyright file="Artifact.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Viewer.Models
{
    using System;
    using System.Collections.Generic;
    using System.Windows.Media.Imaging;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class Artifact : Dictionary<Artifact.Quality, ArtifactInstance>
    {
        private string procedure;
        private DateTime procedureDate;
        private string site;
        private Uri thumbnailURI;
        private bool isThumbnailDownloaded;

        public Artifact()
        {
            this.InitializeProperties(String.Empty, String.Empty, null);
        }

        public Artifact(string procedure, DateTime procedureDate, string site, Uri thumbnailURI)
        {
            this.InitializeProperties(procedure, site, thumbnailURI);
            this.procedureDate = procedureDate;
        }

        public string ThumbnailInfo 
        {
            get
            {
                return "[" + this.site + "] " + this.GetProcedureNameExcerpt() + 
                       " " + this.procedureDate.ToString("MM/dd/yyyy"); }
        }


        public BitmapImage Thumbnail { get; set; }


        public bool ThumbnailDownloaded()
        {
            return this.isThumbnailDownloaded;
        }

        private void InitializeProperties(string procedure, string site, Uri thumbnailURI)
        {
            this.procedure = procedure;
            this.thumbnailURI = thumbnailURI;
            this.isThumbnailDownloaded = false;
            this.site = site;

            if (procedure == null)
            {
                this.procedure = String.Empty;
            }

            if (String.IsNullOrEmpty(site))
            {
                this.site = "N/A";
            }

            if (thumbnailURI == null)
            {
                // add some image 
            }
            else
            {
#if SILVERLIGHT
                this.Thumbnail = new BitmapImage(new Uri(App.Current.Host.Source, "../images/abstract_not_downloaded.jpg"));
#endif
            }
       }
       
        private string GetProcedureNameExcerpt()
        {
            string procedureNameExcerpt = this.procedure;

            if (procedureNameExcerpt.Length > 14)
            {
                procedureNameExcerpt = procedureNameExcerpt.Substring(0, 11);
                procedureNameExcerpt += "...";
            }

            return procedureNameExcerpt;
        }

        /// <summary>
        /// Artifact quality
        /// </summary>
        public enum Quality
        {
            /// <summary>
            /// Abstract Quality
            /// </summary>
            Abstract,

            /// <summary>
            /// Diagnostic Quality
            /// </summary>
            Diagnostic,

            /// <summary>
            /// Reference Quality
            /// </summary>
            Reference
        } 
    }
}
