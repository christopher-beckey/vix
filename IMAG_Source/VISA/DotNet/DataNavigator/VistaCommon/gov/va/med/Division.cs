//-----------------------------------------------------------------------
// <copyright file="Division.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistaCommon.gov.va.med
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;

    /// <summary>
    /// Represents a division within a site
    /// </summary>
    public class Division
    {
        /// <summary>
        /// Gets or sets the division id.
        /// </summary>
        public String Id { get; set; }

        /// <summary>
        /// Gets or sets the division code.
        /// </summary>
        public String Code { get; set; }

        /// <summary>
        /// Gets or sets the division name.
        /// </summary>
        public String Name { get; set; }

        /// <summary>
        /// Gets or sets the site to which this division belongs.
        /// </summary>
        public Site Site { get; set; }
    }
}
