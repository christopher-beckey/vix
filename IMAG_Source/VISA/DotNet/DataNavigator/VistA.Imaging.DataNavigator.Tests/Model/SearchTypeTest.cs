// <copyright file="SearchTypeTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.Model;

namespace VistA.Imaging.DataNavigator.Model
{
    /// <summary>This class contains parameterized unit tests for SearchType</summary>
    [PexClass(typeof(SearchType))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class SearchTypeTest
    {
        /// <summary>Test stub for ToString()</summary>
        [PexMethod]
        public string ToString01([PexAssumeUnderTest]SearchType target)
        {
            string result = target.ToString();
            return result;
            // TODO: add assertions to method SearchTypeTest.ToString01(SearchType)
        }
    }
}
