package gov.va.med.imaging.core.router.commands;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;

public class PutRegionCommandImpl 
extends AbstractCommandImpl<Boolean> {
	private static final long serialVersionUID = 5279615772387888601L;
	private static final Logger logger = Logger.getLogger(PutRegionCommandImpl.class);
	
	private String newRegionId;
	private String newRegionName;
	private String oldRegionId;
	private String oldRegionName;

	/**
	 *
	 * @param String		old region name
	 * @param String		old region Id
	 * @param String		new region name
	 * @param String		new region Id
	 * 
	 */
	public PutRegionCommandImpl(String oldRegionName, String oldRegionId, String newRegionName, String newRegionId)
	{
		super();
		
		this.newRegionId = newRegionId;
		this.newRegionName = newRegionName;
		this.oldRegionId = oldRegionId;
		this.oldRegionName = oldRegionName;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Boolean callSynchronouslyInTransactionContext()
			throws MethodException, ConnectionException
	{
		Boolean isUpdated = null;
		
        try
        {
        	isUpdated = getCommandContext().getSiteResolver().updateRegion(oldRegionName, oldRegionId, newRegionName, newRegionId);
        } 
        catch (MethodException me)
        {
        	String msg = "PutRegionCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to update to new region name [" + this.newRegionName + "]: " + me.getMessage();
        	logger.error(msg);
        	throw new MethodException(msg, me);
        } 
        catch (ConnectionException ce)
        {
        	String msg = "PutRegionCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source for new region name [" + this.newRegionName + "]: " + ce.getMessage();
        	logger.error(msg);
        	throw new ConnectionException(msg, ce);
        }
		return isUpdated;
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
		
		sb.append("New region Id:");
		sb.append(getNewRegionId());
		sb.append(" - New region name:");
		sb.append(getNewRegionName());
		sb.append("Old region Id:");
		sb.append(getOldRegionId());
		sb.append(" - Old region name:");
		sb.append(getOldRegionName());

		return sb.toString();
		
		//return getNewRegionId() + "-" + getNewRegionName() + "-" + getOldRegionId() + "-" + getOldRegionName();
	}

	public String getNewRegionId() {
		return newRegionId;
	}

	public String getNewRegionName() {
		return newRegionName;
	}

	public String getOldRegionId() {
		return oldRegionId;
	}

	public String getOldRegionName() {
		return oldRegionName;
	}
}
