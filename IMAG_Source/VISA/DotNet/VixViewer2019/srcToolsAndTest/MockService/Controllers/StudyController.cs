using System;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;
using System.Xml;

using GLOB = MockService.Common.Globals;

namespace MockService.Controllers
{
    public class StudyController : ApiController
    {
        /// <summary>
        /// VixClient.GetStudyReport()
        /// </summary>
        /// <param name="studyId"></param>
        /// <returns></returns>
        //      Study/token/restservices/study/report/1008861107V475740?securityToken=0Vofu8t6_R9c6v5wKWGwuN1VEHD1BNdLfnq_W8NDCilOPaKsutVsmnSsbKcqLsHlW_KW53og4fXYMCOKaqokdj0ka-TD78oBVbnXPI4BTf4=
        [Route("Study/token/restservices/study/report/{studyId}")]
        public HttpResponseMessage GetStudyReport(string studyId)
        {
            //TODO Need reasonable infor for Report
            string xml = @"<restStringType><value>The mock report will go here !</value></restStringType>";
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };
        }

        [Route("ROIWebApp/token/restservices/exportqueue/dicom")]
        public HttpResponseMessage GetExportQueue()
        {
            string xml = "";
            xml=loadXmlInfo(xml, "GetExportQueue.xml");
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };
        }

        /// <summary>
        /// VixClient.getQAReviewReports()
        /// </summary>
        /// <param name=""></param>
        /// <returns>XML</returns>
        [Route("ViewerImagingWebApp/token/restservices/viewerImagingQA/getQAReviewReports")]
        public HttpResponseMessage getQAReviewReports()
        {
            string xml = loadXmlInfo("", "GetQAReviewReports.xml");
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };

        }

        /// <summary>
        /// getQAReviewReportStat()
        /// </summary>
        /// <param name=""></param>
        /// <returns>XML</returns>
        [Route("ViewerImagingWebApp/token/restservices/viewerImagingQA/getQAReviewReportStat")]
        public HttpResponseMessage getQAReviewReportStat(string securityToken)
        {
            string xmlDefault = @"<restStringType><value>";
            //TODO
            xmlDefault += "</value></restStringType>";
            string xml = loadXmlInfo(xmlDefault, "GetQAReviewReportStat.xml", false);
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };
        }

        [Route("ROIWebApp/token/restservices/roi/status")]
        public HttpResponseMessage GetRoiStatus()
        {
            string xml = "";
            xml = loadXmlInfo(xml, "GetRoiStatus.xml");
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };
        }

        /// <summary>
        /// VixClient.GetPatientStudies()
        /// </summary>
        /// <param name="siteNumbers"></param>
        /// <returns></returns>
        //      ViewerStudyWebApp/token/restservices/study/studies/500,600/?icn=10121&securityToken=TODOtoken&imageFilter=PAT%2cENC
        [Route("ViewerStudyWebApp/token/restservices/study/studies/{siteNumbers}")]
        public HttpResponseMessage GetPatientStudies(string siteNumbers)
        {
            //TODO Add URL parameters: string Icn, string securityToken, string imageFilter
            string[] siteNums = siteNumbers.Split(',');
            string xml = "<studies>";
            if (siteNums[0].Contains("."))
            {
                //This is just for debugging.  The site number can be in the format of x.y.z, where:
                //  x is the site number
                //  y is the number of studies
                //  z is the number of images
                string[] parts = siteNums[0].Split('.');
                xml += GetStudies(parts[0], int.Parse(parts[1]), int.Parse(parts[2]));
            }
     
            foreach (string siteNum in siteNums)
            {
                xml += "<study>" +
                "<imageCount>1</imageCount>" +
                $"<contextId>urn%3avastudy%3a{siteNum}-26732Mock-26732Mock-1008861107V475740</contextId>" +
                "<studyId>1008861107V475740</studyId>" +
                $"<siteNumber>{siteNum}</siteNumber>" +
               "<firstImage>"+
               "<thumbnailImageUri>" + System.Web.HttpUtility.UrlEncode("http://clairenstreb.brinkster.net/images/DelightInTheLord.png") + "</thumbnailImageUri><sensitive>false</sensitive><captureDate>J</captureDate></firstImage>" +
                "<groupIen>26732Mock</groupIen>" +
                "<alternateExamNumber>F</alternateExamNumber>" +
                "<description>G</description>" +
                "<procedureDate>2021-02-16T00:01:00-05:00</procedureDate>" +
                "<sensitive>false</sensitive>" +
                "<package>NONE</package>" +
                "<type>MISCELLANEOUS - CLIN</type>" +
                "<origin>VA</origin>" +
                "<event>N</event>" +
                "<siteName>Salt Lake City, UT</siteName>" +
                "<studyClass>CLIN</studyClass>" +
                "<studyType>MISCELLANEOUS - CLIN</studyType>" +
                "<specialtyDescription>R</specialtyDescription>" +
                "<procedureDescription>CLIN</procedureDescription>" +
                "</study>";
            }
            xml += "</studies>";

            xml = loadXmlInfo(xml, "GetPatientStudies.xml");
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };
        }

        /// <summary>
        /// buildImageXml()
        /// </summary>
        /// <param name="siteNumber"></param>
        /// <param name="SourceFolder"></param>
        /// <returns>An XML string</returns>
        private string buildImageXml(string siteNumber, string SourceFolder )
        {
            string returnXML = @"<image>
    <captureDate>2021-02-16T13:52:00-01:00</captureDate>
    <description>MISCELLANEOUS - JPG</description>
    <diagnosticImageUri>imageURN=urn:vaimage:660-26732Mock-26732Mock_01.JPG-1008861107V475740&amp;imageQuality=100&amp;contentType=image/jpeg,*/*</diagnosticImageUri>
    <dicomImageNumber/>
    <dicomSequenceNumber/>
    <documentDate>2021-02-16T00:00:00-02:00</documentDate>
    <imageId>urn:vaimage:660-26732Mock-26732Mock_01.JPG-1008861107V475740</imageId>
    <imageNumber>1</imageNumber>
    <imageStatus>Viewable</imageStatus>
    <imageType>JPG</imageType>
    <imageViewStatus>Viewable</imageViewStatus>
    <referenceImageUri/>
    <sensitive>false</sensitive>
    <thumbnailImageUri>imageURN=urn:vaimage:660-26732Mock-26732Mock-1008861107V475740&amp;imageQuality=20&amp;contentType=image/jpeg,image/bmp,*/*</thumbnailImageUri>
</image>";

            return returnXML;
        }

        /// <summary>
        /// Load xml info from a file if it exists, otherwise creates/freshens it if indicated
        /// </summary>
        /// <param name="xml"></param>     
        /// <param name="xmlFilename"></param>
        /// <param name="saveXml">(Optional, default is true) Whether to create/freshen</param>
        /// <returns>An XML string</returns>
        private string loadXmlInfo(string xml, string xmlFilename, bool saveXml = true) 
        {
            string xmlFolder = GLOB.responseXmlFolder.TrimEnd('\\');
            if (!Directory.Exists(xmlFolder)) Directory.CreateDirectory(xmlFolder);
            string xmlFile = Path.Combine(xmlFolder, xmlFilename);
            if (File.Exists(xmlFile))
            {
                xml = File.ReadAllText(xmlFile);
            }
            else
            {
                File.WriteAllText(xmlFile, xml);
            }

            if (string.IsNullOrWhiteSpace(xml)) return ("");
            if (saveXml)
            {
                XmlDocument xdoc = new XmlDocument();
                xdoc.LoadXml(xml);
                xdoc.Save(xmlFile);
            }
            return xml;
        }

        /// <summary>
        /// VixClient.GetStudyMetadata()
        /// </summary>
        /// <param name="siteNumbers"></param>
        /// <param name="cprsIdentifier"></param>
        /// <param name="icn"></param>
        /// <param name="securityToken"></param>
        /// <returns></returns>
        //      ViewerStudyWebApp/token/restservices/study/cprs/660?cprsIdentifier=urn%3avastudy%3a660-26732Mock-26732Mock-1008861107V475740&icn=1008861107V475740&securityToken=0Vofu8t6_R9c6v5wKWGwuN1VEHD1BNdLfnq_W8NDCilOPaKsutVsmnSsbKcqLsHlW_KW53og4fXYMCOKaqokdj0ka-TD78oBVbnXPI4BTf4=
        [Route("ViewerStudyWebApp/token/restservices/study/cprs/{siteNumbers}")]
        public HttpResponseMessage GetStudyMetadata(string siteNumbers, string cprsIdentifier, string icn, string securityToken)
        {
            string xml = @"<studies>
	   <study>
		<captureDate>02/16/2021 13:52:33</captureDate>
		<capturedBy>IMAGPROVIDERONETWOSIX,ONETWOSIX</capturedBy>
		<description>Mock Service - STUDY</description>
		<documentDate>2021-03-16T00:00:00-01:23</documentDate>
		<event/>
		<firstImage>
			<captureDate>2021-02-16T13:52:00-06:00</captureDate>
			<description>MISCELLANEOUS - THUMB</description>
			<diagnosticImageUri>imageURN=urn:vaimage:660-26732Mock-26732Mock-1008861107V475740&amp;imageQuality=100&amp;contentType=image/jpeg,*/*</diagnosticImageUri>
			<dicomImageNumber/>
			<dicomSequenceNumber/>
			<documentDate>2021-04-16T00:00:00-15:00</documentDate>
			<imageId>urn:vaimage:660-26732Mock-26732Mock-1008861107V475740</imageId>
			<imageNumber>1</imageNumber>
			<imageStatus>Viewable</imageStatus>
			<imageType>JPG</imageType>
			<imageViewStatus>Viewable</imageViewStatus>
			<referenceImageUri/>
			<sensitive>false</sensitive>
  			<thumbnailImageUri>imageURN=urn:vaimage:660-26732Mock-26732Mock-1008861107V475740&amp;imageQuality=20&amp;contentType=image/jpeg,image/bmp,*/*</thumbnailImageUri>
		</firstImage>
		<firstImageId>urn:vaimage:660-26732Mock-26732Mock-1008861107V475740</firstImageId>
		<groupIen>26732Mock</groupIen>
		<imageCount>1</imageCount>
		<package>NONE</package>
		<type>MISCELLANEOUS - CLIN</type>
		<noteTitle></noteTitle>
		<origin>VA</origin>
		<patientId>icn(1008861107V475740)</patientId>
		<patientName>PATIENT,ONEZEROTWOTHREE</patientName>
		<procedureDate>2021-02-16T00:01:00-09:00</procedureDate>
		<procedureDescription>CLIN</procedureDescription>
		<sensitive>false</sensitive>
		<serieses>
			<series>
				<images> 
   					<image>
						<captureDate>2021-02-16T13:52:00-01:00</captureDate>
						<description>MISCELLANEOUS - JPG</description>
						<diagnosticImageUri>imageURN=urn:vaimage:660-26732Mock-26732Mock_01.JPG-1008861107V475740&amp;imageQuality=100&amp;contentType=image/jpeg,*/*</diagnosticImageUri>
						<dicomImageNumber/>
						<dicomSequenceNumber/>
						<documentDate>2021-02-16T00:00:00-02:00</documentDate>
						<imageId>urn:vaimage:660-26732Mock-26732Mock_01.JPG-1008861107V475740</imageId>
						<imageNumber>1</imageNumber>
						<imageStatus>Viewable</imageStatus>
						<imageType>JPG</imageType>
						<imageViewStatus>Viewable</imageViewStatus>
						<referenceImageUri/>
						<sensitive>false</sensitive>
						<thumbnailImageUri>imageURN=urn:vaimage:660-26732Mock-26732Mock-1008861107V475740&amp;imageQuality=20&amp;contentType=image/jpeg,image/bmp,*/*</thumbnailImageUri>
					</image>
			    	<image>
						<captureDate>2021-02-16T13:52:00-01:00</captureDate>
						<description>MISCELLANEOUS - JPG</description>
						<diagnosticImageUri>imageURN=urn:vaimage:660-26732Mock-728_F0.jpeg-1008861107V475740&amp;imageQuality=100&amp;contentType=image/jpeg,*/*</diagnosticImageUri>
						<dicomImageNumber/>
						<dicomSequenceNumber/>
						<documentDate>2021-02-16T00:00:00-02:00</documentDate>
						<imageId>urn:vaimage:660-26732Mock-26732Mock-1008861107V475740</imageId>
						<imageNumber>1</imageNumber>
						<imageStatus>Viewable</imageStatus>
						<imageType>JPG</imageType>
						<imageViewStatus>Viewable</imageViewStatus>
						<referenceImageUri/>
						<sensitive>false</sensitive>
						<thumbnailImageUri>imageURN=urn:vaimage:660-26732Mock-26732Mock-1008861107V475710&amp;imageQuality=20&amp;contentType=image/jpeg,image/bmp,*/*</thumbnailImageUri>
					</image>
				    <image>
						<captureDate>2021-02-16T13:52:00-01:00</captureDate>
						<description>MISCELLANEOUS - RTF</description>
						<diagnosticImageUri>imageURN=urn:vaimage:660-26732Mock-test.rtf-1008861107V475740&amp;imageQuality=100&amp;contentType=text/rtf,*/*</diagnosticImageUri>
						<dicomImageNumber/>
						<dicomSequenceNumber/>
						<documentDate>2021-02-16T00:00:00-02:00</documentDate>
						<imageId>urn:vaimage:660-26732Mock-26732Mock-1008861107V475740</imageId>
						<imageNumber>1</imageNumber>
						<imageStatus>Viewable</imageStatus>
						<imageType>PDF</imageType>
						<imageViewStatus>Viewable</imageViewStatus>
						<referenceImageUri/>
						<sensitive>false</sensitive>
						<thumbnailImageUri>imageURN=urn:vaimage:660-26732Mock-26732Mock-1008861107V475710&amp;imageQuality=20&amp;contentType=image/jpeg,image/bmp,*/*</thumbnailImageUri>
					</image>
                    <image>
                      <captureDate>2021-02-16T13:52:00-01:00</captureDate>
                      <description>MISCELLANEOUS - GIF</description>
                      <diagnosticImageUri>imageURN=urn:vaimage:660-26732Mock-test.gif-1008861107V475740&amp;imageQuality=100&amp;contentType=image/gif,*/*</diagnosticImageUri>
                      <dicomImageNumber />
                      <dicomSequenceNumber />
                      <documentDate>2021-02-16T00:00:00-02:00</documentDate>
                      <imageId>urn:vaimage:660-26732Mock-26732Mock-1008861107V475740</imageId>
                      <imageNumber>1</imageNumber>
                      <imageStatus>Viewable</imageStatus>
                      <imageType>GIF</imageType>
                      <imageViewStatus>Viewable</imageViewStatus>
                      <referenceImageUri />
                      <sensitive>false</sensitive>
                      <thumbnailImageUri>imageURN=urn:vaimage:660-26732Mock-26732Mock-1008861107V475710&amp;imageQuality=20&amp;contentType=image/jpeg,image/bmp,*/*</thumbnailImageUri>
                    </image>
                    <image>
                      <captureDate>2021-02-16T13:52:00-01:00</captureDate>
                      <description>MISCELLANEOUS - TIF</description>
                      <diagnosticImageUri>imageURN=urn:vaimage:660-26732Mock-test.tiff-1008861107V475740&amp;imageQuality=100&amp;contentType=image/tif,*/*</diagnosticImageUri>
                      <dicomImageNumber />
                      <dicomSequenceNumber />
                      <documentDate>2021-02-16T00:00:00-02:00</documentDate>
                      <imageId>urn:vaimage:660-26732Mock-26732Mock-1008861107V475740</imageId>
                      <imageNumber>1</imageNumber>
                      <imageStatus>Viewable</imageStatus>
                      <imageType>TIF</imageType>
                      <imageViewStatus>Viewable</imageViewStatus>
                      <referenceImageUri />
                      <sensitive>false</sensitive>
                      <thumbnailImageUri>imageURN=urn:vaimage:660-26732Mock-26732Mock-1008861107V475710&amp;imageQuality=20&amp;contentType=image/gif*/*</thumbnailImageUri>
                    </image>
                    <image>
                      <captureDate>2021-02-16T13:52:00-01:00</captureDate>
                      <description>MISCELLANEOUS - PDF</description>
                      <diagnosticImageUri>imageURN=urn:vaimage:660-26732Mock-test.pdf-1008861107V475740&amp;imageQuality=100&amp;contentType=application/pdf</diagnosticImageUri>
                      <dicomImageNumber />
                      <dicomSequenceNumber />
                      <documentDate>2021-02-16T00:00:00-02:00</documentDate>
                      <imageId>urn:vaimage:660-26732Mock-26732Mock-1008861107V475740</imageId>
                      <imageNumber>10</imageNumber>
                      <imageStatus>Viewable</imageStatus>
                      <imageType>PDF</imageType>
                      <imageViewStatus>Viewable</imageViewStatus>
                      <referenceImageUri />
                      <sensitive>false</sensitive>
                    </image>
                </images>
				<modality/>
				<seriesNumber>1</seriesNumber>
				<seriesUid/>
			</series>
		</serieses>
		<siteAbbreviation>SLC</siteAbbreviation>
		<siteName>Salt Lake City, UT</siteName>
		<siteNumber>660</siteNumber>
		<specialtyDescription/>
		<studyClass>CLIN</studyClass>
		<studyId>urn:vastudy:660-26732Mock-1008861107V475740</studyId>
		<studyPackage>NONE</studyPackage>
		<studyType>MISCELLANEOUS - CLIN</studyType>
	</study>
</studies>";

            xml = loadXmlInfo(xml, "GetStudyMetadata.xml");
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };
        }
        /// <summary>
        /// VixClient.GetPatientInformation()
        /// </summary>
        /// <param name="siteNumber"></param>
        /// <param name="patientId"></param>
        /// <returns></returns>
        //      PatientWebApp/token/restservices/patient/information/660/10121      
        [Route("PatientWebApp/token/restservices/patient/information/{siteNumber}/{patientId}")]
        public HttpResponseMessage GetPatientInformation(string siteNumber, string patientId)
        {
         string xml = "<patientType>" +
                "<patientName>John Smith</patientName>" +
                "<dfn></dfn>" +
                "<patientIcn>1008861107V475740</patientIcn>" +
                "<siteNumber>660</siteNumber>" +
                "<Description>TestDescription</Description>" +
                "<dob>02/16/1998</dob>" +
                "<Age>20</Age>" +
                "<patientSex>M</patientSex>" +
                "<DicomDirXmll></DicomDirXmll>" +
                 "</patientType>";

            xml = loadXmlInfo(xml, "GetPatientInformation.xml");
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
              
            };
        }

        private string GetStudies(string siteNumber, int numberStudies, int numImages)
        {
            #region ****************************************** REAL SAMPLE DATA ******************************************
            //Here is some actual output from a test server (no PHI data), pretty printed for readability
            //"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
            //<studies>
            //	<study>
            //		<alternateExamNumber>-</alternateExamNumber>
            //		<captureDate>05/21/2020 14:05:59</captureDate>
            //		<capturedBy>RAHMAN,MOHAMMAD</capturedBy>
            //		<contextId></contextId>
            //		<description>IMAGE</description>
            //		<event></event>
            //		<firstImage>
            //			<captureDate>2020-05-21T13:05:00-05:00</captureDate>
            //			<description>IMAGE</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485472-2485472-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2020-05-20T23:00:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485472-2485472-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>DICOM</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri>imageURN=urn:vaimage:993-2485472-2485472-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri></thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485472-2485472-1008689457V473963</firstImageId>
            //		<groupIen>2485472</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>NONE</package>
            //		<type>IMAGE</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2020-05-20T23:01:00-05:00</procedureDate>
            //		<procedureDescription>CLIN</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2020-05-21T13:05:00-05:00</captureDate>
            //						<description>IMAGE</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485472-2485472-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2020-05-20T23:00:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485472-2485472-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>DICOM</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri>imageURN=urn:vaimage:993-2485472-2485472-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri></thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>RADIOLOGY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485472-1008689457V473963</studyId>
            //		<studyPackage>NONE
            //		</studyPackage>
            //		<studyType>IMAGE</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>-</alternateExamNumber>
            //		<captureDate>03/13/2020 15:52:41</captureDate>
            //		<capturedBy>RAHMAN,MOHAMMAD</capturedBy>
            //		<contextId></contextId>
            //		<description>COURT ORDER</description>
            //		<event></event>
            //		<firstImage>
            //			<captureDate>2020-03-13T14:52:00-05:00</captureDate>
            //			<description>COURT ORDER</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485471-2485471-1008689457V473963&amp;imageQuality=100&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2020-03-12T23:00:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485471-2485471-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>TIFF</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri></referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485471-2485471-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485471-2485471-1008689457V473963</firstImageId>
            //		<groupIen>2485471</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>NONE</package>
            //		<type>COURT ORDER</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2020-03-12T23:01:00-05:00</procedureDate>
            //		<procedureDescription>CLIN</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2020-03-13T14:52:00-05:00</captureDate>
            //						<description>COURT ORDER</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485471-2485471-1008689457V473963&amp;imageQuality=100&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2020-03-12T23:00:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485471-2485471-1008689457V473963
            //						</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>TIFF</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri></referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485471-2485471-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription></specialtyDescription>
            //		<studyClass>ADMIN/CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485471-1008689457V473963</studyId>
            //		<studyPackage>NONE</studyPackage>
            //		<studyType>COURT ORDER</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>-</alternateExamNumber>
            //		<captureDate>08/17/2019 21:30:05</captureDate>
            //		<capturedBy>CSIPO,DEZSO</capturedBy>
            //		<contextId></contextId>
            //		<description>CONSULT - Index term P230T3</description>
            //		<event>ALLERGY TESTING</event>
            //		<firstImage>
            //			<captureDate>2019-08-17T20:30:00-05:00</captureDate>
            //			<description>CONSULT - Index term P230T3</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485438-2485438-1008689457V473963&amp;imageQuality=100&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2019-08-17T20:30:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485438-2485438-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>TIFF</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri></referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485438-2485438-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485438-2485438-1008689457V473963</firstImageId>
            //		<groupIen>2485438</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>NONE</package>
            //		<type>CONSULT</type>
            //		<noteTitle>
            //		</noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2019-08-17T20:30:00-05:00</procedureDate>
            //		<procedureDescription>CLIN</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2019-08-17T20:30:00-05:00</captureDate>
            //						<description>CONSULT - Index term P230T3</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485438-2485438-1008689457V473963&amp;imageQuality=100&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2019-08-17T20:30:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485438-2485438-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>TIFF</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri></referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485438-2485438-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>ALLERGY &amp; IMMUNOLOGY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485438-1008689457V473963</studyId>
            //		<studyPackage>NONE</studyPackage>
            //		<studyType>CONSULT</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>-</alternateExamNumber>
            //		<captureDate>08/17/2019 21:29:17</captureDate>
            //		<capturedBy>CSIPO,DEZSO</capturedBy>
            //		<contextId></contextId>
            //		<description>CONSULT - Index term P230T3</description>
            //		<event>ALLERGY TESTING</event>
            //		<firstImage>
            //			<captureDate>2019-08-17T20:29:00-05:00</captureDate>
            //			<description>CONSULT - Index term P230T3</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485437-2485437-1008689457V473963&amp;imageQuality=100&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2019-08-17T20:29:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485437-2485437-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>TIFF</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri></referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485437-2485437-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485437-2485437-1008689457V473963</firstImageId>
            //		<groupIen>2485437</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>NONE</package>
            //		<type>CONSULT</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2019-08-17T20:29:00-05:00</procedureDate>
            //		<procedureDescription>CLIN</procedureDescription>
            //		<sensitive>false
            //		</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2019-08-17T20:29:00-05:00</captureDate>
            //						<description>CONSULT - Index term P230T3</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485437-2485437-1008689457V473963&amp;imageQuality=100&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2019-08-17T20:29:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485437-2485437-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>TIFF</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri></referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485437-2485437-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM
            //		</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>ALLERGY &amp; IMMUNOLOGY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485437-1008689457V473963</studyId>
            //		<studyPackage>NONE</studyPackage>
            //		<studyType>CONSULT</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>-</alternateExamNumber>
            //		<captureDate>08/17/2019 21:25:30</captureDate>
            //		<capturedBy>CSIPO,DEZSO</capturedBy>
            //		<contextId></contextId>
            //		<description>PHOTO ID</description>
            //		<event></event>
            //		<firstImage>
            //			<captureDate>2019-08-17T20:25:00-05:00</captureDate>
            //			<description>PHOTO ID</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485436-2485436-1008689457V473963&amp;imageQuality=100&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2019-08-17T20:25:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485436-2485436-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>JPEG
            //			</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri></referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485436-2485436-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485436-2485436-1008689457V473963</firstImageId>
            //		<groupIen>2485436</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>NONE</package>
            //		<type>IMAGE</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2019-08-17T20:25:00-05:00</procedureDate>
            //		<procedureDescription>PHOTO ID</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2019-08-17T20:25:00-05:00</captureDate>
            //						<description>PHOTO ID</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485436-2485436-1008689457V473963&amp;imageQuality=100&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2019-08-17T20:25:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485436-2485436-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>JPEG</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri></referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485436-2485436-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription></specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485436-1008689457V473963</studyId>
            //		<studyPackage>NONE</studyPackage>
            //		<studyType>IMAGE</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>RAD-152011</alternateExamNumber>
            //		<captureDate>11/26/2018 13:46:54</captureDate>
            //		<capturedBy></capturedBy>
            //		<contextId>RPT^CPRS^33603855^RA^i6818873.8955-1^32</contextId>
            //		<description>OUTSIDE ULTRASOUND ABDOMEN</description>
            //		<dicomUid>1.2.840.113754.1.4.993.6818873.8955.1.112618.32</dicomUid>
            //		<event>COMPUTED TOMOGRAPHY</event>
            //		<firstImage>
            //			<captureDate>2018-11-26T12:46:00-06:00</captureDate>
            //			<description>OUTSIDE ULTRASOUND ABDOMEN (#1)</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485412-2485411-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2002-07-02T09:55:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485412-2485411-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>DICOM</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri>imageURN=urn:vaimage:993-2485412-2485411-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485412-2485411-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485412-2485411-1008689457V473963</firstImageId>
            //		<groupIen>2485411</groupIen>
            //		<imageCount>3</imageCount>
            //		<package>RAD</package>
            //		<type>IMAGE</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2018-11-26T09:44:00-06:00</procedureDate>
            //		<procedureDescription>RAD CT</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2018-11-26T12:46:00-06:00</captureDate>
            //						<description>OUTSIDE ULTRASOUND ABDOMEN (#1)</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485412-2485411-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2002-07-02T09:55:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485412-2485411-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>DICOM</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri>imageURN=urn:vaimage:993-2485412-2485411-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485412-2485411-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>RADIOLOGY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485411-1008689457V473963</studyId>
            //		<studyPackage>RAD</studyPackage>
            //		<studyType>IMAGE</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>RAD-152003</alternateExamNumber>
            //		<captureDate>11/19/2018 15:59:48</captureDate>
            //		<capturedBy></capturedBy>
            //		<contextId>RPT^CPRS^33603855^RA^i6818880.8871-1^20</contextId>
            //		<description></description>
            //		<dicomUid>1.2.840.113754.1.4.993.6818880.8871.1.111918.20</dicomUid>
            //		<event></event>
            //		<firstImage>
            //			<description></description>
            //			<diagnosticImageUri>imageURN=urn:vap34image:993-3-2-1008689457V473963-6-5-XA&amp;imageQuality=100&amp;contentType=*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<dicomUid>1.3.6.1.4.1.5962.99.1.500461879.810997854.1542393753911.41.0</dicomUid>
            //			<imageId>urn:vap34image:993-3-2-1008689457V473963-6-5-XA</imageId>
            //			<imageModality>XA</imageModality>
            //			<imageNumber>1</imageNumber>
            //			<imageStatus>Viewable (no status)</imageStatus>
            //			<imageType></imageType>
            //			<imageViewStatus>Viewable (no status)</imageViewStatus>
            //			<referenceImageUri></referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vap34image:993-3-2-1008689457V473963-6-5-XA&amp;imageQuality=20&amp;contentType=*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vap34image:993-3-2-1008689457V473963-6-5-XA</firstImageId>
            //		<imageCount>1</imageCount>
            //		<package>RAD</package>
            //		<type></type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2018-11-19T14:59:00-06:00</procedureDate>
            //		<procedureDescription></procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<description></description>
            //						<diagnosticImageUri>imageURN=urn:vap34image:993-3-2-1008689457V473963-6-5-XA&amp;imageQuality=100&amp;contentType=*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<dicomUid>1.3.6.1.4.1.5962.99.1.500461879.810997854.1542393753911.41.0</dicomUid>
            //						<imageId>urn:vap34image:993-3-2-1008689457V473963-6-5-XA</imageId>
            //						<imageModality>XA</imageModality>
            //						<imageNumber>1</imageNumber>
            //						<imageStatus>Viewable (no status)</imageStatus>
            //						<imageType></imageType>
            //						<imageViewStatus>Viewable (no status)</imageViewStatus>
            //						<referenceImageUri></referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vap34image:993-3-2-1008689457V473963-6-5-XA&amp;imageQuality=20&amp;contentType=*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality>XA</modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid>1.3.6.1.4.1.5962.99.1.500.8109.1542393753911.40.3.0.1</seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription></specialtyDescription>
            //		<studyClass>1</studyClass>
            //		<studyId>urn:vap34study:993-2-1008689457V473963</studyId>
            //		<studyModalities></studyModalities>
            //		<studyPackage>RAD</studyPackage>
            //		<studyType></studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>RAD-152003</alternateExamNumber>
            //		<captureDate>11/19/2018 14:19:55</captureDate>
            //		<capturedBy></capturedBy>
            //		<contextId>RPT^CPRS^33603855^RA^i6818880.8871-1^20</contextId>
            //		<description>OUTSIDE MRA ANGIO,ABDOMEN W/WO DYE</description>
            //		<dicomUid>1.2.840.113754.1.4.993.6818880.8871.1.111918.20</dicomUid>
            //		<event>COMPUTED TOMOGRAPHY</event>
            //		<firstImage>
            //			<captureDate>2018-11-19T13:19:00-06:00</captureDate>
            //			<description>OUTSIDE MRA ANGIO,ABDOMEN W/WO DYE (#1)</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485390-2485389-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2002-07-02T09:55:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485390-2485389-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>DICOM</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri>imageURN=urn:vaimage:993-2485390-2485389-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485390-2485389-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485390-2485389-1008689457V473963</firstImageId>
            //		<groupIen>2485389</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>RAD</package>
            //		<type>IMAGE</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2018-11-19T10:28:00-06:00</procedureDate>
            //		<procedureDescription>RAD CT
            //		</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2018-11-19T13:19:00-06:00</captureDate>
            //						<description>OUTSIDE MRA ANGIO,ABDOMEN W/WO DYE (#1)</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485390-2485389-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2002-07-02T09:55:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485390-2485389-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>DICOM</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri>imageURN=urn:vaimage:993-2485390-2485389-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*
            //						</referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485390-2485389-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>RADIOLOGY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485389-1008689457V473963</studyId>
            //		<studyPackage>RAD</studyPackage>
            //		<studyType>IMAGE</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>RAD-152002</alternateExamNumber>
            //		<captureDate>11/19/2018 14:18:45</captureDate>
            //		<capturedBy></capturedBy>
            //		<contextId>RPT^CPRS^33603855^RA^i6818880.8886-1^16</contextId>
            //		<description>ORBIT-FOREIGN BODY</description>
            //		<dicomUid>1.2.840.113754.1.4.993.6818880.8886.1.111918.16</dicomUid>
            //		<event></event>
            //		<firstImage>
            //			<captureDate>2018-11-19T13:18:00-06:00</captureDate>
            //			<description>ORBIT-FOREIGN BODY (#1)</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485388-2485387-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2014-12-15T10:35:00-06:00</documentDate>
            //			<imageId>urn:vaimage:993-2485388-2485387-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>DICOM</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri>imageURN=urn:vaimage:993-2485388-2485387-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485388-2485387-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485388-2485387-1008689457V473963</firstImageId>
            //		<groupIen>2485387</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>RAD</package>
            //		<type>IMAGE</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2018-11-19T10:13:00-06:00</procedureDate>
            //		<procedureDescription>RAD OP</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2018-11-19T13:18:00-06:00</captureDate>
            //						<description>ORBIT-FOREIGN BODY (#1)</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485388-2485387-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2014-12-15T10:35:00-06:00</documentDate>
            //						<imageId>urn:vaimage:993-2485388-2485387-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>DICOM</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri>imageURN=urn:vaimage:993-2485388-2485387-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485388-2485387-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>RADIOLOGY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485387-1008689457V473963</studyId>
            //		<studyPackage>RAD</studyPackage>
            //		<studyType>IMAGE</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>TIU-5298660</alternateExamNumber>
            //		<captureDate>02/06/2018 14:40:11</captureDate>
            //		<capturedBy></capturedBy>
            //		<contextId>RPT^CPRS^33603855^TIU^5298660</contextId>
            //		<description>Dental Consult</description>
            //		<dicomUid>1.2.840.113754.1.4.993.1.375302</dicomUid>
            //		<event>INTRA-ORAL RADIOGRAPH</event>
            //		<firstImage>
            //			<captureDate>2018-02-06T13:40:00-06:00</captureDate>
            //			<description>Dental Consult (#1)</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485210-2485209-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2001-09-21T12:19:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485210-2485209-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>DICOM</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri>imageURN=urn:vaimage:993-2485210-2485209-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485210-2485209-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485210-2485209-1008689457V473963</firstImageId>
            //		<groupIen>2485209</groupIen>
            //		<imageCount>4</imageCount>
            //		<package>CONS</package>
            //		<type>IMAGE</type>
            //		<noteTitle>CONSULT REPORT/DENTAL</noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2018-02-06T12:11:00-06:00</procedureDate>
            //		<procedureDescription>CON/PROC</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2018-02-06T13:40:00-06:00</captureDate>
            //						<description>Dental Consult (#1)</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485210-2485209-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2001-09-21T12:19:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485210-2485209-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>DICOM</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri>imageURN=urn:vaimage:993-2485210-2485209-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485210-2485209-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>DENTISTRY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485209-1008689457V473963</studyId>
            //		<studyPackage>CONS</studyPackage>
            //		<studyType>IMAGE</studyType>
            //	</study>
            //</studies>
            #endregion REAL SAMPLE DATA

            string xml = "<? xml version =\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>" +
                "<studies>" +
                "<study>";

            #region TODO SAMPLE DAT
            //TODO
            //		<alternateExamNumber>-</alternateExamNumber>
            //		<captureDate>05/21/2020 14:05:59</captureDate>
            //		<capturedBy>RAHMAN,MOHAMMAD</capturedBy>
            //		<contextId></contextId>
            //		<description>IMAGE</description>
            //		<event></event>
            //		<firstImage>
            //			<captureDate>2020-05-21T13:05:00-05:00</captureDate>
            //			<description>IMAGE</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485472-2485472-1008689457V473963&amp; imageQuality=90&amp; contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2020-05-20T23:00:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485472-2485472-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>DICOM</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri>imageURN=urn:vaimage:993-2485472-2485472-1008689457V473963&amp; imageQu
            //            ality=70&amp; contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri></thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485472-2485472-1008689457V473963</firstImageId>
            //		<groupIen>2485472</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>NONE</package>
            //		<type>IMAGE</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2020-05-20T23:01:00-05:00</procedureDate>
            //		<procedureDescription>CLIN</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2020-05-21T13:05:00-05:00</captureDate>
            //						<description>IMAGE</description>
            //						<diagnosticImageUri>imageURN= urn:vaimage:993-2485472-2485472-1008689457V473963&amp; imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2020-05-20T23:00:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485472-2485472-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>DICOM</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri>imageURN=urn:vaimage:993-2485472-2485472-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri></thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>RADIOLOGY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485472-1008689457V473963</studyId>
            //		<studyPackage>NONE
            //        </studyPackage>
            //		<studyType>IMAGE</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>-</alternateExamNumber>
            //		<captureDate>03/13/2020 15:52:41</captureDate>
            //		<capturedBy>RAHMAN,MOHAMMAD</capturedBy>
            //		<contextId></contextId>
            //		<description>COURT ORDER</description>
            //		<event></event>
            //		<firstImage>
            //			<captureDate>2020-03-13T14:52:00-05:00</captureDate>
            //			<description>COURT ORDER</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485471-2485471-1008689457V473963&amp; imageQuality=100&amp; contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2020-03-12T23:00:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485471-2485471-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>TIFF</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri></referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485471-2485471-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485471-2485471-1008689457V473963</firstImageId>
            //		<groupIen>2485471</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>NONE</package>
            //		<type>COURT ORDER</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2020-03-12T23:01:00-05:00</procedureDate>
            //		<procedureDescription>CLIN</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2020-03-13T14:52:00-05:00</captureDate>
            //						<description>COURT ORDER</description>
            //						<diagnosticImageUri>imageURN= urn:vaimage:993-2485471-2485471-1008689457V473963&amp; imageQuality=100&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2020-03-12T23:00:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485471-2485471-1008689457V473963
            //						</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>TIFF</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri></referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485471-2485471-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription></specialtyDescription>
            //		<studyClass>ADMIN/CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485471-1008689457V473963</studyId>
            //		<studyPackage>NONE</studyPackage>
            //		<studyType>COURT ORDER</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>-</alternateExamNumber>
            //		<captureDate>08/17/2019 21:30:05</captureDate>
            //		<capturedBy>CSIPO, DEZSO</capturedBy>
            //		<contextId></contextId>
            //		<description>CONSULT - Index term P230T3</description>
            //		<event>ALLERGY TESTING</event>
            //		<firstImage>
            //			<captureDate>2019-08-17T20:30:00-05:00</captureDate>
            //			<description>CONSULT - Index term P230T3</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485438-2485438-1008689457V473963&amp; imageQuality=100&amp; contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2019-08-17T20:30:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485438-2485438-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>TIFF</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri></referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485438-2485438-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485438-2485438-1008689457V473963</firstImageId>
            //		<groupIen>2485438</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>NONE</package>
            //		<type>CONSULT</type>
            //		<noteTitle>
            //		</noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2019-08-17T20:30:00-05:00</procedureDate>
            //		<procedureDescription>CLIN</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2019-08-17T20:30:00-05:00</captureDate>
            //						<description>CONSULT - Index term P230T3</description>
            //						<diagnosticImageUri>imageURN= urn:vaimage:993-2485438-2485438-1008689457V473963&amp; imageQuality=100&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2019-08-17T20:30:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485438-2485438-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>TIFF</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri></referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485438-2485438-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>ALLERGY &amp; IMMUNOLOGY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485438-1008689457V473963</studyId>
            //		<studyPackage>NONE</studyPackage>
            //		<studyType>CONSULT</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>-</alternateExamNumber>
            //		<captureDate>08/17/2019 21:29:17</captureDate>
            //		<capturedBy>CSIPO,DEZSO</capturedBy>
            //		<contextId></contextId>
            //		<description>CONSULT - Index term P230T3</description>
            //		<event>ALLERGY TESTING</event>
            //		<firstImage>
            //			<captureDate>2019-08-17T20:29:00-05:00</captureDate>
            //			<description>CONSULT - Index term P230T3</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485437-2485437-1008689457V473963&amp; imageQuality=100&amp; contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2019-08-17T20:29:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485437-2485437-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>TIFF</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri></referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485437-2485437-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485437-2485437-1008689457V473963</firstImageId>
            //		<groupIen>2485437</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>NONE</package>
            //		<type>CONSULT</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2019-08-17T20:29:00-05:00</procedureDate>
            //		<procedureDescription>CLIN</procedureDescription>
            //		<sensitive>false
            //		</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2019-08-17T20:29:00-05:00</captureDate>
            //						<description>CONSULT - Index term P230T3</description>
            //						<diagnosticImageUri>imageURN= urn:vaimage:993-2485437-2485437-1008689457V473963&amp; imageQuality=100&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2019-08-17T20:29:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485437-2485437-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>TIFF</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri></referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485437-2485437-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM
            //        </siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>ALLERGY &amp; IMMUNOLOGY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485437-1008689457V473963</studyId>
            //		<studyPackage>NONE</studyPackage>
            //		<studyType>CONSULT</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>-</alternateExamNumber>
            //		<captureDate>08/17/2019 21:25:30</captureDate>
            //		<capturedBy>CSIPO,DEZSO</capturedBy>
            //		<contextId></contextId>
            //		<description>PHOTO ID</description>
            //		<event></event>
            //		<firstImage>
            //			<captureDate>2019-08-17T20:25:00-05:00</captureDate>
            //			<description>PHOTO ID</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485436-2485436-1008689457V473963&amp; imageQuality=100&amp; contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2019-08-17T20:25:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485436-2485436-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>JPEG
            //			</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri></referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485436-2485436-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485436-2485436-1008689457V473963</firstImageId>
            //		<groupIen>2485436</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>NONE</package>
            //		<type>IMAGE</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2019-08-17T20:25:00-05:00</procedureDate>
            //		<procedureDescription>PHOTO ID</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2019-08-17T20:25:00-05:00</captureDate>
            //						<description>PHOTO ID</description>
            //						<diagnosticImageUri>imageURN= urn:vaimage:993-2485436-2485436-1008689457V473963&amp; imageQuality=100&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2019-08-17T20:25:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485436-2485436-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>JPEG</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri></referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485436-2485436-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/tiff,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription></specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485436-1008689457V473963</studyId>
            //		<studyPackage>NONE</studyPackage>
            //		<studyType>IMAGE</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>RAD-152011</alternateExamNumber>
            //		<captureDate>11/26/2018 13:46:54</captureDate>
            //		<capturedBy></capturedBy>
            //		<contextId>RPT^CPRS^33603855^RA^i6818873.8955-1^32</contextId>
            //		<description>OUTSIDE ULTRASOUND ABDOMEN</description>
            //		<dicomUid>1.2.840.113754.1.4.993.6818873.8955.1.112618.32</dicomUid>
            //		<event>COMPUTED TOMOGRAPHY</event>
            //		<firstImage>
            //			<captureDate>2018-11-26T12:46:00-06:00</captureDate>
            //			<description>OUTSIDE ULTRASOUND ABDOMEN (#1)</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485412-2485411-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2002-07-02T09:55:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485412-2485411-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>DICOM</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri>imageURN = urn:vaimage:993-2485412-2485411-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485412-2485411-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485412-2485411-1008689457V473963</firstImageId>
            //		<groupIen>2485411</groupIen>
            //		<imageCount>3</imageCount>
            //		<package>RAD</package>
            //		<type>IMAGE</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2018-11-26T09:44:00-06:00</procedureDate>
            //		<procedureDescription>RAD CT</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2018-11-26T12:46:00-06:00</captureDate>
            //						<description>OUTSIDE ULTRASOUND ABDOMEN (#1)</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485412-2485411-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2002-07-02T09:55:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485412-2485411-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>DICOM</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri>imageURN=urn:vaimage:993-2485412-2485411-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485412-2485411-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>RADIOLOGY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485411-1008689457V473963</studyId>
            //		<studyPackage>RAD</studyPackage>
            //		<studyType>IMAGE</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>RAD-152003</alternateExamNumber>
            //		<captureDate>11/19/2018 15:59:48</captureDate>
            //		<capturedBy></capturedBy>
            //		<contextId>RPT^CPRS^33603855^RA^i6818880.8871-1^20</contextId>
            //		<description></description>
            //		<dicomUid>1.2.840.113754.1.4.993.6818880.8871.1.111918.20</dicomUid>
            //		<event></event>
            //		<firstImage>
            //			<description></description>
            //			<diagnosticImageUri>imageURN=urn:vap34image:993-3-2-1008689457V473963-6-5-XA&amp; imageQuality=100&amp; contentType=*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<dicomUid>1.3.6.1.4.1.5962.99.1.500461879.810997854.1542393753911.41.0</dicomUid>
            //			<imageId>urn:vap34image:993-3-2-1008689457V473963-6-5-XA</imageId>
            //			<imageModality>XA</imageModality>
            //			<imageNumber>1</imageNumber>
            //			<imageStatus>Viewable (no status)</imageStatus>
            //			<imageType></imageType>
            //			<imageViewStatus>Viewable (no status)</imageViewStatus>
            //			<referenceImageUri></referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vap34image:993-3-2-1008689457V473963-6-5-XA&amp;imageQuality=20&amp;contentType=*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vap34image:993-3-2-1008689457V473963-6-5-XA</firstImageId>
            //		<imageCount>1</imageCount>
            //		<package>RAD</package>
            //		<type></type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2018-11-19T14:59:00-06:00</procedureDate>
            //		<procedureDescription></procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<description></description>
            //						<diagnosticImageUri>imageURN= urn:vap34image:993-3-2-1008689457V473963-6-5-XA&amp; imageQuality=100&amp;contentType=*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<dicomUid>1.3.6.1.4.1.5962.99.1.500461879.810997854.1542393753911.41.0</dicomUid>
            //						<imageId>urn:vap34image:993-3-2-1008689457V473963-6-5-XA</imageId>
            //						<imageModality>XA</imageModality>
            //						<imageNumber>1</imageNumber>
            //						<imageStatus>Viewable (no status)</imageStatus>
            //						<imageType></imageType>
            //						<imageViewStatus>Viewable (no status)</imageViewStatus>
            //						<referenceImageUri></referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vap34image:993-3-2-1008689457V473963-6-5-XA&amp;imageQuality=20&amp;contentType=*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality>XA</modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid>1.3.6.1.4.1.5962.99.1.500.8109.1542393753911.40.3.0.1</seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription></specialtyDescription>
            //		<studyClass>1</studyClass>
            //		<studyId>urn:vap34study:993-2-1008689457V473963</studyId>
            //		<studyModalities></studyModalities>
            //		<studyPackage>RAD</studyPackage>
            //		<studyType></studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>RAD-152003</alternateExamNumber>
            //		<captureDate>11/19/2018 14:19:55</captureDate>
            //		<capturedBy></capturedBy>
            //		<contextId>RPT^CPRS^33603855^RA^i6818880.8871-1^20</contextId>
            //		<description>OUTSIDE MRA ANGIO,ABDOMEN W/WO DYE</description>
            //		<dicomUid>1.2.840.113754.1.4.993.6818880.8871.1.111918.20</dicomUid>
            //		<event>COMPUTED TOMOGRAPHY</event>
            //		<firstImage>
            //			<captureDate>2018-11-19T13:19:00-06:00</captureDate>
            //			<description>OUTSIDE MRA ANGIO,ABDOMEN W/WO DYE (#1)</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485390-2485389-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2002-07-02T09:55:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485390-2485389-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>DICOM</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri>imageURN=urn:vaimage:993-2485390-2485389-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485390-2485389-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485390-2485389-1008689457V473963</firstImageId>
            //		<groupIen>2485389</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>RAD</package>
            //		<type>IMAGE</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2018-11-19T10:28:00-06:00</procedureDate>
            //		<procedureDescription>RAD CT
            //		</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2018-11-19T13:19:00-06:00</captureDate>
            //						<description>OUTSIDE MRA ANGIO,ABDOMEN W/WO DYE (#1)</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485390-2485389-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2002-07-02T09:55:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485390-2485389-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>DICOM</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri>imageURN=urn:vaimage:993-2485390-2485389-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*
            //						</referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485390-2485389-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>RADIOLOGY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485389-1008689457V473963</studyId>
            //		<studyPackage>RAD</studyPackage>
            //		<studyType>IMAGE</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>RAD-152002</alternateExamNumber>
            //		<captureDate>11/19/2018 14:18:45</captureDate>
            //		<capturedBy></capturedBy>
            //		<contextId>RPT^CPRS^33603855^RA^i6818880.8886-1^16</contextId>
            //		<description>ORBIT-FOREIGN BODY</description>
            //		<dicomUid>1.2.840.113754.1.4.993.6818880.8886.1.111918.16</dicomUid>
            //		<event></event>
            //		<firstImage>
            //			<captureDate>2018-11-19T13:18:00-06:00</captureDate>
            //			<description>ORBIT-FOREIGN BODY (#1)</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485388-2485387-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2014-12-15T10:35:00-06:00</documentDate>
            //			<imageId>urn:vaimage:993-2485388-2485387-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>DICOM</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri>imageURN=urn:vaimage:993-2485388-2485387-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485388-2485387-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485388-2485387-1008689457V473963</firstImageId>
            //		<groupIen>2485387</groupIen>
            //		<imageCount>1</imageCount>
            //		<package>RAD</package>
            //		<type>IMAGE</type>
            //		<noteTitle></noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2018-11-19T10:13:00-06:00</procedureDate>
            //		<procedureDescription>RAD OP</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2018-11-19T13:18:00-06:00</captureDate>
            //						<description>ORBIT-FOREIGN BODY (#1)</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485388-2485387-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2014-12-15T10:35:00-06:00</documentDate>
            //						<imageId>urn:vaimage:993-2485388-2485387-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>DICOM</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri>imageURN=urn:vaimage:993-2485388-2485387-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485388-2485387-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>RADIOLOGY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485387-1008689457V473963</studyId>
            //		<studyPackage>RAD</studyPackage>
            //		<studyType>IMAGE</studyType>
            //	</study>
            //	<study>
            //		<alternateExamNumber>TIU-5298660</alternateExamNumber>
            //		<captureDate>02/06/2018 14:40:11</captureDate>
            //		<capturedBy></capturedBy>
            //		<contextId>RPT^CPRS^33603855^TIU^5298660</contextId>
            //		<description>Dental Consult</description>
            //		<dicomUid>1.2.840.113754.1.4.993.1.375302</dicomUid>
            //		<event>INTRA-ORAL RADIOGRAPH</event>
            //		<firstImage>
            //			<captureDate>2018-02-06T13:40:00-06:00</captureDate>
            //			<description>Dental Consult (#1)</description>
            //			<diagnosticImageUri>imageURN=urn:vaimage:993-2485210-2485209-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //			<dicomImageNumber></dicomImageNumber>
            //			<dicomSequenceNumber></dicomSequenceNumber>
            //			<documentDate>2001-09-21T12:19:00-05:00</documentDate>
            //			<imageId>urn:vaimage:993-2485210-2485209-1008689457V473963</imageId>
            //			<imageStatus>Viewable</imageStatus>
            //			<imageType>DICOM</imageType>
            //			<imageViewStatus>Viewable</imageViewStatus>
            //			<referenceImageUri>imageURN=urn:vaimage:993-2485210-2485209-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //			<sensitive>false</sensitive>
            //			<thumbnailImageUri>imageURN=urn:vaimage:993-2485210-2485209-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //		</firstImage>
            //		<firstImageId>urn:vaimage:993-2485210-2485209-1008689457V473963</firstImageId>
            //		<groupIen>2485209</groupIen>
            //		<imageCount>4</imageCount>
            //		<package>CONS</package>
            //		<type>IMAGE</type>
            //		<noteTitle>CONSULT REPORT/DENTAL</noteTitle>
            //		<origin>VA</origin>
            //		<patientId>icn(1008689457V473963)</patientId>
            //		<patientName>IPOACKIES,QUENTIN W</patientName>
            //		<procedureDate>2018-02-06T12:11:00-06:00</procedureDate>
            //		<procedureDescription>CON/PROC</procedureDescription>
            //		<sensitive>false</sensitive>
            //		<serieses>
            //			<series>
            //				<images>
            //					<image>
            //						<captureDate>2018-02-06T13:40:00-06:00</captureDate>
            //						<description>Dental Consult (#1)</description>
            //						<diagnosticImageUri>imageURN=urn:vaimage:993-2485210-2485209-1008689457V473963&amp;imageQuality=90&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</diagnosticImageUri>
            //						<dicomImageNumber></dicomImageNumber>
            //						<dicomSequenceNumber></dicomSequenceNumber>
            //						<documentDate>2001-09-21T12:19:00-05:00</documentDate>
            //						<imageId>urn:vaimage:993-2485210-2485209-1008689457V473963</imageId>
            //						<imageStatus>Viewable</imageStatus>
            //						<imageType>DICOM</imageType>
            //						<imageViewStatus>Viewable</imageViewStatus>
            //						<referenceImageUri>imageURN=urn:vaimage:993-2485210-2485209-1008689457V473963&amp;imageQuality=70&amp;contentType=application/dicom,image/j2k,image/x-targa,*/*&amp;contentTypeWithSubType=application/dicom,image/j2k,image/x-targa,*/*</referenceImageUri>
            //						<sensitive>false</sensitive>
            //						<thumbnailImageUri>imageURN=urn:vaimage:993-2485210-2485209-1008689457V473963&amp;imageQuality=20&amp;contentType=image/jpeg,image/x-targa,image/bmp,*/*</thumbnailImageUri>
            //					</image>
            //				</images>
            //				<modality></modality>
            //				<seriesNumber>1</seriesNumber>
            //				<seriesUid></seriesUid>
            //			</series>
            //		</serieses>
            //		<siteAbbreviation>NHM</siteAbbreviation>
            //		<siteName>Northhampton, MA(IPO5)</siteName>
            //		<siteNumber>993</siteNumber>
            //		<specialtyDescription>DENTISTRY</specialtyDescription>
            //		<studyClass>CLIN</studyClass>
            //		<studyId>urn:vastudy:993-2485209-1008689457V473963</studyId>
            //		<studyPackage>CONS</studyPackage>
            //		<studyType>IMAGE</studyType>
            //	</study>
            //</studies>"
            #endregion REAL SAMPLE DAT

            return xml;
        }

        /// <summary>
        /// VixClient.GetImage()
        /// </summary>
        /// <param name="imageURN"></param>
        /// <param name="imageQuality"></param>
        /// <param name="contentType"></param>
        /// <param name="securityToken"></param>
        /// <returns></returns>
        //http://localhost:7912/ViewerStudyWebApp/token/image?imageURN=asd&imageQuality=100&contentType=image/jpeg,*/*&securityToken=asdfasdf
        // ViewerStudyWebApp/token/image?imageURN=asd&imageQuality=100&contentType=image/jpeg,*/*&securityToken=asdfasdf
        [HttpPost][HttpGet][HttpHead]
        [Route("ViewerStudyWebApp/token/image")]
        public HttpResponseMessage GetImageFilename(string imageURN, string imageQuality, string contentType, string securityToken)
        {          
           // int imageType = 1;     // 0 = RTF, 1 = JPEG
            string xml = ""; 
            string[] imageLocator = imageURN.Split('-');
            string icn = $@"icn({imageLocator[3]})";
            string siteCode  = imageLocator[0].ToString().Split(':')[2];
            string precontent = contentType.Split(',')[0];
            string[] pieces = precontent.Split('/');
            string content = pieces[0] + '/' + pieces[1];
            string imageFile = Path.Combine(GLOB.GetImageCacheFolder(siteCode, icn, imageLocator[1]), imageLocator[2]);

            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK);
            response.Headers.Add("xxx-image-quality", imageQuality);
            response.Headers.Add("xxx-filename", imageFile );
        
            switch (content)
            {
             
                case "application/rtf":
                    response.Headers.Add("xxx-image-format", "text/rtf");
                    response.Content = new StringContent(xml, Encoding.UTF8, "text/rtf");// Note that the mime type for RTF is not consistent
                    break;
                case "text/rtf":
                    response.Headers.Add("xxx-image-format", "text/rtf");
                    response.Content = new StringContent(xml, Encoding.UTF8, "text/rtf");
                    break;
                case "image/jpeg":
                    response.Headers.Add("xxx-image-format", "image/jpeg");
                    response.Content = new StringContent(xml, Encoding.UTF8, "image/jpeg");
                    break;
                case "application/dicom":
                    response.Headers.Add("xxx-image-format", "application/dicom");
                    response.Content = new StringContent(xml, Encoding.UTF8, "application/dicom");
                    break;
                case "image/tif":
                case "image/tiff":
                    response.Headers.Add("xxx-image-format", "image/tiff");
                    response.Content = new StringContent(xml, Encoding.UTF8, "image/tiff");
                    break; 
                case "image/gif":
                    response.Headers.Add("xxx-image-format", "image/gif");
                    response.Content = new StringContent(xml, Encoding.UTF8, "image/gif");
                    break;
                case "application/pdf":
                    response.Headers.Add("xxx-image-format", "application/pdf");
                    response.Content = new StringContent(xml, Encoding.UTF8, "application/pdf");
                    break;
                case "text/plain"://TODO
                    response.Headers.Add("xxx-image-format", "text/plain");
                    response.Content = new StringContent(xml, Encoding.UTF8, "text/plain");
                    break;
                case "application/msword"://TODO
                    response.Headers.Add("xxx-image-format", "application/msword");
                    response.Content = new StringContent(xml, Encoding.UTF8, "application/msword");
                    break;
                default:
                    response.Headers.Add("xxx-image-format", content);
                    response.Content = new StringContent(xml, Encoding.UTF8, content);
                    break;
            }

            return response;
        }


        /// <summary>
        /// VixClient.GetPStateRecords()
        /// </summary>
        /// <param name="securityToken"></param>   
        /// <returns></returns>
        //      PresentationStateWebApp/token/restservices/presentationstate/get/records?securityToken=0Vofu8t6_R9c6v5wKWGwuN1VEHD1BNdLfnq_W8NDCilOPaKsutVsmnSsbKcqLsHlW_KW53og4fXYMCOKaqokdj0ka-TD78oBVbnXPI4BTf4=         
        [Route("PresentationStateWebApp/token/restservices/presentationstate/get/records")]
        public HttpResponseMessage GetPresentationState(string securityToken )
        {
 
            DateTime timeStamp;
            timeStamp = new DateTime(2008, 3, 1, 7, 0, 0);
            string json = "{\"pStateRecords\": { \"Name\": \"PATIENT, Jane Smith\", \"StudyId\": \"1008861107V475740\", \"DUZ\": \"1008861107V475740\", \"PStateUid\": \"\", \"TimeStamp\": \"" + timeStamp.ToString() + "\"}}";
            json = loadXmlInfo(json, "GetPresentationState.json");

            return new HttpResponseMessage()
            {
                Content = new StringContent(json, Encoding.UTF8, "application/xml")
            };            
        }

        /// <summary>
        /// VixClient.GetOtherPStateInformation()
        /// </summary>
        /// <param name="studyContext"></param>   
        /// <param name="securityToken"></param>   
        /// <returns></returns>
        //      PresentationStateWebApp/token/restservices/presentationstate/get/annotations?studyContext=urn:vastudy:660-26732Mock-26732Mock-1008861107V475740&securityToken=0Vofu8t6_R9c6v5wKWGwuN1VEHD1BNdLfnq_W8NDCilOPaKsutVsmnSsbKcqLsHlW_KW53og4fXYMCOKaqokdj0ka-TD78oBVbnXPI4BTf4=       
        [Route("PresentationStateWebApp/token/restservices/presentationstate/get/annotations")]
        public HttpResponseMessage GetOtherPStateInformation(string studyContext, string securityToken)
        {
            string xml = @"<restStringArrayType><value>1</value><value>NEXT_CONTEXTID|RPT^CPRS^1201^RA^i6968875.8442-1^214|0^1~No Key/Interpretation Images defined for exam.|RAD</value><value>NEXT_CONTEXTID|RPT^CPRS^1201^RA^i6968875.8442-1^214|1|CLN</value></restStringArrayType>";
            xml = loadXmlInfo(xml, "GetOtherPStateInformation.xml");

            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };
        }

        /// <summary>
        /// VixClient.GetPrintReasons()
        /// </summary>
        /// <param name="securityToken"></param>
        /// <returns></returns>
        //      ViewerImagingWebApp/token/restservices/viewerImaging/getPrintReasons       
        [Route("ViewerImagingWebApp/token/restservices/viewerImaging/getPrintReasons")]
        public HttpResponseMessage GetPrintReasons(string securityToken)
        {         
            string xml = @"<printReasons><printReason>Authorized release of medical records or health information (ROI)</printReason><printReason>Clinical care for other VA patients</printReason><printReason>Clinical care for the patient whose images are being downloaded</printReason><printReason>For approved teaching purposes by VA staff</printReason><printReason>For use in Veterans Benefits Administration claims processing.</printReason><printReason>For use in approved VA publications</printReason><printReason>For use in approved research by VA staff</printReason></printReasons>";
            xml = loadXmlInfo(xml, "GetPrintReasons.xml"); 
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };
        }
        /// <summary>
        /// VixClient.LogImageExport()
        /// </summary>
        /// <param name="securityToken"></param>
        /// <returns></returns>
        //     ViewerImagingWebApp/token/restservices/viewerImaging/logPrintImageAccess?siteId=500&imageUrn=urn:vaimage:660-26732Mock-26732Mock_01.JPG-1008861107V475740&reason=Authorized release of medical records or health information (ROI)&securityToken=0Vofu8t6_R9c6v5wKWGwuN1VEHD1BNdLfnq_W8NDCilOPaKsutVsmnSsbKcqLsHlW_KW53og4fXYMCOKaqokdj0ka-TD78oBVbnXPI4BTf4=
        [Route("ViewerImagingWebApp/token/restservices/viewerImaging/logPrintImageAccess")]
        [HttpPost]
        [HttpGet]
        [HttpHead]
        public HttpResponseMessage LogImageExport(string securityToken)
        {
            string xml = "<value>true</value>";// Used by Print Reasons
            xml = loadXmlInfo(xml, "LogImageExport.xml");
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };
        }

        /// <summary>
        ///  VixClient.RetrievePreference()
        /// </summary>
        /// <param name="securityToken"></param>
        /// <param name="key"></param>
        /// <param name="entity"></param>
        /// <returns></returns>
        //      VistaUserPreferenceWebApp/token/restservices/userPreference/load?securityToken=0Vofu8t6_R9c6v5wKWGwuN1VEHD1BNdLfnq_W8NDCilOPaKsutVsmnSsbKcqLsHlW_KW53og4fXYMCOKaqokdj0ka-TD78oBVbnXPI4BTf4=&key=layouts&entity=USR.%6020095   
        [Route("VistaUserPreferenceWebApp/token/restservices/userPreference/load")]
        public HttpResponseMessage GetUserPreference(string securityToken, string key, string entity)
        {           
            string xml = "";  //   It does not look like this is used and can be null ?
            xml = loadXmlInfo(xml, "GetUserPreference.xml");
            return new HttpResponseMessage()
            {
                Content = new StringContent(xml, Encoding.UTF8, "application/xml")
            };
        }
        

    }
}
