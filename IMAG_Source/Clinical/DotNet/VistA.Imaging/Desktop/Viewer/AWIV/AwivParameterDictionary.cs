// -----------------------------------------------------------------------
// <copyright file="AwivParameterDictionary.cs" company="Department of Veterans Affairs">
// Department of Veterans Affairs
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Viewer.AWIV
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics.Contracts;
    using System.Linq;
    using System.Text;
    using System.Text.RegularExpressions;
    using VistA.Imaging.Collections;
    using VistA.Imaging.Models;
    using VistA.Imaging.Security.Principal;
    using VistA.Imaging.Viewer.Models;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class AwivParameterDictionary : ReadOnlyDictionary<string, string>
    {
        #region Fields

        /// <summary>
        /// Backing field for the Patient property
        /// </summary>
        private Patient patientBackingField;

        /// <summary>
        /// Backing field for the ArtifactSet property
        /// </summary>
        private ArtifactSet artifactSetBackingField;

        /// <summary>
        /// Backing field for the VistAPrincipal property
        /// </summary>
        private VistAPrincipal vistaPrincipalBackingField;

        /// <summary>
        /// Backing field for the SiteServiceUrl property
        /// </summary>
        private Uri siteServiceUrlBackingField;

        #endregion

        /// <summary>
        /// Initializes a new instance of the <see cref="AwivParameterDictionary"/> class.
        /// </summary>
        /// <param name="paramString">The param string.</param>
        public AwivParameterDictionary(string paramString)
        {
            Contract.Requires<ArgumentNullException>(paramString != null);
            Regex parserRegEx = new Regex(@"&([A-Z]){([^}]*)}");
            Match match = parserRegEx.Match(paramString);
            while (match != null && match.Success)
            {
                try
                {
                    this.InternalDictionary.Add(match.Groups[1].Value, match.Groups[2].Value);
                }
                catch (ArgumentException ae)
                {
                    throw new AwivParameterException("There are pairs with the same key: " + match.Groups[1].Value, ae);
                }

                match = match.NextMatch();
            }
        }

        #region Properties

        /// <summary>
        /// Gets the patient.
        /// </summary>
        public Patient Patient
        {
            get
            {
                if (this.patientBackingField == null)
                {
                    try
                    {
                        this.patientBackingField = new Patient()
                        {
                            FullName = this["A"],
                            SSN = this["B"],
                            ICN = this["C"]
                        };
                    }
                    catch (KeyNotFoundException ex)
                    {
                        throw new AwivParameterException("AWIV parameter not found", ex);
                    }
                }

                return this.patientBackingField;
            }
        }

        /// <summary>
        /// Gets the artifact set identifier.
        /// </summary>
        public ArtifactSet ArtifactSet
        {
            get
            {
                if (this.artifactSetBackingField == null)
                {
                    try
                    {
                        this.artifactSetBackingField = new ArtifactSet()
                        {
                            Urn = this["D"],
                            SiteId = this["E"]
                        };
                    }
                    catch (KeyNotFoundException ex)
                    {
                        throw new AwivParameterException("AWIV parameter not found", ex);
                    }
                }

                return this.artifactSetBackingField;
            }
        }

        /// <summary>
        /// Gets the vist A principal.
        /// </summary>
        public VistAPrincipal VistAPrincipal
        {
            get
            {
                if (this.vistaPrincipalBackingField == null)
                {
                    try
                    {
                        Institution inst = new Institution()
                        {
                            Name = this["I"],
                            Id = this["J"]
                        };
                        VistAIdentity identity = new VistAIdentity(this["F"]);
                        identity.Ssn = this["H"];
                        this.vistaPrincipalBackingField = new VistAPrincipal(identity, "NCAT");
                        VistABSECredential bseCredential = new VistABSECredential(this["K"], inst);
                        this.vistaPrincipalBackingField.Credentials.Add(bseCredential);
                        VistACapriCredential capriCredential = new VistACapriCredential(
                            identity.Name.Replace(" ", string.Empty),
                            this["G"],
                            identity.Ssn,
                            inst);
                        this.vistaPrincipalBackingField.Credentials.Add(capriCredential);
                    }
                    catch (KeyNotFoundException ex)
                    {
                        throw new AwivParameterException("AWIV parameter not found", ex);
                    }
                }

                return this.vistaPrincipalBackingField;
            }
        }

        /// <summary>
        /// Gets the site service URL.
        /// </summary>
        public Uri SiteServiceUrl
        {
            get
            {
                if (this.siteServiceUrlBackingField == null)
                {
                    try
                    {
                        this.siteServiceUrlBackingField = new Uri(this["L"]);
                    }
                    catch (KeyNotFoundException ex)
                    {
                        throw new AwivParameterException("AWIV parameter not found", ex);
                    }
                    catch (UriFormatException ex)
                    {
                        throw new AwivParameterException("Invalid URI format", ex);
                    }
                }

                return this.siteServiceUrlBackingField;
            }
        }

        /// <summary>
        /// Gets the CVIX site number.
        /// </summary>
        public string CVIXSiteNumber
        {
            get
            {
                try
                {
                    return this["M"];
                }
                catch (KeyNotFoundException ex)
                {
                    throw new AwivParameterException("AWIV parameter not found", ex);
                }
            }
        }

        #endregion
    }
}
