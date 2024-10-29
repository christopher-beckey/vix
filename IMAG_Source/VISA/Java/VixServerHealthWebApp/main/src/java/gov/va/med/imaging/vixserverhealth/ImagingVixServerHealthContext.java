/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 3, 2009
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
package gov.va.med.imaging.vixserverhealth;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class ImagingVixServerHealthContext 
{
	private final static Logger logger = Logger.getLogger(ImagingVixServerHealthContext.class);
	
	public static VixServerHealthRouter getRouter() 
	{
		VixServerHealthRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(VixServerHealthRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "Error getting FederationRouter instance.  Application deployment is probably incorrect.";			 
			TransactionContextFactory.get().setErrorMessage(msg + "\n" + x.getMessage());
			logger.error(msg, x);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_CONFLICT + "");
		}
		return router;
	} 
}
