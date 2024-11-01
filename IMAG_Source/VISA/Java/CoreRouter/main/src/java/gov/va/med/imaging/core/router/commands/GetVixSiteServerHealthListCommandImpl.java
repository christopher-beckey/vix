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
package gov.va.med.imaging.core.router.commands;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.exchange.business.Region;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.health.VixServerHealthHelper;
import gov.va.med.imaging.health.VixServerHealthSource;
import gov.va.med.imaging.health.VixSiteServerHealth;

/**
 * Command to retrieve the health of all VIX sites known to the site service and any locally configured VIX servers.
 * 
 * @author vhaiswwerfej
 *
 */
public class GetVixSiteServerHealthListCommandImpl 
extends AbstractCommandImpl<List<VixSiteServerHealth>>
{
	private static final long serialVersionUID = 7631699210443336314L;
	private static final Logger logger = Logger.getLogger(GetVixSiteServerHealthListCommandImpl.class);
	
	private final Boolean forceRefresh;
	private final VixServerHealthSource [] vixServerHealthSources;
	
	public GetVixSiteServerHealthListCommandImpl(Boolean forceRefresh, VixServerHealthSource [] vixServerHealthSources)
	{
		this.forceRefresh = forceRefresh;
		this.vixServerHealthSources = vixServerHealthSources;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	/**
	 * @return the forceRefresh
	 */
	public Boolean getForceRefresh() {
		return forceRefresh;
	}

	@Override
	public List<VixSiteServerHealth> callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException 
	{
        logger.info("GetVixSiteServerHealthListCommandImpl.callSynchronouslyInTransactionContext() --> Retrieving VIX Server health for all VIX sites with forceRefresh [{}]", this.forceRefresh);
		
		return VixServerHealthHelper.getVixServerHealthHelper().getSitesServerHealth(getAllVIXSites(), getForceRefresh(), getVixServerHealthSources());
	}
	
	private List<Site> getAllVIXSites()
	throws MethodException, MethodConnectionException
	{
		List<Region> regions = null;
        try
        {
        	regions = getCommandContext().getSiteResolver().getAllRegions();
        } 
        catch (MethodException me)
        {
        	String msg = "GetVixSiteServerHealthListCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to resolve all regions: " + me.getMessage();
        	logger.error(msg);
        	throw new MethodException(msg, me);
        } 
        catch (ConnectionException ce)
        {
        	String msg = "GetVixSiteServerHealthListCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source: " + ce.getMessage();
        	logger.error(msg);
        	throw new MethodConnectionException(msg, ce);
        }
        List<Site> vixSites = new ArrayList<Site>();
        VixServerHealthHelper helper = VixServerHealthHelper.getVixServerHealthHelper();
        List<String> excludedSites = helper.getExcludedSiteNumbers();
        for(Region region : regions)
        {
        	for(Site site : region.getSites())
        	{
        		if(!ExchangeUtil.isSiteDOD(site))
        		{
        			if(site.hasAcceleratorServer())
    				{
        				boolean excludeSite = false;
        				for(String siteNumber : excludedSites)
        				{
        					if(siteNumber.equals(site.getSiteNumber()))
        					{
        						excludeSite = true;
        					}
        				}
        				if(!excludeSite)
        					vixSites.add(site);
    				}
        		}
        	}
        }
        // add to the list of sites the local Vix Servers        
        vixSites.addAll(helper.getEnabledLocalVixSites());        
		return vixSites;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj) 
	{
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString() 
	{
		return this.forceRefresh.toString();
	}

	public VixServerHealthSource[] getVixServerHealthSources()
	{
		return vixServerHealthSources;
	}
}
