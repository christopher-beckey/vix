package gov.va.med.imaging.core.router.commands;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;

public class DeleteProtocolCommandImpl extends AbstractCommandImpl<Boolean> {
	private static final long serialVersionUID = 5706559492468815752L;
	private static final Logger logger = Logger.getLogger(AbstractCommandImpl.class);
	
	private String regionName;
	private String regionID;
	private String siteName;
	private String siteId;
	private String protocolName;
	
	/**
	 *
	 * @param String		region name
	 * @param String		region Id
	 * @param String		site name
	 * @param String		site Id
	 * @param String		protocol
	 * 
	 */
	public DeleteProtocolCommandImpl(String regionName, String regionID, String siteName, String siteId,
			String protocol)
	{
		super();
		this.regionName = regionName;
		this.regionID = regionID;
		this.siteName = siteName;
		this.siteId = siteId;
		this.protocolName = protocol;
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
			isDeleted = getCommandContext().getSiteResolver().deleteProtocol(regionName, regionID, siteName, siteId, protocolName);
        } 
        catch (MethodException me)
        {
        	String msg = "DeleteProtocolCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to delete protocol [" + protocolName + "]: " + me.getMessage();
        	logger.error(msg);
        	throw new MethodException(msg, me);
        } 
        catch (ConnectionException ce)
        {
        	String msg = "DeleteProtocolCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source for protocol [" + protocolName + "]: " + ce.getMessage();
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
		StringBuilder sb = new StringBuilder();
		
		sb.append("Region Id:");
		sb.append(this.regionID);
		sb.append(" - Region name:");
		sb.append(this.regionName);
		sb.append(" - Site Id:");
		sb.append(this.siteId);
		sb.append(" - Site name:");
		sb.append(this.siteName);

		return sb.toString();

		//return getRegionName() + "-" + getRegionID() + "-" + getSiteName() + "-" + getSiteId();
	}

	public String getRegionName() {
		return regionName;
	}

	public String getRegionID() {
		return regionID;
	}

	public String getSiteName() {
		return siteName;
	}

	public String getSiteId() {
		return siteId;
	}

	public String getProtocolName() {
		return protocolName;
	}
}
