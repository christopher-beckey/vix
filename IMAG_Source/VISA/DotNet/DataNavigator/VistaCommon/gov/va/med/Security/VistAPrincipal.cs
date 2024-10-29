//-----------------------------------------------------------------------
// <copyright file="VistAPrincipal.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistaCommon.gov.va.med.Security
{
    using System;
    using System.Linq;
    using System.Security.Principal;
    using VistaCommon.gov.va.med;
    using System.Diagnostics.Contracts;

    /// <summary>
    /// Represents a user's VistA account.
    /// </summary>
    public class VistAPrincipal : IPrincipal
    {
        protected string[] roles;

        /// <summary>
        /// Initializes a new instance of the <see cref="VistAPrincipal"/> class.
        /// </summary>
        /// <param name="identity">The identity of the user.</param>
        /// <param name="roles">The roles of the user.</param>
        /// <param name="division">The division of the user.</param>
        public VistAPrincipal(VistAIdentity identity, Division division = null, string[] roles = null)
        {
            Contract.Requires<ArgumentNullException>(identity != null);
            this.Identity = identity;
            this.roles = roles;
            this.Division = division;
        }

        /// <summary>
        /// Gets or sets the division.
        /// </summary>
        /// <value>
        /// The division.
        /// </value>
        public Division Division { get; set; }

        /// <summary>
        /// Gets or sets the duz.
        /// </summary>
        public string Duz { get; set; }

        /// <summary>
        /// Gets the identity of the current principal.
        /// </summary>
        /// <returns>The <see cref="T:System.Security.Principal.IIdentity"/> object associated with the current principal.</returns>
        public IIdentity Identity { get; protected set; }

        /// <summary>
        /// Gets or sets the credentials.
        /// </summary>
        public VistACredentials Credentials { get; set; }

        /// <summary>
        /// Determines whether the current principal belongs to the specified role.
        /// </summary>
        /// <param name="role">The name of the role for which to check membership.</param>
        /// <returns>
        /// true if the current principal is a member of the specified role; otherwise, false.
        /// </returns>
        public bool IsInRole(string role)
        {
            return roles.Contains(role);
        }
    }
}
