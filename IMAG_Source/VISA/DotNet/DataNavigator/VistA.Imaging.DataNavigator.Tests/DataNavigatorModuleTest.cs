// <copyright file="DataNavigatorModuleTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.Practices.Prism.Regions;
using Microsoft.Practices.Unity;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator;
using Microsoft.Practices.ServiceLocation;

namespace VistA.Imaging.DataNavigator
{
    /// <summary>This class contains parameterized unit tests for DataNavigatorModule</summary>
    [PexClass(typeof(DataNavigatorModule))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class DataNavigatorModuleTest
    {
        [TestInitialize]
        public void Init()
        {
            UnityServiceLocator locator = new UnityServiceLocator(new UnityContainer());
            ServiceLocator.SetLocatorProvider(() => locator);
        }

        [TestCleanup]
        public void Cleanup()
        {
            ServiceLocator.SetLocatorProvider(null);
        }

        /// <summary>Test stub for .ctor(IUnityContainer, IRegionManager)</summary>
        [PexMethod]
        public DataNavigatorModule Constructor(IUnityContainer container, IRegionManager regionManager)
        {
            DataNavigatorModule target = new DataNavigatorModule(container, regionManager);
            return target;
            // TODO: add assertions to method DataNavigatorModuleTest.Constructor(IUnityContainer, IRegionManager)
        }

        /// <summary>Test stub for Initialize()</summary>
        [PexMethod]
        public void Initialize([PexAssumeUnderTest]DataNavigatorModule target)
        {
            target.Initialize();
            // TODO: add assertions to method DataNavigatorModuleTest.Initialize(DataNavigatorModule)
        }
    }
}
