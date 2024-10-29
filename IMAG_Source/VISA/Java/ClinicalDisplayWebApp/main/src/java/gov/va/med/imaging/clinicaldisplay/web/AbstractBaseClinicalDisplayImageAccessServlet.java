/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 8, 2008
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
package gov.va.med.imaging.clinicaldisplay.web;

import java.io.IOException;
import java.util.List;

import javax.management.InstanceNotFoundException;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;


import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.http.AcceptElementList;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.AbstractBaseFacadeImageServlet;
import gov.va.med.imaging.wado.query.WadoQuery;
import gov.va.med.imaging.wado.query.WadoRequest;
import gov.va.med.imaging.wado.query.exceptions.WadoQueryComplianceException;

/**
 * Abstract base clinical Display image servlet that contains common functions for retrieving
 * images in the ClinicalDisplay interface.
 * 
 * @author VHAISWWERFEJ
 *
 */
public abstract class AbstractBaseClinicalDisplayImageAccessServlet 
extends AbstractBaseFacadeImageServlet 
{
	private static final long serialVersionUID = 1L;

	private static Logger logger = Logger.getLogger(AbstractBaseClinicalDisplayImageAccessServlet.class);	

	/**
	 * 
	 * @param wadoRequest
	 * @param resp
	 * @param logImageAccess
	 * @throws WadoQueryComplianceException
	 * @throws IOException
	 * @throws ImageServletException 
	 * @throws InstanceNotFoundException
	 */
	protected long doExchangeCompliantGet(WadoRequest wadoRequest, HttpServletResponse resp, 
		boolean logImageAccess) 
	throws WadoQueryComplianceException, IOException, ImageServletException, SecurityCredentialsExpiredException
	{
		logger.debug("Doing Exchange compliant GET:  {}", wadoRequest.toString());
		WadoQuery wadoQuery = wadoRequest.getWadoQuery();
		
		ImageURN imageUrn = wadoQuery.getInstanceUrn();
		GlobalArtifactIdentifier gai = wadoQuery.getGlobalArtifactIdentifier();
		ImageQuality imageQuality = ImageQuality.getImageQuality( wadoRequest.getWadoQuery().getImageQualityValue() );
		AcceptElementList contentTypeList = wadoQuery.getContentTypeList();
		List<ImageFormat> contentTypeWtihSubTypeList = wadoQuery.getContentTypeWithSubTypeList();
		List<ImageFormat> acceptableResponseContent = 
			validateContentType(imageQuality, contentTypeList, contentTypeWtihSubTypeList);
		
		// Do sanity check for non-Wado requests
		String imageUrnLog = (imageUrn == null ? "NULL" : "" + imageUrn);
		logger.debug("   GET params:  imageUrn=[{}]  ImageQuality=[{}]", imageUrnLog, imageQuality.name());
				
		// if the object (instance) GUID is supplied then just stream the instance
		// back, ignoring any other parameters
		
		MetadataNotification metadataNotification = new MetadataNotification(resp, true);
		if(wadoQuery.isGetTxtFile()) 
		{
			return streamTxtFileInstanceByUrn(imageUrn, resp.getOutputStream(), metadataNotification);
		}
		else 
		{
			long bytes = 0L;
			if(imageUrn == null)
			{
				bytes = streamDocument(gai, resp.getOutputStream(), metadataNotification);
			}
			else
			{
				bytes = streamImageInstanceByUrn(imageUrn, imageQuality, acceptableResponseContent, 			
						resp.getOutputStream(), metadataNotification, logImageAccess);
			}
			return bytes;
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#getUserSiteNumber()
	 */
	@Override
	public String getUserSiteNumber() 
	{
		TransactionContext context = TransactionContextFactory.get();
		return context.getLoggerSiteNumber();
	}
	
	
}
