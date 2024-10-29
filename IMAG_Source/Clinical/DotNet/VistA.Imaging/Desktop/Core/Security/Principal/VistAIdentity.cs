//-----------------------------------------------------------------------
// <copyright file="VistAIdentity.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.Security.Principal
{
    using System;
    using System.Diagnostics.Contracts;
    using System.Security.Principal;

    /// <summary>
    /// Represents a user's VistA information
    /// </summary>
    public class VistAIdentity : IIdentity
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="VistAIdentity"/> class.
        /// </summary>
        /// <param name="name">The name of the user</param>
        public VistAIdentity(string name)
        {
            Contract.Requires<ArgumentException>(name != null && name.Length > 0);
            this.Name = name;
        }

        /// <summary>
        /// Gets or sets the type of authentication used.
        /// </summary>
        /// <returns>The type of authentication used to identify the user.</returns>
        public string AuthenticationType { get; set; }

        /// <summary>
        /// Gets or sets the name of the user.
        /// </summary>
        /// <returns>The name of the user on whose behalf the code is running.</returns>
        public string Name { get; protected set; }

        /// <summary>
        /// Gets or sets the full name of the user.
        /// </summary>
        public string FullName { get; set; }

        /// <summary>
        /// Gets or sets the SSN.
        /// </summary>
        public string Ssn { get; set; }

        /// <summary>
        /// Gets a value indicating whether the user has been authenticated.
        /// </summary>
        /// <returns>true if the user was authenticated; otherwise, false.</returns>
        public bool IsAuthenticated
        {
            get { return !string.IsNullOrWhiteSpace(this.Name); }
        }
    }
}
