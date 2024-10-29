package gov.va.med.imaging.exchange.siteservice.web;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;

import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.exchange.siteservice.SiteServiceFacadeRouter;

public class ManageProtocolService extends HttpServlet {

	private static final long serialVersionUID = 5592472303405052952L;
	private static final Logger LOGGER = Logger.getLogger(ManageProtocolService.class);

	enum PROCOTOL_OPS {
		ADD_PROTOCOL, UPDATE_PROTOCOL, DELETE_PROTOCOL, TEST_PROTOCOL
	}
	
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

		if(req == null) {
			
			JSONObject result = new JSONObject();
			res.setContentType("application/json");
			res.setCharacterEncoding("UTF-8");
			
			try {
				result.put("status", false);
				result.put("conflictMessage", "ManageProtocolService.doPost() --> Given request object is null.");
			} catch (JSONException e) {
				// Do nothing
			}

			res.getWriter().write(result.toString());
			return;  // QN: Is this necessary to prevent going further???
		}
		
		Boolean opStatus = false;
		
		String retMsg = "ManageProtocolService.doPost() --> ";  // 35 chars
		String regionName = req.getParameter("regionName").trim();
		String regionId = req.getParameter("regionNumber").trim();
		String siteName = req.getParameter("siteName").trim();
		String siteId = req.getParameter("siteNumber").trim();

		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();

		if (req.getParameter("Ops").equals(PROCOTOL_OPS.ADD_PROTOCOL.toString())) {
			
			try {
				opStatus = router.addProtocol(regionName, regionId, siteName, siteId, translateJSONToProtocolObject(req));
				retMsg += "Successfully added protocol for site Id [" + siteId + "]";
			} catch (MethodException e) {
				retMsg += "MethodException: conflict while adding protocol: " + e.getMessage();
				LOGGER.warn(retMsg);
			} catch (ConnectionException e) {
				retMsg += "ConnectionException: conflict while adding protocol: " + e.getMessage();
				LOGGER.error(retMsg);
				throw new IOException(retMsg, e);
			}
			
		} else if (req.getParameter("Ops").equals(PROCOTOL_OPS.UPDATE_PROTOCOL.toString())) {

			String prevProtocolName = req.getParameter("prevProtocol").trim();
			Integer prevPort  = Integer.parseInt(req.getParameter("prevPort"));
			
			try {
				opStatus = router.updateProtocol(regionName, regionId, siteName, siteId, prevProtocolName, prevPort, translateJSONToProtocolObject(req));
				retMsg += "Successfully updated previous protocol [" + prevProtocolName + "]";
			} catch (MethodException e) {
				retMsg += "MethodException: conflict while updating the protocol [" + prevProtocolName + "]: " + e.getMessage();
				LOGGER.warn(retMsg);
			} catch (ConnectionException e) {
				retMsg += "ConnectionException: conflict while updating the protocol [" + prevProtocolName + "]: " + e.getMessage();
				LOGGER.error(retMsg);
				throw new IOException(retMsg, e);
			}
			
		} else if (req.getParameter("Ops").equals(PROCOTOL_OPS.DELETE_PROTOCOL.toString())) {

			String protocolName = req.getParameter("protocolName").trim();
			
			try{
				opStatus = router.deleteProtocol(regionName, regionId, siteName, siteId, protocolName);
				retMsg += "Successfully deleted protocol [" + protocolName + "]";
			} catch (MethodException e) {
				retMsg += "MethodException: while deleting protocol [" + protocolName + "]: " + e.getMessage();
				LOGGER.error(retMsg);
				throw new ServletException(retMsg, e);
			} catch (ConnectionException e) {
				retMsg += "ConnectionException: while deleting protocol [" + protocolName + "]: " + e.getMessage();
				LOGGER.error(retMsg);
				throw new IOException(retMsg, e);
			}

		} else if (req.getParameter("Ops").equals(PROCOTOL_OPS.TEST_PROTOCOL.toString())) {
			
			//Boolean isSuccess = false;
			String protocol = req.getParameter("protocol").trim();
			String server = req.getParameter("server").trim();
			int port = Integer.parseInt(req.getParameter("port"));
			
			// Fortify change: b/c of the if-else, a bit messy to use try-with-resources. Added finally block instead
			SSLSocket sslSocket = null;
			Socket socket = null;
			
			try {
				if(protocol.equalsIgnoreCase("wss")) {
					SSLSocketFactory factory =
							(SSLSocketFactory) SSLSocketFactory.getDefault();
					sslSocket =	(SSLSocket) factory.createSocket();
					sslSocket.connect(new InetSocketAddress(server, port), 30000);
				}
				else {
					socket = new Socket();
					socket.connect(new InetSocketAddress(server, port), 30000);
					socket.close();
				}
				
				opStatus = true;
				retMsg += "Successfully tested protocol [" + protocol + "]";
				
			} catch (Exception ex) {
				retMsg += "Exception: while testing the protocol [" + protocol + "]: " + ex.getMessage();
				LOGGER.warn(retMsg);
				//IO Exception means, the server is not available or not accepting the TCP connections.
			} finally {
	        	// Fortify change: added finally block
	        	try { if(socket != null) { socket.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
	        	try { if(sslSocket != null) { sslSocket.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
			}
		}
		
		JSONObject result = new JSONObject();
		try {
			result.put("status", opStatus);
			result.put("conflict_message", (retMsg.length() == 35 ? retMsg += "No operation was specified." : retMsg));
		} catch (JSONException e) {
			// Do nothing
		}
		
		res.setContentType("application/json");
		res.setCharacterEncoding("UTF-8");
		res.getWriter().write(result.toString());
	}

	private SiteConnection translateJSONToProtocolObject(HttpServletRequest request) {
		
		String protocol = request.getParameter("protocol").trim();
		String server = request.getParameter("server").trim();
		String modality = request.getParameter("modality").trim();
		int port = Integer.parseInt(request.getParameter("port"));

		return new SiteConnection(protocol, server, port, modality);
	}
}