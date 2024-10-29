// <copyright file="DataNavigationViewModelTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.Practices.Prism.Regions;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator;
using VistA.Imaging.DataNavigator.Repositories;
using VistA.Imaging.DataNavigator.ViewModels;
using VistA.Imaging.DataNavigator.ViewModels.Factories;

namespace VistA.Imaging.DataNavigator.ViewModels
{
    /// <summary>This class contains parameterized unit tests for DataNavigationViewModel</summary>
    [PexClass(typeof(DataNavigationViewModel))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class DataNavigationViewModelTest
    {
        /// <summary>Test stub for .ctor()</summary>
        [PexMethod]
        public DataNavigationViewModel Constructor()
        {
            DataNavigationViewModel target = new DataNavigationViewModel();
            return target;
            // TODO: add assertions to method DataNavigationViewModelTest.Constructor()
        }

        /// <summary>Test stub for .ctor(IRegionManager, IFilemanFileRepository, IFilemanEntryRepository, IHierarchicalEntryViewModelFactory, DataNavigatorModule)</summary>
        [PexMethod]
        public DataNavigationViewModel Constructor01(
            IRegionManager regionManager,
            IFilemanFileRepository filemanFileRepository,
            IFilemanEntryRepository entryRepository,
            IHierarchicalEntryViewModelFactory hierarchicalEntryViewModelFactory,
            DataNavigatorModule module
        )
        {
            DataNavigationViewModel target
               = new DataNavigationViewModel(regionManager, filemanFileRepository, 
                                             entryRepository, hierarchicalEntryViewModelFactory, module);
            return target;
            // TODO: add assertions to method DataNavigationViewModelTest.Constructor01(IRegionManager, IFilemanFileRepository, IFilemanEntryRepository, IHierarchicalEntryViewModelFactory, DataNavigatorModule)
        }

        /// <summary>Test stub for Initialze()</summary>
        [PexMethod]
        public void Initialze([PexAssumeUnderTest]DataNavigationViewModel target)
        {
            target.Initialze();
            // TODO: add assertions to method DataNavigationViewModelTest.Initialze(DataNavigationViewModel)
        }
    }
}
