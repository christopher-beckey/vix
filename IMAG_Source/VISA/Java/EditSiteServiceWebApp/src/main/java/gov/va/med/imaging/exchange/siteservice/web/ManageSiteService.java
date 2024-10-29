package gov.va.med.imaging.exchange.siteservice.web;

import java.io.IOException;
import java.net.MalformedURLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteImpl;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.exchange.siteservice.SiteServiceFacadeRouter;

public class ManageSiteService extends HttpServlet {

	private static final long serialVersionUID = 5592472303405052952L;
	private static final Logger LOGGER = Logger.getLogger(ManageSiteService.class);

	enum SITE_OPS {
		ADD_SITE, DELETE_SITE, UPDATE_SITE
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

		String retMsg = "ManageSiteService.doPost() --> ";  // 31 chars;
		String regionName = req.getParameter("regionName").trim();
		String regionId = req.getParameter("regionNumber").trim();
		String siteName = req.getParameter("siteName").trim();
		String siteId = req.getParameter("siteNumber").trim();

		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();

		if (req.getParameter("Ops").equals(SITE_OPS.ADD_SITE.toString())) {

			try {
				opStatus = router.addSite(regionName, regionId, translateJSONToSiteObject(req));
				retMsg += "Successfully added site Id [" + siteId + "]";
			} catch (MethodException e) {
				retMsg += "MethodException: conflict while adding site Id [" + siteId + "]: " + e.getMessage();
				LOGGER.warn(retMsg);
			} catch (ConnectionException e) {
				retMsg += "ConnectionException: conflict while adding site Id [" + siteId + "]: " + e.getMessage();
				LOGGER.error(retMsg);
				throw new IOException(retMsg, e);
			} catch (MalformedURLException e) {
				retMsg += "MalformedURLException: while adding site Id [" + siteId + "]: " + e.getMessage();
				LOGGER.warn(retMsg);
			}
		} 
		else if (req.getParameter("Ops").equals(SITE_OPS.UPDATE_SITE.toString())) 
		{
			String prevSiteName = req.getParameter("prevSiteName").trim();
			String prevSiteNumber = req.getParameter("prevSiteNumber").trim();

			try {
				opStatus = router.updateSite(regionName, regionId, prevSiteName, prevSiteNumber, translateJSONToSiteObject(req));
				retMsg += "Successfully updated region [" + regionName + "]";
			} catch (MethodException e) {
				retMsg += "MethodException: conflict while updating region [" + regionName + "]: " + e.getMessage();
				LOGGER.warn(retMsg);
			} catch (ConnectionException e) {
				retMsg += "ConnectionException: conflict while updating region [" + regionName + "]: " + e.getMessage();
				LOGGER.error(retMsg);
				throw new IOException(retMsg, e);
			}
		} 
		else if (req.getParameter("Ops").equals(SITE_OPS.DELETE_SITE.toString())) {
			try {
				opStatus = router.deleteSite(regionId, regionName, siteId, siteName);
				retMsg += "Successfully deleted region Id [" + regionId + "]";
			} catch (MethodException e) {
				retMsg += "MethodException: while deleting regiond Id [" + regionId + "]: " + e.getMessage();
				LOGGER.error(retMsg);
				throw new ServletException(retMsg, e);
			} catch (ConnectionException e) {
				retMsg += "ConnectionException: while deleting region Id [" + regionId + "]: " + e.getMessage();
				LOGGER.error(retMsg);
				throw new IOException(retMsg, e);
			}

			JSONObject result = new JSONObject();
			try {
				result.put("status", opStatus);
				result.put("conflict_message", (retMsg.length() == 31 ? retMsg += "No operation was specified." : retMsg));
			} catch (JSONException e) {
				// Do nothing
			}
			res.setContentType("application/json");
			res.setCharacterEncoding("UTF-8");
			res.getWriter().write(result.toString());
		}
	}

	private Site translateJSONToSiteObject(HttpServletRequest request) throws MalformedURLException {
		
		String regionId = request.getParameter("regionNumber").trim();
		String siteName = request.getParameter("siteName").trim();
		String siteId = request.getParameter("siteNumber").trim();
		String siteAbbr = request.getParameter("siteAbbr").trim();
		String sitePatientLookupable = request.getParameter("sitePatientLookupable").trim();
		String siteUserAuthenticatable = request.getParameter("siteUserAuthenticatable").trim();

		return new SiteImpl(regionId, siteId, siteName, siteAbbr, Boolean.parseBoolean(sitePatientLookupable),
					Boolean.parseBoolean(siteUserAuthenticatable), null, SiteImpl.createDefaultSiteURLs(siteId, "", 100, "", 100));
	}
}