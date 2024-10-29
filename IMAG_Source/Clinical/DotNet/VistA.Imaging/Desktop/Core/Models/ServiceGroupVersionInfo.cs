// -----------------------------------------------------------------------
// <copyright file="ServiceGroupVersionInfo.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Models
{
    using System.Collections.Generic;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class ServiceGroupVersionInfo
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ServiceGroupVersionInfo"/> class.
        /// </summary>
        public ServiceGroupVersionInfo()
        {
            this.Endpoints = new Dictionary<string, ServiceEndpointInfo>();
        }

        /// <summary>
        /// Gets or sets the path.
        /// </summary>
        public string Path { get; set; }

        /// <summary>
        /// Gets or sets the version.
        /// </summary>
        public int Version { get; set; }

        /// <summary>
        /// Gets or sets the endpoints.
        /// </summary>
        public Dictionary<string, ServiceEndpointInfo> Endpoints { get; set; }
    }
}
