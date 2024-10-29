package gov.va.med.imaging.core.router.commands;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;

public class DeleteRegionCommandImpl 
extends AbstractCommandImpl<Boolean>{

	private static final long serialVersionUID = 5706559492468815752L;
	private static final Logger logger = Logger.getLogger(DeleteRegionCommandImpl.class);
	
	private String regionId;
	
	/**
	 * @param String		region Id
	 */
	public DeleteRegionCommandImpl(String regionId)
	{
		super();
		this.regionId = regionId;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Boolean callSynchronouslyInTransactionContext()
			throws MethodException, ConnectionException
	{
		Boolean isDeleted = null;
        try
        {
        	isDeleted = getCommandContext().getSiteResolver().deleteRegion(regionId);
        } 
        catch (MethodException me)
        {
        	String msg = "DeleteRegionCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to delete region Id [" + regionId + "]: " + me.getMessage();
        	logger.error(msg);
        	throw new MethodException(msg, me);
        } 
        catch (ConnectionException ce)
        {
        	String msg = "DeleteRegionCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source for region Id [" + regionId + "]: " + ce.getMessage();
        	logger.error(msg);
        	throw new ConnectionException(msg, ce);
        }
		return isDeleted;
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
		return this.regionId;
	}

	public String getRegionId() {
		return this.regionId;
	}
}
