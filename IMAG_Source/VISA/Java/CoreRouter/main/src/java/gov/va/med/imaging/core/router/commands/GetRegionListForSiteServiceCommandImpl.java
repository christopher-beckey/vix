/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.exchange.business.Region;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswbeckec
 *
 */
public class GetRegionListForSiteServiceCommandImpl 
extends AbstractCommandImpl<List<Region>> 
{
	private static final long serialVersionUID = -1641953235756357554L;
	private static final Logger logger = Logger.getLogger(GetRegionListForSiteServiceCommandImpl.class);

	/**
	 * @param commandContext
	 */
	public GetRegionListForSiteServiceCommandImpl()
	{
		super();
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public List<Region> callSynchronouslyInTransactionContext()
			throws MethodException, ConnectionException
	{
		List<Region> regions = null;
        try
        {
        	regions = getCommandContext().getSiteResolver().getAllRegionsForSiteService();
        } 
        catch (MethodException me)
        {
        	String msg = "GetRegionListForSiteServiceCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to resolve all regions: " + me.getMessage();
        	logger.error(msg);
        	throw new MethodException(msg, me);
        } 
        catch (ConnectionException ce)
        {
        	String msg = "GetRegionListForSiteServiceCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source: " + ce.getMessage();
        	logger.error(msg);
        	throw new ConnectionException(msg, ce);
        }
		return regions;
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		return "No params";
	}
}
