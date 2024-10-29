/**
 * 
 */
package gov.va.med.imaging.cache;

import java.io.Serializable;

/**
 * A value object used to pass the metadata about a cache instance.
 * 
 * @author VHAISWBECKEC
 *
 */
public class CacheMetadata 
implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private CacheItemPath cacheItemPath;
	private String cacheUri;
	private String location;
	private String protocol;
	
	public CacheMetadata() 
	{
		super();
	}

	public CacheMetadata(
		CacheItemPath cacheItemPath,
		String cacheUri,
		String location,
		String protocol) 
	{
		super();
		this.cacheItemPath = cacheItemPath;
		this.cacheUri = cacheUri;
		this.location = location;
		this.protocol = protocol;
	}

	public CacheItemPath getCacheItemPath() {
		return cacheItemPath;
	}

	public String getCacheUri() {
		return this.cacheUri;
	}

	public String getLocation() {
		return location;
	}

	public String getProtocol() {
		return protocol;
	}
}
