// <copyright file="FilemanFieldPointerTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.Model;
using VistA.Imaging.DataNavigator.Repositories;

namespace VistA.Imaging.DataNavigator.Model
{
    /// <summary>This class contains parameterized unit tests for FilemanFieldPointer</summary>
    [PexClass(typeof(FilemanFieldPointer))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class FilemanFieldPointerTest
    {
        /// <summary>Test stub for .ctor(IFilemanFileRepository, FilemanField, String, String)</summary>
        [PexMethod]
        public FilemanFieldPointer Constructor(
            IFilemanFileRepository fileRepository,
            FilemanField sourceField,
            string targetFileNumber,
            string targetfieldNumber
        )
        {
            FilemanFieldPointer target = new FilemanFieldPointer
                                             (fileRepository, sourceField, targetFileNumber, targetfieldNumber);
            return target;
            // TODO: add assertions to method FilemanFieldPointerTest.Constructor(IFilemanFileRepository, FilemanField, String, String)
        }

        /// <summary>Test stub for get_TargetField()</summary>
        [PexMethod]
        public FilemanField TargetFieldGet([PexAssumeUnderTest]FilemanFieldPointer target)
        {
            FilemanField result = target.TargetField;
            return result;
            // TODO: add assertions to method FilemanFieldPointerTest.TargetFieldGet(FilemanFieldPointer)
        }
    }
}
