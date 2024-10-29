package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.CACHE_POPULATION_DEPTH;
import gov.va.med.cache.gui.shared.CacheGroupMetadata;
import gov.va.med.cache.gui.shared.CacheInstanceMetadata;
import gov.va.med.cache.gui.shared.CacheItemPath;
import gov.va.med.cache.gui.shared.CacheManagerVO;
import gov.va.med.cache.gui.shared.CacheMetadata;
import gov.va.med.cache.gui.shared.CacheRegionMetadata;
import gov.va.med.cache.gui.shared.CacheVO;

import java.util.List;

import com.google.gwt.user.client.rpc.AsyncCallback;

/**
 * The async counterpart of <code>ImagingCacheManagementService</code>.
 */
public interface ImagingCacheManagementServiceAsync
{
	void getCacheManagerVO(AsyncCallback<CacheManagerVO> callback)
	throws IllegalArgumentException;
	
	void getCacheList(CACHE_POPULATION_DEPTH depth, CACHE_POPULATION_DEPTH populateMetadataDepth, AsyncCallback<List<CacheVO>> callback) 
	throws IllegalArgumentException;
	
	void clearCache(CacheItemPath path, AsyncCallback<CacheItemPath> callback)
	throws IllegalArgumentException;
	
	void getCacheItems(CacheItemPath path, CACHE_POPULATION_DEPTH populateMetadataDepth, CACHE_POPULATION_DEPTH depth, AsyncCallback<CacheVO> callback) 
	throws IllegalArgumentException;
	
	void deleteGroup(CacheItemPath groupPath, AsyncCallback<CacheItemPath> callback)
	throws IllegalArgumentException;

	void deleteInstance(CacheItemPath groupPath, AsyncCallback<CacheItemPath> callback)
	throws IllegalArgumentException;

	void getCacheMetadata(CacheItemPath groupPath, AsyncCallback<CacheMetadata> callback);

	void getCacheRegionMetadata(CacheItemPath groupPath, AsyncCallback<CacheRegionMetadata> callback);

	void getCacheGroupMetadata(CacheItemPath groupPath, AsyncCallback<CacheGroupMetadata> callback);

	void getCacheInstanceMetadata(CacheItemPath groupPath, AsyncCallback<CacheInstanceMetadata> callback);

}
