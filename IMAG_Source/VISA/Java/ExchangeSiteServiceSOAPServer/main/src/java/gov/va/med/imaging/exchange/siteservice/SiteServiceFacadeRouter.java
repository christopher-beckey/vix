package gov.va.med.imaging.exchange.siteservice;

import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
//import gov.va.med.imaging.core.interfaces.exceptions.RegionSiteConflictException;
import gov.va.med.imaging.exchange.business.Region;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteConnection;

import java.util.List;

/**
 * 
 * @author vhaiswbeckec
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface SiteServiceFacadeRouter
extends FacadeRouter
{
	/**
	 * Checks to see if the ViX can communicate with the specified site
	 * @param siteNumber The site number to communicate with
	 * @return The status of the site
	 */
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetRegionListCommand")
	public abstract List<Region> getRegionList()
	throws MethodException, ConnectionException;

	/**
	 * Checks to see if the ViX can communicate with the specified site
	 * @param siteNumber The site number to communicate with
	 * @return The status of the site
	 */
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetRegionCommand")
	public abstract Region getRegion(String regionId)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetSiteCommand")
	public abstract Site getSite(String siteId)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetSitesCommand")
	public abstract List<Site> getSites(String [] siteIds)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostRegionCommand")
	public abstract Boolean addRegion(String regionName, String regionId)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PutRegionCommand")
	public abstract Boolean updateRegion(String oldRegionName,String oldRegionId, String newRegionName, String newRegionId)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="DeleteRegionCommand")
	public abstract Boolean deleteRegion(String regionId)
			throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="DeleteSiteCommand")
	public abstract Boolean deleteSite(String regionId, String regionName, String siteId, String siteName)
			throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostSiteCommand")
	public abstract Boolean addSite(String regionName,String regionId,Site siteToSave)
			throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PutSiteCommand")
	public abstract Boolean updateSite(String regionName,String  regionId, String  prevSiteName, String  prevSiteNumber, Site siteToSave)
			throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostProtocolCommand")
	public Boolean addProtocol(String regionName, String regionID, String siteName, String siteId,
			SiteConnection siteConnection) throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PutProtocolCommand")
	public Boolean updateProtocol(String regionName,  String regionID,  String siteName,
			 String siteId,  String prevProtocol,  Integer prevPort,  SiteConnection protocol)
			throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="DeleteProtocolCommand")
	public Boolean deleteProtocol( String regionName,  String regionId,  String siteName,
			 String siteId,  String protocolName) throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetRegionListForSiteServiceCommand")
	public abstract List<Region> getRegionListForSiteService()
	throws MethodException, ConnectionException;
}
