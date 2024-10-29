/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Sept 14, 2016
 * Developer: Budy Tjahjo
 */
package gov.va.med.imaging.data.web;

import gov.va.med.URNFactory;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.data.ImagingDataContext;
import gov.va.med.imaging.data.ImagingDataRouter;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.tomcat.vistarealm.VistaRealmPrincipal.AuthenticationCredentialsType;
import gov.va.med.imaging.tomcat.vistarealm.VistaRealmSecurityContext;
import gov.va.med.imaging.transactioncontext.ClientPrincipal;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

/**
 * @author Budy Tjahjo
 * 
 * Sample of Invoking the servlet
 * http://localhost:8080/ImagingDisplayWebApp/image/devfields?studyUrn=urn:vastudy:050-5391-7&siteNumber=050&accessCode=boating3&verifyCode=boating3..
 */
public class ImageDevFieldsServlet
extends HttpServlet
{
	private static final long serialVersionUID = -4069787811096261240L;
	private final static Logger logger = Logger.getLogger(ImageDevFieldsServlet.class);

	/* (non-Javadoc)
	 * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		try
		{	
			String accessCode = request.getParameter("accessCode");
			String verifyCode = request.getParameter("verifyCode");
			String siteNumber = request.getParameter("siteNumber");
			String studyUrn = request.getParameter("studyUrn");

            logger.info("Retrieving Image System Global Node [{}]", studyUrn);
			
			TransactionContext transactionContext = TransactionContextFactory.get(); 
			
			if (!accessCode.equals("") && !verifyCode.equals("") && !siteNumber.equals("")) {
				ClientPrincipal principal = new ClientPrincipal(
					siteNumber, true,AuthenticationCredentialsType.Password, 
					accessCode, verifyCode,
					null, null, null, null, null,
					new ArrayList<String>(),
					new HashMap<String, Object>()
				);
				principal.setAuthenticatedByVista(true); // if all works this will be true
				VistaRealmSecurityContext.set(principal);
				TransactionContextFactory.createClientTransactionContext(principal);
				transactionContext.setBrokerSecurityApplicationName("VISTA IMAGING VIX");
				transactionContext.setAccessCode(accessCode);
				transactionContext.setVerifyCode(verifyCode);
				transactionContext.setSiteNumber(siteNumber);
			}
			
			transactionContext.setUrn(studyUrn);
			transactionContext.setRequestType("Imaging Data Web App V1 getImagingSystemGlobalNode");
			
			AbstractImagingURN urn = URNFactory.create(studyUrn, AbstractImagingURN.class);
			
			ImagingDataRouter router = ImagingDataContext.getRouter();
			String result = router.getImageDevFields(urn,"");
			
			response.setStatus(HttpServletResponse.SC_OK);
			response.setContentType("text/xml");
			PrintWriter writer = response.getWriter();
			writer.write("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>");
			writer.write("<getImageDevFields-response>");
			//writer.write("<status>SUCCESS</status>");
			writer.write("<message>");
			writer.write(result);
			writer.write("</message>");
			writer.write("</getImageDevFields-response>");
		}
		catch(URNFormatException urnfX)
		{
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, urnfX.getMessage());
		} 
		catch(ImageNotFoundException infX)
		{
			response.sendError(HttpServletResponse.SC_NOT_FOUND, infX.getMessage());
		}
		catch (MethodException mX)
		{
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, mX.getMessage());
		} 
		catch (ConnectionException cX)
		{
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, cX.getMessage());
		}
		finally
		{
		}
	}

}
