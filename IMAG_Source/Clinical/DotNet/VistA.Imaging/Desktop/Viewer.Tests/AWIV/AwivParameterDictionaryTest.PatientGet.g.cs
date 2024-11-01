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
using VistA.Imaging.Models;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Microsoft.Pex.Framework.Generated;
using System.Collections.Generic;

namespace VistA.Imaging.Viewer.AWIV
{
    public partial class AwivParameterDictionaryTest
    {
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void PatientGetThrowsAwivParameterException589()
{
    AwivParameterDictionary awivParameterDictionary;
    Patient patient;
    awivParameterDictionary = new AwivParameterDictionary("");
    patient = this.PatientGet(awivParameterDictionary);
}
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void PatientGetThrowsAwivParameterException185()
{
    AwivParameterDictionary awivParameterDictionary;
    Patient patient;
    awivParameterDictionary = new AwivParameterDictionary("&");
    patient = this.PatientGet(awivParameterDictionary);
}
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void PatientGetThrowsAwivParameterException172()
{
    AwivParameterDictionary awivParameterDictionary;
    Patient patient;
    awivParameterDictionary = new AwivParameterDictionary("&\0");
    patient = this.PatientGet(awivParameterDictionary);
}
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void PatientGetThrowsAwivParameterException798()
{
    AwivParameterDictionary awivParameterDictionary;
    Patient patient;
    awivParameterDictionary = new AwivParameterDictionary("&A");
    patient = this.PatientGet(awivParameterDictionary);
}
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void PatientGetThrowsAwivParameterException58()
{
    AwivParameterDictionary awivParameterDictionary;
    Patient patient;
    awivParameterDictionary = new AwivParameterDictionary("&A{\0");
    patient = this.PatientGet(awivParameterDictionary);
}
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void PatientGetThrowsAwivParameterException421()
{
    AwivParameterDictionary awivParameterDictionary;
    Patient patient;
    awivParameterDictionary = new AwivParameterDictionary("&A{}");
    patient = this.PatientGet(awivParameterDictionary);
}
[TestMethod]
[PexGeneratedBy(typeof(AwivParameterDictionaryTest))]
[ExpectedException(typeof(AwivParameterException))]
public void PatientGetThrowsAwivParameterException130()
{
    AwivParameterDictionary awivParameterDictionary;
    Patient patient;
    awivParameterDictionary = new AwivParameterDictionary("&Z{}&D{}\u0080");
    patient = this.PatientGet(awivParameterDictionary);
}
    }
}
