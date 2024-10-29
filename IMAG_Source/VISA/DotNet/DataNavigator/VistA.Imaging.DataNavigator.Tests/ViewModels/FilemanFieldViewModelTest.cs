// <copyright file="FilemanFieldViewModelTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.Model;
using VistA.Imaging.DataNavigator.ViewModels;

namespace VistA.Imaging.DataNavigator.ViewModels
{
    /// <summary>This class contains parameterized unit tests for FilemanFieldViewModel</summary>
    [PexClass(typeof(FilemanFieldViewModel))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class FilemanFieldViewModelTest
    {
        /// <summary>Test stub for .ctor(FilemanField)</summary>
        [PexMethod]
        public FilemanFieldViewModel Constructor(FilemanField field)
        {
            FilemanFieldViewModel target = new FilemanFieldViewModel(field);
            return target;
            // TODO: add assertions to method FilemanFieldViewModelTest.Constructor(FilemanField)
        }

        /// <summary>Test stub for ToString()</summary>
        [PexMethod]
        public string ToString01([PexAssumeUnderTest]FilemanFieldViewModel target)
        {
            string result = target.ToString();
            return result;
            // TODO: add assertions to method FilemanFieldViewModelTest.ToString01(FilemanFieldViewModel)
        }
    }
}
