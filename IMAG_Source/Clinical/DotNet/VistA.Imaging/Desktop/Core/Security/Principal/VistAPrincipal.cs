//-----------------------------------------------------------------------
// <copyright file="VistAPrincipal.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.Security.Principal
{
    using System.Collections.Generic;
    using System.Security.Principal;

    /// <summary>
    /// Represents a user's VistA account.
    /// </summary>
    public class VistAPrincipal : IPrincipal
    {
        /// <summary>
        /// The user's roles
        /// </summary>
        private List<string> roles;

        /// <summary>
        /// Initializes a new instance of the <see cref="VistAPrincipal"/> class.
        /// </summary>
        /// <param name="identity">The identity.</param>
        /// <param name="roles">The roles.</param>
        public VistAPrincipal(VistAIdentity identity, params string[] roles)
        {
            this.Identity = identity;
            this.roles = new List<string>(roles);
            this.Credentials = new List<IVistACredential>();
        }

        #region Properties

        /// <summary>
        /// Gets or sets the current principal
        /// </summary>
        public static VistAPrincipal Current { get; set; }

        /// <summary>
        /// Gets the user's credentials.
        /// </summary>
        public List<IVistACredential> Credentials { get; private set; }

        /// <summary>
        /// Gets or sets the identity of the current principal.
        /// </summary>
        public VistAIdentity Identity { get; protected set; }

        /// <summary>
        /// Gets the identity of the current principal.
        /// </summary>
        /// <returns>The <see cref="T:System.Security.Principal.IIdentity"/> object associated with the current principal.</returns>
        IIdentity IPrincipal.Identity
        {
            get { return this.Identity; }
        }

        #endregion

        /// <summary>
        /// Determines whether the current principal belongs to the specified role.
        /// </summary>
        /// <param name="role">The name of the role for which to check membership.</param>
        /// <returns>
        /// true if the current principal is a member of the specified role; otherwise, false.
        /// </returns>
        public bool IsInRole(string role)
        {
            if (this.roles == null)
            {
                return false;
            }

            return this.roles.Contains(role);
        }
    }
}
