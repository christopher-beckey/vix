// <copyright file="HierarchicalEntryViewModelFactoryTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.Model;
using VistA.Imaging.DataNavigator.Repositories;
using VistA.Imaging.DataNavigator.ViewModels;
using VistA.Imaging.DataNavigator.ViewModels.Factories;

namespace VistA.Imaging.DataNavigator.ViewModels.Factories
{
    /// <summary>This class contains parameterized unit tests for HierarchicalEntryViewModelFactory</summary>
    [PexClass(typeof(HierarchicalEntryViewModelFactory))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class HierarchicalEntryViewModelFactoryTest
    {
        /// <summary>Test stub for .ctor(IFilemanFileRepository, IFilemanEntryRepository, IHierarchicalEntryLoadViewModelFactory)</summary>
        [PexMethod]
        public HierarchicalEntryViewModelFactory Constructor(
            IFilemanFileRepository fileRepository,
            IFilemanEntryRepository entryRepository,
            IHierarchicalEntryLoadViewModelFactory hierarchicalEntryLoadViewModelFactory
        )
        {
            HierarchicalEntryViewModelFactory target = new HierarchicalEntryViewModelFactory
                                                           (fileRepository, entryRepository, hierarchicalEntryLoadViewModelFactory);
            return target;
            // TODO: add assertions to method HierarchicalEntryViewModelFactoryTest.Constructor(IFilemanFileRepository, IFilemanEntryRepository, IHierarchicalEntryLoadViewModelFactory)
        }

        /// <summary>Test stub for CreateHierarchicalEntryViewModel(FilemanEntry)</summary>
        [PexMethod]
        public HierarchicalEntryViewModel CreateHierarchicalEntryViewModel(
            [PexAssumeUnderTest]HierarchicalEntryViewModelFactory target,
            FilemanEntry entry
        )
        {
            HierarchicalEntryViewModel result
               = target.CreateHierarchicalEntryViewModel(entry);
            return result;
            // TODO: add assertions to method HierarchicalEntryViewModelFactoryTest.CreateHierarchicalEntryViewModel(HierarchicalEntryViewModelFactory, FilemanEntry)
        }
    }
}
