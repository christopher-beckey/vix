/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 11, 2008
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
package gov.va.med.imaging.federation.web;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;
import gov.va.med.imaging.url.vista.StringUtils;

/**
 * Checksum notification handler, receives the checksum and applies it to the response
 * stream
 * @author VHAISWWERFEJ
 *
 */
public class FederationChecksumNotification 
implements ImageMetadataNotification
{
	private HttpServletResponse resp;
	private ChecksumNotificationImageType imgType;
	
	public FederationChecksumNotification(HttpServletResponse resp, ChecksumNotificationImageType checksumImageType)
	{
		this.resp = resp;
		this.imgType = checksumImageType;
	}
	
	@Override
	public void imageMetadata(String checksumValue, ImageFormat imageFormat,
		int fileSize, ImageQuality imageQuality) 
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		if(checksumValue != null)
		{
			if(imgType == ChecksumNotificationImageType.IMAGE)
			{
				resp.addHeader(
						StringUtils.cleanString(TransactionContextHttpHeaders.httpHeaderImageChecksum), 
						StringUtils.cleanString(checksumValue));
			}
			else if(imgType == ChecksumNotificationImageType.TXTFILE)
			{
				resp.addHeader(
						StringUtils.cleanString(TransactionContextHttpHeaders.httpHeaderTXTChecksum),
						StringUtils.cleanString(checksumValue));
			}			
		}
		if(imageFormat != null)
		{
			resp.setContentType(imageFormat.getMime());
			resp.addHeader(
					StringUtils.cleanString(TransactionContextHttpHeaders.httpHeaderVistaImageFormat), 
					StringUtils.cleanString(imageFormat.getMimeWithEnclosedMime()));
			// only want to set the format sent if not already sent (so the text file doesn't overwrite the image file entry)
			if(transactionContext.getFacadeImageFormatSent() == null)
				transactionContext.setFacadeImageFormatSent(imageFormat.toString());
		}
		if(imageQuality != null)
		{
			// JMW 10/8/2008 - set the image quality only for an image (not for the TXT file).
			// if you set it for both then the response has multiple quality values and it confuses the client
			if(imgType == ChecksumNotificationImageType.IMAGE)
			{
				//System.out.println("Seting image quality [" + imageQuality + "]");
				//new Throwable().printStackTrace();
				if(resp.containsHeader(TransactionContextHttpHeaders.httpHeaderImageQuality))
				{
					resp.setHeader(
							StringUtils.cleanString(TransactionContextHttpHeaders.httpHeaderImageQuality),
							StringUtils.cleanString(imageQuality.getCanonical() + ""));
				}
				else
				{
					resp.addHeader(
							StringUtils.cleanString(TransactionContextHttpHeaders.httpHeaderImageQuality),
							StringUtils.cleanString(imageQuality.getCanonical() + ""));
				}
				transactionContext.setFacadeImageQualitySent(imageQuality.toString());
			}
		}
		if(fileSize > 0)
		{
			if(imgType == ChecksumNotificationImageType.IMAGE)
			{
				resp.addHeader(
						StringUtils.cleanString(TransactionContextHttpHeaders.httpHeaderImageSize),
						StringUtils.cleanString(fileSize + ""));
			}
			else if(imgType == ChecksumNotificationImageType.TXTFILE)
			{
				resp.addHeader(
						StringUtils.cleanString(TransactionContextHttpHeaders.httpHeaderTxtSize),
						StringUtils.cleanString(fileSize + ""));
			}	
		}
		String machineName = transactionContext.getMachineName();
		if(machineName == null)
			machineName = "<unknown>";
		if(resp.containsHeader(TransactionContextHttpHeaders.httpHeaderMachineName))
		{
			resp.setHeader(
					StringUtils.cleanString(TransactionContextHttpHeaders.httpHeaderMachineName),
					StringUtils.cleanString(machineName));
		}
		else
		{
			resp.addHeader(
					StringUtils.cleanString(TransactionContextHttpHeaders.httpHeaderMachineName),
					StringUtils.cleanString(machineName));	
		}		
	}
	
	/**
	 * Identifies the type of checksum that is to be applied, if the image it refers to 
	 * is an image or a TXT file
	 * @author VHAISWWERFEJ
	 *
	 */
	public enum ChecksumNotificationImageType
	{
		IMAGE, TXTFILE;
	}
}
