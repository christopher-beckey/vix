/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 3, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.federation.configuration;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;

/**
 * Configuration properties for the Federation Web App
 * 
 * @author vhaiswwerfej
 *
 */
public class FederationWebAppConfiguration 
extends AbstractBaseFacadeConfiguration
{
	private List<ImageFormat> federationExamImageReferenceAcceptableFormatList = 
		new ArrayList<ImageFormat>();
	private List<ImageFormat> federationExamImageDiagnosticAcceptableFormatList = 
		new ArrayList<ImageFormat>();
	
	private List<ImageFormat> federationImageDiagnosticAcceptableFormatList = 
		new ArrayList<ImageFormat>();	
	private List<ImageFormat> federationImageReferenceAcceptableFormatList = 
		new ArrayList<ImageFormat>();
	private List<ImageFormat> federationImageThumbnailAcceptableFormatList = 
		new ArrayList<ImageFormat>();
	
	public synchronized static FederationWebAppConfiguration getFederationWebAppConfiguration()
	{
		try
		{
			return FacadeConfigurationFactory.getConfigurationFactory().getConfiguration(
					FederationWebAppConfiguration.class);			
		}
		catch(CannotLoadConfigurationException clcX)
		{
			return null;
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration#loadDefaultConfiguration()
	 */
	@Override
	public AbstractBaseFacadeConfiguration loadDefaultConfiguration()
	{
		federationExamImageReferenceAcceptableFormatList.add(ImageFormat.DICOMJPEG2000);
		federationExamImageReferenceAcceptableFormatList.add(ImageFormat.J2K);		
		federationExamImageReferenceAcceptableFormatList.add(ImageFormat.DICOM);
		federationExamImageReferenceAcceptableFormatList.add(ImageFormat.TGA);
		federationExamImageReferenceAcceptableFormatList.add(ImageFormat.DICOMJPEG);
		federationExamImageReferenceAcceptableFormatList.add(ImageFormat.ORIGINAL);
		
		federationExamImageDiagnosticAcceptableFormatList = new ArrayList<ImageFormat>();
		federationExamImageDiagnosticAcceptableFormatList.add(ImageFormat.DICOMJPEG2000);
		federationExamImageDiagnosticAcceptableFormatList.add(ImageFormat.J2K);
		federationExamImageDiagnosticAcceptableFormatList.add(ImageFormat.DICOM);
		federationExamImageDiagnosticAcceptableFormatList.add(ImageFormat.TGA);
		federationExamImageDiagnosticAcceptableFormatList.add(ImageFormat.DICOMJPEG);
		federationExamImageDiagnosticAcceptableFormatList.add(ImageFormat.ORIGINAL);
		
		federationImageThumbnailAcceptableFormatList.add(ImageFormat.JPEG);
		federationImageThumbnailAcceptableFormatList.add(ImageFormat.BMP);
		federationImageThumbnailAcceptableFormatList.add(ImageFormat.TGA);
		federationImageThumbnailAcceptableFormatList.add(ImageFormat.ORIGINAL);
		
		federationImageReferenceAcceptableFormatList.add(ImageFormat.DICOMJPEG2000);
//		federationImageReferenceAcceptableFormatList.add(ImageFormat.DICOM);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.TGA);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.PDF);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.DOC);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.RTF);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.TEXT_PLAIN);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.AVI);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.BMP);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.HTML);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.MP3);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.MPG);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.J2K);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.JPEG);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.TIFF);
		federationImageReferenceAcceptableFormatList.add(ImageFormat.ORIGINAL);
		
		federationImageDiagnosticAcceptableFormatList.add(ImageFormat.DICOMJPEG2000);
//		federationImageDiagnosticAcceptableFormatList.add(ImageFormat.DICOM);
		federationImageDiagnosticAcceptableFormatList.add(ImageFormat.TGA);
		federationImageDiagnosticAcceptableFormatList.add(ImageFormat.J2K);
		federationImageDiagnosticAcceptableFormatList.add(ImageFormat.JPEG);
		federationImageDiagnosticAcceptableFormatList.add(ImageFormat.TIFF);
		federationImageDiagnosticAcceptableFormatList.add(ImageFormat.ORIGINAL);
		return this;
	}
	
	/**
	 * @return the federationExamImageReferenceAcceptableFormatList
	 */
	public List<ImageFormat> getFederationExamImageReferenceAcceptableFormatList()
	{
		return federationExamImageReferenceAcceptableFormatList;
	}

	/**
	 * @param federationExamImageReferenceAcceptableFormatList the federationExamImageReferenceAcceptableFormatList to set
	 */
	public void setFederationExamImageReferenceAcceptableFormatList(
	List<ImageFormat> federationExamImageReferenceAcceptableFormatList)
	{
		this.federationExamImageReferenceAcceptableFormatList = federationExamImageReferenceAcceptableFormatList;
	}

	/**
	 * @return the federationExamImageDiagnosticAcceptableFormatList
	 */
	public List<ImageFormat> getFederationExamImageDiagnosticAcceptableFormatList()
	{
		return federationExamImageDiagnosticAcceptableFormatList;
	}

	/**
	 * @param federationExamImageDiagnosticAcceptableFormatList the federationExamImageDiagnosticAcceptableFormatList to set
	 */
	public void setFederationExamImageDiagnosticAcceptableFormatList(
	List<ImageFormat> federationExamImageDiagnosticAcceptableFormatList)
	{
		this.federationExamImageDiagnosticAcceptableFormatList = federationExamImageDiagnosticAcceptableFormatList;
	}

	/**
	 * @return the federationImageDiagnosticAcceptableFormatList
	 */
	public List<ImageFormat> getFederationImageDiagnosticAcceptableFormatList()
	{
		return federationImageDiagnosticAcceptableFormatList;
	}

	/**
	 * @param federationImageDiagnosticAcceptableFormatList the federationImageDiagnosticAcceptableFormatList to set
	 */
	public void setFederationImageDiagnosticAcceptableFormatList(
		List<ImageFormat> federationImageDiagnosticAcceptableFormatList)
	{
		this.federationImageDiagnosticAcceptableFormatList = federationImageDiagnosticAcceptableFormatList;
	}

	/**
	 * @return the federationImageReferenceAcceptableFormatList
	 */
	public List<ImageFormat> getFederationImageReferenceAcceptableFormatList()
	{
		return federationImageReferenceAcceptableFormatList;
	}

	/**
	 * @param federationImageReferenceAcceptableFormatList the federationImageReferenceAcceptableFormatList to set
	 */
	public void setFederationImageReferenceAcceptableFormatList(
		List<ImageFormat> federationImageReferenceAcceptableFormatList)
	{
		this.federationImageReferenceAcceptableFormatList = federationImageReferenceAcceptableFormatList;
	}

	/**
	 * @return the federationImageThumbnailAcceptableFormatList
	 */
	public List<ImageFormat> getFederationImageThumbnailAcceptableFormatList()
	{
		return federationImageThumbnailAcceptableFormatList;
	}

	/**
	 * @param federationImageThumbnailAcceptableFormatList the federationImageThumbnailAcceptableFormatList to set
	 */
	public void setFederationImageThumbnailAcceptableFormatList(
		List<ImageFormat> federationImageThumbnailAcceptableFormatList)
	{
		this.federationImageThumbnailAcceptableFormatList = federationImageThumbnailAcceptableFormatList;
	}

	public static void main(String [] args)
	{
		FederationWebAppConfiguration config = getFederationWebAppConfiguration();
		config.storeConfiguration();
	}

}
