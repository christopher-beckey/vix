// <copyright file="RegionManagerFactory.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>

using System;
using Microsoft.Pex.Framework;
using Microsoft.Practices.Prism.Regions;

namespace Microsoft.Practices.Prism.Regions
{
    /// <summary>A factory for Microsoft.Practices.Prism.Regions.RegionManager instances</summary>
    public static partial class RegionManagerFactory
    {
        /// <summary>A factory for Microsoft.Practices.Prism.Regions.RegionManager instances</summary>
        [PexFactoryMethod(typeof(RegionManager))]
        public static RegionManager Create()
        {
            RegionManager regionManager = new RegionManager();
            return regionManager;

            // TODO: Edit factory method of RegionManager
            // This method should be able to configure the object in all possible ways.
            // Add as many parameters as needed,
            // and assign their values to each field by using the API.
        }
    }
}
