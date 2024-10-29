// <copyright file="HierarchicalEntryViewModelTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
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
    /// <summary>This class contains parameterized unit tests for HierarchicalEntryViewModel</summary>
    [PexClass(typeof(HierarchicalEntryViewModel))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class HierarchicalEntryViewModelTest
    {
        /// <summary>Test stub for .ctor(FilemanEntry, FilemanField, FilemanField, IFilemanEntryRepository, IHierarchicalEntryViewModelFactory, IHierarchicalEntryLoadViewModelFactory)</summary>
        [PexMethod]
        public HierarchicalEntryViewModel Constructor(
            FilemanEntry entry,
            FilemanField childPointerField,
            FilemanField parentPointerField,
            IFilemanEntryRepository entryRepository,
            IHierarchicalEntryViewModelFactory hierarchicalEntryViewModelFactory,
            IHierarchicalEntryLoadViewModelFactory hierarchicalEntryLoadViewModelFactory
        )
        {
            HierarchicalEntryViewModel target = new HierarchicalEntryViewModel
                                                    (entry, childPointerField, parentPointerField, 
                                                     entryRepository, hierarchicalEntryViewModelFactory, 
                                                                      hierarchicalEntryLoadViewModelFactory);
            return target;
            // TODO: add assertions to method HierarchicalEntryViewModelTest.Constructor(FilemanEntry, FilemanField, FilemanField, IFilemanEntryRepository, IHierarchicalEntryViewModelFactory, IHierarchicalEntryLoadViewModelFactory)
        }

        /// <summary>Test stub for get_IsExpanded()</summary>
        [PexMethod]
        public bool IsExpandedGet([PexAssumeUnderTest]HierarchicalEntryViewModel target)
        {
            bool result = target.IsExpanded;
            return result;
            // TODO: add assertions to method HierarchicalEntryViewModelTest.IsExpandedGet(HierarchicalEntryViewModel)
        }

        /// <summary>Test stub for set_IsExpanded(Boolean)</summary>
        [PexMethod]
        public void IsExpandedSet(
            [PexAssumeUnderTest]HierarchicalEntryViewModel target,
            bool value
        )
        {
            target.IsExpanded = value;
            // TODO: add assertions to method HierarchicalEntryViewModelTest.IsExpandedSet(HierarchicalEntryViewModel, Boolean)
        }

        /// <summary>Test stub for get_Parent()</summary>
        [PexMethod]
        public TreeNodeViewModel ParentGet([PexAssumeUnderTest]HierarchicalEntryViewModel target)
        {
            TreeNodeViewModel result = target.Parent;
            return result;
            // TODO: add assertions to method HierarchicalEntryViewModelTest.ParentGet(HierarchicalEntryViewModel)
        }

        /// <summary>Test stub for set_Parent(TreeNodeViewModel)</summary>
        [PexMethod]
        public void ParentSet(
            [PexAssumeUnderTest]HierarchicalEntryViewModel target,
            TreeNodeViewModel value
        )
        {
            target.Parent = value;
            // TODO: add assertions to method HierarchicalEntryViewModelTest.ParentSet(HierarchicalEntryViewModel, TreeNodeViewModel)
        }

        /// <summary>Test stub for ToString()</summary>
        [PexMethod]
        public string ToString01([PexAssumeUnderTest]HierarchicalEntryViewModel target)
        {
            string result = target.ToString();
            return result;
            // TODO: add assertions to method HierarchicalEntryViewModelTest.ToString01(HierarchicalEntryViewModel)
        }
    }
}
