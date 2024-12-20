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
using VistA.Imaging.Security.Principal;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Pex.Framework.Generated;

namespace VistA.Imaging.Viewer.AWIV
{
    public partial class AwivParameterDictionaryTest
    {
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void VistAPrincipalGetThrowsAwivParameterException669()
{
    AwivParameterDictionary awivParameterDictionary;
    VistAPrincipal vistAPrincipal;
    awivParameterDictionary = new AwivParameterDictionary("");
    vistAPrincipal = this.VistAPrincipalGet(awivParameterDictionary);
}
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void VistAPrincipalGetThrowsAwivParameterException395()
{
    AwivParameterDictionary awivParameterDictionary;
    VistAPrincipal vistAPrincipal;
    awivParameterDictionary = new AwivParameterDictionary("&");
    vistAPrincipal = this.VistAPrincipalGet(awivParameterDictionary);
}
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void VistAPrincipalGetThrowsAwivParameterException682()
{
    AwivParameterDictionary awivParameterDictionary;
    VistAPrincipal vistAPrincipal;
    awivParameterDictionary = new AwivParameterDictionary("&\0");
    vistAPrincipal = this.VistAPrincipalGet(awivParameterDictionary);
}
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void VistAPrincipalGetThrowsAwivParameterException798()
{
    AwivParameterDictionary awivParameterDictionary;
    VistAPrincipal vistAPrincipal;
    awivParameterDictionary = new AwivParameterDictionary("&A");
    vistAPrincipal = this.VistAPrincipalGet(awivParameterDictionary);
}
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void VistAPrincipalGetThrowsAwivParameterException3()
{
    AwivParameterDictionary awivParameterDictionary;
    VistAPrincipal vistAPrincipal;
    awivParameterDictionary = new AwivParameterDictionary("&A{\0");
    vistAPrincipal = this.VistAPrincipalGet(awivParameterDictionary);
}
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void VistAPrincipalGetThrowsAwivParameterException933()
{
    AwivParameterDictionary awivParameterDictionary;
    VistAPrincipal vistAPrincipal;
    awivParameterDictionary = new AwivParameterDictionary("&A{}");
    vistAPrincipal = this.VistAPrincipalGet(awivParameterDictionary);
}
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void VistAPrincipalGetThrowsAwivParameterException154()
{
    AwivParameterDictionary awivParameterDictionary;
    VistAPrincipal vistAPrincipal;
    awivParameterDictionary = new AwivParameterDictionary("&F{}&K{}_W\0&&");
    vistAPrincipal = this.VistAPrincipalGet(awivParameterDictionary);
}
    }
}
