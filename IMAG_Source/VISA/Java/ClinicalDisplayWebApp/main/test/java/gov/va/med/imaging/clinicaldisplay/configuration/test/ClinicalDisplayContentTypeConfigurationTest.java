/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 10, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.clinicaldisplay.configuration.test;

import gov.va.med.imaging.clinicaldisplay.configuration.ClinicalDisplayWebAppConfiguration;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.enums.VistaImageType;
import gov.va.med.imaging.webservices.clinical.ClinicalContentTypeConfig;
import junit.framework.TestCase;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ClinicalDisplayContentTypeConfigurationTest 
extends TestCase 
{
	
	private ClinicalDisplayWebAppConfiguration configurationManager = null;
	
	
	
	/* (non-Javadoc)
	 * @see junit.framework.TestCase#setUp()
	 */
	@Override
	protected void setUp() throws Exception 
	{
		super.setUp();
		configurationManager = ClinicalDisplayWebAppConfiguration.getConfiguration();
	}
	
	/*
	private int[] getInterfaceVersions()
	{
		int []versions = {ClinicalDisplayWebAppConfiguration.CLINICAL_DISPLAY_INTERFACE_VERSION_0,
				ClinicalDisplayWebAppConfiguration.CLINICAL_DISPLAY_INTERFACE_VERSION_2,
				ClinicalDisplayWebAppConfiguration.CLINICAL_DISPLAY_INTERFACE_VERSION_3};
		
		return versions;
	}*/

	public void testJpegContentTypeConfiguration()
	{
		
		
		{
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.JPEG, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.JPEG, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.JPEG, ImageQuality.DIAGNOSTIC);
			shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.JPEG, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
		}
	}
	
	public void testPatientPhotoContentTypeConfiguration()
	{
		
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.PATIENT_PHOTO, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.PATIENT_PHOTO, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.PATIENT_PHOTO, ImageQuality.DIAGNOSTIC);
			shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.PATIENT_PHOTO, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
		
	}
	
	public void testXrayJpegContentTypeConfiguration()
	{
		
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.XRAY_JPEG, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.XRAY_JPEG, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.XRAY_JPEG, ImageQuality.DIAGNOSTIC);
			shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.XRAY_JPEG, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
		
	}
	
	public void testTiffContentTypeConfiguration()
	{
		
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.TIFF, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.TIFF, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.TIFF, ImageQuality.DIAGNOSTIC);
			shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.TIFF, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
		
	}
	
	public void testMotionVideoContentTypeConfiguration()
	{
		
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.MOTION_VIDEO, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.MOTION_VIDEO, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.AVI.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.MOTION_VIDEO, ImageQuality.DIAGNOSTIC);
			shouldBeContentType = ImageFormat.AVI.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.MOTION_VIDEO, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			shouldBeContentType = ImageFormat.AVI.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
		
	}
	
	public void testHtmlContentTypeConfiguration()
	{
		
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.HTML, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.HTML, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.HTML.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.HTML, ImageQuality.DIAGNOSTIC);
			shouldBeContentType = ImageFormat.HTML.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.HTML, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			shouldBeContentType = ImageFormat.HTML.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
		
	}
	
	public void testWordDocContentTypeConfiguration()
	{
		
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.WORD_DOCUMENT, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.WORD_DOCUMENT, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.DOC.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.WORD_DOCUMENT, ImageQuality.DIAGNOSTIC);
			shouldBeContentType = ImageFormat.DOC.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.WORD_DOCUMENT, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			shouldBeContentType = ImageFormat.DOC.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
		
	}
	
	public void testTextPlainContentTypeConfiguration()
	{
		
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.ASCII_TEXT, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.ASCII_TEXT, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.TEXT_PLAIN.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.ASCII_TEXT, ImageQuality.DIAGNOSTIC);
			shouldBeContentType = ImageFormat.TEXT_PLAIN.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.ASCII_TEXT, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			shouldBeContentType = ImageFormat.TEXT_PLAIN.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
		
	}
	
	public void testPdfContentTypeConfiguration()
	{
		
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.PDF, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.PDF, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.PDF.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.PDF, ImageQuality.DIAGNOSTIC);
			shouldBeContentType = ImageFormat.PDF.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.PDF, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			shouldBeContentType = ImageFormat.PDF.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
		
	}
	
	public void testRtfContentTypeConfiguration()
	{
		
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.RTF, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.RTF, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.RTF.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.RTF, ImageQuality.DIAGNOSTIC);
			shouldBeContentType = ImageFormat.RTF.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.RTF, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			shouldBeContentType = ImageFormat.RTF.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
		
	}
	
	public void testAudioContentTypeConfiguration()
	{
		
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.AUDIO, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.AUDIO, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.WAV.getMime() + "," + ImageFormat.MP3.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.AUDIO, ImageQuality.DIAGNOSTIC);
			shouldBeContentType = ImageFormat.WAV.getMime() + "," + ImageFormat.MP3.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.AUDIO, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			shouldBeContentType = ImageFormat.WAV.getMime() + "," + ImageFormat.MP3.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
		
	}
	
	public void testXrayContentTypeConfiguration()
	{
		
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.XRAY, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TGA.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.XRAY, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.DICOM.getMime() + "," + ImageFormat.J2K.getMime() + "," + 
			ImageFormat.DICOM.getMime() + "," + ImageFormat.TGA.getMime();		
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.XRAY, ImageQuality.DIAGNOSTIC);
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.XRAY, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			compareContentTypes(config.getContentType(), shouldBeContentType);
		
	}
	
	public void testDICOMContentTypeConfiguration()
	{
		
		
		{
			ClinicalContentTypeConfig config = getConfig( 
					VistaImageType.DICOM, ImageQuality.THUMBNAIL);
			String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TGA.getMime() + "," + ImageFormat.BMP.getMime();
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			
			config = getConfig( 
					VistaImageType.DICOM, ImageQuality.REFERENCE);
			shouldBeContentType = ImageFormat.DICOM.getMime() + "," + ImageFormat.J2K.getMime() + "," + 
			ImageFormat.DICOM.getMime() + "," + ImageFormat.TGA.getMime();	
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.DICOM, ImageQuality.DIAGNOSTIC);
			compareContentTypes(config.getContentType(), shouldBeContentType);
			
			config = getConfig( 
					VistaImageType.DICOM, ImageQuality.DIAGNOSTICUNCOMPRESSED);
			compareContentTypes(config.getContentType(), shouldBeContentType);
		}
	}
	
	public void testBwMedContentTypeConfiguration()
	{
		ClinicalContentTypeConfig config = getConfig(
				VistaImageType.BWMED, ImageQuality.THUMBNAIL);
		String shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
		compareContentTypes(config.getContentType(), shouldBeContentType);
		
		config = getConfig(
				VistaImageType.BWMED, ImageQuality.REFERENCE);
		shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
		compareContentTypes(config.getContentType(), shouldBeContentType);
		
		config = getConfig(
				VistaImageType.BWMED, ImageQuality.DIAGNOSTIC);
		shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
		compareContentTypes(config.getContentType(), shouldBeContentType);
		
		config = getConfig(
				VistaImageType.BWMED, ImageQuality.DIAGNOSTICUNCOMPRESSED);
		shouldBeContentType = ImageFormat.JPEG.getMime() + "," + ImageFormat.TIFF.getMime() + "," + ImageFormat.BMP.getMime();
		compareContentTypes(config.getContentType(), shouldBeContentType);
	}
	
	private ClinicalContentTypeConfig getConfig(VistaImageType imageType, ImageQuality imageQuality)
	{
		ClinicalContentTypeConfig config =
			configurationManager.getContentTypeConfiguration(imageType, imageQuality);
		assertNotNull(config);
		return config;
	}
	
	private void compareContentTypes(String configContentType, String expectedContentType)
	{
		assertEquals("Config Content Type [" + configContentType + "] not equal to expected [" + expectedContentType + "]", configContentType, expectedContentType);	
	}

}
