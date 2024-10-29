/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jan 15, 2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */
package gov.va.med.imaging.datasource;

import java.util.Iterator;
import java.util.List;

import gov.va.med.OID;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.annotations.SPI;
import gov.va.med.imaging.exchange.business.Region;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteConnection;

/**
 * This is the service provider interface for site resolution.
 * 
 * @author VHAISWBECKEC
 *
 */
@SPI(description="Defines the interface to resolve logical home and repository IDs into a physical location.")
public interface SiteResolutionDataSourceSpi
extends LocalDataSourceSpi
{
	/**
	 * Return true if the home community ID is accessible through a gateway.
	 * Returns false if no gateway is known for the community.
	 * 
	 * A gateway is capable of aggregating results for all repositories within
	 * the community.
	 * 
	 * From the perspective of site resolution, a gateway is a routing (mapping) 
	 * where the repository ID is a wildcard string.
	 * 
	 * @param homeCommunityId
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract boolean isRepositoryGatewayExtant(OID homeCommunityId)
	throws MethodException, ConnectionException;

	/**
	 * 
	 * @param artifactSource
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract ResolvedArtifactSource resolveArtifactSource(RoutingToken routingToken)
	throws MethodException, ConnectionException;

	/**
	 * This is the central method of SiteResolutionDataSourceSpi.  Given a site ID
	 * return a list or URLs to contact the site through.  the protocol of the URLs
	 * determines which interface is used to contact the site.
	 * 
	 * @param siteId
	 * @return An instance of ResolvedSite containing the Site and its associated URLs, or null if not found.
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract ResolvedSite resolveSite(String siteId)
	throws MethodException, ConnectionException;
	
	/**
	 * A SiteResolutionDataSourceSpi may optionally implement a
	 * resolveSite() method that overrides the preferred protocols
	 * as defined within the SiteResolutionDataSourceSpi implementation.
	 * This is intended for testing and makes it possible for a VIX to call
	 * its own facades.
	 * 
	 * @param siteId
	 * @param preferredProtocol
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract ResolvedSite resolveSite(String siteId, String[] preferredProtocol)
	throws MethodException, ConnectionException;

	/**
	 * 
	 * @param site
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public ResolvedSite resolveSite(Site site) 
	throws MethodException, ConnectionException;
	
	/**
	 * 
	 * @param site
	 * @param preferredProtocol
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public ResolvedSite resolveSite(Site site, String[] preferredProtocol) 
	throws MethodException, ConnectionException;
	
	/**
	 * Return an Iterator over all sites with resolved URLs.
	 * 
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
    public abstract Iterator<ResolvedSite> iterator()
	throws MethodException, ConnectionException;
    
    /**
     * This resolves a region number into a region containing the sites of that region.
     * @param regionId The unique identifier for the region
     * @return
     * @throws MethodException
     * @throws ConnectionException
     */
    public abstract Region resolveRegion(String regionId)
    throws MethodException, ConnectionException;
    
    /**
     * Retrieves all of the regions with each region containing the sites of that region
     * @return
     * @throws MethodException
     * @throws ConnectionException
     */
    public abstract List<Region> getAllRegions()
    throws MethodException, ConnectionException;

	/**
	 * Retrieves a list of all of the ArtifactSources known to the site resolver
	 * @return
	 */
	public abstract List<ArtifactSource> getAllArtifactSources()
	throws MethodException, ConnectionException;

	/**
	 * @return
	 */
	public abstract List<ResolvedArtifactSource> getAllResolvedArtifactSources()
	throws MethodException, ConnectionException;
	
	/**
	 * Refresh the site service data from the source
	 */
	public abstract void refreshSiteResolutionData()
	throws MethodException, ConnectionException;
	
	/**
	 * Return a site object given a site ID, this is not a ResolvedSite
	 * @param siteId
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract Site getSite(String siteId)
	throws MethodException, ConnectionException;	
	
	/**
	 * Add Region to VhaSites.xml
	 * @param regionName
	 * @param regionId
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract Boolean addRegion(String regionName, String regionId)
	throws MethodException, ConnectionException;
	
	/**
	 * Add the Site element in VhaSites.xml
	 * @param regionName
	 * @param regionId
	 * @param site
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract Boolean addSite(String regionName, String regionId, Site site)
			throws MethodException, ConnectionException;
	/**
	 * Updates the Existing Region in the VhaSites.xml
	 * @param oldRegionName
	 * @param oldRegionId
	 * @param newRegionName
	 * @param newRegionId
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract Boolean updateRegion(String oldRegionName,String oldRegionId, String newRegionName, String newRegionId)
			throws MethodException, ConnectionException;
	/**
	 * Deletes the Region from VhaSites.xml.
	 * @param regionId
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract Boolean deleteRegion(String regionId)
			throws MethodException, ConnectionException;
	/**
	 * Deletes the Site from VhaSites.xml.
	 * @param regionId
	 * @param regionName
	 * @param siteId
	 * @param siteName
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract Boolean deleteSite(String regionId, String regionName, String siteId, String siteName)
			throws MethodException, ConnectionException;
	/**
	 * Updates the existing Site in VhaSites.xml.
	 * @param regionName
	 * @param regionID
	 * @param prevSiteName
	 * @param prevSiteId
	 * @param site
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract Boolean updateSite(String regionName, String regionID, String prevSiteName,
			String prevSiteId, Site site) throws MethodException, ConnectionException;
	/**
	 * Adds the Protocol to VhaSites.xml.
	 * @param regionName
	 * @param regionID
	 * @param siteName
	 * @param siteId
	 * @param siteConnection
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract Boolean addProtocol(String regionName, String regionID, String siteName, String siteId,
			SiteConnection siteConnection) throws MethodException, ConnectionException;
	/**
	 * Updates the existing Protocol to the VhaSites.xml.
	 * @param regionName
	 * @param regionID
	 * @param siteName
	 * @param siteId
	 * @param prevProtocol
	 * @param prevPort
	 * @param protocol
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract Boolean updateProtocol(String regionName, String regionID, String siteName, String siteId,
			String prevProtocol, int prevPort, SiteConnection protocol) throws MethodException, ConnectionException ;
	/**
	 * Deletes the protocol from VhaSites.xml
	 * @param regionName
	 * @param regionId
	 * @param siteName
	 * @param siteId
	 * @param protocolName
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public abstract Boolean deleteProtocol(String regionName, String regionId, String siteName, String siteId,
			String protocolName) throws MethodException, ConnectionException;
	
	/**
     * Retrieves all of the regions with each region containing the sites of that region
     * and Sites will not have default VISTA protocol.
     * @return
     * @throws MethodException
     * @throws ConnectionException
     */
    public abstract List<Region> getAllRegionsForSiteService() throws MethodException, ConnectionException;
}
