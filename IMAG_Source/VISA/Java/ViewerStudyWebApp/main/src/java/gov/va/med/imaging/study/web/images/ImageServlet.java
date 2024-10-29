/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.images;

import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.http.exceptions.HttpHeaderParseException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.AbstractBaseFacadeImageServlet;
import gov.va.med.imaging.wado.query.WadoRequest;
import gov.va.med.imaging.wado.query.exceptions.WadoQueryComplianceException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author Julian
 *
 */
public class ImageServlet
extends AbstractBaseFacadeImageServlet
{
	private static final long serialVersionUID = 7006551208788126570L;
	
	private static final List<ImageFormat> acceptableThumbnailResponseTypes;
	private static final List<ImageFormat> acceptableReferenceResponseTypes;
	private static final List<ImageFormat> acceptableDiagnosticResponseTypes;
	
	static
	{
		acceptableDiagnosticResponseTypes = new ArrayList<ImageFormat>();
		acceptableReferenceResponseTypes = new ArrayList<ImageFormat>();
		acceptableThumbnailResponseTypes = new ArrayList<ImageFormat>();
		for(ImageFormat imageFormat : ImageFormat.values())
		{
			acceptableDiagnosticResponseTypes.add(imageFormat);
			acceptableReferenceResponseTypes.add(imageFormat);
			acceptableThumbnailResponseTypes.add(imageFormat);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseFacadeImageServlet#getAcceptableThumbnailResponseTypes()
	 */
	@Override
	protected List<ImageFormat> getAcceptableThumbnailResponseTypes()
	{
		return acceptableThumbnailResponseTypes;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseFacadeImageServlet#getAcceptableReferenceResponseTypes(boolean)
	 */
	@Override
	protected List<ImageFormat> getAcceptableReferenceResponseTypes(
		boolean includeSubTypes)
	{
		return acceptableReferenceResponseTypes;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseFacadeImageServlet#getAcceptableDiagnosticResponseTypes(boolean)
	 */
	@Override
	protected List<ImageFormat> getAcceptableDiagnosticResponseTypes(
		boolean includeSubTypes)
	{
		return acceptableDiagnosticResponseTypes;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#getUserSiteNumber()
	 */
	@Override
	public String getUserSiteNumber()
	{
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException
	{
		WadoRequest wadoRequest=null;
		long bytesTransferred = 0;
		TransactionContext transactionContext = TransactionContextFactory.get();

        getLogger().info("Beginning GET handler: servlet path=[{}],  path info=[{}],  HTTP method=[{}]\nquery string: [{}]", req.getServletPath(), req.getPathInfo(), req.getMethod(), req.getQueryString());
		
		try
		{
			wadoRequest = WadoRequest.createParsedCDTPCompliantWadoRequest(req);
			initTransactionContext(wadoRequest);
			transactionContext.setRequestType("Viewer Study WebApp V1 getImage");
			transactionContext.setViewerProcess(new Boolean(true));
			transactionContext.setHttpServletRequestMethod(req.getMethod());
			boolean viewerHeadRequest = (req.getMethod() != null) && (req.getMethod().equals("HEAD"));
			transactionContext.setViewerHeadRequest(viewerHeadRequest);
			
			getLogger().debug("Viewer Study WebApp V1 getImage");
            getLogger().debug("XCHANGE w/extensions compliance requested, Request is [{}]", wadoRequest.toString());
			bytesTransferred = doExchangeCompliantGet(wadoRequest, resp, true);
			transactionContext.setEntriesReturned( bytesTransferred==0 ? 0 : 1 );
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
		}
		catch( WadoQueryComplianceException wadoX )
		{
			String msg = "Request is not a valid Exchange (WAI) protocol request: " + wadoX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(wadoX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			resp.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg );
		}
		catch( HttpHeaderParseException httpParseX )
		{
			String msg = "Error parsing HTTP header information: " + httpParseX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(httpParseX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		}
		catch (IOException ioX) 
		{
			String msg = "I/O error when sending image content: " + ioX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ioX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		} 
		catch (ImageServletException isX)
        {
			String msg = isX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			// don't set the transactionContext.setExceptionClassName() property here
			// it gets set in the AbstractBaseImageServlet because that is where the real
			// exception is caught
			//transactionContext.setExceptionClassName(isX.getClass().getName());
			transactionContext.setResponseCode(isX.getResponseCode() + "");
			resp.sendError(isX.getResponseCode(), msg );
        }
		catch(SecurityCredentialsExpiredException sceX)
		{
			String msg = "SecurityCredentials expired: " + sceX.getMessage();
			// logging of error already done
			// just need to set appropriate error code
			transactionContext.setResponseCode(HttpServletResponse.SC_PRECONDITION_FAILED + "");
			transactionContext.setErrorMessage(msg);
			resp.sendError(HttpServletResponse.SC_PRECONDITION_FAILED, msg);
		}
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "Routing token formatting error when sending image content: " + rtfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		}

        getLogger().info("GET handler returned {} bytes for query string: [{}] ", bytesTransferred, req.getQueryString());
	}

	// imageURN=urn:vaimage:1-12623-12623-23[dfn]&imageQuality=100&contentType=image/jpeg,image/tiff,image/bmp,*/*

	@Override
	protected void doHead(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		resp.setHeader("content-length", "0");
		resp.getOutputStream().flush();
		resp.getOutputStream().close();
	}

}
