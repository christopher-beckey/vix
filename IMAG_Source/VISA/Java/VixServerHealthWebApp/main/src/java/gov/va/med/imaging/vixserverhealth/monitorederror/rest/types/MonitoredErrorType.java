/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 30, 2013
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.vixserverhealth.monitorederror.rest.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement
public class MonitoredErrorType
{
	private String errorMessageContains;
	private long count;
	private Date lastOccurrence;
	private boolean active;
	
	public MonitoredErrorType()
	{
		super();
	}

	/**
	 * @param errorMessageContains
	 * @param count
	 * @param lastOccurrence
	 * @param active
	 */
	public MonitoredErrorType(String errorMessageContains, long count,
			Date lastOccurrence, boolean active)
	{
		super();
		this.errorMessageContains = errorMessageContains;
		this.count = count;
		this.lastOccurrence = lastOccurrence;
		this.active = active;
	}

	/**
	 * @return the errorMessageContains
	 */
	public String getErrorMessageContains()
	{
		return errorMessageContains;
	}

	/**
	 * @param errorMessageContains the errorMessageContains to set
	 */
	public void setErrorMessageContains(String errorMessageContains)
	{
		this.errorMessageContains = errorMessageContains;
	}

	/**
	 * @return the count
	 */
	public long getCount()
	{
		return count;
	}

	/**
	 * @param count the count to set
	 */
	public void setCount(long count)
	{
		this.count = count;
	}

	/**
	 * @return the lastOccurrence
	 */
	public Date getLastOccurrence()
	{
		return lastOccurrence;
	}

	/**
	 * @param lastOccurrence the lastOccurrence to set
	 */
	public void setLastOccurrence(Date lastOccurrence)
	{
		this.lastOccurrence = lastOccurrence;
	}

	/**
	 * @return the active
	 */
	public boolean isActive()
	{
		return active;
	}

	/**
	 * @param active the active to set
	 */
	public void setActive(boolean active)
	{
		this.active = active;
	}

}
