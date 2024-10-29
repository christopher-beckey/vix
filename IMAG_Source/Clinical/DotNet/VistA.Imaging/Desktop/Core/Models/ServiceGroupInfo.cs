// -----------------------------------------------------------------------
// <copyright file="ServiceGroupInfo.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Models
{
    using System.Collections.Generic;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class ServiceGroupInfo
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ServiceGroupInfo"/> class.
        /// </summary>
        public ServiceGroupInfo()
        {
            this.Versions = new Dictionary<int, ServiceGroupVersionInfo>();
        }

        /// <summary>
        /// Gets or sets the type of the service.
        /// </summary>
        public string ServiceType { get; set; }

        /// <summary>
        /// Gets or sets the versions.
        /// </summary>
        public Dictionary<int, ServiceGroupVersionInfo> Versions { get; set; }
    }
}
