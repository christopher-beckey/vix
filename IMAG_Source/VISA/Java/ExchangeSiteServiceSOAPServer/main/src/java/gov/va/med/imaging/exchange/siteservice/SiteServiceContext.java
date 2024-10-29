/**
 * 
 */
package gov.va.med.imaging.exchange.siteservice;

import gov.va.med.imaging.core.FacadeRouterUtility;

/**
 * @author vhaiswbeckec
 *
 */
public class SiteServiceContext
{
	private static SiteServiceFacadeRouter router = null;
	public static SiteServiceFacadeRouter getSiteServiceFacadeRouter()
	{
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(SiteServiceFacadeRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "Error getting SiteServiceFacadeRouter instance.  Application deployment is probably incorrect.";			 
		}
		return router;
	}	
	

}
