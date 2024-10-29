/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 25, 2013
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.visa;

import gov.va.med.imaging.core.FacadeRouterUtility;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class VisaWebContext
{
	private final static Logger LOGGER = Logger.getLogger(VisaWebContext.class);
	
	public static VisaWebRouter getRouter() 
	{
		VisaWebRouter router = null;
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(VisaWebRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "VisaWebContext.getRouter() --> Error getting FederationRouter instance: " + x.getMessage();			 
			LOGGER.warn(msg);
		}
		return router;
	} 
}
