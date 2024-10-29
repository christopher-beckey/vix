package gov.va.med.imaging.core.router.commands;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.exchange.business.SiteConnection;

public class PutProtocolCommandImpl extends AbstractCommandImpl<Boolean> {
	private static final long serialVersionUID = 5279615772387888601L;
	private static final Logger logger = Logger.getLogger(PutProtocolCommandImpl.class);
	
	private String regionName;
	private String regionID;
	private String siteName;
	private String siteId;
	private String prevProtocol;
	private Integer prevPort;
	SiteConnection protocol;

	/**
	 *
	 * @param String			region name
	 * @param String			region Id
	 * @param String			site name
	 * @param String			site Id
	 * @param String			previous protocol
	 * @param Integer			previous port
	 * @param SiteConnection	site connection to update to	
	 * 
	 */
	public PutProtocolCommandImpl(String regionName, String regionID, String siteName, String siteId,
			String prevProtocol, Integer prevPort, SiteConnection protocol) {
		super();

		this.regionName = regionName;
		this.regionID = regionID;
		this.siteName = siteName;
		this.siteId = siteId;
		this.prevProtocol = prevProtocol;
		this.prevPort = prevPort;
		this.protocol = protocol;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#
	 * callSynchronouslyInTransactionContext()
	 */
	@Override
	public Boolean callSynchronouslyInTransactionContext() throws MethodException, ConnectionException {
		Boolean isUpdated = null;

		try {
			isUpdated = getCommandContext().getSiteResolver().updateProtocol(regionName, regionID, siteName, siteId, prevProtocol, prevPort,
					protocol);
		} catch (MethodException me) {
	        	String msg = "PutProtocolCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service failed to update protpcol for region [" + this.regionName + "]: " + me.getMessage();
	        	logger.error(msg);
	        	throw new MethodException(msg, me);
	    } catch (ConnectionException ce) {
	        	String msg = "PutProtocolCommandImpl.callSynchronouslyInTransactionContext() --> Configured site resolution service was unable to contact data source for region [" + this.regionName + "]: " + ce.getMessage();
	        	logger.error(msg);
	        	throw new ConnectionException(msg, ce);
	    }    
		return isUpdated;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.
	 * Object)
	 */
	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		return false;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString() {
		
		StringBuilder sb = new StringBuilder();
		
		sb.append("Region Id:");
		sb.append(this.regionID);
		sb.append(" - Region name:");
		sb.append(this.regionName);
		sb.append(" - Site Id:");
		sb.append(this.siteId);
		sb.append(" - Site name:");
		sb.append(this.siteName);
		sb.append(" - Previous protocol:");
		sb.append(this.prevProtocol);
		sb.append(" - Previous port:");
		sb.append(this.prevPort);
		sb.append(" - Protocol:");
		sb.append(this.protocol.getProtocol());

		return sb.toString();

		//return getRegionName() + " - " + getRegionID();
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

	public String getPrevProtocol() {
		return prevProtocol;
	}

	public Integer getPrevPort() {
		return prevPort;
	}

	public SiteConnection getProtocol() {
		return protocol;
	}
}
