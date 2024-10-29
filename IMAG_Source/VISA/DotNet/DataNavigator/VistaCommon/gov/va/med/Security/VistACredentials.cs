//-----------------------------------------------------------------------
// <copyright file="VistACredentials.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistaCommon.gov.va.med.Security
{
    using System;
    using System.Linq;
    using System.Security;
    using System.Diagnostics.Contracts;

    /// <summary>
    /// Represents the credentials of a VistA user
    /// </summary>
    public class VistACredentials : IDisposable
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="VistACredentials"/> class.
        /// </summary>
        /// <param name="accessCode">The access code.</param>
        /// <param name="verifyCode">The verify code.</param>
        public VistACredentials(SecureString accessCode, SecureString verifyCode)
        {
            Contract.Requires<ArgumentNullException>(accessCode != null);
            Contract.Requires<ArgumentNullException>(verifyCode != null);
            Contract.Requires<ArgumentException>(accessCode.Length > 0);
            Contract.Requires<ArgumentException>(verifyCode.Length > 0);
            Contract.Ensures(this.AccessCode != null);
            Contract.Ensures(this.VerifyCode != null);
            Contract.Ensures(this.AccessCode.IsReadOnly() == true);
            Contract.Ensures(this.VerifyCode.IsReadOnly() == true);
            if (!accessCode.IsReadOnly())
            {
                accessCode.MakeReadOnly();
            }

            if (!verifyCode.IsReadOnly())
            {
                verifyCode.MakeReadOnly();
            }

            this.AccessCode = accessCode;
            this.VerifyCode = verifyCode;
        }

        /// <summary>
        /// Gets the access code.
        /// </summary>
        /// <value>
        public SecureString AccessCode { get; private set; }

        /// <summary>
        /// Gets the verify code.
        /// </summary>
        public SecureString VerifyCode { get; private set; }

        public void Dispose()
        {
            this.AccessCode.Dispose();
            this.AccessCode = null;
            this.VerifyCode.Dispose();
            this.VerifyCode = null;
        }
    }
}
