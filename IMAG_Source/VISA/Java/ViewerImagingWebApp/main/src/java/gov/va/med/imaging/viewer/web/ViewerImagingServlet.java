/**
 * Date Created: Apr 25, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.web;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.tomcat.vistarealm.VistaRealmSecurityContext;
import gov.va.med.imaging.tomcat.vistarealm.VistaRealmPrincipal.AuthenticationCredentialsType;
import gov.va.med.imaging.transactioncontext.ClientPrincipal;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.viewer.ViewerImagingContext;
import gov.va.med.imaging.viewer.ViewerImagingRouter;
import gov.va.med.imaging.viewer.business.DeleteImageUrn;
import gov.va.med.imaging.viewer.business.DeleteImageUrnResult;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 * 
 * Sample of Invoking the servlet
 * http://localhost:8080/ViewerImagingWebApp/viewerImaging/deleteImage
 * 			?imageUrn={imageUrn}
 * 			&deleteImageFile={deleteImageFile}  //default = 1
 * 			&deleteGroup={deleteGroup}			//default = 0
 * 			&reason={reason}
 */

public class ViewerImagingServlet
extends HttpServlet
{
	private static final long serialVersionUID = -4069787822096261240L;
	private final static Logger logger = Logger.getLogger(ViewerImagingServlet.class);

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
			String imageUrn = request.getParameter("imageUrn");
			String deleteGroup = request.getParameter("deleteGroup");
			String reason = request.getParameter("reason");

            logger.info("Deleting Image [{}] deleteGroup [{}] reason [{}]", imageUrn, deleteGroup, reason);
			
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
			
			transactionContext.setRequestType("Viewer Imaging Web App V1 Delete Images");
			
			ViewerImagingRouter router = ViewerImagingContext.getRouter();
			RoutingToken routingToken = 
					RoutingTokenHelper.createSiteAppropriateRoutingToken(siteNumber);

			List<DeleteImageUrn> imageUrns = new ArrayList<DeleteImageUrn>();
			imageUrns.add(new DeleteImageUrn(imageUrn, deleteGroup == "1" ? true : false, reason));
			
		    List<DeleteImageUrnResult> result = router.deleteImages(routingToken,imageUrns);
			
			response.setStatus(HttpServletResponse.SC_OK);
			response.setContentType("text/xml");
			PrintWriter writer = response.getWriter();
			writer.write("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>");
			writer.write("<deleteImages-response>");
			// Fortify change: can't risk serializing contents actually out
			writer.write("<result>" + result.size() + "</result>");
			writer.write("</deleteImages-response>");
		}
		catch(Exception e)
		{
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
		} 
		finally
		{
		}
	}

}
