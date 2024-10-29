// <copyright file="HierarchicalEntryLoadViewModelFactoryTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
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
    /// <summary>This class contains parameterized unit tests for HierarchicalEntryLoadViewModelFactory</summary>
    [PexClass(typeof(HierarchicalEntryLoadViewModelFactory))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class HierarchicalEntryLoadViewModelFactoryTest
    {
        /// <summary>Test stub for .ctor(IFilemanEntryRepository)</summary>
        [PexMethod]
        public HierarchicalEntryLoadViewModelFactory Constructor(IFilemanEntryRepository entryRepository)
        {
            HierarchicalEntryLoadViewModelFactory target
               = new HierarchicalEntryLoadViewModelFactory(entryRepository);
            return target;
            // TODO: add assertions to method HierarchicalEntryLoadViewModelFactoryTest.Constructor(IFilemanEntryRepository)
        }

        /// <summary>Test stub for CreateHierarchicalEntryLoadViewModel(FilemanFilePointer, TreeNodeViewModel)</summary>
        [PexMethod]
        public HierarchicalEntryLoadViewModel CreateHierarchicalEntryLoadViewModel(
            [PexAssumeUnderTest]HierarchicalEntryLoadViewModelFactory target,
            FilemanFilePointer pointer,
            TreeNodeViewModel parent
        )
        {
            HierarchicalEntryLoadViewModel result
               = target.CreateHierarchicalEntryLoadViewModel(pointer, parent);
            return result;
            // TODO: add assertions to method HierarchicalEntryLoadViewModelFactoryTest.CreateHierarchicalEntryLoadViewModel(HierarchicalEntryLoadViewModelFactory, FilemanFilePointer, TreeNodeViewModel)
        }
    }
}
