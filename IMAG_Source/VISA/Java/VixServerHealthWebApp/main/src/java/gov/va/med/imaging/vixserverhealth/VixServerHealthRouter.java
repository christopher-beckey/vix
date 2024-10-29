/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 3, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.vixserverhealth;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Region;
import gov.va.med.imaging.health.VixServerHealth;
import gov.va.med.imaging.health.VixServerHealthSource;
import gov.va.med.imaging.health.VixSiteServerHealth;

/**
 * @author vhaiswwerfej
 *
 */
@FacadeRouterInterface//(extendsClassName="gov.va.med.imaging.BaseWebFacadeRouterImpl")
@FacadeRouterInterfaceCommandTester
public interface VixServerHealthRouter 
extends FacadeRouter
{
	/**
	 * Method to get the current VIX Server health values.
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetVixServerHealthCommand")
	public abstract VixServerHealth getVixServerHealth(VixServerHealthSource [] vixServerHealthSources)
	throws MethodException, ConnectionException;
		
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetVixSiteServerHealthBySiteNumberCommand")
	public abstract VixSiteServerHealth getVixSiteServerHealth(RoutingToken routingToken, Boolean forceRefresh, 
			VixServerHealthSource [] vixServerHealthSources)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetVixSiteServerHealthListCommand")
	public abstract List<VixSiteServerHealth> getVixSiteServerHealthList(Boolean forceRefresh, 
			VixServerHealthSource [] vixServerHealthSources)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetVixSiteServerHealthListByRegionCommand")
	public abstract List<VixSiteServerHealth> getVixSiteServerHealthListByRegion(String regionNumber, Boolean forceRefresh,
			VixServerHealthSource [] vixServerHealthSources)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetRegionCommand")
	public abstract Region getRegion(String regionId)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetLocalSiteVixSiteServerHealthCommand")
	public abstract VixSiteServerHealth getLocalSiteVixSiteServerHealth(VixServerHealthSource [] vixServerHealthSources)
	throws MethodException, ConnectionException;
}
