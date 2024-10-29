/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 20, 2010
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
package gov.va.med.imaging.vixserverhealth.taglib;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.taglib.exceptions.MissingRequiredArgumentException;
import gov.va.med.imaging.health.VixServerHealthSource;
import gov.va.med.imaging.health.VixSiteServerHealth;
import gov.va.med.imaging.vixserverhealth.VixServerHealthRouter;
import gov.va.med.imaging.vixserverhealth.web.VixServerHealthView;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import javax.servlet.jsp.JspException;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class VixServerHealthViewCollectionTag 
extends AbstractVixServerHealthViewCollectionTag 
{
	private static final long serialVersionUID = 1L;	

	private Logger logger = Logger.getLogger(this.getClass());
	
	private Boolean forceRefresh = null;

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vixserverhealth.taglib.AbstractVixServerHealthViewCollectionTag#getSiteHealths()
	 */
	/**
	 * @return the forceRefresh
	 */
	public Boolean getForceRefresh() {
		return forceRefresh;
	}

	/**
	 * @param forceRefresh the forceRefresh to set
	 */
	public void setForceRefresh(Boolean forceRefresh) {
		this.forceRefresh = forceRefresh;
	}

	@Override
	protected Collection<VixServerHealthView> getSiteHealths()
	throws JspException, MissingRequiredArgumentException 
	{
		try 
    	{
			VixServerHealthRouter router;
    		try
    		{
    			router = FacadeRouterUtility.getFacadeRouter(VixServerHealthRouter.class);
    		} 
    		catch (Exception x)
    		{
    			logger.error("Exception getting the facade router implementation.", x);
    			throw new JspException(x);
    		}
    		
    		boolean force = false;
    		if(getForceRefresh() != null)
    			force = getForceRefresh();
    		
    		List<VixSiteServerHealth> sites = router.getVixSiteServerHealthList(force, VixServerHealthSource.values());
    		List<VixServerHealthView> views = new ArrayList<VixServerHealthView>(sites.size());
    		for(VixSiteServerHealth health : sites)
    		{
    			views.add(new VixServerHealthView(health));
    		}
    		Collections.sort(views); // sort by site name
    		return views;
    	}
    	catch(MethodException mX)
    	{
    		logger.error(mX);
    		throw new JspException(mX);
    	}
    	catch(ConnectionException mX)
    	{
    		logger.error(mX);
    		throw new JspException(mX);
    	}
	}

}
