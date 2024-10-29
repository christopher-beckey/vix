/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 18, 2012
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
package gov.va.med.imaging.jmx.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement
public class ThreadInfoType
{

	private String threadName;
	private long threadId;
	private String threadState;
	private String lockName;
	private long lockOwnerId;
	private String lockOwnerName;
	
	public ThreadInfoType()
	{
		super();
	}

	public ThreadInfoType(String threadName, long threadId, String threadState,
			String lockName, long lockOwnerId, String lockOwnerName)
	{
		super();
		this.threadName = threadName;
		this.threadId = threadId;
		this.threadState = threadState;
		this.lockName = lockName;
		this.lockOwnerId = lockOwnerId;
		this.lockOwnerName = lockOwnerName;
	}

	public String getLockName()
	{
		return lockName;
	}

	public void setLockName(String lockName)
	{
		this.lockName = lockName;
	}

	public long getLockOwnerId()
	{
		return lockOwnerId;
	}

	public void setLockOwnerId(long lockOwnerId)
	{
		this.lockOwnerId = lockOwnerId;
	}

	public String getLockOwnerName()
	{
		return lockOwnerName;
	}

	public void setLockOwnerName(String lockOwnerName)
	{
		this.lockOwnerName = lockOwnerName;
	}

	public String getThreadName()
	{
		return threadName;
	}

	public void setThreadName(String threadName)
	{
		this.threadName = threadName;
	}

	public long getThreadId()
	{
		return threadId;
	}

	public void setThreadId(long threadId)
	{
		this.threadId = threadId;
	}

	public String getThreadState()
	{
		return threadState;
	}

	public void setThreadState(String threadState)
	{
		this.threadState = threadState;
	}
}
