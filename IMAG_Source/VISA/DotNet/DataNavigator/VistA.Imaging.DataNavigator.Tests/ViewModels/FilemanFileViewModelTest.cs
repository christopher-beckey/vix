// <copyright file="FilemanFileViewModelTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using System.Collections.ObjectModel;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.Model;
using VistA.Imaging.DataNavigator.ViewModels;

namespace VistA.Imaging.DataNavigator.ViewModels
{
    /// <summary>This class contains parameterized unit tests for FilemanFileViewModel</summary>
    [PexClass(typeof(FilemanFileViewModel))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class FilemanFileViewModelTest
    {
        /// <summary>Test stub for .ctor(FilemanFile)</summary>
        [PexMethod]
        public FilemanFileViewModel Constructor(FilemanFile file)
        {
            FilemanFileViewModel target = new FilemanFileViewModel(file);
            return target;
            // TODO: add assertions to method FilemanFileViewModelTest.Constructor(FilemanFile)
        }

        /// <summary>Test stub for get_IndexedFieldViewModels()</summary>
        [PexMethod]
        public ObservableCollection<FilemanFieldViewModel> IndexedFieldViewModelsGet([PexAssumeUnderTest]FilemanFileViewModel target)
        {
            ObservableCollection<FilemanFieldViewModel> result
               = target.IndexedFieldViewModels;
            return result;
            // TODO: add assertions to method FilemanFileViewModelTest.IndexedFieldViewModelsGet(FilemanFileViewModel)
        }

        /// <summary>Test stub for ToString()</summary>
        [PexMethod]
        public string ToString01([PexAssumeUnderTest]FilemanFileViewModel target)
        {
            string result = target.ToString();
            return result;
            // TODO: add assertions to method FilemanFileViewModelTest.ToString01(FilemanFileViewModel)
        }
    }
}
