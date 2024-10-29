// <copyright file="FilemanEntrySearchResultTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.Model;

namespace VistA.Imaging.DataNavigator.Model
{
    /// <summary>This class contains parameterized unit tests for FilemanEntrySearchResult</summary>
    [PexClass(typeof(FilemanEntrySearchResult))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class FilemanEntrySearchResultTest
    {
    }
}
