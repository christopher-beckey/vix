// <copyright file="AwivParameterDictionaryTest.cs">Copyright ©  2012</copyright>

namespace VistA.Imaging.Viewer.AWIV
{
    using System;
    using Microsoft.Pex.Framework;
    using Microsoft.Pex.Framework.Validation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;
    using VistA.Imaging.Models;
    using VistA.Imaging.Security.Principal;
    using VistA.Imaging.Viewer.AWIV;
    using VistA.Imaging.Viewer.Models;

    /// <summary>This class contains parameterized unit tests for AwivParameterDictionary</summary>
    [PexClass(typeof(AwivParameterDictionary))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [PexAllowedExceptionFromTypeUnderTest(typeof(AwivParameterException))]
    [TestClass]
    public partial class AwivParameterDictionaryTest
    {
        /// <summary>Test stub for get_ArtifactSetIdentifier()</summary>
        [PexMethod]
        public ArtifactSet ArtifactSetGet([PexAssumeUnderTest]AwivParameterDictionary target)
        {
            ArtifactSet result = target.ArtifactSet;
            return result;
            // TODO: add assertions to method AwivParameterDictionaryTest.ArtifactSetIdentifierGet(AwivParameterDictionary)
        }

        /// <summary>Test stub for get_CVIXSiteNumber()</summary>
        [PexMethod]
        public string CVIXSiteNumberGet([PexAssumeUnderTest]AwivParameterDictionary target)
        {
            string result = target.CVIXSiteNumber;
            return result;
            // TODO: add assertions to method AwivParameterDictionaryTest.CVIXSiteNumberGet(AwivParameterDictionary)
        }

        /// <summary>Test stub for .ctor(String)</summary>
        [PexMethod]
        public AwivParameterDictionary Constructor(string paramString)
        {
            AwivParameterDictionary target = new AwivParameterDictionary(paramString);
            return target;
            // TODO: add assertions to method AwivParameterDictionaryTest.Constructor(String)
        }

        /// <summary>Test stub for get_Patient()</summary>
        [PexMethod]
        public Patient PatientGet([PexAssumeUnderTest]AwivParameterDictionary target)
        {
            Patient result = target.Patient;
            return result;
            // TODO: add assertions to method AwivParameterDictionaryTest.PatientGet(AwivParameterDictionary)
        }

        /// <summary>Test stub for get_SiteServiceUrl()</summary>
        [PexMethod]
        public Uri SiteServiceUrlGet([PexAssumeUnderTest]AwivParameterDictionary target)
        {
            Uri result = target.SiteServiceUrl;
            return result;
            // TODO: add assertions to method AwivParameterDictionaryTest.SiteServiceUrlGet(AwivParameterDictionary)
        }

        /// <summary>Test stub for get_VistAPrincipal()</summary>
        [PexMethod]
        public VistAPrincipal VistAPrincipalGet([PexAssumeUnderTest]AwivParameterDictionary target)
        {
            VistAPrincipal result = target.VistAPrincipal;
            return result;
            // TODO: add assertions to method AwivParameterDictionaryTest.VistAPrincipalGet(AwivParameterDictionary)
        }
    }
}
