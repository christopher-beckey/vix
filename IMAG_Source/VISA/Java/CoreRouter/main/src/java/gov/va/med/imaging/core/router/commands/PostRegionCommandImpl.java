/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;

/**
 * @author vhaiswbeckec
 *
 */
public class PostRegionCommandImpl 
extends AbstractCommandImpl<Boolean> 
{
	private static final long serialVersionUID = 5279615772387888601L;
	private static final Logger logger = Logger.getLogger(PostRegionCommandImpl.class);
	
	private String regionId;
	private String regionName;

	/**
	 * @param String		region name
	 * @param String		region Id
	 * 
	 */
	public PostRegionCommandImpl(String regionName, String regionId)
	{
		super();
		
		this.regionName = regionName;
		this.regionId = regionId;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Boolean callSynchronouslyInTransactionContext()
			throws MethodException, ConnectionException
	{
		Boolean isSaved = null;
		
        try
        {
        	isSaved = getCommandContext().getSiteResolver().addRegion(regionName, regionId);
        } 
        catch (MethodException me)
        {
        	String msg = "PostRegionCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to add region [" + regionName + "]: " + me.getMessage();
        	logger.error(msg);
        	throw new MethodException(msg, me);
        } 
        catch (ConnectionException ce)
        {
        	String msg = "PostRegionCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source for region [" + this.regionName + "]: " + ce.getMessage();
        	logger.error(msg);
        	throw new ConnectionException(msg, ce);
        }    
        return isSaved;
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
		StringBuilder sb = new StringBuilder();
		
		sb.append("Region Id:");
		sb.append(this.regionId);
		sb.append(" - Region name:");
		sb.append(this.regionName);

		return sb.toString();
		
		//return getRegionId() + " - " + getRegionName();
	}

	public String getRegionId()
	{
		return regionId;
	}
	
	public String getRegionName()
	{
		return regionName;
	}
}