/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created:
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:
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
package gov.va.med.imaging.wado;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import gov.va.med.URNFactory;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.TransactionContextHelper;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.AbstractBaseImageServlet;

public class ThumbnailServlet 
extends AbstractBaseImageServlet
{
	private static final long serialVersionUID = 1L;
	private static final Logger LOGGER = Logger.getLogger(ThumbnailServlet.class);
	
	private static List<ImageFormat> thumbnailResponseType;
	static
	{
		 thumbnailResponseType = new ArrayList<ImageFormat>();
		 thumbnailResponseType.add(ImageFormat.JPEG);
	}

	@Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
	throws ServletException, IOException
    {
		String pathInfo = req.getPathInfo();
		
		if(pathInfo == null || pathInfo.isEmpty())
		{
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "The image URN was not specified in the URL and must be.");
		}
		else
		{
			TransactionContext transactionContext = TransactionContextFactory.get();
			String imageIdentifier = pathInfo.charAt(0) == '/' ? pathInfo.substring(1) : pathInfo;

            LOGGER.info("ThumbnailServlet.doGet() --> Getting thumbnail image [{}]", pathInfo);
			
			try
	        {
		        ImageURN imageUrn = URNFactory.create(imageIdentifier, ImageURN.class);
		        TransactionContextHelper.setTransactionContextFields("getThumbnail", imageUrn.getPatientId(), imageIdentifier);
		        
		    	long bytesTransferred = streamImageInstanceByUrn(
		    			imageUrn, ImageQuality.THUMBNAIL,
		    			thumbnailResponseType, 
		    			resp.getOutputStream(),
		    			new MetadataNotification(resp) );
		    	
		    	transactionContext.setEntriesReturned( bytesTransferred == 0 ? 0 : 1 );
				transactionContext.setFacadeBytesSent(bytesTransferred);
				transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
	        } 
			catch (URNFormatException e)
	        {
				String msg = "ThumbnailServlet.doGet() --> Image Id [" + StringUtil.cleanString(imageIdentifier) + "] is not a valid image identifier (ImageURN): " + e.getMessage();
				LOGGER.info(msg);
				transactionContext.setResponseCode(HttpServletResponse.SC_BAD_REQUEST + "");
				resp.sendError(HttpServletResponse.SC_BAD_REQUEST, msg);
	        } 
			catch (ImageServletException isX)
	        {
				String msg = "ThumbnailServlet.doGet() --> Encountered [ImageServletException]: " + isX.getMessage();
				LOGGER.error(msg);
				transactionContext.setResponseCode(isX.getResponseCode() + "");
				resp.sendError(isX.getResponseCode(), msg);
	        }
			catch(Exception ex)
			{
				String msg = "DiagnosticServlet.doGet() --> Encountered exception [" + ex.getClass().getSimpleName() + "]: " + ex.getMessage();
				LOGGER.error(msg);
				transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
				resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg);
			}
		}		
    }

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#getUserSiteNumber()
	 */
	@Override
	public String getUserSiteNumber() 
	{
		return TransactionContextFactory.get().getLoggerSiteNumber();
	}
}
