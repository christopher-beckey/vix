/**
 * 
 * Date Created: Jul 27, 2017
 * Developer: vhaisltjhajb
 */
package gov.va.med.imaging.vistaUserPreference;

import java.util.List;


import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;

/**
 * @author Budy Tjahjo
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface VistaUserPreferenceRouter
extends FacadeRouter
{
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostUserPreferenceCommand")
	public abstract String postUserPreference(
			RoutingToken routingToken, 
			String entity, 
			String key,
			String value)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetUserPreferenceCommand")
	public abstract List<String> getUserPreference(
			RoutingToken routingToken, 
			String entity,
			String key)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="DeleteUserPreferenceCommand")
	public abstract String deleteUserPreference(
			RoutingToken routingToken, 
			String entity,
			String key)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetUserPreferenceKeysCommand")
	public abstract List<String> getUserPreferenceKeys(
			RoutingToken routingToken, 
			String entity)
	throws MethodException, ConnectionException;


}
