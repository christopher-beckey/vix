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
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Pex.Framework.Generated;

namespace VistA.Imaging.Collections
{
    public partial class ReadOnlyDictionaryTKeyTValueTest
    {
[TestMethod]
[PexGeneratedBy(typeof(ReadOnlyDictionaryTKeyTValueTest))]
[ExpectedException(typeof(NotSupportedException))]
public void ClearThrowsNotSupportedException545()
{
    ReadOnlyDictionary<int, int> readOnlyDictionary;
    readOnlyDictionary = new ReadOnlyDictionary<int, int>();
    this.Clear<int, int>(readOnlyDictionary);
}
    }
}