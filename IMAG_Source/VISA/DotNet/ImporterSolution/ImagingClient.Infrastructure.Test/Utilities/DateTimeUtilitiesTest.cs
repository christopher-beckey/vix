/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */
namespace ImagingClient.Infrastructure.Utilities
{
    using Microsoft.VisualStudio.TestTools.UnitTesting;

    /// <summary>
    /// This is a test class for DateTimeUtilitiesTest and is intended
    /// to contain all DateTimeUtilitiesTest Unit Tests
    /// </summary>
    [TestClass]
    public class DateTimeUtilitiesTest
    {
        #region Public Properties

        /// <summary>
        /// Gets or sets the test context which provides
        /// information about and functionality for the current test run.
        /// </summary>
        public TestContext TestContext { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// A test for GetFormattedDicomDate
        /// </summary>
        [TestMethod]
        public void ConvertNullDateToEmptyString()
        {
            string expected = string.Empty;
            string actual = DateTimeUtilities.ReformatDicomDateAsShortDate(null);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// A test for GetFormattedDicomDate
        /// </summary>
        [TestMethod]
        public void ReflectEmptyDate()
        {
            string dicomDate = string.Empty;
            string expected = string.Empty;
            string actual = DateTimeUtilities.ReformatDicomDateAsShortDate(dicomDate);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// A test for GetFormattedDicomTime
        /// </summary>
        [TestMethod]
        public void ReflectInvalidTime()
        {
            string dicomTime = "ABCD";
            string expected = "ABCD";
            string actual = DateTimeUtilities.ReformatDicomTimeAsShortTime(dicomTime);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// A test for GetFormattedDicomDate
        /// </summary>
        [TestMethod]
        public void ReflectNonDicomDate()
        {
            string dicomDate = "12/15/1995";
            string expected = "12/15/1995";
            string actual = DateTimeUtilities.ReformatDicomDateAsShortDate(dicomDate);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// A test for GetFormattedDicomDate
        /// </summary>
        [TestMethod]
        public void ReformatDicomDate()
        {
            string dicomDate = "19951215";
            string expected = "12/15/1995";
            string actual = DateTimeUtilities.ReformatDicomDateAsShortDate(dicomDate);
            Assert.AreEqual(expected, actual);
        }

        // You can use the following additional attributes as you write your tests:
        // Use ClassInitialize to run code before running the first test in the class
        // [ClassInitialize()]
        // public static void MyClassInitialize(TestContext testContext)
        // {
        // }
        // Use ClassCleanup to run code after all tests in a class have run
        // [ClassCleanup()]
        // public static void MyClassCleanup()
        // {
        // }
        // Use TestInitialize to run code before running each test
        // [TestInitialize()]
        // public void MyTestInitialize()
        // {
        // }
        // Use TestCleanup to run code after each test has run
        // [TestCleanup()]
        // public void MyTestCleanup()
        // {
        // }

        /// <summary>
        /// A test for GetFormattedDicomTime
        /// </summary>
        [TestMethod]
        public void ReformatHhAsShortTime()
        {
            string dicomTime = "13";
            string expected = "1:00:00 PM";
            string actual = DateTimeUtilities.ReformatDicomTimeAsShortTime(dicomTime);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// A test for GetFormattedDicomTime
        /// </summary>
        [TestMethod]
        public void ReformatHhMmAsShortTime()
        {
            string dicomTime = "1315";
            string expected = "1:15:00 PM";
            string actual = DateTimeUtilities.ReformatDicomTimeAsShortTime(dicomTime);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// A test for GetFormattedDicomTime
        /// </summary>
        [TestMethod]
        public void ReformatHhMmSsAsShortTime()
        {
            string dicomTime = "131523";
            string expected = "1:15:23 PM";
            string actual = DateTimeUtilities.ReformatDicomTimeAsShortTime(dicomTime);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// A test for GetFormattedDicomTime
        /// </summary>
        [TestMethod]
        public void ReformatHhMmSsDecimalValueAsShortTime()
        {
            string dicomTime = "131523.123456";
            string expected = "1:15:23 PM";
            string actual = DateTimeUtilities.ReformatDicomTimeAsShortTime(dicomTime);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// A test for GetFormattedDicomTime
        /// </summary>
        [TestMethod]
        public void Return000000AsOneMinuteAfterMidnight()
        {
            string dicomTime = "000000";
            string expected = "12:01:00 AM";
            string actual = DateTimeUtilities.ReformatDicomTimeAsShortTime(dicomTime);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// A test for GetFormattedDicomTime
        /// </summary>
        [TestMethod]
        public void Return0000AsOneMinuteAfterMidnight()
        {
            string dicomTime = "000000";
            string expected = "12:01:00 AM";
            string actual = DateTimeUtilities.ReformatDicomTimeAsShortTime(dicomTime);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// A test for GetFormattedDicomTime
        /// </summary>
        [TestMethod]
        public void Return00AsOneMinuteAfterMidnight()
        {
            string dicomTime = "00";
            string expected = "12:01:00 AM";
            string actual = DateTimeUtilities.ReformatDicomTimeAsShortTime(dicomTime);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// A test for GetFormattedDicomTime
        /// </summary>
        [TestMethod]
        public void ReturnEmptyTimeAsOneMinuteAfterMidnight()
        {
            string dicomTime = string.Empty;
            string expected = "12:01:00 AM";
            string actual = DateTimeUtilities.ReformatDicomTimeAsShortTime(dicomTime);
            Assert.AreEqual(expected, actual);
        }

        /// <summary>
        /// A test for GetFormattedDicomTime
        /// </summary>
        [TestMethod]
        public void ReturnNullTimeAsOneMinuteAfterMidnight()
        {
            string expected = "12:01:00 AM";
            string actual = DateTimeUtilities.ReformatDicomTimeAsShortTime(null);
            Assert.AreEqual(expected, actual);
        }

        #endregion
    }
}