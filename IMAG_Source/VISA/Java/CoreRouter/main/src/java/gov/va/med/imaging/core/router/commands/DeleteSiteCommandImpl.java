package gov.va.med.imaging.core.router.commands;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;

public class DeleteSiteCommandImpl extends AbstractCommandImpl<Boolean>{
	private static final long serialVersionUID = 5706559492468815752L;
	private static final Logger logger = Logger.getLogger(DeleteSiteCommandImpl.class);
	
	private String regionNumber;
	private String regionName;
	private String siteNumber;
	private String siteName;
	
	/**
	 *
	 * @param String		region number (should be Id)
	 * @param String		region name
	 * @param String		site Id
	 * @param String		site name
	 * 
	 */
	public DeleteSiteCommandImpl(String regionNumber, String regionName, String siteNumber, String siteName)
	{
		super();
		this.regionNumber = regionNumber;
		this.regionName = regionName;
		this.siteNumber = siteNumber;
		this.siteName = siteName;
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
			isDeleted = getCommandContext().getSiteResolver().deleteSite(regionNumber, regionName, siteNumber, siteNumber);
        } 
        catch (MethodException me)
        {
        	String msg = "DeleteSiteCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to delete site Id [" + siteNumber + "]: " + me.getMessage();
        	logger.error(msg);
        	throw new MethodException(msg, me);
        } 
        catch (ConnectionException ce)
        {
        	String msg = "DeleteSiteCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source for site Id [" + siteNumber + "]: " + ce.getMessage();
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
		
		sb.append("Region number:");
		sb.append(this.regionName);
		sb.append(" - Region name:");
		sb.append(this.regionName);
		sb.append("Site number:");
		sb.append(this.siteNumber);
		sb.append(" - Site name:");
		sb.append(this.siteName);

		return sb.toString();

		//return getRegionName() + "-" + getRegionNumber() + "-" + getSiteName() + "-" + getSiteNumber();
	}

	public String getRegionName() {
		return regionName;
	}

	public String getRegionNumber() {
		return regionNumber;
	}

	public String getSiteName() {
		return siteName;
	}

	public String getSiteNumber() {
		return siteNumber;
	}
}
