package gov.va.med.imaging.exchange.siteservice.web;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.siteservice.SiteServiceContext;
import gov.va.med.imaging.exchange.siteservice.SiteServiceFacadeRouter;

public class ManageRegionService extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	private static final Logger LOGGER = Logger.getLogger(ManageRegionService.class);

	enum REGION_OPS {
		ADD_REGION, DELETE_REGION, UPDATE_REGION
	}

	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		
		if(req == null) {
			
			JSONObject result = new JSONObject();
			res.setContentType("application/json");
			res.setCharacterEncoding("UTF-8");
			
			try {
				result.put("status", false);
				result.put("conflictMessage", "ManageRegionService.doPost() --> Given request object is null.");
			} catch (JSONException e) {
				// Do nothing
			}

			res.getWriter().write(result.toString());
			return;  // QN: Is this necessary to prevent going further???
		}
		
		String retMsg = "ManageRegionService.doPost() --> ";  // 33 chars
		SiteServiceFacadeRouter router = SiteServiceContext.getSiteServiceFacadeRouter();

		Boolean opStatus = false;
		String regionId = req.getParameter("regionNumber").trim();

		if (req.getParameter("Ops").equals(REGION_OPS.ADD_REGION.toString())) 
		{
			String regionName = req.getParameter("regionName").trim();

			try {
				opStatus = router.addRegion(regionName, regionId);
				retMsg += "Successfully added region [" + regionName + "]";
			} catch (MethodException e) {
				retMsg += "MethodException: conflict while adding the region [" + regionName + "]: " + e.getMessage();
				LOGGER.warn(retMsg);
			} catch (ConnectionException e) {
				retMsg += "ConnectionException: conflict while adding the region [" + regionName + "]: " + e.getMessage();
				LOGGER.error(retMsg);
				throw new IOException(retMsg, e);
			}
			
		} 
		else if (req.getParameter("Ops").equals(REGION_OPS.UPDATE_REGION.toString())) 
		{
			String prevRegionName = req.getParameter("prevRegionName").trim();
			String prevRegionId = req.getParameter("prevRegionNumber").trim();
			String newRegionName = req.getParameter("regionName").trim(); 
			String newRegionId = req.getParameter("regionNumber").trim();
			
			try {
				opStatus = router.updateRegion(prevRegionName, prevRegionId, newRegionName, newRegionId);
				retMsg += "Successfully updated old region [" + prevRegionName + "] to new region [" + newRegionName + "]";
			} catch (MethodException e) {
				retMsg += "MethodException: conflict while updating the previous region [" + prevRegionName + "]: " + e.getMessage();
				LOGGER.warn(retMsg);
			} catch (ConnectionException e) {
				retMsg += "ConnectionException: conflict while updating the region [" + prevRegionName + "]: " + e.getMessage();
				LOGGER.error(retMsg);
				throw new IOException(retMsg, e);
			}
			
		} 
		else if (req.getParameter("Ops").equals(REGION_OPS.DELETE_REGION.toString())) 
		{
			try{
				opStatus = router.deleteRegion(regionId);
				retMsg += "Successfully deleted region Id [" + regionId + "]";
			} catch (MethodException e) {
				retMsg += "MethodException: while deleting region Id [" + regionId + "]: " + e.getMessage();
				LOGGER.error(retMsg);
				throw new ServletException(retMsg, e);
			} catch (ConnectionException e) {
				retMsg += "ConnectionException: while deleting region Id [" + regionId + "]: " + e.getMessage();
				LOGGER.error(retMsg);
				throw new IOException(retMsg, e);
			}
		}
		
		JSONObject result = new JSONObject();
		try {
			result.put("status", opStatus);
			result.put("conflict_message", (retMsg.length() == 33 ? retMsg += "No operation was specified." : retMsg));
		} catch (JSONException e) {
			// Do nothing
		}
		res.setContentType("application/json");
		res.setCharacterEncoding("UTF-8");
		res.getWriter().write(result.toString());
	}
}

