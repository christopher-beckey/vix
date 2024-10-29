// <copyright file="DataNavigatorModuleFactory.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>

using System;
using Microsoft.Pex.Framework;
using VistA.Imaging.DataNavigator;
using Microsoft.Practices.Unity;
using Microsoft.Practices.Prism.Regions;

namespace VistA.Imaging.DataNavigator
{
    /// <summary>A factory for VistA.Imaging.DataNavigator.DataNavigatorModule instances</summary>
    public static partial class DataNavigatorModuleFactory
    {
        /// <summary>A factory for VistA.Imaging.DataNavigator.DataNavigatorModule instances</summary>
        [PexFactoryMethod(typeof(DataNavigatorModule))]
        public static DataNavigatorModule Create(
            IUnityContainer container_iUnityContainer,
            IRegionManager regionManager_iRegionManager
        )
        {
            DataNavigatorModule dataNavigatorModule = new DataNavigatorModule
                                                          (container_iUnityContainer, regionManager_iRegionManager);
            return dataNavigatorModule;

            // TODO: Edit factory method of DataNavigatorModule
            // This method should be able to configure the object in all possible ways.
            // Add as many parameters as needed,
            // and assign their values to each field by using the API.
        }
    }
}
