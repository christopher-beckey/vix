// <copyright file="TreeNodeViewModelTest.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
using System;
using Microsoft.Pex.Framework;
using Microsoft.Pex.Framework.Validation;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using VistA.Imaging.DataNavigator.ViewModels;

namespace VistA.Imaging.DataNavigator.ViewModels
{
    /// <summary>This class contains parameterized unit tests for TreeNodeViewModel</summary>
    [PexClass(typeof(TreeNodeViewModel))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class TreeNodeViewModelTest
    {
        /// <summary>Test stub for .ctor()</summary>
        [PexMethod]
        public TreeNodeViewModel Constructor()
        {
            TreeNodeViewModel target = new TreeNodeViewModel();
            return target;
            // TODO: add assertions to method TreeNodeViewModelTest.Constructor()
        }
    }
}
