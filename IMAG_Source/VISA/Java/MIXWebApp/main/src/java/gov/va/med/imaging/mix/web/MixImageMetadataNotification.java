/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Sep 17, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.mix.web;

import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import javax.servlet.http.HttpServletResponse;

/**
 * @author Julian
 *
 */
public class MixImageMetadataNotification
implements ImageMetadataNotification
{
	private final HttpServletResponse response;
	
	public MixImageMetadataNotification(HttpServletResponse response)
	{
		this.response = response;
	}
	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.ImageMetadataNotification#imageMetadata(java.lang.String, gov.va.med.imaging.exchange.enums.ImageFormat, int, gov.va.med.imaging.exchange.enums.ImageQuality)
	 */
	@Override
	public void imageMetadata(String checksumValue,
			ImageFormat imageFormat, int fileSize, ImageQuality imageQuality)
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		if(imageFormat != null)
		{
			response.setContentType(imageFormat.getMime());				
			transactionContext.setFacadeImageFormatSent(imageFormat.toString());
		}	
		if(imageQuality != null)
		{
			transactionContext.setFacadeImageQualitySent(imageQuality.toString());
		}	
		
	}
	
}