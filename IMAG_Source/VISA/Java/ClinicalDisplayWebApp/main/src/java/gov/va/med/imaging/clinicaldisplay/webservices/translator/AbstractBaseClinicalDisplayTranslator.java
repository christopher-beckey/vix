/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 30, 2009
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
package gov.va.med.imaging.clinicaldisplay.webservices.translator;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.regex.Pattern;

import gov.va.med.imaging.clinicaldisplay.configuration.ClinicalDisplayWebAppConfiguration;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.enums.VistaImageType;
import gov.va.med.imaging.translator.AbstractClinicalTranslator;
import gov.va.med.imaging.webservices.clinical.ClinicalContentTypeConfig;

import gov.va.med.logging.Logger;


/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractBaseClinicalDisplayTranslator 
extends AbstractClinicalTranslator
{
	private final static Logger logger = Logger.getLogger(AbstractBaseClinicalDisplayTranslator.class);
	private final static String clinicalDisplayWebserviceShortDateFormat = "MM/dd/yyyy";
	private final static String clinicalDisplayWebserviceShortYearDateFormat = "MM/dd/yy"; 
	private final static String clinicalDisplayWebserviceLongDateFormat = "MM/dd/yyyy HH:mm";	
	
	private final static String clinicalDisplayShortDatePattern = "\\d\\d[/]\\d\\d[/]\\d\\d\\d\\d";
	private final static String clinicalDisplayShortYearDatePattern = "\\d\\d[/]\\d\\d[/]\\d\\d";
	
	
	
	protected static Logger getLogger()
	{
		return logger;
	}
	
	/**
	 * Certain characters cannot be given to the Clinical Display client because they will cause exceptions
	 * in the parsing, they must be removed to ensure proper display of metadata. This function removes those
	 * characters and replaces them with a space
	 * @param input Input string to check
	 * @return
	 */
	protected static String extractIllegalCharacters(String input)
	{
		if(input == null)
			return "";
		return input.replaceAll("\\^", " ");	
	}
	
	// be careful about re-using SimpleDateFormat instances because they are not thread-safe 
	protected static DateFormat getClinicalDisplayWebserviceShortDateFormat()
	{
		return new SimpleDateFormat(clinicalDisplayWebserviceShortDateFormat);
	}
	
	protected static DateFormat getClinicalDisplayWebserviceLongDateFormat()
	{
		return new SimpleDateFormat(clinicalDisplayWebserviceLongDateFormat);
	}
	
	/**
	 * Find the appropriate date format based on the pattern of the input date
	 * @param date The input date in raw format
	 * 
	 */
	protected static DateFormat getClinicalDisplayWebserviceFormat(String date)
	{
		Pattern shortPattern = Pattern.compile(clinicalDisplayShortYearDatePattern);
		if(shortPattern.matcher(date).matches())
			return new SimpleDateFormat(clinicalDisplayWebserviceShortYearDateFormat);
		Pattern longYearPattern = Pattern.compile(clinicalDisplayShortDatePattern);
		if(longYearPattern.matcher(date).matches())
			return new SimpleDateFormat(clinicalDisplayWebserviceShortDateFormat);
		return null;
	}
	
	protected static boolean isRadImage(Image image)
	{
		if(image == null)
			return false;
		int imgType = image.getImgType();
		if((imgType == VistaImageType.DICOM.getImageType()) || 
				(imgType == VistaImageType.XRAY.getImageType()))
		{
			return true;
		}
		return false;
	}
	
	private static ClinicalContentTypeConfig getContentTypeConfig(int imageType, ImageQuality imageQuality)
	{
		VistaImageType vistaImageType = getVistaImageType(imageType);
		if(vistaImageType == null)
		{
			return null;			
		}
		return getClinicalDisplayConfiguration().getContentTypeConfiguration(vistaImageType, 
				imageQuality);
	}
	
	
	private static ClinicalDisplayWebAppConfiguration getClinicalDisplayConfiguration()
	{
		return ClinicalDisplayWebAppConfiguration.getConfiguration();
	}
	
	private static VistaImageType getVistaImageType(int imageType)
	{
		return VistaImageType.valueOfImageType(imageType);
	}
	
	protected static String getContentType(Image image, ImageQuality imageQuality)
	{
		String contentType = "";
		
		ClinicalContentTypeConfig config = getContentTypeConfig(image.getImgType(), imageQuality);
		if(config != null)
			contentType = config.getContentType();		
		
		if(contentType.length() > 0)
		{
			contentType += ",*/*";
		}
		else
		{
			contentType = "*/*";
		}
		return contentType;
	}

}
