/**
 * 
 */
package gov.va.med.imaging.exchange.business.dicom;

import gov.va.med.imaging.exchange.business.PersistentEntity;

import java.io.Serializable;

/**
 * @author VHAISWPETERB
 *
 */
public class SCWorkItemQueryParameters implements PersistentEntity,
		Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2770579753351975136L;
	private int id;
	private String hostname;
	private int queueLimit;
	private int lastIENReceived;
	
	public SCWorkItemQueryParameters(){
		
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.PersistentEntity#setId(int)
	 */
	@Override
	public void setId(int id) {
		this.id = id;

	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.PersistentEntity#getId()
	 */
	@Override
	public int getId() {
		return this.id;
	}

	public String getHostname() {
		return hostname;
	}

	public void setHostname(String hostname) {
		this.hostname = hostname;
	}

	public int getQueueLimit() {
		return queueLimit;
	}

	public void setQueueLimit(int queueLimit) {
		this.queueLimit = queueLimit;
	}

	public int getLastIENReceived() {
		return lastIENReceived;
	}

	public void setLastIENReceived(int lastIENReceived) {
		this.lastIENReceived = lastIENReceived;
	}

	@Override
	public String toString() {
		
		StringBuffer buffer = new StringBuffer();
		buffer.append("Hostname: ");
		buffer.append(this.hostname);
		buffer.append(" ; ");
		buffer.append("Queue Query Limit: ");
		buffer.append(this.queueLimit);
		buffer.append(" ; ");
		buffer.append("last IEN Received: ");
		buffer.append(this.lastIENReceived);
		buffer.append("\r\n");
		
		return buffer.toString();
	}
	
}
