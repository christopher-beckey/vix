// <auto-generated>
// This file contains automatically generated unit tests.
// Do NOT modify this file manually.
// 
// When Pex is invoked again,
// it might remove or update any previously generated unit tests.
// 
// If the contents of this file becomes outdated, e.g. if it does not
// compile anymore, you may delete this file and invoke Pex again.
// </auto-generated>
using System;
using System.ComponentModel;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Pex.Framework.Generated;

namespace VistA.Imaging.DataNavigator.Model
{
    public partial class FilemanFieldValueComparerTest
    {
[TestMethod]
[PexGeneratedBy(typeof(FilemanFieldValueComparerTest))]
public void Constructor412()
{
    FilemanFieldValueComparer filemanFieldValueComparer;
    filemanFieldValueComparer = this.Constructor(default(ListSortDirection?));
    Assert.IsNotNull((object)filemanFieldValueComparer);
    Assert.IsNull((object)(filemanFieldValueComparer.Direction));
}
    }
}