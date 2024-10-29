// -----------------------------------------------------------------------
// <copyright file="VistACapriCredential.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Security.Principal
{
    using VistA.Imaging.Models;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class VistACapriCredential : IVistACredential
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="VistACapriCredential"/> class.
        /// </summary>
        public VistACapriCredential()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="VistACapriCredential"/> class.
        /// </summary>
        /// <param name="fullName">The full name.</param>
        /// <param name="duz">The duz.</param>
        /// <param name="ssn">The SSN.</param>
        /// <param name="institution">The institution.</param>
        public VistACapriCredential(string fullName, string duz, string ssn, Institution institution)
        {
            this.FullName = fullName;
            this.Duz = duz;
            this.Ssn = ssn;
            this.Institution = institution;
        }

        /// <summary>
        /// Gets or sets the full name.
        /// </summary>
        public string FullName { get; set; }

        /// <summary>
        /// Gets or sets the duz.
        /// </summary>
        public string Duz { get; set; }

        /// <summary>
        /// Gets or sets the SSN.
        /// </summary>
        public string Ssn { get; set; }

        /// <summary>
        /// Gets or sets the institution.
        /// </summary>
        public Institution Institution { get; set; }
    }
}
