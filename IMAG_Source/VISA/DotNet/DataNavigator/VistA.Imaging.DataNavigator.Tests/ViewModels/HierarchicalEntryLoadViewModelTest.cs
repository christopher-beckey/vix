// <copyright file="HierarchicalEntryLoadViewModelTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.Model;
using VistA.Imaging.DataNavigator.Repositories;
using VistA.Imaging.DataNavigator.ViewModels;
using VistA.Imaging.DataNavigator.ViewModels.Factories;

namespace VistA.Imaging.DataNavigator.ViewModels
{
    /// <summary>This class contains parameterized unit tests for HierarchicalEntryLoadViewModel</summary>
    [PexClass(typeof(HierarchicalEntryLoadViewModel))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class HierarchicalEntryLoadViewModelTest
    {
        /// <summary>Test stub for .ctor(FilemanFilePointer, TreeNodeViewModel, IFilemanEntryRepository, IHierarchicalEntryViewModelFactory)</summary>
        [PexMethod]
        public HierarchicalEntryLoadViewModel Constructor(
            FilemanFilePointer pointer,
            TreeNodeViewModel parent,
            IFilemanEntryRepository filemanEntryRepository,
            IHierarchicalEntryViewModelFactory hierarchicalEntryViewModelFactory
        )
        {
            HierarchicalEntryLoadViewModel target
               = new HierarchicalEntryLoadViewModel(pointer, parent, 
                                                    filemanEntryRepository, hierarchicalEntryViewModelFactory);
            return target;
            // TODO: add assertions to method HierarchicalEntryLoadViewModelTest.Constructor(FilemanFilePointer, TreeNodeViewModel, IFilemanEntryRepository, IHierarchicalEntryViewModelFactory)
        }

        /// <summary>Test stub for get_IsSelected()</summary>
        [PexMethod]
        public bool IsSelectedGet([PexAssumeUnderTest]HierarchicalEntryLoadViewModel target)
        {
            bool result = target.IsSelected;
            return result;
            // TODO: add assertions to method HierarchicalEntryLoadViewModelTest.IsSelectedGet(HierarchicalEntryLoadViewModel)
        }

        /// <summary>Test stub for set_IsSelected(Boolean)</summary>
        [PexMethod]
        public void IsSelectedSet(
            [PexAssumeUnderTest]HierarchicalEntryLoadViewModel target,
            bool value
        )
        {
            target.IsSelected = value;
            // TODO: add assertions to method HierarchicalEntryLoadViewModelTest.IsSelectedSet(HierarchicalEntryLoadViewModel, Boolean)
        }

        /// <summary>Test stub for ToString()</summary>
        [PexMethod]
        public string ToString01([PexAssumeUnderTest]HierarchicalEntryLoadViewModel target)
        {
            string result = target.ToString();
            return result;
            // TODO: add assertions to method HierarchicalEntryLoadViewModelTest.ToString01(HierarchicalEntryLoadViewModel)
        }
    }
}
