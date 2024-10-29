/**
 * 
 */
package gov.va.med.imaging.cache;

import gov.va.med.imaging.cache.BinaryOrdersOfMagnitude;

import java.io.Serializable;

/**
 * A value object used to pass the metadata about a region instance.
 * 
 * @author VHAISWBECKEC
 * 
 */
public class CacheRegionMetadata implements Serializable {
	private static final long serialVersionUID = 1L;

	private CacheItemPath cacheItemPath;
	private String[] evictionStrategyNames;
	private long totalSpace;
	private long usedSpace;

	public CacheRegionMetadata() {
		super();
	}

	public CacheRegionMetadata(CacheItemPath cacheItemPath,
			String[] evictionStrategyNames, long totalSpace, long usedSpace) {
		super();
		this.cacheItemPath = cacheItemPath;
		this.evictionStrategyNames = evictionStrategyNames;
		this.totalSpace = totalSpace;
		this.usedSpace = usedSpace;
	}

	public CacheItemPath getCacheItemPath() {
		return cacheItemPath;
	}

	public String[] getEvictionStrategyNames() {
		return evictionStrategyNames;
	}

	public long getTotalSpace() {
		return totalSpace;
	}

	public long getUsedSpace() {
		return usedSpace;
	}

	public String getTotalSpaceFormatted() {
		return BinaryOrdersOfMagnitude.format(getTotalSpace());
	}

	public String getUsedSpaceFormatted() {
		return BinaryOrdersOfMagnitude.format(getUsedSpace());
	}
}
