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
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Pex.Framework.Generated;

namespace VistA.Imaging.Collections
{
    public partial class ReadOnlyDictionaryTKeyTValueTest
    {
[TestMethod]
[PexGeneratedBy(typeof(ReadOnlyDictionaryTKeyTValueTest))]
public void ValuesGet829()
{
    ReadOnlyDictionary<int, int> readOnlyDictionary;
    ICollection<int> iCollection;
    readOnlyDictionary = new ReadOnlyDictionary<int, int>();
    iCollection = this.ValuesGet<int, int>(readOnlyDictionary);
    Assert.IsNotNull((object)iCollection);
    Assert.IsNotNull((object)readOnlyDictionary);
}
    }
}
