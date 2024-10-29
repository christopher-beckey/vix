/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web;

import gov.va.med.imaging.core.FacadeRouterUtility;


/**
 * @author Julian
 *
 */
public class ViewerStudyFacadeContext
{

	private static ViewerStudyFacadeRouter router = null;
	public static ViewerStudyFacadeRouter getRouter()
	{
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(ViewerStudyFacadeRouter.class);
		} 
		catch (Exception ex)
		{
			ex.printStackTrace();		
		}
		return router;
	}
}
