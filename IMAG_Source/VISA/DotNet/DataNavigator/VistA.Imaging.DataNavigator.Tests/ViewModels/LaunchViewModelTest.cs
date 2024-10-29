// <copyright file="LaunchViewModelTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.Practices.Prism.Regions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.ViewModels;

namespace VistA.Imaging.DataNavigator.ViewModels
{
    /// <summary>This class contains parameterized unit tests for LaunchViewModel</summary>
    [PexClass(typeof(LaunchViewModel))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class LaunchViewModelTest
    {
        /// <summary>Test stub for .ctor(IRegionManager)</summary>
        [PexMethod]
        public LaunchViewModel Constructor(IRegionManager regionManager)
        {
            LaunchViewModel target = new LaunchViewModel(regionManager);
            return target;
            // TODO: add assertions to method LaunchViewModelTest.Constructor(IRegionManager)
        }
    }
}
