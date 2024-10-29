/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 6, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.indexterm.federation;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.enums.IndexClass;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexClassType;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexTermURNType;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexTermValueType;

/**
 * @author Administrator
 *
 */
@FacadeRouterInterface(extendsClassName="gov.va.med.imaging.BaseWebFacadeRouterImpl")
@FacadeRouterInterfaceCommandTester
public interface FederationIndexTermRouter
extends gov.va.med.imaging.BaseWebFacadeRouter
//extends FacadeRouter
{
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetOriginsIndexTermsCommand")
	public abstract List<IndexTermValue> getOrigins(RoutingToken routingToken)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetProcedureEventsIndexTermsCommand")
	public abstract List<IndexTermValue> getProcedureEvents(RoutingToken routingToken, List<IndexClass> indexClasses, 
			List<IndexTermURN> specialtyURNs)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetSpecialtiesIndexTermsCommand")
	public abstract List<IndexTermValue> getSpecialties(RoutingToken routingToken,
			List<IndexClass> indexClasses, List<IndexTermURN> eventURNs)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetTypesIndexTermsCommand")
	public abstract List<IndexTermValue> getTypes(RoutingToken routingToken,
			List<IndexClass> indexClasses)
	throws MethodException, ConnectionException;

}
