// <copyright file="FilemanFilePointerTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.Model;
using VistA.Imaging.DataNavigator.Repositories;

namespace VistA.Imaging.DataNavigator.Model
{
    /// <summary>This class contains parameterized unit tests for FilemanFilePointer</summary>
    [PexClass(typeof(FilemanFilePointer))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class FilemanFilePointerTest
    {
        /// <summary>Test stub for .ctor(IFilemanFileRepository, FilemanField, String)</summary>
        [PexMethod]
        public FilemanFilePointer Constructor(
            IFilemanFileRepository fileRepository,
            FilemanField sourceField,
            string targetFileNumber
        )
        {
            FilemanFilePointer target
               = new FilemanFilePointer(fileRepository, sourceField, targetFileNumber);
            return target;
            // TODO: add assertions to method FilemanFilePointerTest.Constructor(IFilemanFileRepository, FilemanField, String)
        }

        /// <summary>Test stub for get_TargetFile()</summary>
        [PexMethod]
        public FilemanFile TargetFileGet([PexAssumeUnderTest]FilemanFilePointer target)
        {
            FilemanFile result = target.TargetFile;
            return result;
            // TODO: add assertions to method FilemanFilePointerTest.TargetFileGet(FilemanFilePointer)
        }
    }
}
