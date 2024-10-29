/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 6, 2006
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWBECKEC
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
package gov.va.med.siteservice;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import javax.xml.namespace.NamespaceContext;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.TransformerFactoryConfigurationError;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import gov.va.med.siteservice.rest.SiteServiceRestService;
import org.apache.commons.io.FilenameUtils;
import gov.va.med.logging.Logger;
import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.thoughtworks.xstream.XStream;

import gov.va.med.imaging.DateUtil;
import gov.va.med.imaging.ReadWriteLockCollections;
import gov.va.med.imaging.ReadWriteLockMap;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Region;
import gov.va.med.imaging.exchange.business.RegionImpl;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteConnection;

/**
 * This class is a caching proxy for SiteService.
 * It maintains a map from site ID to Site instance.  The map
 * is first obtained from SiteService and cached in memory and
 * in local persistent storage.  The map is periodically updated
 * by a timer task.  If SiteService is unavailable then the map
 * is loaded from the local persistent copy.
 * 
 * @author VHAISWBECKEC
 */
public class SiteService
implements Iterable<Site>
{
	private static Logger logger = Logger.getLogger(SiteService.class);
	private final SiteServiceConfiguration configuration;
	private Timer refreshTimer;
	private RefreshTimerTask refreshTask;
	private RetrySiteFetchTask retrySiteFetchTask;
	private Date lastCacheUpdate;
	private final RetryBackoffPolicy retryBackoffPolicy;
	
	// This maps the site ID to the Site for faster lookup by site ID.
	// Use a Map that is synchronized seperately on read and write operations.
	// Reads may happen simultaneously, writes must be serialized.
	private final ReadWriteLockMap<String, Site> siteMap;
	private final ReadWriteLockMap<String, Region> regionMap;
	
	// The first time that the cache is loaded it will load from the local
	// persistent copy if SiteService is unavailable.  On subsequent refreshes,
	// it will not use the local persistent copy.
	private boolean initialLoadComplete;
	private SiteServiceSource siteServiceSource = null;
	private String siteServiceDataSourceVersion = "";
	
	/**
	 * @param appConfiguration
	 * @throws IllegalArgumentException
	 * @throws SecurityException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 * @throws InvocationTargetException
	 * @throws NoSuchMethodException
	 * Constructor for Spring singleton.
	 */
	@SuppressWarnings( "unchecked" )
	public SiteService(SiteServiceConfiguration configuration) 
	throws IllegalArgumentException, SecurityException, InstantiationException, IllegalAccessException, InvocationTargetException, NoSuchMethodException
	{
		assert configuration != null;
		this.configuration = configuration;
		siteMap = (ReadWriteLockMap<String, Site>)ReadWriteLockCollections.readWriteLockMap(new HashMap<String, Site>());
		regionMap = (ReadWriteLockMap<String, Region>)ReadWriteLockCollections.readWriteLockMap(new HashMap<String, Region>());
		initialLoadComplete = false;
		if(refreshTimer == null)
			refreshTimer = new Timer("SiteServiceCacheRefresh", true);
		retryBackoffPolicy = new RetryBackoffPolicy(configuration.getMaxRestRetryDelayMillis(),
				configuration.getMaxRestRetryAttempts());
		getSiteServiceUri();		// here to force an error in the initializer if the URI is not formatted properly
		initialize();				// loads the cache for the first time
	}
	
	public SiteServiceConfiguration getConfiguration()
	{
		return this.configuration;
	}

	// If initialLoadComplete is true then the map has been successfully
	// loaded at least once (either from local file or remote siteService).
	// Whether initialLoadComplete is true affects how refreshes behave.
	public boolean isInitialLoadComplete()
    {
    	return initialLoadComplete;
    }

	// initialLoadComplete is a latching property, once set to true it
	// cannot be reset to false
	public void setInitialLoadComplete(boolean initialLoadComplete)
    {
    	this.initialLoadComplete = this.initialLoadComplete || initialLoadComplete;
    }

	/**
	 * return the Date of the last successful update from SiteService
	 * @return
	 */
	public Date getLastCacheUpdate()
    {
    	return lastCacheUpdate;
    }

	/**
	 * 
	 */
	private void initialize()
    {
		// refresh from SiteService if we can else from persistent storage it it exists
		refreshCache();
		
		// start the refresh timer task
		scheduleRefresh();
    }

	/**
	 * 
	 * @return
	 */
	public URL getUrl()
	{
		try
		{
			return getConfiguration().getSiteServiceUri().toURL();
		}
		catch (MalformedURLException x)
		{
			String message = "The site service URL '" + getConfiguration().getSiteServiceUri() + "' is not a valid URL."; 
			logger.error(message);
			return null;
		}
	}
	
	/**
	 * A convenience method for getting the SiteService URI.
	 * Wraps some error handling and instance creation.
	 * 
	 * @return
	 * @throws IllegalArgumentException
	 */
	public URI getSiteServiceUri()
	throws IllegalArgumentException
	{
		return getConfiguration().getSiteServiceUri();
	}
	
	public String getSiteServiceSource()
	{
		if(siteServiceSource == SiteServiceSource.siteService)
			return getSiteServiceUri().toString();
		else if(siteServiceSource == SiteServiceSource.cacheFile)
			return getVhaSitesFile().getAbsolutePath();
		return "";
	}

	/**
	 * Schedule the refresh of the cache.  By default, the site service cache is refreshed
	 * once a day at 11PM local time.
	 * If the refresh schedule is updated (i.e. refreshHour or refreshPeriod) are modified
	 * then this method must be called to reschedule the refresh.
	 * This method is synchronized to protect the refreshTimer and refreshTask locals
	 * from uncoordinated modification.
	 */
	public synchronized void scheduleRefresh()
	{
		// if the refresh task already exists, then we are re-scheduling ourselves
		if(refreshTask != null)
		{
			refreshTask.cancel();
			refreshTask = null;
		}
		
		refreshTask = new RefreshTimerTask();
		
		// schedule ourselves to, by default, refresh every 24 hours,
		// starting at 23:00, the first occurrence of which must be at least 1 hour from now
		refreshTimer.schedule(
			new RefreshTimerTask(), 
			DateUtil.nextOccurenceOfHour(
				getConfiguration().getRefreshHour(), 
				getConfiguration().getRefreshMinimumDelay()), 
				getConfiguration().getRefreshPeriod()
		);
        logger.info("SiteService scheduled to refresh at [{}:00:00] and every [{}] days thereafter", getConfiguration().getRefreshHour(), (float) getConfiguration().getRefreshPeriod() / (float) DateUtil.MILLISECONDS_IN_DAY);
	}

	public synchronized void scheduleSiteFetchRetry(int attemptCount)
	{
		if(retrySiteFetchTask != null)
		{
			logger.info("Site Service retry task rescheduling");
			retrySiteFetchTask.cancel();
			retrySiteFetchTask = null;
		}

		if(attemptCount > 50){
			logger.warn("Max Site Service fetch retry attempts exceeded, giving up");
			return;
		}

        logger.info("Retrying Site Service REST fetch, attempt number {}", attemptCount);

		retrySiteFetchTask = new RetrySiteFetchTask(++attemptCount);
		refreshTimer.schedule(retrySiteFetchTask, retrySiteFetchTask.getDelay());
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.interfaces.ISiteService#getSiteByNumber(java.lang.String)
	 */
	public Site getSiteByNumber(String siteNumber) 
	{
		return this.siteMap.get(siteNumber);
	}
	
	public List<Region> getAllRegions()
	{
		logger.debug("getAllRegions ()");
		List<Region> regions = new ArrayList<Region>();
		for(String key : regionMap.keySet())
		{
			Region region = regionMap.get(key);
			regions.add(getRegionByNumber(region.getRegionNumber()));
		}
        logger.debug("Found [{}] regions", regions.size());
		return regions;
	}
	
	/**
	 * Return all the region configured in VhaSites.xml.
	 * @return List<Region>
	 */
	public List<Region> getAllRegionsForSiteService()
	{
		logger.debug("getAllRegionsForSiteService ()");
		List<Region> regions = new ArrayList<Region>();
		List<Region> regionsFromXml = new ArrayList<Region>();
		List<Site> sitesFromXml = new ArrayList<Site>();
		
		NamespaceContext ctx = new NamespaceContext() {
            public String getNamespaceURI(String prefix) {
                String uri;
                if (prefix.equals("vha"))
                    uri = "http://med.va.gov/vistaweb/sitesTable";
                else
                    uri = null;
                return uri;
            }
            public Iterator getPrefixes(String val) {
                return null;
            }
            public String getPrefix(String uri) {
                return null;
            }
        };
		InputSource source = new InputSource(this.getConfiguration().getVhaSitesXmlFileName());
		XPath xPath = XPathFactory.newInstance().newXPath();
		xPath.setNamespaceContext(ctx);
		SiteServiceTranslator translator = new SiteServiceTranslator();
		
		try{
			NodeList siteNodes =  (NodeList)xPath.evaluate("//vha:VhaSite",
					source,
					XPathConstants.NODESET);
			sitesFromXml = translator.translateSiteNodesForSiteService(siteNodes);
		} catch(XPathExpressionException xpee){
			logger.error(xpee);
		}
		
		try{
			NodeList regionNodes =  (NodeList)xPath.evaluate("//vha:VhaVisn",
					source,
					XPathConstants.NODESET);
			regionsFromXml = translator.translateRegionNodes(regionNodes);
		} catch(XPathExpressionException xpee){
			logger.error(xpee);
		}
		
		for(Region region : regionsFromXml) {
			for(Site site: sitesFromXml) {
				if(region.getRegionNumber().trim().equals(site.getRegionId().trim())) {
					region.getSites().add(site);
				}
			}
			regions.add(region);
		}

        logger.debug("getAllRegionsForSiteService() : Found [{}] regions", regions.size());
		return regions;
	}
	
	public Region getRegionByNumber(String regionNumber)
	{
        logger.debug("getRegionByNumber ({})", regionNumber);
		Region region = this.regionMap.get(regionNumber);
		if(region == null)
			return null;		
		// want to create a new instance of region since we are putting in the site objects 
		// (but don't want those in the regions in the cache)
		Region result = new RegionImpl(region.getRegionName(), region.getRegionNumber());
		
		// find all the sites for this region
		for(String key : this.siteMap.keySet())
		{
			Site site = this.siteMap.get(key);
			if(regionNumber.equals(site.getRegionId()))
			{
				result.getSites().add(site);
			}
		}
        logger.debug("Found [{}] sites for region [{}]", result.getSites().size(), regionNumber);
		return result;			
	}

	/**
	 * Return an Iterator over all of the Site
	 * @see java.lang.Iterable#iterator()
	 */
	@Override
    public Iterator<Site> iterator()
    {
		return new Iterator<Site>()
		{
			private Iterator<String> keysetIterator = siteMap.keySet().iterator();
			
			@Override
            public boolean hasNext()
            {
	            return keysetIterator.hasNext();
            }

			@Override
            public Site next()
            {
	            return siteMap.get(keysetIterator.next());
            }

			@Override
            public void remove()
            {
				throw new UnsupportedOperationException("remove() is not supported by the SiteService iterator.");
            }
		};
    }
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.interfaces.ISiteService#forceCacheRefresh()
	 * Force the local cache site to refresh from SiteService.
	 */
	public void refreshCache()
	{
		logger.info( isInitialLoadComplete() ? 
			"Refreshing Site cache." : 
			"Loading Site cache for the first time."
		);

		if (this.getVhaSitesFile().exists()){
			try
            {
                logger.info("Loading site map from local cache file '{}'.", getVhaSitesFile().getAbsolutePath());
				loadCacheFromVhaSitesXml();
	    		setInitialLoadComplete(true);	// set this true only if we have successfully loaded a non-zero length Site list
	    		logger.info( "Successfully loaded site map from local cache." );
				siteServiceSource = SiteServiceSource.cacheFile;
            } 
			catch (SiteMapLoadException | RegionMapLoadException e)
            {
				logger.error(e);
            }
		}
		else{
			try
			{
				logger.info( "Loading cache from site service." );
				loadCacheFromSiteService(1);
				setInitialLoadComplete(true);	// set this true only if we have successfully loaded a non-zero length Site list
				logger.info( "Successfully loaded cache from site service." );
				siteServiceSource = SiteServiceSource.siteService;
			}
			catch (SiteMapLoadException ex)
			{
				// If there was an exception while loading the site service from the web service, 
				// attempt to load it from the file on disk
                logger.error("SiteService cache refresh failed with exception [{}].", ex.getCause() != null ? ex.getCause().getMessage() : ex.getMessage());
				try
	            {
					logger.info( "Loading site map from local cache." );
		            loadSiteMapFromLocalCache();
		    		setInitialLoadComplete(true);	// set this true only if we have successfully loaded a non-zero length Site list
					logger.info( "Successfully loaded site map from local cache." );
	            } 
				catch (SiteMapLoadException | RegionMapLoadException e)
	            {
					logger.error(e);
	            }
			}
			catch(RegionMapLoadException rmlX)
			{
				// If there was an exception while loading the site service from the web service, 
				// attempt to load it from the file on disk
                logger.error("SiteService region cache refresh failed with exception [{}].", rmlX.getCause() != null ? rmlX.getCause().getMessage() : rmlX.getMessage());
				try
	            {
		            loadSiteMapFromLocalCache();
		    		setInitialLoadComplete(true);	// set this true only if we have successfully loaded a non-zero length Site list
	            } 
				catch (SiteMapLoadException | RegionMapLoadException e)
	            {
					logger.error(e);
	            }
			}
		}
	}

	private void loadCacheFromVhaSitesXml() throws SiteMapLoadException, RegionMapLoadException {
		NamespaceContext ctx = new NamespaceContext() {
            public String getNamespaceURI(String prefix) {
                String uri;
                if (prefix.equals("vha"))
                    uri = "http://med.va.gov/vistaweb/sitesTable";
                else
                    uri = null;
                return uri;
            }
            public Iterator getPrefixes(String val) {
                return null;
            }
            public String getPrefix(String uri) {
                return null;
            }
        };
		InputSource source = new InputSource(this.getConfiguration().getVhaSitesXmlFileName());
		XPath xPath = XPathFactory.newInstance().newXPath();
		xPath.setNamespaceContext(ctx);
		SiteServiceTranslator translator = new SiteServiceTranslator();
		try{
			NodeList siteNodes =  (NodeList)xPath.evaluate("//vha:VhaSite",
					source,
					XPathConstants.NODESET);
			List<Site> newSites = translator.translateSiteNodes(siteNodes);
			updateCacheFromSiteList(newSites);
		} catch(XPathExpressionException xpee){
			throw new SiteMapLoadException(xpee, true);
		}
		
		try{
			NodeList regionNodes =  (NodeList)xPath.evaluate("//vha:VhaVisn",
					source,
					XPathConstants.NODESET);
			List<Region> newRegions = translator.translateRegionNodes(regionNodes);
			updateCacheFromRegionList(newRegions);
		} catch(XPathExpressionException xpee){
			throw new RegionMapLoadException(xpee, true);
		}
		lastCacheUpdate = new Date();
	}
	
	/**
	 * Load the SiteService cache from the SiteService webservice.
	 * The "new" site list is first obtained in its entirety and then the
	 * site map is updated in one synchronized method.  The site map should
	 * always be modified in this manner, not by adding/updating single entries.
	 * This method either succeeds in loading a non-zero length list or 
	 * throws an exception.
	 * 
	 * @throws SiteMapLoadException - wraps the underlying exception
	 */
	private void loadCacheFromSiteService(int attemptCount)
	throws SiteMapLoadException, RegionMapLoadException
    {

		List<Region> newRegions = null;
	    List<Site> newSites = null;

		logger.debug("Using SiteService REST endpoint");
		try
		{
			SiteServiceRestService restService = new SiteServiceRestService(getSiteServiceUri());
			newSites = restService.fetchSites();
			newRegions = restService.fetchRegions();
			siteServiceDataSourceVersion = "2";
		}
		catch(SiteMapLoadException smlX)
		{
            logger.warn("Error loading sites from site service, {}", smlX.getMessage());
			scheduleSiteFetchRetry(attemptCount);
			throw smlX;
		}
		catch(RegionMapLoadException rmlX)
		{
            logger.warn("Error loading regions from site service, {}", rmlX.getMessage());
			scheduleSiteFetchRetry( attemptCount);
			throw rmlX;
		}
	    // Fortify change: check for null first.  Do this way so not to check both "newSites" and "site" for null separately
	    // OLD: for(Site site: newSites)
	    for(Site site: newSites == null ? Collections.<Site>emptyList() : newSites)
            logger.debug("Site to load to Cache: {}", site.getSiteNumber());

	    // update the cache map
    	updateCacheFromSiteList(newSites);
	    
	    // update the cache map
    	updateCacheFromRegionList(newRegions);
    	
    	// save the latest list of Site so that we can reboot without
    	// contacting SiteService
    	storeSiteListToCacheFile(newSites);
    	storeRegionListToCacheFile(newRegions);

    	lastCacheUpdate = new Date();
    	logger.info( "SiteService cache refresh completed successfully. " ); 
    }


	/**
	 * Load the SiteService cache from the locally stored copy.
	 * 
	 * The site list is first obtained in its entirety and then the
	 * site map is updated in one synchronized method.  The site map should
	 * always be modified in this manner, not by adding/updating single entries.
	 * 
	 * This method either succeeds in loading a non-zero length list or 
	 * throws an exception.
	 */
	private void loadSiteMapFromLocalCache()
	throws SiteMapLoadException, RegionMapLoadException
    { 
	    List<Site> newSites = loadSiteListFromCacheFile();
	    List<Region> newRegions = loadRegionListFromCacheFile();
	    
	    if(newSites == null || newSites.size() == 0)
	    	throw new SiteMapLoadException("SiteService failed to load from cache. ", false);
	    if(newRegions == null || newRegions.size() == 0)
	    	throw new RegionMapLoadException("SiteService failed to load regions from cache. ", false);
	    
    	// update the cache map
    	updateCacheFromSiteList(newSites);
    	updateCacheFromRegionList(newRegions);
    	logger.info( "SiteService loaded from cache successfully. " ); 
    }

	/**
	 * A convenience method to load the Site Map from a Site List.
	 * 
	 * Given a List of Site instances, update the local Site Map.
	 * The List may come from the SiteService or from the local cached copy.
	 * 
	 * @param newSites
	 */
	private void updateCacheFromSiteList(List<Site> newSites)
    {
	    Map<String, Site> newSiteMap = new HashMap<String, Site>();
	    
	    for(Site site : newSites)
	    	newSiteMap.put(site.getSiteNumber(), site);
	    
	    //ImagingExchangeSiteTO[] sites = webService.getImagingExchangeSites();
	    
	    // Note that we build a temporary Map instance and then load the
	    // real Map in one fell swoop. This is done because the clearAndPutAll()
	    // method does the entire add in one isolated transaction. No read
	    // operations will occur while the Map is being cleared and updated.
	    // This is how updates to this type of map should be done, at least
	    // in the context of this application.
	    siteMap.clearAndPutAll(newSiteMap);
    }
	
	/**
	 * A convenience method to load the Region Map from a Region List.
	 * 
	 * Given a List of Region instances, update the local Region Map.
	 * The List may come from the SiteService or from the local cached copy.
	 * 
	 * @param newRegions
	 */
	private void updateCacheFromRegionList(List<Region> newRegions)
	{
		Map<String, Region> newRegionMap = new HashMap<String, Region>();
		for(Region region : newRegions)
		{
			newRegionMap.put(region.getRegionNumber(), region);
		}
		regionMap.clearAndPutAll(newRegionMap);
	}
	
	// ===============================================================================================
	// Local Persistent Caching
	// ===============================================================================================
	/**
	 * Retrieve the filename to use to store the cache on disk.
	 * 
	 * @return The filename to use for the cache on disk
	 */
	private File getSiteListCacheFile() 
	{
		return new File( getConfiguration().getSiteServiceCacheFileName() );
	}
	
	private File getRegionListCacheFile()
	{
		return new File( getConfiguration().getRegionListCacheFileName() );
	}
	
	private File getVhaSitesFile() 
	{
		// Fortify change: line 829 is the curly bracket.  Fixed the below just in case
		return new File( StringUtil.toSystemFileSeparator(getConfiguration().getVhaSitesXmlFileName()) );
	}

	/**
	 * Load the data from the site service from a file stored on the disk.
	 * 
	 * @return a list of sites from the caches file, null if the file does not exist
	 * or if there were no sites
	 */
	@SuppressWarnings("unchecked")
	private List<Site> loadSiteListFromCacheFile() 
	{
		List<Site> sites = null;
		
		logger.info("SiteService.loadsiteServiceFromCache: Loading site service data from cache");
		
		// Fortify change: made sure file path is OK
		String filename = FilenameUtils.normalize(getSiteListCacheFile().getAbsolutePath());
		
		// Fortify change: moved instantiation into try-with-resources to be closed for us
		try ( FileInputStream inStream = new FileInputStream(filename) )
		{
            logger.info("Loading Site Service site cache using XStream from file '{}'.", filename);
			XStream xstream = new XStream(); // See comment inside storeRegionListToCacheFile()
			sites = (List<Site>)xstream.fromXML(inStream);
            logger.info("Site Service site cache loaded using XStream and is {}", sites == null ? "NULL" : "NOT NULL");
		}
		catch(FileNotFoundException fnfX)
		{
			// This should never happen because the first time the ViX is brought up, the site service should
			// be available. After that the file should exist in the ViX configuration directory
            logger.error("SiteService.loadSiteServiceFromCache: {}", fnfX.getMessage());
		}
		catch(Exception ex)
		{
            logger.error("SiteService.loadSiteServiceFromCache: {}", ex.getMessage());
		}
		
		// Do NOT return a zero length site list
		// If there are no sites in the file then return null
		return sites != null && sites.size() > 0 ? sites : null;
	}	
	
	/**
	 * Load the data from the site service from a file stored on the disk.
	 * 
	 * @return a list of regions from the caches file, null if the file does not exist
	 * or if there were no regions
	 */
	@SuppressWarnings("unchecked")
	private List<Region> loadRegionListFromCacheFile() 
	{
		List<Region> regions = null;
		
		logger.info("SiteService.loadRegionListFromCacheFile: Loading region list data from cache");
		
		// Fortify change: made sure file path is OK
		String filename = FilenameUtils.normalize(getRegionListCacheFile().getAbsolutePath());
		
		// Fortify change: moved instantiation into try-with-resources to be closed for us
		try ( FileInputStream inStream = new FileInputStream(filename) )
		{
            logger.info("Loading Site Service region cache using XStream from file '{}'.", filename);
			XStream xstream = new XStream(); // See comment inside storeRegionListToCacheFile()
			regions = (List<Region>)xstream.fromXML(inStream);
            logger.info("Site Service region cache loaded using XStream and is {}", regions == null ? "NULL" : "NOT NULL");
		}
		catch(FileNotFoundException fnfX)
		{
			// This should never happen because the first time the ViX is brought up, the site service should
			// be available. After that the file should exist in the ViX configuration directory
            logger.error("SiteService.loadRegionListFromCacheFile: {}", fnfX.getMessage());
		}
		catch(Exception ex)
		{
            logger.error("SiteService.loadRegionListFromCacheFile: {}", ex.getMessage());
		}
		
		// Do NOT return a zero length site list
		// If there are no sites in the file then return null
		return regions != null && regions.size() > 0 ? regions : null;
	}	
	
	/**
	 * Stores the list of sites to the cache file on disk
	 * @param sites
	 * @return
	 */
	private boolean storeSiteListToCacheFile(List<Site> sites)
	{
		boolean success = false;
		if(sites == null || sites.isEmpty()) return success;
		
		// Fortify change: made sure file path is OK
		String filename = FilenameUtils.normalize(getSiteListCacheFile().getAbsolutePath());
		
		// Fortify change: moved instantiation into try-with-resources to be closed for us
		try ( FileOutputStream outStream = new FileOutputStream(filename) )
		{
            logger.info("Saving local site cache to '{}' using XStream.", filename);
			XStream xstream = new XStream(); // See comment inside storeRegionListToCacheFile()
			xstream.toXML(sites, outStream);
            logger.info("SiteService site cache saved to: {}", filename);
			success = true;
		} catch (Exception ex)
		{
			// This exception should not occur, it would only occur if the ViX configuration location does
			// not exist, this shouldn't happen or we have other bigger problems
            logger.error("SiteService.storeSiteListToCacheFile: {}", ex.getMessage());
		}
		return success;
	}
	
	/**
	 * Stores the list of regions to the cache file on disk
	 * @param regions
	 * @return
	 */
	private boolean storeRegionListToCacheFile(List<Region> regions)
	{		
		boolean success = false;
		if(regions == null || regions.isEmpty()) return success;
		
		// Fortify change: made sure file path is OK
		String filename = FilenameUtils.normalize(getRegionListCacheFile().getAbsolutePath());
		
		// Fortify change: moved instantiation into try-with-resources to be closed for us
		try ( FileOutputStream outStream = new FileOutputStream(filename) )
		{
            logger.info("Saving SiteService region cache '{}' using XStream.", filename);
			
			// Custom class. Not implement AutoClosable = can be used with try-with-resources
			// Not actual stream and this custom class doesn't provide a close() method
			XStream xstream = new XStream();
			xstream.toXML(regions, outStream);
            logger.info("SiteService region cache saved to: {}", filename);
			success = true;
		} catch (Exception ex)
		{
			// This exception should not occur, it would only occur if the ViX configuration location does
			// not exist, this shouldn't happen or we have other bigger problems
            logger.error("SiteService.storeRegionListToCacheFile: {}", ex.getMessage());
		}

		return success;
	}

	@Override
	public String toString()
	{
		return 
			this.getClass().getName() + " [" +
			"Site Service URI: " + this.getSiteServiceUri() +
			"]";
	}
	
	public String getSiteServiceDataSourceVersion()
	{
		return siteServiceDataSourceVersion;
	}

	/**
	 * 
	 * @author VHAISWBECKEC
	 *
	 */
	class RefreshTimerTask
	extends TimerTask
	{
		@Override
        public void run()
        {
			try
            {
				refreshCache();
            } 
			catch (Exception e)
            {
				logger.error(e);
            } 
        }
		
	}

	class RetrySiteFetchTask
	extends TimerTask
	{
		private final int attemptCount;

		public RetrySiteFetchTask(int attemptCount)
		{
			this.attemptCount = attemptCount;
            logger.debug("Retrying SiteService request in {}ms", getDelay());
		}

		public long getDelay(){
			return retryBackoffPolicy.getDelay(attemptCount);
		}

		@Override
		public void run()
		{
			try
			{
				loadCacheFromSiteService(this.attemptCount);
			}
			catch(SiteMapLoadException | RegionMapLoadException smlX)
			{
				logger.warn("Error loading sites, executing retry policy");
			}
		}
	}

	enum SiteServiceSource
	{
		siteService, cacheFile;
	}
	
	/**
	 *  Adds a Region to VhaSites.xml.
	 *  
	 * @param regionName
	 * @param regionId
	 * @return Boolean
	 * @throws MethodException
	 */
	public Boolean addRegionToVhaSitesXml(final String regionName, final String regionId)
			throws MethodException
	{
		Boolean isSaved = false;
		Document doc = createDomDocument();
		
		if(doc == null) {
			logger.error("Exception thrown while creating the Dom document");
			return isSaved;
		}
		
		//Validating for region name and region number
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes;
		try {
			nodes = (NodeList) xpath.evaluate("//VhaVisn", doc, XPathConstants.NODESET);
			for (int idx = 0; idx < nodes.getLength(); idx++) {
				Node cNode = nodes.item(idx);
				Node idNode = cNode.getAttributes().getNamedItem("ID");
				Node nameNode = cNode.getAttributes().getNamedItem("name");
				
				if (idNode.getNodeValue().equals(regionId)) {
					throw new MethodException("There is already a Region with same Region number("+ regionId+")");
				}
				if(nameNode.getNodeValue().equalsIgnoreCase(regionName)) {
					throw new MethodException("There is already a Region with same Region name("+ regionName+")");
				}
			}
		} catch (XPathExpressionException e1) {
			logger.error(e1);
		}
		
		//Saving the new node in vhasites xml file
		try {
			nodes = (NodeList) xpath.evaluate("//VhaVisnTable", doc,
			    XPathConstants.NODESET);
				Element regionElm = doc.createElement("VhaVisn");
				regionElm.setAttribute("name", regionName);
				regionElm.setAttribute("ID", regionId);
				int len = nodes.getLength();
				for (int idx = 0; idx < len; idx++) {
					if(idx == len - 1) {
						nodes.item(idx).insertBefore(regionElm, null);
					}
				}
		} catch (XPathExpressionException e) {
			logger.error(e);
			return isSaved;
		}
		
		
		isSaved = writeDomDocument(doc);
        logger.info("Region added: {}", isSaved);
		return isSaved;
	}
	
	/**
	 * Deletes the Region from VhaSites.xml.
	 * 
	 * @param regionId
	 * @return Boolean
	 */
	public Boolean deleteRegionFromVhaSitesXml(final String regionId)
	{
		Boolean isDeleted = false;
		Document doc = createDomDocument();
		
		if(doc == null) {
			logger.error("Exception thrown while creating the Dom document");
			return isDeleted;
		}
		
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes;
		try {
			nodes = (NodeList) xpath.evaluate("//VhaVisn", doc, XPathConstants.NODESET);
			for (int idx = 0; idx < nodes.getLength(); idx++) {
				Node cNode = nodes.item(idx);
				Node idNode = cNode.getAttributes().getNamedItem("ID");
				if (cNode.getNodeName().equals("VhaVisn") && idNode.getNodeValue().equals(regionId)) {
						cNode.getParentNode().removeChild(cNode);
				}
			}
		} catch (XPathExpressionException e) {
			logger.error(e);
			return isDeleted;
		}

		isDeleted = writeDomDocument(doc);
        logger.info("Region deleted: {}", isDeleted);
		return isDeleted;
	}
	
	/**
	 * Adds a Site node to VhaSites.xml
	 * @param regionName
	 * @param regionID
	 * @param site
	 * @return Boolean
	 * @throws MethodException
	 */
	public Boolean addSiteToVhaSitesXml(final String regionName, final String regionID, Site site)
			throws MethodException {
		Boolean isSaved = false;
		Document doc = createDomDocument();

		if (doc == null) {
			logger.error("Exception thrown while creating the Dom document");
			return isSaved;
		}
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes;
		try {
			nodes = (NodeList) xpath.evaluate("//VhaVisn", doc, XPathConstants.NODESET);
		} catch (XPathExpressionException e1) {
			logger.error(e1);
			return isSaved;
		}

		// iterating over regions
		for (int idx = 0; idx < nodes.getLength(); idx++) {
			Node cNode = nodes.item(idx);
			Node idNode = cNode.getAttributes().getNamedItem("ID");
			Node nameNode = cNode.getAttributes().getNamedItem("name");

			if (idNode.getNodeValue().equals(regionID) && nameNode.getNodeValue().equalsIgnoreCase(regionName)) {

				boolean isSitePresent = false;
				// iterating over sites
				NodeList siteNodes = cNode.getChildNodes();
				for (int idx1 = 0; idx1 < siteNodes.getLength(); idx1++) {
					try {
						Node siteNode = siteNodes.item(idx1);
						Node idSiteNode = siteNode.getAttributes().getNamedItem("ID");
						Node nameSiteNode = siteNode.getAttributes().getNamedItem("name");

						if (idSiteNode.getNodeValue().equals(site.getSiteNumber())){
							isSitePresent = true;
							throw new MethodException("There is already a site with same site number("+ site.getSiteNumber() +").");
						}
						if(nameSiteNode.getNodeValue().equalsIgnoreCase(site.getSiteName())){
							isSitePresent = true;
							throw new MethodException("There is already a site with same site name("+ site.getSiteName() +").");
						}
					} catch (NullPointerException e) {
						continue;
					}
				}

				// if site not present, then add the new site
				if (!isSitePresent) {
					Element siteEle = doc.createElement("VhaSite");
					siteEle.setAttribute("ID", site.getSiteNumber());
					siteEle.setAttribute("name", site.getSiteName());
					siteEle.setAttribute("moniker", site.getSiteAbbr());
					siteEle.setAttribute("sitePatientLookupable", Boolean.valueOf(site.isSitePatientLookupable()).toString());
					siteEle.setAttribute("siteUserAuthenticatable", Boolean.valueOf(site.isSiteUserAuthenticatable()).toString());

					cNode.appendChild(siteEle);
					isSaved = writeDomDocument(doc);
					
				}
			} 
		}
        logger.info("Site added: {}", isSaved);
		return isSaved;
	}
	
    /**
     * Updates the existing Site in VhaSites.xml
     * @param regionName
     * @param regionID
     * @param prevSiteName
     * @param prevSiteId
     * @param site
     * @return Boolean
     * @throws MethodException
     */
	public Boolean updateSiteToVhaSitesXml(final String regionName, final String regionID, final String prevSiteName,
			final String prevSiteId, Site site) throws MethodException {

		Boolean isUpdated = false;
		Document doc = createDomDocument();

		if (doc == null) {
			logger.error("Exception thrown while creating the Dom document");
			return isUpdated;
		}

		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes;
		try {
			nodes = (NodeList) xpath.evaluate("//VhaVisn", doc, XPathConstants.NODESET);
		} catch (XPathExpressionException e1) {
			logger.error(e1);
			return isUpdated;
		}

		// iterating over regions
		for (int idx = 0; idx < nodes.getLength(); idx++) {
			Node cNode = nodes.item(idx);
			Node idNode = cNode.getAttributes().getNamedItem("ID");
			Node nameNode = cNode.getAttributes().getNamedItem("name");

			if (idNode.getNodeValue().equals(regionID) && nameNode.getNodeValue().equalsIgnoreCase(regionName)) {

				boolean isSiteIdChanged = false;
				boolean isSiteNameChanged = false;

				if (!prevSiteId.trim().equals(site.getSiteNumber().trim())) {
					isSiteIdChanged = true;
				}
				if (!prevSiteName.trim().equals(site.getSiteName().trim())) {
					isSiteNameChanged = true;
				}

				// iterating over sites if site id is changed
				NodeList siteNodes = cNode.getChildNodes();
				for (int idx1 = 0; idx1 < siteNodes.getLength(); idx1++) {
					try {
						Node siteNode = siteNodes.item(idx1);
						Node idSiteNode = siteNode.getAttributes().getNamedItem("ID");
						Node nameSiteNode = siteNode.getAttributes().getNamedItem("name");

						if (isSiteIdChanged && (idSiteNode.getNodeValue().equals(site.getSiteNumber()))) {
							throw new MethodException(
									"There is already a site with same site number(" + site.getSiteNumber() + ").");
						}
						if (isSiteNameChanged && (nameSiteNode.getNodeValue().equalsIgnoreCase(site.getSiteName()))) {
							throw new MethodException(
									"There is already a site with same site name(" + site.getSiteName() + ").");
						}
					} catch (NullPointerException e) {
						continue;
					}
				}

				// updating the existing site
				for (int idx1 = 0; idx1 < siteNodes.getLength(); idx1++) {

					try {
						Node siteNode = siteNodes.item(idx1);
						Node idSiteNode = siteNode.getAttributes().getNamedItem("ID");
						Node nameSiteNode = siteNode.getAttributes().getNamedItem("name");
						if (idSiteNode.getNodeValue().equals(prevSiteId)
								|| nameSiteNode.getNodeValue().equalsIgnoreCase(prevSiteName)) {

							NamedNodeMap siteNodeAttr = siteNode.getAttributes();
							siteNodeAttr.getNamedItem("ID").setTextContent(site.getSiteNumber());
							siteNodeAttr.getNamedItem("name").setTextContent(site.getSiteName());
							siteNodeAttr.getNamedItem("moniker").setTextContent(site.getSiteAbbr());
							if (siteNodeAttr.getNamedItem("sitePatientLookupable") == null) {
								Attr sitePatientLookupableNode = doc.createAttribute("sitePatientLookupable");
								sitePatientLookupableNode
										.setValue(Boolean.valueOf(site.isSitePatientLookupable()).toString());
								siteNodeAttr.setNamedItem(sitePatientLookupableNode);
							} else {
								siteNodeAttr.getNamedItem("sitePatientLookupable")
										.setTextContent(Boolean.valueOf(site.isSitePatientLookupable()).toString());
							}

							if (siteNodeAttr.getNamedItem("siteUserAuthenticatable") == null) {
								Attr sitePatientLookupableNode = doc.createAttribute("siteUserAuthenticatable");
								sitePatientLookupableNode
										.setValue(Boolean.valueOf(site.isSiteUserAuthenticatable()).toString());
								siteNodeAttr.setNamedItem(sitePatientLookupableNode);
							} else {
								siteNodeAttr.getNamedItem("siteUserAuthenticatable")
										.setTextContent(Boolean.valueOf(site.isSiteUserAuthenticatable()).toString());
							}

							isUpdated = writeDomDocument(doc);
                            logger.info("Site Updated: {}", isUpdated);
							return isUpdated;
						}
					} catch (NullPointerException e) {
						continue;
					}
				}
			}
		  }
        logger.info("Site Updated: {}", isUpdated);
		return isUpdated;
	}
	
	/**
	 * Deletes the Site from VhaSites.xml.
	 * 
	 * @param regionId
	 * @param regionName
	 * @param siteId
	 * @param siteName
	 * @return Boolean
	 */
	public Boolean deleteSiteFromVhaSitesXml(final String regionId, final String regionName, final String siteId,
			final String siteName){
		Boolean isDeleted = false;
		Document doc = createDomDocument();
		if (doc == null) {
			logger.error("Exception thrown while creating the Dom document");
			return isDeleted;
		}
		
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes;
		try {
			nodes = (NodeList) xpath.evaluate("//VhaVisn", doc, XPathConstants.NODESET);
		} catch (XPathExpressionException e1) {
			logger.error(e1);
			return isDeleted;
		}

		// iterating over regions
		for (int idx = 0; idx < nodes.getLength(); idx++) {
			Node cNode = nodes.item(idx);
			Node idNode = cNode.getAttributes().getNamedItem("ID");
			Node nameNode = cNode.getAttributes().getNamedItem("name");

			if (idNode.getNodeValue().equals(regionId) && nameNode.getNodeValue().equalsIgnoreCase(regionName)) {
				NodeList siteNodes = cNode.getChildNodes();
				// iterating over sites
				for (int idx1 = 0; idx1 < siteNodes.getLength(); idx1++) {
					try {
						Node siteNode = siteNodes.item(idx1);
						Node idSiteNode = siteNode.getAttributes().getNamedItem("ID");
						Node nameSiteNode = siteNode.getAttributes().getNamedItem("name");
						if (idSiteNode.getNodeValue().equals(siteId)) {
							siteNode.getParentNode().removeChild(siteNode);
							isDeleted = writeDomDocument(doc);
                            logger.info("Site Deleted: {}", isDeleted);
							return isDeleted;
						}
					} catch (NullPointerException e) {
						continue;
					}
				}
			}
		}
        logger.info("Site Deleted: {}", isDeleted);
		return isDeleted;
	}
	
	/**
	 * Updates the Existing Region in the VhaSites.xml
	 * @param oldRegionName
	 * @param oldRegionId
	 * @param newRegionName
	 * @param newRegionId
	 * @return Boolean
	 * @throws MethodException
	 */
	public Boolean updateRegionToVhaSitesXml(String oldRegionName,String oldRegionId, String newRegionName, String newRegionId) 
			throws MethodException 
	{
			Boolean isUpdated= false;
			
			Document doc = createDomDocument();
			if(doc == null) {
				logger.error("Exception thrown while creating the Dom document");
				return isUpdated;
			}
			
			boolean isRegionIdChanged = false;
			boolean isRegionNameChanged = false;
			oldRegionId = oldRegionId.trim();
			oldRegionName = oldRegionName.trim();
			newRegionId = newRegionId.trim();
			newRegionName = newRegionName.trim();
	
			isRegionIdChanged = !oldRegionId.equals(newRegionId);
			isRegionNameChanged = !oldRegionName.equalsIgnoreCase(newRegionName); 
			XPath xpath = XPathFactory.newInstance().newXPath();
			NodeList nodes;
			
			try {
				nodes = (NodeList) xpath.evaluate("//VhaVisn", doc, XPathConstants.NODESET);
			} catch (XPathExpressionException e) {
				logger.error(e);
				return isUpdated;
			}
	
			// validating for region name and region number.
			if(isRegionIdChanged || isRegionNameChanged) {
				for (int idx = 0; idx < nodes.getLength(); idx++) {
					Node cNode = nodes.item(idx);
					Node idNode = cNode.getAttributes().getNamedItem("ID");
					Node nameNode = cNode.getAttributes().getNamedItem("name");
					
					if(idNode.getNodeValue().equals(newRegionId) && isRegionIdChanged) {
						throw new MethodException("There is already a Region with same Region number("+ newRegionId+")");
					}
					if(nameNode.getNodeValue().equalsIgnoreCase(newRegionName) && isRegionNameChanged) {
						throw new MethodException("There is already a Region with same Region name("+ newRegionName+")");
					}
				}
			}
			
			//updating the value
			for (int idx = 0; idx < nodes.getLength(); idx++) {
				Node cNode = nodes.item(idx);
				Node idNode = cNode.getAttributes().getNamedItem("ID");
				Node nameNode = cNode.getAttributes().getNamedItem("name");
	
				if (cNode.getNodeName().equals("VhaVisn") && idNode.getNodeValue().equals(oldRegionId)
						&& nameNode.getNodeValue().equalsIgnoreCase(oldRegionName)) {
					idNode.setNodeValue(newRegionId);
					nameNode.setNodeValue(newRegionName);
				}
			}
			isUpdated = writeDomDocument(doc);
        logger.info("Region Updated: {}", isUpdated);
			return isUpdated;
		}
	
	/**
	 * Adds the Protocol to VhaSites.xml.
	 * @param regionName
	 * @param regionID
	 * @param siteName
	 * @param siteId
	 * @param siteConnection
	 * @return Boolean
	 * @throws MethodException
	 */
	public Boolean addProcToVhaSitesXml(final String regionName, final String regionID, final String siteName,
			final String siteId, final SiteConnection siteConnection) throws MethodException {
		Boolean isSaved = false;
		Document doc = createDomDocument();

		if (doc == null) {
			logger.error("Exception thrown while creating the Dom document");
			return isSaved;
		}
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes;
		try {
			nodes = (NodeList) xpath.evaluate("//VhaVisn", doc, XPathConstants.NODESET);
		} catch (XPathExpressionException e1) {
			logger.error(e1);
			return isSaved;
		}

		// iterating over regions
		for (int idx = 0; idx < nodes.getLength(); idx++) {
			Node regNode = nodes.item(idx);
			Node regIdNode = regNode.getAttributes().getNamedItem("ID");
			Node regNameNode = regNode.getAttributes().getNamedItem("name");

			if (regIdNode.getNodeValue().equals(regionID) && regNameNode.getNodeValue().equalsIgnoreCase(regionName)) {
				NodeList siteNodes = regNode.getChildNodes();

				for (int idx1 = 0; idx1 < siteNodes.getLength(); idx1++) {
					try {
						Node siteNode = siteNodes.item(idx1);
						Node siteIdNode = siteNode.getAttributes().getNamedItem("ID");
						Node siteNameNode = siteNode.getAttributes().getNamedItem("name");

						if (siteIdNode.getNodeValue().trim().equals(siteId)
								&& siteNameNode.getNodeValue().trim().equalsIgnoreCase(siteName)) {

							boolean isProcPresent = false;
							// iterating over sites
							NodeList procNodes = siteNode.getChildNodes();
							for (int idx2 = 0; idx2 < procNodes.getLength(); idx2++) {
								try {
									Node procNode = procNodes.item(idx2);
									Node procPortNode = procNode.getAttributes().getNamedItem("port");
									Node procNameNode = procNode.getAttributes().getNamedItem("protocol");

									if (procNameNode.getNodeValue().equalsIgnoreCase(siteConnection.getProtocol())) {
										isProcPresent = true;
										throw new MethodException("There is already a protocol with same protocol name("
												+ siteConnection.getProtocol() + ").");
									}
								} catch (NullPointerException e) {
									continue;
								}
							}

							// if site not present, then add the new site
							if (!isProcPresent) {
								Element procEle = doc.createElement("DataSource");
								procEle.setAttribute("protocol", siteConnection.getProtocol());
								procEle.setAttribute("source", siteConnection.getServer());
								procEle.setAttribute("port", Integer.valueOf(siteConnection.getPort()).toString());
								procEle.setAttribute("modality", siteConnection.getModality());
								procEle.setAttribute("status", "active");

								siteNode.appendChild(procEle);
								isSaved = writeDomDocument(doc);
                                logger.info("Protocol Added: {}", isSaved);
								return isSaved;
							}
						}
					} catch (NullPointerException e) {
						continue;
					}
				}
			}
		}
        logger.info("Protocol Added: {}", isSaved);
		return isSaved;
	}
	
    /**
     * Updates the existing Protocol to the VhaSites.xml.
     * @param regionName
     * @param regionID
     * @param siteName
     * @param siteId
     * @param prevProtocol
     * @param prevPort
     * @param protocol
     * @return Boolean
     * @throws MethodException
     */
	public Boolean updateProcToVhaSitesXml(final String regionName, final String regionID, final String siteName,
			final String siteId, final String prevProtocol, final int prevPort, final SiteConnection protocol)
			throws MethodException {

		Boolean isUpdated = false;
		Document doc = createDomDocument();

		if (doc == null) {
			logger.error("Exception thrown while creating the Dom document");
			return isUpdated;
		}

		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList regNodes;
		try {
			regNodes = (NodeList) xpath.evaluate("//VhaVisn", doc, XPathConstants.NODESET);
		} catch (XPathExpressionException e1) {
			logger.error(e1);
			return isUpdated;
		}

		// iterating over regions
		for (int idx = 0; idx < regNodes.getLength(); idx++) {
			Node regNode = regNodes.item(idx);
			Node regIdNode = regNode.getAttributes().getNamedItem("ID");
			Node regNameNode = regNode.getAttributes().getNamedItem("name");

			if (regIdNode.getNodeValue().equals(regionID) && regNameNode.getNodeValue().equalsIgnoreCase(regionName)) {

				NodeList siteNodes = regNode.getChildNodes();
				for (int idx1 = 0; idx1 < siteNodes.getLength(); idx1++) {
					try {
						Node siteNode = siteNodes.item(idx1);
						Node siteIdNode = siteNode.getAttributes().getNamedItem("ID");
						Node siteNameNode = siteNode.getAttributes().getNamedItem("name");

						if (siteIdNode.getNodeValue().trim().equals(siteId)
								&& siteNameNode.getNodeValue().trim().equalsIgnoreCase(siteName)) {

							boolean isProcotolNameChanged = false;

							if (!prevProtocol.trim().equalsIgnoreCase(protocol.getProtocol().trim())) {
								isProcotolNameChanged = true;
							}

							// iterating over sites if site id is changed
							NodeList procNodes = siteNode.getChildNodes();
							for (int idx2 = 0; idx2 < procNodes.getLength(); idx2++) {
								try {
									Node procNode = procNodes.item(idx2);
									Node protocolNode = procNode.getAttributes().getNamedItem("protocol");
									Node portNode = procNode.getAttributes().getNamedItem("port");

									if (isProcotolNameChanged
											&& (protocolNode.getNodeValue().equalsIgnoreCase(protocol.getProtocol()))) {
										throw new MethodException("There is already a protocol with same protocol name("
												+ protocol.getProtocol() + ").");
									}
								} catch (NullPointerException e) {
									continue;
								}
							}

							// updating the existing protocol
							for (int idx3 = 0; idx3 < procNodes.getLength(); idx3++) {
								try {
									Node procNode = procNodes.item(idx3);
									Node nameProcNode = procNode.getAttributes().getNamedItem("protocol");
									if (nameProcNode.getNodeValue().equalsIgnoreCase(prevProtocol)) {
										try {
											NamedNodeMap procNodeAttr = procNode.getAttributes();
											procNodeAttr.getNamedItem("protocol").setTextContent(protocol.getProtocol());
											procNodeAttr.getNamedItem("source").setTextContent(protocol.getServer());
											procNodeAttr.getNamedItem("port")
													.setTextContent(Integer.valueOf(protocol.getPort()).toString());
											if(procNodeAttr.getNamedItem("modality") == null) {
												Attr modalityAttr = doc.createAttribute("modality");
												modalityAttr.setValue(protocol.getModality());
												procNodeAttr.setNamedItem(modalityAttr);
											} else {
												procNodeAttr.getNamedItem("modality").setTextContent(protocol.getModality());
											}
											procNodeAttr.getNamedItem("status").setTextContent("active");
											isUpdated = writeDomDocument(doc);
                                            logger.info("Protocol Updated: {}", isUpdated);
											return isUpdated;
										}
										catch(NullPointerException e) {
											logger.error("Attribute missing in updating the protocol", e);
											throw new MethodException("Attribute missing while updating the protocol("+ protocol.getProtocol() + ").");
										}
									}
								} catch (NullPointerException e) {
									continue;
								}
							}
						}
					} catch (NullPointerException e) {
						continue;
					}
				}
			 }
		  }
        logger.info("Protocol Updated: {}", isUpdated);
		return isUpdated;
	}
	
	/**
	 * Deletes the protocol from VhaSites.xml.
	 * 
	 * @param regionName
	 * @param regionId
	 * @param siteName
	 * @param siteId
	 * @param protocolName
	 * @return Boolean
	 */
	public Boolean deleteProcToVhaSiteXml(final String regionName, final String regionId, final String siteName,
			final String siteId, final String protocolName) {
		Boolean isDeleted = false;
		Document doc = createDomDocument();
		if (doc == null) {
			logger.error("Exception thrown while creating the Dom document");
			return isDeleted;
		}

		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes;
		try {
			nodes = (NodeList) xpath.evaluate("//VhaVisn", doc, XPathConstants.NODESET);
		} catch (XPathExpressionException e1) {
			logger.error(e1);
			return isDeleted;
		}

		// iterating over regions
		for (int idx = 0; idx < nodes.getLength(); idx++) {
			Node cNode = nodes.item(idx);
			try {
				Node idNode = cNode.getAttributes().getNamedItem("ID");
				
				if (idNode.getNodeValue().equals(regionId)) {
					NodeList siteNodes = cNode.getChildNodes();
					// iterating over sites
					for (int idx1 = 0; idx1 < siteNodes.getLength(); idx1++) {
						try {
							Node siteNode = siteNodes.item(idx1);
							Node idSiteNode = siteNode.getAttributes().getNamedItem("ID");
							Node nameSiteNode = siteNode.getAttributes().getNamedItem("name");

							if (idSiteNode.getNodeValue().equals(siteId)
									&& nameSiteNode.getNodeValue().equalsIgnoreCase(siteName)) {
								NodeList procNodes = siteNode.getChildNodes();

								for (int idx2 = 0; idx2 < procNodes.getLength(); idx2++) {
									Node procNode = procNodes.item(idx2);
									try {
										if (procNode.getAttributes().getNamedItem("protocol").getNodeValue()
												.equalsIgnoreCase(protocolName)) {
											procNode.getParentNode().removeChild(procNode);
											isDeleted = writeDomDocument(doc);
                                            logger.info("Protocol Deleted: {}", isDeleted);
											return isDeleted;
										}
									} catch (NullPointerException e) {
										continue;
									}
								}
							}
						} catch (NullPointerException e) {
							continue;
						}
					}
				}
			} catch (NullPointerException e) {
				continue;
			}
		}
        logger.info("Protocol Deleted: {}", isDeleted);
		return isDeleted;

	}
	

	
	/**
	 * Takes the backup of VhaSites.xml file before doing any changes to it.
	 * @return boolean
	 */
	private boolean createVhaSitesXmlBackUp() {
		final SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd_HH.mm.ss");
		
		// Fortify change: made sure file separator is OK
		File backUpDirectory = new File(StringUtil.toSystemFileSeparator(System.getenv("vixconfig") + "\\SiteServiceBackup"));
		
	    if (!backUpDirectory.exists()){
	        backUpDirectory.mkdir();
	    }
	    
		Path source = Paths.get(this.getConfiguration().getVhaSitesXmlFileName());
	    Path target = Paths.get(backUpDirectory + "\\VhaSites-"+ sdf.format(new Date()) +".xml");
	    try {
	        Files.copy(source, target);
	        return true;
	    } catch (IOException e1) {
	        logger.error("Exception thrown while taking VhaSites.xml backup", e1);
	        return false;
	    }
	}
	
	/**
	 * Utility method to create the Dom Document.
	 * @return Document
	 */
	private Document createDomDocument() {
		Document doc = null;
			try {
				doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(
						new File(this.getConfiguration().getVhaSitesXmlFileName()));
			} catch (SAXException e) {
				logger.error(e);
				return null;
			} catch (IOException e) {
				logger.error(e);
				return null;
			} catch (ParserConfigurationException e) {
				logger.error(e);
				return null;
			}
			return doc;
	}
	
	/**
	 * Utility method to update the vhasites.xml file to the file system.
	 * @param doc
	 * @return Boolean
	 */
	private synchronized Boolean writeDomDocument(Document doc) {
		Boolean result = false;
		
		//Taking the Vhasites.xml backup before doing any changes to the file
		if (createVhaSitesXmlBackUp()) {
			Transformer xformer = null;
			Transformer xformer2 = null;
			try {
				xformer = TransformerFactory.newInstance().newTransformer();
				xformer.setOutputProperty(OutputKeys.INDENT, "yes");
				xformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount","4"); 
				xformer.transform(new DOMSource(doc),
						new StreamResult(this.getConfiguration().getVhaSitesXmlFileName()));
				
				//Saving the VhaSites.xml file in c:\\SiteService directory
				xformer2 = TransformerFactory.newInstance().newTransformer();
				xformer2.setOutputProperty(OutputKeys.INDENT, "yes");
				xformer2.setOutputProperty("{http://xml.apache.org/xslt}indent-amount","4"); 
				xformer2.transform(new DOMSource(doc), new StreamResult(this.getConfiguration().getVhaSitesXmlFileNameFromSiteServiceDir()));
				
				refreshCache();
				result = true;
			} catch (TransformerConfigurationException e) {
				logger.error(e);
				result = false;
			} catch (TransformerFactoryConfigurationError e) {
				logger.error(e);
				result = false;
			} catch (TransformerException e) {
		    	logger.error(e);
		    	result = false;
			} catch(Exception e) {
				logger.error(e);
				result = false;
			}
		}
		return result;
	}
}

