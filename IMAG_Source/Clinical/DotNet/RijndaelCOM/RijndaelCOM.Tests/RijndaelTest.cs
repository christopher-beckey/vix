using VistA.Imaging.RijndaelCOM;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Text;
using System.Runtime.InteropServices;

namespace RijndaelCOM.Tests
{
    /// <summary>
    ///This is a test class for RijndaelTest and is intended
    ///to contain all RijndaelTest Unit Tests
    ///</summary>
    [TestClass()]
    public class RijndaelTest
    {
        [DllImport("msvcrt.dll")]
        static extern int memcmp(byte[] b1, byte[] b2, long count);

        private const string ClearText = @"&A{CLZWKHAA , ALUUN A}&B{101364841}&C{1002016321V080363}&D{RPT^CPRS;TEST.ST-LOUIS.MED.VA.GOV^2705^TIU^1822447^^^^^^^^0}&E{992}&F{MONSON , STEVE }&G{136672}&H{223334667}&I{CLE13}&J{982}&K{VISTA IMAGING VIX^90e2cca6-8de1-479e-ba7c-a52ea5b9028d}&L{http://vhaiswimmixvi1/VistaWebSvcs/ImagingExchangeSiteService.asmx}&M{2001}&O{VW}";
        private const string CipherTextB64 = @"fPkfFnhQfRPx/lrwB8JBOGgyDXHDPlssn1QhaOme5aAEDBVdlBtJZq47wKaKcQCg3JVdv0BhTFqYAshKcIfPMIGeccX60WDSzZj7Pk1wmLe9C7cADQJBuGnmZzYxYNPC0LFxXitYXxwhsRJAgYsVJ2D9aPkhnwft/7Y8Ukm5bIagiGVrGXbfhhJmIEHWDpUsF9hDV2WZpFycSQq5gZnlWQc0mKMaDzUsrMQ3tIcbsFba9lFMUpSjfDlD4AXabAFXJPdjQdZmwO/eidZXuu4HFvURxWlTXMKSqZ3SAEMqfKeYDXLOnNMfKU0EkX4G0h9N7ElwAyKComR79L6DzI28Dzl9nWjVbBNGmaEZ4CkL3AG8yGNlJ5nL0wDEBhJOeEd90IZBUefUHM921krYK4JDGmV0Z4yzS9NIvFtzcUCmKqHYrgSmhk+T0VovM0qrLiSO";
        private const string Key = @"0123456789abcdef";
        private const string IV = "fedcba9876543210";

        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        // 
        //You can use the following additional attributes as you write your tests:
        //
        //Use ClassInitialize to run code before running the first test in the class
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //Use ClassCleanup to run code after all tests in a class have run
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //Use TestInitialize to run code before running each test
        //[TestInitialize()]
        //public void MyTestInitialize()
        //{
        //}
        //
        //Use TestCleanup to run code after each test has run
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion

        /// <summary>
        ///A test for Decrypt
        ///</summary>
        [TestMethod()]
        public void DecryptTest()
        {
            byte[] key = Encoding.ASCII.GetBytes(Key);
            byte[] iv = Encoding.ASCII.GetBytes(IV);
            Rijndael target = new Rijndael() { Key = key };
            byte[] cipherBytes = Convert.FromBase64String(CipherTextB64);
            byte[] expected = Encoding.ASCII.GetBytes(ClearText);
            byte[] actual = target.Decrypt(cipherBytes, iv);
            Assert.IsTrue(expected.Length == actual.Length && memcmp(expected, actual, expected.Length) == 0);
        }

        /// <summary>
        ///A test for DecryptBase64ToString
        ///</summary>
        [TestMethod()]
        public void DecryptBase64ToStringTest()
        {
            Rijndael target = new Rijndael() { KeyString = Key };
            string expected = ClearText;
            string actual = target.DecryptBase64ToString(CipherTextB64, IV);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        ///A test for Encrypt
        ///</summary>
        [TestMethod()]
        public void EncryptTest()
        {
            byte[] key = Encoding.ASCII.GetBytes(Key);
            byte[] iv = Encoding.ASCII.GetBytes(IV);
            Rijndael target = new Rijndael() { Key = key };
            byte[] clearBytes = Encoding.ASCII.GetBytes(ClearText);
            byte[] expected = Convert.FromBase64String(CipherTextB64);
            byte[] actual = target.Encrypt(clearBytes, iv);
            Assert.IsTrue(expected.Length == actual.Length && memcmp(expected, actual, expected.Length) == 0);
        }

        /// <summary>
        ///A test for EncryptStringToBase64
        ///</summary>
        [TestMethod()]
        public void EncryptStringToBase64Test()
        {
            Rijndael target = new Rijndael() { KeyString = Key };
            string expected = CipherTextB64;
            string actual = target.EncryptStringToBase64(ClearText, IV);
            Assert.AreEqual(expected, actual);
        }
    }
}
