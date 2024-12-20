/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 13, 2010
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
package gov.va.med.imaging.federation.web;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.http.exceptions.HttpHeaderParseException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.query.WadoQuery;
import gov.va.med.imaging.wado.query.WadoRequest;
import gov.va.med.imaging.wado.query.exceptions.WadoQueryComplianceException;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractFederationTextServlet
extends AbstractFederationServlet
{
	private static final long serialVersionUID = 1L;

	/**
	 * Abstract method used to convert the image URN input into the proper format
	 * @param imageUrn
	 * @return
	 * @throws URNFormatException
	 */
	protected abstract ImageURN convertImageUrn(ImageURN imageUrn)
	throws URNFormatException;
	
	@Override
	public Long getImage(ImageURN imageUrn,
			ImageFormatQualityList requestedFormatQuality,
			OutputStream outStream, ImageMetadataNotification metadataCallback)
	throws MethodException, ConnectionException
	{
		return null;
	}

	@Override
	public int getImageTxtFile(ImageURN imageUrn, OutputStream outStream,
			ImageMetadataNotification metadataNotification)
	throws MethodException, ConnectionException
	{
		return getFederationRouter().getTxtFileByImageURN(imageUrn, outStream, 
				metadataNotification);
	}

	@Override
	public int getImageTxtFileAsChild(ImageURN imageUrn,
			OutputStream outStream,
			ImageMetadataNotification metadataNotification)
			throws MethodException, ConnectionException
	{
		return getFederationRouter().getTxtFileByImageURN(imageUrn, outStream, 
				metadataNotification);
	}

	@Override
	protected List<ImageFormat> getAcceptableDiagnosticResponseTypes(
			boolean includeSubTypes)
	{
		return null;
	}

	@Override
	protected List<ImageFormat> getAcceptableReferenceResponseTypes(
			boolean includeSubTypes)
	{
		return null;
	}

	@Override
	protected List<ImageFormat> getAcceptableThumbnailResponseTypes()
	{
		return null;
	}

	@Override
	public Long getDocument(GlobalArtifactIdentifier gai, OutputStream outStream, 
			ImageMetadataNotification imageMetadataNotification)
	throws MethodException, ConnectionException
	{
		return null;
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		// turn off sessions?
		HttpSession session = request.getSession(false);
		if(session != null)
			session.invalidate();
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		WadoRequest wadoRequest = null;
		WadoQuery wadoQuery = null;
		try
		{
			wadoRequest = createParsedWadoRequest(request);
			wadoQuery = wadoRequest.getWadoQuery();			
	
			initTransactionContext(wadoRequest);
			
			// ImageURN is base32 encoded at this point
			ImageURN imageUrn = wadoQuery.getInstanceUrn();
			try
			{	
				// base 32 decode the URN (if necessary)
				imageUrn = convertImageUrn(imageUrn);
			}
			catch(URNFormatException urnfX)
			{
				String msg = "AbstractFederationTextServlet.doGet() --> URNFormatException decoding image URN [" + imageUrn.toString() + "] in request: " +	urnfX.getMessage();
				getLogger().error(msg);
				transactionContext.setErrorMessage(msg);
				transactionContext.setExceptionClassName(urnfX.getClass().getSimpleName());
				transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg);	
				return;				
			}
		
			doGetTxtFile(imageUrn, response);
		}
		catch(HttpHeaderParseException httphpX)
		{
			String msg = "AbstractFederationTextServlet.doGet() --> Error parsing Federation HTTP header information: " + httphpX.getMessage();	
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(httphpX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		}
		catch(WadoQueryComplianceException wqcX)
		{
			String msg = "AbstractFederationTextServlet.doGet() --> Request is not a valid Federation query compliance request: " + wqcX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(wqcX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			response.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg );	
		}
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "AbstractFederationTextServlet.doGet() --> Routing token formatting error when sending image content: " + rtfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		}
	}

	@Override
	public String getUserSiteNumber()
	{
		TransactionContext context = TransactionContextFactory.get();
		return context.getLoggerSiteNumber();
	}
	
	protected abstract WadoRequest createParsedWadoRequest(HttpServletRequest request)
	throws HttpHeaderParseException, WadoQueryComplianceException;

	@Override
	public boolean includeTextFile(GlobalArtifactIdentifier gai)
	{
		return isGaiVA(gai);
	}
}
