// -----------------------------------------------------------------------
// <copyright file="PatientFacade.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Facades
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using VistA.Imaging.Models;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class PatientFacade : IPatientFacade
    {
        /// <summary>
        /// The awiv service group
        /// </summary>
        private const string AwivServiceGroup = "AWIV";

        /// <summary>
        /// The photo endpoint name
        /// </summary>
        private const string PhotoEndpointName = "Photo";

        /// <summary>
        /// The service group version
        /// </summary>
        private const int ServiceGroupVersion = 2;

        /// <summary>
        /// The photoUriTemplate
        /// </summary>
        private UriTemplate photoUriTemplate = new UriTemplate("?siteNumber={siteNumber}&patientIcn={patientIcn}", true);

        /// <summary>
        /// Builds the patient photo URI.
        /// </summary>
        /// <param name="server">The server.</param>
        /// <param name="siteNumber">The site number.</param>
        /// <param name="patientIcn">The patient icn.</param>
        /// <returns>The URI to the patient's photo</returns>
        public Uri BuildPatientPhotoUri(SiteConnectionInfo server, string siteNumber, string patientIcn)
        {
            ServiceGroupVersionInfo service = server.Services[AwivServiceGroup].Versions[ServiceGroupVersion];
            Uri rootUri = new Uri(server.VixUri, service.Path + "/" + service.Endpoints[PhotoEndpointName].Path);
            return this.photoUriTemplate.BindByName(rootUri, new Dictionary<string, string>() { { "siteNumber", siteNumber }, { "patientIcn", patientIcn } });
        }
    }
}
