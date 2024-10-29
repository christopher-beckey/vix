//-----------------------------------------------------------------------
// <copyright file="Site.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistaCommon.gov.va.med
{
    using System;
    using System.Linq;

    /// <summary>
    /// Represents a VistA Site
    /// </summary>
    public class Site
    {
        public string Name { get; set; }
        public string Number { get; set; }
        public string Abbreviation { get; set; }
    }
}
