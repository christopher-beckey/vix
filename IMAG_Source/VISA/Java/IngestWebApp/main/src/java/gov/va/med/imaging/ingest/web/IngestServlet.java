/**
 * 
 * 
 * Date Created: Jan 8, 2014
 * Developer: Administrator
 */
package gov.va.med.imaging.ingest.web;

import gov.va.med.RoutingToken;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.ingest.IngestContextHolder;
import gov.va.med.imaging.ingest.web.BaseIngestServlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

/**
 * @author Administrator
 *
 */
public class IngestServlet
extends BaseIngestServlet
{
	private static final long serialVersionUID = 4110835427212431966L;

	
	protected RoutingToken createLocalRoutingToken()
	throws RoutingTokenFormatException
	{
		String siteNumber = IngestContextHolder.getIngestContext().getAppConfiguration().getLocalSiteNumber();
		return RoutingTokenHelper.createSiteAppropriateRoutingToken(siteNumber);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.ingest.web.BaseIngestServlet#isFormatAllowed(gov.va.med.imaging.exchange.enums.ImageFormat)
	 */
	@Override
	protected boolean isFormatAllowed(ImageFormat imageFormat)
	{
		if(imageFormat == null){
			return false;
		}
		for(ImageFormat value: ImageFormat.values()){
			if(value == imageFormat){
				return true;
			}
		}
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.ingest.web.BaseIngestServlet#sendResponse(javax.servlet.http.HttpServletResponse, java.util.Map, gov.va.med.imaging.ImageURN, java.lang.Throwable)
	 */
	@Override
	protected void sendResponse(HttpServletResponse response,
			Map<String, String> inputParameters, ImageURN imageUrn, String patientTiuNoteUrn, Throwable t)
	throws IOException
	{
		if(t != null)
		{
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, t.getMessage());
		}
		else
		{
			PrintWriter writer = response.getWriter();
			writer.write(imageUrn.toString(SERIALIZATION_FORMAT.RAW));
			writer.flush();
			writer.close();
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.ingest.web.BaseIngestServlet#getWebAppName()
	 */
	@Override
	protected String getWebAppName()
	{
		return "Ingest Web App";
	}

}
