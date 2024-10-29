// -----------------------------------------------------------------------
// <copyright file="IPatientFacade.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Facades
{
    using System;
    using VistA.Imaging.Models;

    /// <summary>
    /// The Patient Facade Interface
    /// </summary>
    public interface IPatientFacade
    {
        /// <summary>
        /// Builds the patient photo URI.
        /// </summary>
        /// <param name="server">The server.</param>
        /// <param name="siteNumber">The site number.</param>
        /// <param name="patientIcn">The patient icn.</param>
        /// <returns>The URI to the patient's photo</returns>
        Uri BuildPatientPhotoUri(SiteConnectionInfo server, string siteNumber, string patientIcn);
    }
}
