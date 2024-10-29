// <copyright file="FilemanFieldTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.Model;

namespace VistA.Imaging.DataNavigator.Model
{
    /// <summary>This class contains parameterized unit tests for FilemanField</summary>
    [PexClass(typeof(FilemanField))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class FilemanFieldTest
    {
        /// <summary>Test stub for .ctor(String, String, Boolean, FilemanFilePointer)</summary>
        [PexMethod]
        public FilemanField Constructor(
            string name,
            string number,
            bool isIndexed,
            FilemanFilePointer pointer
        )
        {
            FilemanField target = new FilemanField(name, number, isIndexed, pointer);
            return target;
        }

        /// <summary>Test stub for ToString()</summary>
        [PexMethod]
        public string ToString01([PexAssumeUnderTest]FilemanField target)
        {
            string result = target.ToString();
            return result;
        }
    }
}
