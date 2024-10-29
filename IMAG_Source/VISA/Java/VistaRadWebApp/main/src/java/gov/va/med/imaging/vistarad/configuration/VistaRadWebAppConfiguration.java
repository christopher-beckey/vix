/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 9, 2009
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
package gov.va.med.imaging.vistarad.configuration;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.facade.configuration.AbstractBaseFacadeConfiguration;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;

/**
 * Configuration properties for the VistARad web app interface.
 * 
 * 
 * @author vhaiswwerfej
 *
 */
public class VistaRadWebAppConfiguration 
extends AbstractBaseFacadeConfiguration 
{
	private List<ImageFormat> diagnosticQualityImageFormats = 
		new ArrayList<ImageFormat>();
	private List<ImageFormat> imageAccessReferenceQualityImageFormats = 
		new ArrayList<ImageFormat>();
	private List<ImageFormat> imageAccessDiagnosticQualityImageFormats = 
		new ArrayList<ImageFormat>();
	
	public VistaRadWebAppConfiguration()
	{
		super();
	}
	
	public static synchronized VistaRadWebAppConfiguration getVistaRadConfiguration()
	{
		try
		{
			return FacadeConfigurationFactory.getConfigurationFactory().getConfiguration(
					VistaRadWebAppConfiguration.class);			
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
		diagnosticQualityImageFormats.add(ImageFormat.DICOM);
		diagnosticQualityImageFormats.add(ImageFormat.TGA);
		
		imageAccessReferenceQualityImageFormats.add(ImageFormat.DICOM);
		imageAccessReferenceQualityImageFormats.add(ImageFormat.TGA);
		imageAccessReferenceQualityImageFormats.add(ImageFormat.DICOMJPEG);
		imageAccessReferenceQualityImageFormats.add(ImageFormat.ORIGINAL);
		
		imageAccessDiagnosticQualityImageFormats.add(ImageFormat.DICOM);
		imageAccessDiagnosticQualityImageFormats.add(ImageFormat.TGA);
		imageAccessDiagnosticQualityImageFormats.add(ImageFormat.DICOMJPEG);
		imageAccessDiagnosticQualityImageFormats.add(ImageFormat.ORIGINAL);
		return this;
	}

	/**
	 * Return the image formats that VRad can use to request for diagnostic images.
	 * 
	 * @return the diagnosticQualityImageFormats
	 */
	public List<ImageFormat> getDiagnosticQualityImageFormats() {
		return diagnosticQualityImageFormats;
	}

	/**
	 * @param diagnosticQualityImageFormats the diagnosticQualityImageFormats to set
	 */
	public void setDiagnosticQualityImageFormats(
			List<ImageFormat> diagnosticQualityImageFormats) {
		this.diagnosticQualityImageFormats = diagnosticQualityImageFormats;
	}

	/**
	 * Get the list of acceptable formats the servlet can allow for reference quality requests
	 * 
	 * @return the imageAccessReferenceQualityImageFormats
	 */
	public List<ImageFormat> getImageAccessReferenceQualityImageFormats()
	{
		return imageAccessReferenceQualityImageFormats;
	}

	/**
	 * @param imageAccessReferenceQualityImageFormats the imageAccessReferenceQualityImageFormats to set
	 */
	public void setImageAccessReferenceQualityImageFormats(
			List<ImageFormat> imageAccessReferenceQualityImageFormats)
	{
		this.imageAccessReferenceQualityImageFormats = imageAccessReferenceQualityImageFormats;
	}

	/**
	 * Get the list of acceptable formats the servlet can allow for diagnostic quality requests
	 * 
	 * @return the imageAccessDiagnosticQualityImageFormats
	 */
	public List<ImageFormat> getImageAccessDiagnosticQualityImageFormats()
	{
		return imageAccessDiagnosticQualityImageFormats;
	}

	/**
	 * @param imageAccessDiagnosticQualityImageFormats the imageAccessDiagnosticQualityImageFormats to set
	 */
	public void setImageAccessDiagnosticQualityImageFormats(
			List<ImageFormat> imageAccessDiagnosticQualityImageFormats)
	{
		this.imageAccessDiagnosticQualityImageFormats = imageAccessDiagnosticQualityImageFormats;
	}

	public static void main(String [] args)
	{
		VistaRadWebAppConfiguration config = getVistaRadConfiguration();
		config.storeConfiguration();
	}
}
