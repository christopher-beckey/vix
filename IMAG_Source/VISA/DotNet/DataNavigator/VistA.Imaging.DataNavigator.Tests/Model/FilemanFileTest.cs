// <copyright file="FilemanFileTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.Model;

namespace VistA.Imaging.DataNavigator.Model
{
    /// <summary>This class contains parameterized unit tests for FilemanFile</summary>
    [PexClass(typeof(FilemanFile))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class FilemanFileTest
    {
        /// <summary>Test stub for .ctor(String, String, FilemanField[])</summary>
        [PexMethod]
        public FilemanFile Constructor(
            string name,
            string number,
            FilemanField[] fields
        )
        {
            FilemanFile target = new FilemanFile(name, number, fields);
            return target;
            // TODO: add assertions to method FilemanFileTest.Constructor(String, String, FilemanField[])
        }

        /// <summary>Test stub for get_Item(String)</summary>
        [PexMethod]
        public FilemanField ItemGet([PexAssumeUnderTest]FilemanFile target, string id)
        {
            FilemanField result = target[id];
            return result;
            // TODO: add assertions to method FilemanFileTest.ItemGet(FilemanFile, String)
        }

        /// <summary>Test stub for ToString()</summary>
        [PexMethod]
        public string ToString01([PexAssumeUnderTest]FilemanFile target)
        {
            string result = target.ToString();
            return result;
            // TODO: add assertions to method FilemanFileTest.ToString01(FilemanFile)
        }
    }
}
