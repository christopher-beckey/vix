// <copyright file="FilemanEntryTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.Model;

namespace VistA.Imaging.DataNavigator.Model
{
    /// <summary>This class contains parameterized unit tests for FilemanEntry</summary>
    [PexClass(typeof(FilemanEntry))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class FilemanEntryTest
    {
        /// <summary>Test stub for .ctor(FilemanFile)</summary>
        [PexMethod]
        public FilemanEntry Constructor(FilemanFile file)
        {
            FilemanEntry target = new FilemanEntry(file);
            Assert.AreEqual(file, target.File);
            return target;
        }

        /// <summary>Test stub for get_Item(String)</summary>
        [PexMethod]
        public FilemanFieldValue ItemGet([PexAssumeUnderTest]FilemanEntry target, string id)
        {
            FilemanFieldValue result = target[id];
            return result;
        }

        /// <summary>Test stub for ToString()</summary>
        [PexMethod]
        public string ToString01([PexAssumeUnderTest]FilemanEntry target)
        {
            string result = target.ToString();
            return result;
            // TODO: add assertions to method FilemanEntryTest.ToString01(FilemanEntry)
        }
    }
}
