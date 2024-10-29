/**
 * 
 */
package gov.va.med.imaging.core.router.commands;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.exchange.business.SiteConnection;

/**
 * @author vhaiswbeckec
 *
 */
public class PostProtocolCommandImpl 
extends AbstractCommandImpl<Boolean> 
{
	private static final long serialVersionUID = 5279615772387888601L;
	private static final Logger logger = Logger.getLogger(PostProtocolCommandImpl.class);
	
	private String regionId;
	private String regionName;
	private String siteId;
	private String siteName;
	private SiteConnection siteConnection;

	/**
	 *
	 * @param String				region name
	 * @param String				region Id
	 * @param String				site name
	 * @param String				site Id
	 * @param SiteConnection		site connection
	 * 
	 */
	public PostProtocolCommandImpl(String regionName, String regionId, String siteName, String siteId, SiteConnection siteConnection)
	{
		super();
		
		this.regionId = regionId;
		this.regionName = regionName;
		this.siteId = siteId;
		this.siteName = siteName;
		this.siteConnection = siteConnection;
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
        	isSaved = getCommandContext().getSiteResolver().addProtocol(regionName, regionId, siteName, siteId, siteConnection);
        } 
        catch (MethodException me)
        {
        	String msg = "PostProtocolCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to add region [" + this.regionName + "]: " + me.getMessage();
        	logger.error(msg);
        	throw new MethodException(msg, me);
        } 
        catch (ConnectionException ce)
        {
        	String msg = "PostProtocolCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source for region [" + this.regionName + "]: " + ce.getMessage();
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
		sb.append(" - Site Id:");
		sb.append(this.siteId);
		sb.append(" - Site name:");
		sb.append(this.siteName);
		sb.append(" - New protocol:");
		sb.append(siteConnection.getProtocol());

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
