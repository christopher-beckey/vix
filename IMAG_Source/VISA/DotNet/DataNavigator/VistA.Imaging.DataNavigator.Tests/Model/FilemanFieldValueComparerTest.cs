// <copyright file="FilemanFieldValueComparerTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using System.ComponentModel;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.Model;

namespace VistA.Imaging.DataNavigator.Model
{
    /// <summary>This class contains parameterized unit tests for FilemanFieldValueComparer</summary>
    [PexClass(typeof(FilemanFieldValueComparer))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class FilemanFieldValueComparerTest
    {
        /// <summary>Test stub for Compare(FilemanFieldValue, FilemanFieldValue)</summary>
        [PexMethod]
        public int Compare(
            [PexAssumeUnderTest]FilemanFieldValueComparer target,
            FilemanFieldValue x,
            FilemanFieldValue y
        )
        {
            int result = target.Compare(x, y);
            return result;
            // TODO: add assertions to method FilemanFieldValueComparerTest.Compare(FilemanFieldValueComparer, FilemanFieldValue, FilemanFieldValue)
        }

        /// <summary>Test stub for Compare(Object, Object)</summary>
        [PexMethod]
        public int Compare01(
            [PexAssumeUnderTest]FilemanFieldValueComparer target,
            object x,
            object y
        )
        {
            int result = target.Compare(x, y);
            return result;
            // TODO: add assertions to method FilemanFieldValueComparerTest.Compare01(FilemanFieldValueComparer, Object, Object)
        }

        /// <summary>Test stub for .ctor(Nullable`1&lt;ListSortDirection&gt;)</summary>
        [PexMethod]
        public FilemanFieldValueComparer Constructor(ListSortDirection? direction)
        {
            FilemanFieldValueComparer target = new FilemanFieldValueComparer(direction);
            return target;
            // TODO: add assertions to method FilemanFieldValueComparerTest.Constructor(Nullable`1<ListSortDirection>)
        }
    }
}
