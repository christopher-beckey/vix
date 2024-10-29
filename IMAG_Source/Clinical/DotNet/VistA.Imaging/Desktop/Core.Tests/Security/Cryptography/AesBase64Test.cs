// <copyright file="AesBase64Test.cs" company="Department of Veterans Affairs">Copyright © Department of Veterans Affairs 2011</copyright>
namespace VistA.Imaging.Security.Cryptography
{
    using System;
    using Microsoft.Pex.Framework;
    using Microsoft.Pex.Framework.Validation;
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    /// <summary>This class contains parameterized unit tests for AesBase64</summary>
    [PexClass(typeof(AesBase64))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(InvalidOperationException))]
    [PexAllowedExceptionFromTypeUnderTest(typeof(ArgumentException), AcceptExceptionSubtypes = true)]
    [TestClass]
    public partial class AesBase64Test
    {
        /// <summary>
        /// Clear text test string
        /// </summary>
        private const string ClearText = @"&A{CLZWKHAA , ALUUN A}&B{101364841}&C{1002016321V080363}&D{RPT^CPRS;TEST.ST-LOUIS.MED.VA.GOV^2705^TIU^1822447^^^^^^^^0}&E{992}&F{MONSON , STEVE }&G{136672}&H{223334667}&I{CLE13}&J{982}&K{VISTA IMAGING VIX^90e2cca6-8de1-479e-ba7c-a52ea5b9028d}&L{http://vhaiswimmixvi1/VistaWebSvcs/ImagingExchangeSiteService.asmx}&M{2001}&O{VW}";

        /// <summary>
        /// Encrypted text test string base 64 encoded
        /// </summary>
        private const string CipherTextBase64 = @"w8aGF0iO4TPIxr91NWiW/JAtOgBpPXAcPZ5xSDHNpJzVX9R9FO/O4Nuw0X1aFJec1+S0MZLp69xjhWKx+WEwG+SPsoA5XRYtWSQBziQOJCrfv84H28Tdn/rag0qm79wejb4GghTRygKvPl5pwHCV2WGxCa8uw4O47wQLrSOfDq2BlS/n0Ze5M3ywA9N3Ta6/cdi3D4oU4BvpIRAK1qhMBFthP+4EI/V+8bEWBbQMrj/ErJHAN+OHhYp+YSYAVTJpCE+0lF7vtyp+KjBjuXv8Zjaq6STxNYxQfWOanVIFQCNzY6+K9WoxLdLnvWZqszWu5C7igxVqTe08oy3VJ6LfdE43m1n6NBjtzmEaN/igU6hTeuCtdTV6a+BjHXFt/KVNC9YKSPWkcyBw8hIRkf5DZnr0N+Ww84XK3C48fpCEZGsLh2vXUi8XCKyINM1U/5vI";

        /// <summary>
        /// Base 64 encoded key
        /// </summary>
        private const string KeyBase64 = @"MDEyMzQ1Njc4OWFiY2RlZg==";

        /// <summary>
        /// Base 64 encoded initialization vector
        /// </summary>
        private const string IVBase64 = @"ZmVkY2JhOTg3NjU0MzIxMA==";

        #region Pex Methods

        /// <summary>
        /// Test stub for .ctor(Byte[])
        /// </summary>
        /// <param name="key">The key.</param>
        /// <returns>The constructed AesBase64</returns>
        [PexMethod]
        public AesBase64 Constructor(byte[] key)
        {
            AesBase64 target = new AesBase64(key);
            return target;
        }

        /// <summary>
        /// Test stub for .ctor(String)
        /// </summary>
        /// <param name="base64Key">The base64 key.</param>
        /// <returns>The constructed AesBase64</returns>
        [PexMethod]
        public AesBase64 Constructor01(string base64Key)
        {
            AesBase64 target = new AesBase64(base64Key);
            return target;
        }

        /// <summary>
        /// Test stub for DecryptToString(String, String)
        /// </summary>
        /// <param name="target">The target.</param>
        /// <param name="base64CipherText">The base64 cipher text.</param>
        /// <param name="base64Iv">The base64 iv.</param>
        /// <returns>Decrypted string</returns>
        [PexMethod]
        public string DecryptToString(
            [PexAssumeUnderTest]AesBase64 target,
            string base64CipherText,
            string base64Iv)
        {
            string result = target.DecryptToString(base64CipherText, base64Iv);
            return result;
        }

        /// <summary>
        /// Test stub for EncryptString(String, String)
        /// </summary>
        /// <param name="target">The target.</param>
        /// <param name="clearText">The clear text.</param>
        /// <param name="base64Iv">The base64 iv.</param>
        /// <returns>Encrypted string</returns>
        [PexMethod]
        public string EncryptString(
            [PexAssumeUnderTest]AesBase64 target,
            string clearText,
            string base64Iv)
        {
            string result = target.EncryptString(clearText, base64Iv);
            return result;
        }

        #endregion

        #region Test Methods

        /// <summary>
        /// Tests DecryptToString.
        /// </summary>
        [TestMethod]
        public void DecryptTest()
        {
            AesBase64 aes = new AesBase64(KeyBase64);
            string result = this.DecryptToString(aes, CipherTextBase64, IVBase64);
            Assert.AreEqual(ClearText, result);
        }

        /// <summary>
        /// Tests EncryptTest.
        /// </summary>
        [TestMethod]
        public void EncryptTest()
        {
            AesBase64 aes = new AesBase64(KeyBase64);
            string result = this.EncryptString(aes, ClearText, IVBase64);
            Assert.AreEqual(CipherTextBase64, result);
        }

        #endregion
    }
}
