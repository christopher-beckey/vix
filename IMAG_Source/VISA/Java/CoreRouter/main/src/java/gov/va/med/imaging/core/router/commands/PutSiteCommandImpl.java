package gov.va.med.imaging.core.router.commands;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.exchange.business.Site;

public class PutSiteCommandImpl 
extends AbstractCommandImpl<Boolean> {
	private static final long serialVersionUID = 5279615772387888601L;
	private static final Logger logger = Logger.getLogger(PutSiteCommandImpl.class);
	
	private String regionName;
	private String regionId;
	private String prevSiteName;
	private String prevSiteNumber;
	private Site siteToSave;

	/**
	 *
	 * @param String		region name
	 * @param String		region Id
	 * @param String		previous site name
	 * @param String		previous site Id (number)
	 * @param String		site to save
	 * 
	 */
	public PutSiteCommandImpl(String regionName, String regionId, String prevSiteName, String prevSiteNumber, Site siteToSave)
	{
		super();
		
		this.regionId = regionId;
		this.regionName = regionName;
		this.prevSiteName = prevSiteName;
		this.prevSiteNumber = prevSiteNumber;
		this.siteToSave = siteToSave;
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
        	isUpdated = getCommandContext().getSiteResolver().updateSite(regionName, regionId, prevSiteName, prevSiteNumber, siteToSave);
        } 
        catch (MethodException me)
        {
        	String msg = "PutSiteCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to update to new site: " + me.getMessage();
        	logger.error(msg);
        	throw new MethodException(msg, me);
        } 
        catch (ConnectionException ce)
        {
        	String msg = "PutSiteCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source: " + ce.getMessage();
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
		
		sb.append("Region name:");
		sb.append(getRegionName());
		sb.append(" - Region Id:");
		sb.append(getRegionId());
		sb.append("Site name to save:");
		sb.append(siteToSave.getSiteName());
		sb.append(" - Site Id to save:");
		sb.append(siteToSave.getSiteNumber());

		return sb.toString();

		//return getRegionName() + " - " + getRegionId() + " - " + siteToSave.getSiteName()+ " - " + siteToSave.getSiteNumber();
	}

	public String getRegionName() {
		return regionName;
	}

	public String getRegionId() {
		return regionId;
	}

	public String getPrevSiteName() {
		return prevSiteName;
	}

	public String getPrevSiteNumber() {
		return prevSiteNumber;
	}

	public Site getSiteToSave() {
		return siteToSave;
	}
}
