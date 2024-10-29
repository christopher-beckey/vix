/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.exchange.business.Region;

/**
 * @author vhaiswbeckec
 *
 */
public class GetRegionCommandImpl 
extends AbstractCommandImpl<Region> 
{
	private static final long serialVersionUID = 5279615772387888601L;
	private static final Logger logger = Logger.getLogger(GetRegionCommandImpl.class);
	
	private final String regionId;

	/**
	 * @param String			region Id
	 */
	public GetRegionCommandImpl(String regionId)
	{
		super();
		this.regionId = regionId;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Region callSynchronouslyInTransactionContext()
			throws MethodException, ConnectionException
	{
		Region region = null;
        try
        {
        	region = getCommandContext().getSiteResolver().resolveRegion(getRegionId());
        }
        catch (MethodException me)
        {
        	String msg = "GetRegionCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to to resolve region Id [" + this.regionId + "]: " + me.getMessage();
        	logger.error(msg);
        	throw new MethodException(msg, me);
        } 
        catch (ConnectionException ce)
        {
        	String msg = "GetRegionCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source for region Id [" + this.regionId + "]: " + ce.getMessage();
        	logger.error(msg);
        	throw new ConnectionException(msg, ce);
        }
		return region;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		// TODO Auto-generated method stub
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		return "Region Id: " + this.regionId;
	}

	public String getRegionId()
	{
		return this.regionId;
	}

}
