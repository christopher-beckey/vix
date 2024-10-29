/**
 * 
 */
package gov.va.med.cache.gui.shared;

import gov.va.med.cache.gui.client.BinaryOrdersOfMagnitude;

import java.io.Serializable;
import java.util.Date;

import com.google.gwt.user.client.rpc.IsSerializable;
import com.ibm.icu.text.SimpleDateFormat;

/**
 * A value object used to pass the metadata about a cache group.
 * 
 * @author VHAISWBECKEC
 *
 */
public class CacheGroupMetadata 
implements Serializable, IsSerializable
{
	private static final long serialVersionUID = 1L;
	
	private CacheItemPath cacheItemPath;
	private long size;
	private Date createDate;
	private Date lastAccessDate;
	
	public CacheGroupMetadata() 
	{
		super();
	}

	public CacheGroupMetadata(
		CacheItemPath cacheItemPath,
		long size, 
		Date createDate, 
		Date lastAccessDate) 
	{
		super();
		this.cacheItemPath = cacheItemPath;
		this.size = size;
		this.createDate = createDate;
		this.lastAccessDate = lastAccessDate;
	}
	
	public CacheGroupMetadata(
		CacheItemPath cacheItemPath,
		long size, 
		Date lastAccessDate) 
	{
		super();
		this.cacheItemPath = cacheItemPath;
		this.size = size;
		this.createDate = null;
		this.lastAccessDate = lastAccessDate;
	}

	public CacheItemPath getCacheItemPath() {
		return cacheItemPath;
	}

	public long getSize() {
		return size;
	}

	public String getSizeFormatted() {
		return BinaryOrdersOfMagnitude.format(getSize());
	}

	public Date getCreateDate() {
		return createDate;
	}

	public Date getLastAccessDate() {
		return lastAccessDate;
	}

}
