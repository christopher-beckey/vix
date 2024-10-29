/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Apr 17, 2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */
package gov.va.med.imaging.wado;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import gov.va.med.GlobalArtifactIdentifierFactory;
import gov.va.med.OctetSequenceEscaping;
import gov.va.med.imaging.channels.AbstractBytePump.TRANSFER_TYPE;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.exchange.business.documents.DocumentRetrieveResult;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author VHAISWBECKEC
 *
 */
public class DocumentServlet 
extends AbstractBaseImageServlet
{
	private static final long serialVersionUID = 1L;
	private static final Logger LOGGER = Logger.getLogger(DocumentServlet.class);

	/**
	 * 
	 */
	public DocumentServlet()
	{
	}

	/**
	 * The request URL must specify the document identifiers in the form:
	 * <home community ID>/<repository ID>/<document ID>
	 * 
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@SuppressWarnings("deprecation")
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
	throws ServletException, IOException
	{ 
		String pathInfo = req.getPathInfo();		// includes the URL after the servlet and before the query string
		
		if(pathInfo == null || pathInfo.isEmpty())
		{
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "The path info must be included in the path of the URL.");
			return;
		}
			
		String [] documentIdentifiers = pathInfo.substring(1).split("/");  // get rid of the leading forward slash
		
		if(documentIdentifiers == null || documentIdentifiers.length < 3)
		{
			resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "The document Ids were not specified in the URL and must be.");
			return;
		}
		
		OctetSequenceEscaping rfc2141EscapeEngine = OctetSequenceEscaping.createRFC2141EscapeEngine();

		String homeCommunityId = rfc2141EscapeEngine.unescapeIllegalCharacters(documentIdentifiers[0]); 
		String repositoryId = rfc2141EscapeEngine.unescapeIllegalCharacters(documentIdentifiers[1]); 
		String documentId = rfc2141EscapeEngine.unescapeIllegalCharacters(documentIdentifiers[2]);

        LOGGER.info("DocumentServlet.doGet() --> Getting document Id [{}:{}:{}]", homeCommunityId, repositoryId, documentId);
		DocumentRetrieveResult drr = null;
		
		try
        {
			drr = retrieveDocument(GlobalArtifactIdentifierFactory.create(homeCommunityId, repositoryId, documentId));
			
			ByteStreamPump pump = ByteStreamPump.getByteStreamPump(TRANSFER_TYPE.NetworkToNetwork);
			resp.setContentType( drr.getDocumentStream().getImageFormat().getMime() );
			pump.xfer( drr.getDocumentStream(), resp.getOutputStream() );
        } 
		catch (ImageServletException isX)
        {
			String msg = "DocumentServlet.doGet() --> Encountered [ImageServletException]: " + isX.getMessage();
			LOGGER.error(msg);
			resp.sendError(isX.getResponseCode(), msg);
        }
		catch(Exception ex)
		{
			String msg = "DocumentServlet.doGet() --> Encountered exception [" + ex.getClass().getSimpleName() + "]: " + ex.getMessage();
			LOGGER.error(msg);
			resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg);
		}
		finally
		{
        	// Fortify change: check for null first
        	// OLD: try{drr.getDocumentStream().close();}catch(Throwable t){}
        	try{ if(drr != null && drr.getDocumentStream() != null) {drr.getDocumentStream().close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
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
