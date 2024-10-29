/**
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.router;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.enums.IndexClass;

/**
 * @author Julian Werfel
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface IndexTermRouter
extends FacadeRouter
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
