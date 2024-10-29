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
using Microsoft.Pex.Engine.Exceptions;
using Microsoft.Pex.Framework.Generated;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace VistA.Imaging.Security.Cryptography
{
    public partial class AesBase64Test
    {
[TestMethod]
[PexGeneratedBy(typeof(AesBase64Test))]
[PexRaisedContractException(PexExceptionState.Expected)]
public void DecryptToStringThrowsContractException968()
{
    try
    {
      AesBase64 aesBase64;
      string s;
      byte[] bs = new byte[16];
      aesBase64 = new AesBase64(bs);
      s = this.DecryptToString(aesBase64, (string)null, (string)null);
      throw 
        new AssertFailedException("expected an exception of type ContractException");
    }
    catch(Exception ex)
    {
      if (!PexContract.IsContractException(ex))
        throw ex;
    }
}
[TestMethod]
[PexGeneratedBy(typeof(AesBase64Test))]
[PexRaisedContractException(PexExceptionState.Expected)]
public void DecryptToStringThrowsContractException874()
{
    try
    {
      AesBase64 aesBase64;
      string s;
      byte[] bs = new byte[24];
      aesBase64 = new AesBase64(bs);
      s = this.DecryptToString(aesBase64, "", (string)null);
      throw 
        new AssertFailedException("expected an exception of type ContractException");
    }
    catch(Exception ex)
    {
      if (!PexContract.IsContractException(ex))
        throw ex;
    }
}
[TestMethod]
[PexGeneratedBy(typeof(AesBase64Test))]
[PexRaisedContractException(PexExceptionState.Expected)]
public void DecryptToStringThrowsContractException()
{
    try
    {
      AesBase64 aesBase64;
      string s;
      byte[] bs = new byte[16];
      aesBase64 = new AesBase64(bs);
      s = this.DecryptToString(aesBase64, "\0", (string)null);
      throw 
        new AssertFailedException("expected an exception of type ContractException");
    }
    catch(Exception ex)
    {
      if (!PexContract.IsContractException(ex))
        throw ex;
    }
}
[TestMethod]
[PexGeneratedBy(typeof(AesBase64Test))]
[PexRaisedContractException(PexExceptionState.Expected)]
public void DecryptToStringThrowsContractException640()
{
    try
    {
      AesBase64 aesBase64;
      string s;
      byte[] bs = new byte[24];
      aesBase64 = new AesBase64(bs);
      s = this.DecryptToString(aesBase64, "\ufeff", (string)null);
      throw 
        new AssertFailedException("expected an exception of type ContractException");
    }
    catch(Exception ex)
    {
      if (!PexContract.IsContractException(ex))
        throw ex;
    }
}
[TestMethod]
[PexGeneratedBy(typeof(AesBase64Test))]
[PexRaisedContractException(PexExceptionState.Expected)]
public void DecryptToStringThrowsContractException429()
{
    try
    {
      AesBase64 aesBase64;
      string s;
      byte[] bs = new byte[24];
      aesBase64 = new AesBase64(bs);
      s = this.DecryptToString(aesBase64, "\0\ufeff", (string)null);
      throw 
        new AssertFailedException("expected an exception of type ContractException");
    }
    catch(Exception ex)
    {
      if (!PexContract.IsContractException(ex))
        throw ex;
    }
}
[TestMethod]
[PexGeneratedBy(typeof(AesBase64Test))]
[PexRaisedContractException(PexExceptionState.Expected)]
public void DecryptToStringThrowsContractException877()
{
    try
    {
      AesBase64 aesBase64;
      string s;
      byte[] bs = new byte[16];
      aesBase64 = new AesBase64(bs);
      s = this.DecryptToString(aesBase64, "", "^");
      throw 
        new AssertFailedException("expected an exception of type ContractException");
    }
    catch(Exception ex)
    {
      if (!PexContract.IsContractException(ex))
        throw ex;
    }
}
[TestMethod]
[PexGeneratedBy(typeof(AesBase64Test))]
[PexRaisedContractException(PexExceptionState.Expected)]
public void DecryptToStringThrowsContractException872()
{
    try
    {
      AesBase64 aesBase64;
      string s;
      byte[] bs = new byte[16];
      aesBase64 = new AesBase64(bs);
      s = this.DecryptToString(aesBase64, "", "\0,,\0");
      throw 
        new AssertFailedException("expected an exception of type ContractException");
    }
    catch(Exception ex)
    {
      if (!PexContract.IsContractException(ex))
        throw ex;
    }
}
[TestMethod]
[PexGeneratedBy(typeof(AesBase64Test))]
[PexRaisedContractException(PexExceptionState.Expected)]
public void DecryptToStringThrowsContractException297()
{
    try
    {
      AesBase64 aesBase64;
      string s;
      byte[] bs = new byte[16];
      aesBase64 = new AesBase64(bs);
      s = this.DecryptToString(aesBase64, "", "bDd0");
      throw 
        new AssertFailedException("expected an exception of type ContractException");
    }
    catch(Exception ex)
    {
      if (!PexContract.IsContractException(ex))
        throw ex;
    }
}
[TestMethod]
[PexGeneratedBy(typeof(AesBase64Test))]
[PexRaisedContractException(PexExceptionState.Expected)]
public void DecryptToStringThrowsContractException893()
{
    try
    {
      AesBase64 aesBase64;
      string s;
      byte[] bs = new byte[16];
      aesBase64 = new AesBase64(bs);
      s = this.DecryptToString
              (aesBase64, "\0\ufeff\ufeff\ufeff\ufeff\ufeff", (string)null);
      throw 
        new AssertFailedException("expected an exception of type ContractException");
    }
    catch(Exception ex)
    {
      if (!PexContract.IsContractException(ex))
        throw ex;
    }
}
[TestMethod]
[PexGeneratedBy(typeof(AesBase64Test))]
[PexRaisedContractException(PexExceptionState.Expected)]
public void DecryptToStringThrowsContractException671()
{
    try
    {
      AesBase64 aesBase64;
      string s;
      byte[] bs = new byte[16];
      aesBase64 = new AesBase64(bs);
      s = this.DecryptToString(aesBase64, "\ufeff\0", (string)null);
      throw 
        new AssertFailedException("expected an exception of type ContractException");
    }
    catch(Exception ex)
    {
      if (!PexContract.IsContractException(ex))
        throw ex;
    }
}
[TestMethod]
[PexGeneratedBy(typeof(AesBase64Test))]
[PexRaisedContractException(PexExceptionState.Expected)]
public void DecryptToStringThrowsContractException106()
{
    try
    {
      AesBase64 aesBase64;
      string s;
      byte[] bs = new byte[24];
      aesBase64 = new AesBase64(bs);
      s = this.DecryptToString(aesBase64, "\ufeff\ufeff\0", (string)null);
      throw 
        new AssertFailedException("expected an exception of type ContractException");
    }
    catch(Exception ex)
    {
      if (!PexContract.IsContractException(ex))
        throw ex;
    }
}
[TestMethod]
[PexGeneratedBy(typeof(AesBase64Test))]
[PexRaisedContractException(PexExceptionState.Expected)]
public void DecryptToStringThrowsContractException264()
{
    try
    {
      AesBase64 aesBase64;
      string s;
      byte[] bs = new byte[16];
      aesBase64 = new AesBase64(bs);
      s = this.DecryptToString(aesBase64, "", "\ufeff");
      throw 
        new AssertFailedException("expected an exception of type ContractException");
    }
    catch(Exception ex)
    {
      if (!PexContract.IsContractException(ex))
        throw ex;
    }
}
    }
}
