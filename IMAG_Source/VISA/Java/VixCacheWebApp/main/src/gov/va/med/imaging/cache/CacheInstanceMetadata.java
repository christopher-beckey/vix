/**
 * 
 */
package gov.va.med.imaging.cache;

import gov.va.med.imaging.cache.BinaryOrdersOfMagnitude;

import java.io.Serializable;
import java.util.Date;

/**
 * A value object used to pass the metadata about a cache instance.
 * 
 * @author VHAISWBECKEC
 *
 */
public class CacheInstanceMetadata 
implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private CacheItemPath cacheItemPath;
	private long size;
	private Date createDate;
	private Date lastAccessDate;
	private String mediaType;		// the field formerly known as MIME
	private String checksum;
	
	public CacheInstanceMetadata() 
	{
		super();
	}

	public CacheInstanceMetadata(
		CacheItemPath cacheItemPath,
		long size, 
		Date createDate, 
		Date lastAccessDate,
		String mediaType,
		String checksum) 
	{
		super();
		this.cacheItemPath = cacheItemPath;
		this.size = size;
		this.createDate = createDate;
		this.lastAccessDate = lastAccessDate;
		this.mediaType = mediaType;
		this.checksum = checksum;
	}
	
	public CacheInstanceMetadata(
		CacheItemPath cacheItemPath,
		long size, 
		Date lastAccessDate, 
		String checksum) 
	{
		super();
		this.cacheItemPath = cacheItemPath;
		this.size = size;
		this.createDate = null;
		this.lastAccessDate = lastAccessDate;
		this.mediaType = null;
		this.checksum = checksum;
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

	public String getMediaType() {
		return mediaType;
	}

	public String getChecksum() {
		return checksum;
	}
	
	
}
