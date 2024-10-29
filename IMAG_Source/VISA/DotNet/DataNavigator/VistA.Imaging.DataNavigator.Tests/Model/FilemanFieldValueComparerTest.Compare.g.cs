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
public void Compare18()
{
    int i;
    FilemanFieldValueComparer s0
       = new FilemanFieldValueComparer(default(ListSortDirection?));
    i = this.Compare(s0, (FilemanFieldValue)null, (FilemanFieldValue)null);
    Assert.AreEqual<int>(0, i);
    Assert.IsNotNull((object)s0);
    Assert.IsNull((object)(s0.Direction));
}
[TestMethod]
[PexGeneratedBy(typeof(FilemanFieldValueComparerTest))]
public void Compare959()
{
    int i;
    FilemanFieldValueComparer s0
       = new FilemanFieldValueComparer(default(ListSortDirection?));
    FilemanFieldValue s1 = new FilemanFieldValue();
    s1.Field = (FilemanField)null;
    s1.FieldNumber = (string)null;
    s1.InternalValue = (string)null;
    s1.ExternalValue = (string)null;
    i = this.Compare(s0, (FilemanFieldValue)null, s1);
    Assert.AreEqual<int>(-1, i);
    Assert.IsNotNull((object)s0);
    Assert.IsNull((object)(s0.Direction));
}
[TestMethod]
[PexGeneratedBy(typeof(FilemanFieldValueComparerTest))]
public void Compare468()
{
    int i;
    FilemanFieldValueComparer s0 = new FilemanFieldValueComparer
                                       (new ListSortDirection?(ListSortDirection.Descending));
    i = this.Compare(s0, (FilemanFieldValue)null, (FilemanFieldValue)null);
    Assert.AreEqual<int>(0, i);
    Assert.IsNotNull((object)s0);
    Assert.IsNotNull((object)(s0.Direction));
    Assert.AreEqual<ListSortDirection>
        (ListSortDirection.Descending, (ListSortDirection)((object)(s0.Direction)));
}
[TestMethod]
[PexGeneratedBy(typeof(FilemanFieldValueComparerTest))]
public void Compare666()
{
    int i;
    FilemanFieldValueComparer s0
       = new FilemanFieldValueComparer(default(ListSortDirection?));
    FilemanFieldValue s1 = new FilemanFieldValue();
    s1.Field = (FilemanField)null;
    s1.FieldNumber = (string)null;
    s1.InternalValue = (string)null;
    s1.ExternalValue = (string)null;
    i = this.Compare(s0, s1, (FilemanFieldValue)null);
    Assert.AreEqual<int>(1, i);
    Assert.IsNotNull((object)s0);
    Assert.IsNull((object)(s0.Direction));
}
[TestMethod]
[PexGeneratedBy(typeof(FilemanFieldValueComparerTest))]
public void Compare932()
{
    int i;
    FilemanFieldValueComparer s0
       = new FilemanFieldValueComparer(default(ListSortDirection?));
    FilemanFieldValue s1 = new FilemanFieldValue();
    s1.Field = (FilemanField)null;
    s1.FieldNumber = (string)null;
    s1.InternalValue = (string)null;
    s1.ExternalValue = (string)null;
    FilemanFieldValue s2 = new FilemanFieldValue();
    s2.Field = (FilemanField)null;
    s2.FieldNumber = (string)null;
    s2.InternalValue = (string)null;
    s2.ExternalValue = (string)null;
    i = this.Compare(s0, s1, s2);
    Assert.AreEqual<int>(0, i);
    Assert.IsNotNull((object)s0);
    Assert.IsNull((object)(s0.Direction));
}
[TestMethod]
[PexGeneratedBy(typeof(FilemanFieldValueComparerTest))]
public void Compare78()
{
    int i;
    FilemanFieldValueComparer s0
       = new FilemanFieldValueComparer(default(ListSortDirection?));
    FilemanFieldValue s1 = new FilemanFieldValue();
    s1.Field = (FilemanField)null;
    s1.FieldNumber = (string)null;
    s1.InternalValue = (string)null;
    s1.ExternalValue = (string)null;
    FilemanFieldValue s2 = new FilemanFieldValue();
    s2.Field = (FilemanField)null;
    s2.FieldNumber = "";
    s2.InternalValue = (string)null;
    s2.ExternalValue = (string)null;
    i = this.Compare(s0, s1, s2);
    Assert.AreEqual<int>(0, i);
    Assert.IsNotNull((object)s0);
    Assert.IsNull((object)(s0.Direction));
}
    }
}
